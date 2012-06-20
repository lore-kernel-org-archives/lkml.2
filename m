Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2FTIZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:25:01 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54336 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab2FTIY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:24:58 -0400
Date: Wed, 20 Jun 2012 03:24:57 -0500
From: Robin Holt <holt@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] phys_efi_set_virtual_address_map needs va, no pa.
Message-ID: <20120620082457.GE3464@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel allocated memmap may end up being beyond the first
512GB of memory.  That early range is identity mapped, while the
remainder of memory is not.  The net result is the memmap allocated by
efi_enter_virtual_mode will not be accessible via its __pa as is currently
passed back to EFI.

Since EFI is going to have to parse the passed in table, I believe the
EFI documentation is wrong.

I asked one of our BIOS engineers to look at the Intel reference code
and he said it was obvious that the address would have to be a virtaully
accessible address as we are in virtual mode while EFI is handling the
callback.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 92660ed..ea4317a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -869,7 +869,7 @@ void __init efi_enter_virtual_mode(void)
 		memmap.desc_size * count,
 		memmap.desc_size,
 		memmap.desc_version,
-		(efi_memory_desc_t *)__pa(new_memmap));
+		new_memmap);
 
 	if (status != EFI_SUCCESS) {
 		pr_alert("Unable to switch EFI into virtual mode "
-- 
1.7.0.4

