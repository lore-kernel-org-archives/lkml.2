Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1GEGVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:21:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60896 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1GEGVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:21:54 -0400
Date: Tue, 5 Jul 2011 14:21:48 +0800
From: wzt <wzt.wzt@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@zytor.com
Subject: [PATCH] x86: Fix memory leak of init_vdso_vars()
Message-ID: <20110705062148.GA6056@program>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory leak of init_vdso_vars().

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 arch/x86/vdso/vma.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 4b5d26f..c6b0308 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -44,19 +44,19 @@ static int __init init_vdso_vars(void)
 	vdso_size = npages << PAGE_SHIFT;
 	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
 	if (!vdso_pages)
-		goto oom;
+		goto oom1;
 	for (i = 0; i < npages; i++) {
 		struct page *p;
 		p = alloc_page(GFP_KERNEL);
 		if (!p)
-			goto oom;
+			goto oom2;
 		vdso_pages[i] = p;
 		copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
 	}
 
 	vbase = vmap(vdso_pages, npages, 0, PAGE_KERNEL);
 	if (!vbase)
-		goto oom;
+		goto oom2;
 
 	if (memcmp(vbase, "\177ELF", 4)) {
 		printk("VDSO: I'm broken; not ELF\n");
@@ -70,7 +70,13 @@ static int __init init_vdso_vars(void)
 	vunmap(vbase);
 	return 0;
 
- oom:
+oom2:
+	i--;
+	for (; i >= 0; i--)
+		__free_page(vdso_pages[i]);
+	__free_page(vdso_pages);
+
+oom1:
 	printk("Cannot allocate vdso\n");
 	vdso_enabled = 0;
 	return -ENOMEM;
-- 
1.7.4.1

