Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2JRUvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42623 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab2JRUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:12 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/19] x86, mm: only keep initial mapping for ram
Date: Thu, 18 Oct 2012 13:50:15 -0700
Message-Id: <1350593430-24470-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0 mean any e820 type, for any range is overlapped with any entry in e820,
kernel will keep it's initial page table mapping.

What we want is only keeping initial page table for ram range.

Change to E820_RAM and E820_RESERVED_KERN.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 61b3c44..4898e80 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -373,7 +373,8 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 		next = (addr & PAGE_MASK) + PAGE_SIZE;
 		if (addr >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(addr & PAGE_MASK, next, 0))
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RESERVED_KERN))
 				set_pte(pte, __pte(0));
 			continue;
 		}
@@ -420,7 +421,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		next = (address & PMD_MASK) + PMD_SIZE;
 		if (address >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(address & PMD_MASK, next, 0))
+			    !e820_any_mapped(address & PMD_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(address & PMD_MASK, next, E820_RESERVED_KERN))
 				set_pmd(pmd, __pmd(0));
 			continue;
 		}
@@ -494,7 +496,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		next = (addr & PUD_MASK) + PUD_SIZE;
 		if (addr >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(addr & PUD_MASK, next, 0))
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_RAM) &&
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_RESERVED_KERN))
 				set_pud(pud, __pud(0));
 			continue;
 		}
-- 
1.7.7

