Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab1D1SDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:03:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab1D1SDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:03:00 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] x86: Populate virtual address field of all EFI memmap entries
Date: Thu, 28 Apr 2011 14:02:26 -0400
Message-Id: <1304013746-20239-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our current implementation of SetVirtualAddressMap passes back the entire
memory map it received from the firmware, but only modifies entries that
have the runtime attribute set. Experiments (mostly involving screaming)
with real-world EFI implementations suggests that some will call
ConvertPointer on data that exist outside runtime regions anyway. The
easiest fix here seems to be to continue remapping runtime regions and
just to copy the physical address to the virtal address for other regions.

This doesn't fix any observed problems with our current implementation,
but it seems better to be safe than sorry.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0fe27d7..f11b3b0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -507,8 +507,10 @@ void __init efi_enter_virtual_mode(void)
 	efi.systab = NULL;
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+			md->virt_addr = md->phys_addr;
 			continue;
+		}
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
-- 
1.7.4.4

