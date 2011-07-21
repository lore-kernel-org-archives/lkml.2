Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1GUTrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:47:39 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:58072 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800Ab1GUTrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:47:37 -0400
X-AuditID: 12074425-b7bcaae000000a1b-c1-4e288231b0c6
From: Andy Lutomirski <luto@MIT.EDU>
To: mingo@redhat.com, wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@zytor.com, Michal Hocko <mhocko@suse.cz>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] x86-64: Do not allocate memory for the vDSO
Date: Thu, 21 Jul 2011 15:47:10 -0400
Message-Id: <2c4ed5c2c2e93603790229e0c3403ae506ccc0cb.1311277573.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAObL_7H=wh4exBfyjJyumtOBgvAjLnewu3dp6eeyaoQi3txXwQ@mail.gmail.com>
References: <CAObL_7H=wh4exBfyjJyumtOBgvAjLnewu3dp6eeyaoQi3txXwQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsUixG6nomvYpOFncOWpmsXxCZYWfVeOsltM
	2yhucXnXHDaLV83fWS0uHVjAZLF501RmizWfT7FZ/NjwmNWB02PnrLvsHptWdbJ5vDt3jt1j
	3slAj/f7rrJ5nFlwhN3j8yY5jxMtX1gDOKK4bFJSczLLUov07RK4Mv4+P8Je8Fi4YsqzFrYG
	xmaBLkZODgkBE4mP03ezQthiEhfurWfrYuTiEBLYxyjR9nQ7E4SzgVFiz85PzBDOYSaJZ483
	MYO0sAmoSHQsfcAEYosI6Ep83XGbEaSIWWAHo8T2hZNZQBLCAjYSe7cvYQSxWQRUJc7e2AMW
	5xUIkuhb1cIMsVtO4sjl52CDOAUCJc69mAlWIyQQIHFm6jHGCYx8CxgZVjHKpuRW6eYmZuYU
	pybrFicn5uWlFula6OVmluilppRuYgSHq4vqDsYJh5QOMQpwMCrx8DL5avgJsSaWFVfmHmKU
	5GBSEuVd3wgU4kvKT6nMSCzOiC8qzUktPsQowcGsJMIrFAOU401JrKxKLcqHSUlzsCiJ84Z4
	//cVEkhPLEnNTk0tSC2CycpwcChJ8NaBDBUsSk1PrUjLzClBSDNxcIIM5wEavhCkhre4IDG3
	ODMdIn+KUVFKnDcfJCEAksgozYPrhaWTV4ziQK8I8y4AqeIBpiK47ldAg5mABreoq4IMLklE
	SEk1MPZvSD+z9M+bVdqBzc2lFz91PZpj9+jkxGY7l1Wve5lPhrEGzjy6dda1xQqm+y00Ct6I
	x1WpPP45RYj1EMe8iw63HgTERdd2xq5JP9GhePSPCv+5+uSaO7NEGCM0n4itVItP+JF8tS7Y
	NSWiZ+3nzVcqBKYI2quKNcr2zt1fUl3X8M3l/B/lLUosxRmJhlrMRcWJALmV4GoCAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can map the vDSO straight from kernel data, saving a few page
allocations.  As an added bonus, the deleted code contained a memory
leak.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
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
index ba92244..40e4cb0 100644
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
 
 static void patch_vdso(void *vdso, size_t len)
@@ -51,7 +52,7 @@ found:
 	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
 }
 
-static int __init init_vdso_vars(void)
+static int __init init_vdso(void)
 {
 	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	int i;
@@ -59,26 +60,12 @@ static int __init init_vdso_vars(void)
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
 
-- 
1.7.6

