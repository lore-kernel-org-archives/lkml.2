Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633Ab2CON5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 09:57:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab2CON5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 09:57:21 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, x86@kernel.org, matt.fleming@intel.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] EFI: Only set regions uncacheable if they support it
Date: Thu, 15 Mar 2012 09:56:38 -0400
Message-Id: <1331819798-1955-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EFI memory region attributes field indicates whether the region can
be mapped with various cache attributes. Our current implementation always
marks regions uncacheable if they don't have the writeback support flag.
This causes us to mark some regions uncacheable even if they don't
indicate support for being uncacheable, triggering a clflush that may cause
an MCE. Ensure we only do this for regions which support it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4cf9bd0..12f78e1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -682,7 +682,8 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
-		if (!(md->attribute & EFI_MEMORY_WB)) {
+		if (md->attribute & EFI_MEMORY_UC &&
+		    !(md->attribute & EFI_MEMORY_WB)) {
 			addr = md->virt_addr;
 			npages = md->num_pages;
 			memrange_efi_to_native(&addr, &npages);
-- 
1.7.7.6

