Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab0FEQvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:51:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53594 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab0FEQvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VLmWfhRSUkkRiM/bJcNaYRRftYuupkmTpA9SyznU79ZXJeLkCArBlQdVAji4QdxZ/M
         dsUclfSNlhFslvzz2T9mOCIe5A/Q8DqwSvy3wAIEYjSq7TLZmP8zrTRfyktqBRki1g/v
         dw4u7+C/Mj7TCQNVVGB185G/MmJBeHF0Rqs1I=
Date: Sat, 5 Jun 2010 18:49:42 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       Christoph Bumiller <e0425955@student.tuwien.ac.at>,
       Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>,
       nouveau@lists.freedesktop.org, x86@kernel.org
Subject: [PATCH] kmmio/mmiotrace: fix double free of kmmio_fault_pages
Message-ID: <20100605164919.GA2816@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
Cc: Pekka Paalanen <pq@iki.fi>
Cc: Stuart Bennett <stuart@freedesktop.org>
---
 arch/x86/mm/kmmio.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

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
-- 
1.7.1

