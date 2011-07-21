Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1GUUwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:52:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:57677 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab1GUUwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:52:41 -0400
Date: Thu, 21 Jul 2011 20:52:35 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-aafade242ff24fac3aabf61c7861dfa44a3c2445@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de
In-Reply-To: <2c4ed5c2c2e93603790229e0c3403ae506ccc0cb.1311277573.git.luto@mit.edu>
References: <2c4ed5c2c2e93603790229e0c3403ae506ccc0cb.1311277573.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64, vdso: Do not allocate memory for the vDSO
Git-Commit-ID: aafade242ff24fac3aabf61c7861dfa44a3c2445
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 20:52:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aafade242ff24fac3aabf61c7861dfa44a3c2445
Gitweb:     http://git.kernel.org/tip/aafade242ff24fac3aabf61c7861dfa44a3c2445
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Thu, 21 Jul 2011 15:47:10 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 21 Jul 2011 13:41:53 -0700

x86-64, vdso: Do not allocate memory for the vDSO

We can map the vDSO straight from kernel data, saving a few page
allocations.  As an added bonus, the deleted code contained a memory
leak.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/2c4ed5c2c2e93603790229e0c3403ae506ccc0cb.1311277573.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/vdso/vdso.S |   15 +++++++++++++--
 arch/x86/vdso/vma.c  |   25 ++++++-------------------
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 1d3aa6b..1b979c1 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,10 +1,21 @@
+#include <asm/page_types.h>
+#include <linux/linkage.h>
 #include <linux/init.h>
 
-__INITDATA
+__PAGE_ALIGNED_DATA
 
 	.globl vdso_start, vdso_end
+	.align PAGE_SIZE
 vdso_start:
 	.incbin "arch/x86/vdso/vdso.so"
 vdso_end:
 
-__FINIT
+.previous
+
+	.globl vdso_pages
+	.bss
+	.align 8
+	.type vdso_pages, @object
+vdso_pages:
+	.zero (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE * 8
+	.size vdso_pages, .-vdso_pages
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index c39938d..316fbca 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -14,13 +14,14 @@
 #include <asm/vgtod.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
+#include <asm/page.h>
 
 unsigned int __read_mostly vdso_enabled = 1;
 
 extern char vdso_start[], vdso_end[];
 extern unsigned short vdso_sync_cpuid;
 
-static struct page **vdso_pages;
+extern struct page *vdso_pages[];
 static unsigned vdso_size;
 
 static void __init patch_vdso(void *vdso, size_t len)
@@ -54,7 +55,7 @@ found:
 	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
 }
 
-static int __init init_vdso_vars(void)
+static int __init init_vdso(void)
 {
 	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	int i;
@@ -62,26 +63,12 @@ static int __init init_vdso_vars(void)
 	patch_vdso(vdso_start, vdso_end - vdso_start);
 
 	vdso_size = npages << PAGE_SHIFT;
-	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
-	if (!vdso_pages)
-		goto oom;
-	for (i = 0; i < npages; i++) {
-		struct page *p;
-		p = alloc_page(GFP_KERNEL);
-		if (!p)
-			goto oom;
-		vdso_pages[i] = p;
-		copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
-	}
+	for (i = 0; i < npages; i++)
+		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
 
 	return 0;
-
- oom:
-	printk("Cannot allocate vdso\n");
-	vdso_enabled = 0;
-	return -ENOMEM;
 }
-subsys_initcall(init_vdso_vars);
+subsys_initcall(init_vdso);
 
 struct linux_binprm;
 
