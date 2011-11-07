Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab1KGQRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:17:30 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50189 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab1KGQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:27 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v8 14/16] ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
Date: Mon,  7 Nov 2011 16:16:56 +0000
Message-Id: <1320682618-1182-15-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:13.0873 (UTC) FILETIME=[B5C64010:01CC9D68]
X-MC-Unique: 111110716172500201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GHq0w015273

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

