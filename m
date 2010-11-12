Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab0KLSBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:01:52 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50935 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932562Ab0KLSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:18 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 16/20] ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
Date: Fri, 12 Nov 2010 18:00:36 +0000
Message-Id: <1289584840-18097-17-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:54.0032 (UTC) FILETIME=[8C913100:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

Memory banks living outside of the 32-bit physical address
space do not have a 1:1 pa <-> va mapping and therefore the
__va macro may wrap.

This patch ensures that such banks are marked as highmem so
that the Kernel doesn't try to split them up when it sees that
the wrapped virtual address overlaps the vmalloc space.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/mmu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index b03e431..787a409 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -785,7 +785,8 @@ static void __init sanity_check_meminfo(void)
 
 #ifdef CONFIG_HIGHMEM
 		if (__va(bank->start) > vmalloc_min ||
-		    __va(bank->start) < (void *)PAGE_OFFSET)
+		    __va(bank->start) < (void *)PAGE_OFFSET ||
+		    bank->start > ULONG_MAX)
 			highmem = 1;
 
 		bank->highmem = highmem;
@@ -794,7 +795,7 @@ static void __init sanity_check_meminfo(void)
 		 * Split those memory banks which are partially overlapping
 		 * the vmalloc area greatly simplifying things later.
 		 */
-		if (__va(bank->start) < vmalloc_min &&
+		if (!highmem && __va(bank->start) < vmalloc_min &&
 		    bank->size > vmalloc_min - __va(bank->start)) {
 			if (meminfo.nr_banks >= NR_BANKS) {
 				printk(KERN_CRIT "NR_BANKS too low, "
