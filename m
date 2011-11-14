Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1KNQYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:24:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55748 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab1KNQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:24:21 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v9 14/15] ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
Date: Mon, 14 Nov 2011 16:23:50 +0000
Message-Id: <1321287831-24560-15-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1321287831-24560-1-git-send-email-catalin.marinas@arm.com>
References: <1321287831-24560-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 14 Nov 2011 16:24:08.0897 (UTC) FILETIME=[D60A2310:01CCA2E9]
X-MC-Unique: 111111416241901101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pAEGOa9v019372

From: Will Deacon <will.deacon@arm.com>

Memory banks living outside of the 32-bit physical address
space do not have a 1:1 pa <-> va mapping and therefore the
__va macro may wrap.

This patch ensures that such banks are marked as highmem so
that the Kernel doesn't try to split them up when it sees that
the wrapped virtual address overlaps the vmalloc space.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/mm/mmu.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 1935311..b836d6b 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -799,6 +799,9 @@ void __init sanity_check_meminfo(void)
 		struct membank *bank = &meminfo.bank[j];
 		*bank = meminfo.bank[i];
 
+		if (bank->start > ULONG_MAX)
+			highmem = 1;
+
 #ifdef CONFIG_HIGHMEM
 		if (__va(bank->start) >= vmalloc_min ||
 		    __va(bank->start) < (void *)PAGE_OFFSET)
@@ -810,7 +813,7 @@ void __init sanity_check_meminfo(void)
 		 * Split those memory banks which are partially overlapping
 		 * the vmalloc area greatly simplifying things later.
 		 */
-		if (__va(bank->start) < vmalloc_min &&
+		if (!highmem && __va(bank->start) < vmalloc_min &&
 		    bank->size > vmalloc_min - __va(bank->start)) {
 			if (meminfo.nr_banks >= NR_BANKS) {
 				printk(KERN_CRIT "NR_BANKS too low, "
@@ -831,6 +834,17 @@ void __init sanity_check_meminfo(void)
 		bank->highmem = highmem;
 
 		/*
+		 * Highmem banks not allowed with !CONFIG_HIGHMEM.
+		 */
+		if (highmem) {
+			printk(KERN_NOTICE "Ignoring RAM at %.8llx-%.8llx "
+			       "(!CONFIG_HIGHMEM).\n",
+			       (unsigned long long)bank->start,
+			       (unsigned long long)bank->start + bank->size - 1);
+			continue;
+		}
+
+		/*
 		 * Check whether this memory bank would entirely overlap
 		 * the vmalloc area.
 		 */

