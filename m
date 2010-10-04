Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0JDV7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:59:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59944 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0JDV7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:59:14 -0400
Message-ID: <4CAA4DE2.1020406@kernel.org>
Date: Mon, 04 Oct 2010 14:57:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/4] x86, memblock: Fix crashkernel allocation
References: <4CAA4BD5.4020505@kernel.org>
In-Reply-To: <4CAA4BD5.4020505@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cai Qian found crashkernel is broken with x86 memblock changes
1. crashkernel=128M@32M always reported that range is used, even first kernel is small
   no one use that range
2. always get following report when using "kexec -p"
	Could not find a free area of memory of a000 bytes...
	locate_hole failed

The root cause is that generic memblock_find_in_range() will try to get range from top_down.
But crashkernel do need from low and specified range.

Let's limit the target range with rash_base + crash_size to make sure that
We get range from bottom.

-v5: use DEFAULT_BZIMAGE_ADDR_MAX to limit area that could be used by bzImge.
     also second try for vmlinux or new kexec tools will use bzImage 64bit entry

Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -501,6 +501,7 @@ static inline unsigned long long get_tot
 	return total << PAGE_SHIFT;
 }
 
+#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
 static void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
@@ -518,17 +519,28 @@ static void __init reserve_crashkernel(v
 	if (crash_base <= 0) {
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
-				 alignment);
+		/*
+		 * Assume half crash_size is for bzImage
+		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
+		 */
+		crash_base = memblock_find_in_range(alignment,
+				DEFAULT_BZIMAGE_ADDR_MAX + crash_size/2,
+				crash_size, alignment);
+
 		if (crash_base == MEMBLOCK_ERROR) {
-			pr_info("crashkernel reservation failed - No suitable area found.\n");
-			return;
+			crash_base = memblock_find_in_range(alignment,
+					 ULONG_MAX, crash_size, alignment);
+
+			if (crash_base == MEMBLOCK_ERROR) {
+				pr_info("crashkernel reservation failed - No suitable area found.\n");
+				return;
+			}
 		}
 	} else {
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base, ULONG_MAX, crash_size,
-				 1<<20);
+		start = memblock_find_in_range(crash_base,
+				 crash_base + crash_size, crash_size, 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
