Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1AaXB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:01:59 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:51705 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab1AaXB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:01:57 -0500
Message-ID: <4D473F5F.1020308@free.fr>
Date: Tue, 01 Feb 2011 00:01:51 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-security-module@vger.kernel.org,
        Matthias Hopf <mhopf@suse.de>, rjw@sisk.pl,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] NX protection for kernel data : fix xen boot
Content-Type: multipart/mixed;
 boundary="------------000804010508040305030309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000804010508040305030309
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I think it should be applied before 2.6.38 release, because without
this patch S3 suspend doesn't work on x86_32 with CONFIG_DEBUG_RODATA.



--------------000804010508040305030309
Content-Type: text/x-diff;
 name="0001-NX-protection-for-kernel-data-fix-32-bits-wakeup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-NX-protection-for-kernel-data-fix-32-bits-wakeup.patch"

>From 8e4bdefe9649a89c972974d94510f0c2bd2d0ea4 Mon Sep 17 00:00:00 2001
From: Matthieu CASTET <castet.matthieu@free.fr>
Date: Thu, 27 Jan 2011 21:36:07 +0100
Subject: [PATCH] NX protection for kernel data : fix 32 bits wakeup

32 bits wakeup realmode trampoline enable paging, while still
in low memory.

We should make this memory !NX in order it works.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Tested-by: Matthias Hopf <mhopf@suse.de>
---
 arch/x86/mm/init_32.c  |    8 ++++++++
 arch/x86/mm/pageattr.c |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c821074..0048738 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -227,6 +227,14 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 
 static inline int is_kernel_text(unsigned long addr)
 {
+#if defined(CONFIG_X86_32) && defined(CONFIG_ACPI_SLEEP)
+	/*
+	 * We need to make the wakeup trampoline in first 1MB !NX
+	 */
+	if (addr >= PAGE_OFFSET && addr <= (PAGE_OFFSET + (1<<20)))
+		return 1;
+#endif
+
 	if (addr >= (unsigned long)_text && addr <= (unsigned long)__init_end)
 		return 1;
 	return 0;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d343b3c..f1d6cf5 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -265,6 +265,13 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	if (pcibios_enabled && within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
 #endif
+	/*
+	 * We need to make the wakeup trampoline in first 1MB !NX
+	 */
+#if defined(CONFIG_X86_32) && defined(CONFIG_ACPI_SLEEP)
+	if (within(address, PAGE_OFFSET, PAGE_OFFSET + (1<<20)))
+		pgprot_val(forbidden) |= _PAGE_NX;
+#endif
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
-- 
1.7.2.3


--------------000804010508040305030309--
