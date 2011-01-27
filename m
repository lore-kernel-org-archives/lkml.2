Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1A0WJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:09:33 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:34724 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1A0WJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:09:31 -0500
Message-ID: <4D41ED13.5020105@free.fr>
Date: Thu, 27 Jan 2011 23:09:23 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-security-module@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kees Cook <kees.cook@canonical.com>
Subject: [PATCH] NX protection for kernel data : fix xen boot
Content-Type: multipart/mixed;
 boundary="------------060001060106090509030006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060001060106090509030006
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I think it should be applied before 2.6.38 release, because without
this patch xen doesn't boot on x86_32 with CONFIG_DEBUG_RODATA.


--------------060001060106090509030006
Content-Type: text/x-diff;
 name="0001-NX-protection-for-kernel-data-fix-xen-boot.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-NX-protection-for-kernel-data-fix-xen-boot.patch"

>From 08f54ec4007ab0df231d81ed436632aa7f605feb Mon Sep 17 00:00:00 2001
From: Matthieu CASTET <castet.matthieu@free.fr>
Date: Thu, 20 Jan 2011 21:11:45 +0100
Subject: [PATCH] NX protection for kernel data : fix xen boot

Xen want page table pages read only.

But the initial page table (from head_*.S) live in .data or .bss.

That was broken by 64edc8ed5ffae999d8d413ba006850e9e34166cb.
Revert the problematic part as it is only a protection and
not really needed.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/pageattr.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 2ad6c48..951eb4a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -256,7 +256,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 				   unsigned long pfn)
 {
 	pgprot_t forbidden = __pgprot(0);
-	pgprot_t required = __pgprot(0);
 
 	/*
 	 * The BIOS area between 640k and 1Mb needs to be executable for
@@ -286,12 +285,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	if (within(pfn, __pa((unsigned long)__start_rodata) >> PAGE_SHIFT,
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
-	/*
-	 * .data and .bss should always be writable.
-	 */
-	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
-	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
-		pgprot_val(required) |= _PAGE_RW;
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
 	/*
@@ -331,7 +324,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 #endif
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
-	prot = __pgprot(pgprot_val(prot) | pgprot_val(required));
 
 	return prot;
 }
-- 
1.7.2.3


--------------060001060106090509030006--
