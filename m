Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab1ILOhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:37:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54407 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757246Ab1ILOfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:35:02 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 02/10] x86, efi: Make efi_call_phys_prelog() CONFIG_RELOCATABLE-aware
Date: Mon, 12 Sep 2011 15:34:46 +0100
Message-Id: <1315838094-2307-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

efi_call_phys_prelog() assumes that the kernel was loaded at a
physical address within the first 8MB of ram, usually
0x1000000. However, this isn't the case with a CONFIG_RELOCATABLE=y
kernel which could have been loaded anywhere in the physical address
space.

Replace the hardcoded pgd_index(0) and pgd_index(PAGE_OFFSET) with the
runtime addresses of the kernel in the physical and virtual space,
respectively.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi_32.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 5cab48e..1156e9a 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -44,8 +44,12 @@ void efi_call_phys_prelog(void)
 {
 	unsigned long cr4;
 	unsigned long temp;
+	unsigned long phys_addr, virt_addr;
 	struct desc_ptr gdt_descr;
 
+	virt_addr = (unsigned long)_text;
+	phys_addr = virt_addr - PAGE_OFFSET;
+
 	local_irq_save(efi_rt_eflags);
 
 	/*
@@ -57,18 +61,18 @@ void efi_call_phys_prelog(void)
 
 	if (cr4 & X86_CR4_PAE) {
 		efi_bak_pg_dir_pointer[0].pgd =
-		    swapper_pg_dir[pgd_index(0)].pgd;
-		swapper_pg_dir[0].pgd =
-		    swapper_pg_dir[pgd_index(PAGE_OFFSET)].pgd;
+		    swapper_pg_dir[pgd_index(phys_addr)].pgd;
+		swapper_pg_dir[pgd_index(phys_addr)].pgd =
+		    swapper_pg_dir[pgd_index(virt_addr)].pgd;
 	} else {
 		efi_bak_pg_dir_pointer[0].pgd =
-		    swapper_pg_dir[pgd_index(0)].pgd;
+		    swapper_pg_dir[pgd_index(phys_addr)].pgd;
 		efi_bak_pg_dir_pointer[1].pgd =
-		    swapper_pg_dir[pgd_index(0x400000)].pgd;
-		swapper_pg_dir[pgd_index(0)].pgd =
-		    swapper_pg_dir[pgd_index(PAGE_OFFSET)].pgd;
-		temp = PAGE_OFFSET + 0x400000;
-		swapper_pg_dir[pgd_index(0x400000)].pgd =
+		    swapper_pg_dir[pgd_index(phys_addr + 0x400000)].pgd;
+		swapper_pg_dir[pgd_index(phys_addr)].pgd =
+		    swapper_pg_dir[pgd_index(virt_addr)].pgd;
+		temp = virt_addr + 0x400000;
+		swapper_pg_dir[pgd_index(phys_addr + 0x400000)].pgd =
 		    swapper_pg_dir[pgd_index(temp)].pgd;
 	}
 
-- 
1.7.4.4

