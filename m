Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1HJPE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:04:59 -0400
Received: from service87.mimecast.com ([94.185.240.25]:42147 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753375Ab1HJPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:04:12 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v7 14/16] ARM: LPAE: mark memory banks with start > ULONG_MAX as highmem
Date: Wed, 10 Aug 2011 16:03:37 +0100
Message-Id: <1312988619-16804-15-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 10 Aug 2011 15:03:55.0194 (UTC) FILETIME=[B93159A0:01CC576E]
X-MC-Unique: 111081016041000301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p7AF5eid003945

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
index 1ba2a5a..85aa25e 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -792,7 +792,8 @@ void __init sanity_check_meminfo(void)
 		*bank = meminfo.bank[i];
 
 #ifdef CONFIG_HIGHMEM
-		if (__va(bank->start) >= vmalloc_min ||
+		if (bank->start > ULONG_MAX ||
+		    __va(bank->start) >= vmalloc_min ||
 		    __va(bank->start) < (void *)PAGE_OFFSET)
 			highmem = 1;
 
@@ -802,7 +803,7 @@ void __init sanity_check_meminfo(void)
 		 * Split those memory banks which are partially overlapping
 		 * the vmalloc area greatly simplifying things later.
 		 */
-		if (__va(bank->start) < vmalloc_min &&
+		if (!highmem && __va(bank->start) < vmalloc_min &&
 		    bank->size > vmalloc_min - __va(bank->start)) {
 			if (meminfo.nr_banks >= NR_BANKS) {
 				printk(KERN_CRIT "NR_BANKS too low, "

