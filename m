Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1GLH7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:59:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48684 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1GLH6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:58:23 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] x86: Fix memblock_x86_check_reserved_size() use in efi_reserve_boot_services()
Date: Tue, 12 Jul 2011 09:58:05 +0200
Message-Id: <1310457490-3356-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310457490-3356-1-git-send-email-tj@kernel.org>
References: <1310457490-3356-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of memblock_x86_check_reserved_size() doesn't
indicate whether there's an overlapping reservatoin or not.  It
indicates whether the caller needs to iterate further to discover all
reserved portions of the specified area.

efi_reserve_boot_esrvices() wants to check whether the boot services
area overlaps with other reservations but incorrectly used
membloc_x86_check_reserved_size().  Use memblock_is_region_reserved()
instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/platform/efi/efi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 899e393..a4c322c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -325,8 +325,7 @@ void __init efi_reserve_boot_services(void)
 		if ((start+size >= virt_to_phys(_text)
 				&& start <= virt_to_phys(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
-			memblock_x86_check_reserved_size(&start, &size,
-							1<<EFI_PAGE_SHIFT)) {
+			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
 			memblock_dbg(PFX "Could not reserve boot range "
-- 
1.7.6

