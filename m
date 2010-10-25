Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0JYJBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:01:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46563 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782Ab0JYJBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:01:32 -0400
Subject: [RFC PATCH 14/18] ARM: LPAE: mark memory banks with start >
 ULONG_MAX as highmem
To: linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Oct 2010 10:00:52 +0100
Message-ID: <20101025090052.25275.14252.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 09:00:53.0455 (UTC) FILETIME=[20E1FDF0:01CB7423]
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
index c060d82..f8f8e06 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -787,7 +787,8 @@ static void __init sanity_check_meminfo(void)
 
 #ifdef CONFIG_HIGHMEM
 		if (__va(bank->start) > vmalloc_min ||
-		    __va(bank->start) < (void *)PAGE_OFFSET)
+		    __va(bank->start) < (void *)PAGE_OFFSET ||
+		    bank->start > ULONG_MAX)
 			highmem = 1;
 
 		bank->highmem = highmem;
@@ -796,7 +797,7 @@ static void __init sanity_check_meminfo(void)
 		 * Split those memory banks which are partially overlapping
 		 * the vmalloc area greatly simplifying things later.
 		 */
-		if (__va(bank->start) < vmalloc_min &&
+		if (!highmem && __va(bank->start) < vmalloc_min &&
 		    bank->size > vmalloc_min - __va(bank->start)) {
 			if (meminfo.nr_banks >= NR_BANKS) {
 				printk(KERN_CRIT "NR_BANKS too low, "

