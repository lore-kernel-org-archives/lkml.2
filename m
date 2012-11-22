Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab2KVUsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:48:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964939Ab2KVS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:43 -0500
Date: Wed, 21 Nov 2012 17:54:03 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-74f27655dda84604d8bab47872020dcce5c88731@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-17-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-17-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: relocate initrd under all mem for 64bit
Git-Commit-ID: 74f27655dda84604d8bab47872020dcce5c88731
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:54:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74f27655dda84604d8bab47872020dcce5c88731
Gitweb:     http://git.kernel.org/tip/74f27655dda84604d8bab47872020dcce5c88731
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:53 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:15 -0800

x86, mm: relocate initrd under all mem for 64bit

instead of under 4g.

For 64bit, we can use any mapped mem instead of low mem.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-17-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 68dffec..94f922a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -324,7 +324,7 @@ static void __init relocate_initrd(void)
 	char *p, *q;
 
 	/* We need to move the initrd down into directly mapped mem */
-	ramdisk_here = memblock_find_in_range(0, PFN_PHYS(max_low_pfn_mapped),
+	ramdisk_here = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 						 area_size, PAGE_SIZE);
 
 	if (!ramdisk_here)
@@ -392,7 +392,7 @@ static void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	mapped_size = get_mem_size(max_low_pfn_mapped);
+	mapped_size = get_mem_size(max_pfn_mapped);
 	if (ramdisk_size >= (mapped_size>>1))
 		panic("initrd too large to handle, "
 		       "disabling initrd (%lld needed, %lld available)\n",
@@ -401,8 +401,7 @@ static void __init reserve_initrd(void)
 	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
 			ramdisk_end - 1);
 
-	if (ramdisk_end <= (max_low_pfn_mapped<<PAGE_SHIFT) &&
-	    pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
+	if (pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
 				PFN_DOWN(ramdisk_end))) {
 		/* All are mapped, easy case */
 		/*
