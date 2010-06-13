Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0FMV6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 17:58:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33034 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0FMV6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 17:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=EjZnad5nczecySqFozZrfothybVqSAEV0R9sUopPtCcqBioU2YQdlvqmo9hmgy+Gzr
         Tev9x0G/4RC0I7VqBSG4pXNtJ3ZM2yrweiDPO6VqVkLAEby08hfqrkVSxUAguxfPUOsy
         IqQQekycnG66GEPJmshsooAfhG3WdLBvpen0A=
Date: Sun, 13 Jun 2010 23:56:54 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Stuart Bennett <stuart@freedesktop.org>,
       Marcin =?utf-8?Q?Ko=C5=9Bcielnicki?= <koriakin@0x04.net>,
       Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>,
       nouveau@lists.freedesktop.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCHv2] kmmio/mmiotrace: fix double free of kmmio_fault_pages
Message-ID: <20100613215654.GA3829@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After every iounmap mmiotrace has to free kmmio_fault_pages, but it
can't do it directly, so it defers freeing by RCU.

It usually works, but when mmiotraced code calls ioremap-iounmap
multiple times without sleeping between (so RCU won't kick in and
start freeing) it can be given the same virtual address, so at
every iounmap mmiotrace will schedule the same pages for release.
Obviously it will explode on second free.

Fix it by marking kmmio_fault_pages which are scheduled for release
and not adding them second time.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Pekka Paalanen <pq@iki.fi>
Cc: Stuart Bennett <stuart@freedesktop.org>
Tested-by: Marcin Kościelnicki <koriakin@0x04.net>
Tested-by: Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>
---
v2: added test to testmmiotrace.c
---
 arch/x86/mm/kmmio.c         |   16 +++++++++++++---
 arch/x86/mm/testmmiotrace.c |   22 ++++++++++++++++++++++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 5d0e67f..e5d5e2c 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -45,6 +45,8 @@ struct kmmio_fault_page {
 	 * Protected by kmmio_lock, when linked into kmmio_page_table.
 	 */
 	int count;
+
+	bool scheduled_for_release;
 };
 
 struct kmmio_delayed_release {
@@ -398,8 +400,11 @@ static void release_kmmio_fault_page(unsigned long page,
 	BUG_ON(f->count < 0);
 	if (!f->count) {
 		disarm_kmmio_fault_page(f);
-		f->release_next = *release_list;
-		*release_list = f;
+		if (!f->scheduled_for_release) {
+			f->release_next = *release_list;
+			*release_list = f;
+			f->scheduled_for_release = true;
+		}
 	}
 }
 
@@ -471,8 +476,10 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
 			prevp = &f->release_next;
 		} else {
 			*prevp = f->release_next;
+			f->release_next = NULL;
+			f->scheduled_for_release = false;
 		}
-		f = f->release_next;
+		f = *prevp;
 	}
 	spin_unlock_irqrestore(&kmmio_lock, flags);
 
@@ -510,6 +517,9 @@ void unregister_kmmio_probe(struct kmmio_probe *p)
 	kmmio_count--;
 	spin_unlock_irqrestore(&kmmio_lock, flags);
 
+	if (!release_list)
+		return;
+
 	drelease = kmalloc(sizeof(*drelease), GFP_ATOMIC);
 	if (!drelease) {
 		pr_crit("leaking kmmio_fault_page objects.\n");
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index 8565d94..e6cc5be 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -90,6 +90,27 @@ static void do_test(unsigned long size)
 	iounmap(p);
 }
 
+/*
+ * Tests how mmiotrace behaves in face of multiple ioremap / iounmaps in
+ * a short time. We had a bug in deferred freeing procedure which tried
+ * to free this region multiple times (ioremap can reuse the same address
+ * for many mappings).
+ */
+static void do_test_bulk_ioremapping(void)
+{
+	void __iomem *p;
+	int i;
+	
+	for (i = 0; i < 10; ++i) {
+		p = ioremap_nocache(mmio_address, PAGE_SIZE);
+		if (p)
+			iounmap(p);
+	}
+
+	/* Force freeing. If it will crash we will know why. */
+	synchronize_rcu();
+}
+
 static int __init init(void)
 {
 	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
@@ -104,6 +125,7 @@ static int __init init(void)
 		   "and writing 16 kB of rubbish in there.\n",
 		   size >> 10, mmio_address);
 	do_test(size);
+	do_test_bulk_ioremapping();
 	pr_info("All done.\n");
 	return 0;
 }
-- 
1.7.1

