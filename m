Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2IKXCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:02:39 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:16193 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2IKXCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:02:38 -0400
From: T Makphaibulchoke <tmac@hp.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        matt.fleming@intel.com, keithp@keithp.com,
        linux-kernel@vger.kernel.org
Cc: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH] x86/platform/efi/efi_64.c: fix problem in efi_ioremap in case of a failure in init_memory_mapping.
Date: Tue, 11 Sep 2012 17:02:34 -0600
Message-Id: <1347404554-16975-1-git-send-email-tmac@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case that init_memory_mapping failed, returning a NULL, simply return.
An attempt to recursively invoke efi_io_remap could result in mapping of a
wrong range, 0 to size + physaddr, instead of the intended physaddr to
physaddr + size - 1 range.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>
---
 arch/x86/platform/efi/efi_64.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac3aa54..5d032e9 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -90,6 +90,14 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 		return ioremap(phys_addr, size);
 
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
+
+	if (!last_map_pfn) {
+		/* Do not try to rmmap again in case of a failure */
+		pr_warn("%s: mapping of 0x%lx(0x%lx) failed.\n",
+			__func__, phys_addr, size);
+		return NULL;
+	}
+
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
 		unsigned long top = last_map_pfn << PAGE_SHIFT;
 		efi_ioremap(top, size - (top - phys_addr), type);
-- 
1.7.1

