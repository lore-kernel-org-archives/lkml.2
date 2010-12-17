Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0LQDVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:21:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:54112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab0LQDVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:21:43 -0500
Date: Fri, 17 Dec 2010 03:19:03 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, sgruszka@redhat.com,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        sgruszka@redhat.com
In-Reply-To: <4D0AD3ED.8070607@kernel.org>
References: <4D0AD3ED.8070607@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32: Make sure we can map all of lowmem if we need to
Message-ID: <tip-147dd5610c8d1bacb88a6c1dfdaceaf257946ed0@git.kernel.org>
Git-Commit-ID: 147dd5610c8d1bacb88a6c1dfdaceaf257946ed0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Dec 2010 03:19:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  147dd5610c8d1bacb88a6c1dfdaceaf257946ed0
Gitweb:     http://git.kernel.org/tip/147dd5610c8d1bacb88a6c1dfdaceaf257946ed0
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 16 Dec 2010 19:11:09 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 16 Dec 2010 19:11:09 -0800

x86-32: Make sure we can map all of lowmem if we need to

A relocatable kernel can be anywhere in lowmem -- and in the case of a
kdump kernel, is likely to be fairly high.  Since the early page
tables map everything from address zero up we need to make sure we
allocate enough brk that we can map all of lowmem if we need to.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Tested-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D0AD3ED.8070607@kernel.org>
---
 arch/x86/boot/compressed/misc.c |    2 +-
 arch/x86/kernel/head_32.S       |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 23f315c..325c052 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -355,7 +355,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	if (heap > 0x3fffffffffffUL)
 		error("Destination address too large");
 #else
-	if (heap > ((-__PAGE_OFFSET-(512<<20)-1) & 0x7fffffff))
+	if (heap > ((-__PAGE_OFFSET-(128<<20)-1) & 0x7fffffff))
 		error("Destination address too large");
 #endif
 #ifndef CONFIG_RELOCATABLE
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index bcece91..d7cdf5b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -60,16 +60,18 @@
 #define PAGE_TABLE_SIZE(pages) ((pages) / PTRS_PER_PGD)
 #endif
 
+/* Number of possible pages in the lowmem region */
+LOWMEM_PAGES = (((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT)
+	
 /* Enough space to fit pagetables for the low memory linear map */
-MAPPING_BEYOND_END = \
-	PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
+MAPPING_BEYOND_END = PAGE_TABLE_SIZE(LOWMEM_PAGES) << PAGE_SHIFT
 
 /*
  * Worst-case size of the kernel mapping we need to make:
- * the worst-case size of the kernel itself, plus the extra we need
- * to map for the linear map.
+ * a relocatable kernel can live anywhere in lowmem, so we need to be able
+ * to map all of lowmem.
  */
-KERNEL_PAGES = (KERNEL_IMAGE_SIZE + MAPPING_BEYOND_END)>>PAGE_SHIFT
+KERNEL_PAGES = LOWMEM_PAGES
 
 INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE_asm
 RESERVE_BRK(pagetables, INIT_MAP_SIZE)
