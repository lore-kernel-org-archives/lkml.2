Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1EETUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab1EETUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:20:08 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/5] efi: Merge contiguous memory regions of the same type and attribute
Date: Thu,  5 May 2011 15:19:44 -0400
Message-Id: <1304623186-18261-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1304623186-18261-1-git-send-email-mjg@redhat.com>
References: <1304623186-18261-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some firmware implementations assume that physically contiguous regions
will be contiguous in virtual address space. This assumption is, obviously,
entirely unjustifiable. Said firmware implementations lack the good grace
to handle their failings in a measured and reasonable manner, instead
tending to shit all over address space and oopsing the kernel.

In an ideal universe these firmware implementations would simultaneously
catch fire and cease to be a problem, but since some of them are present
in attractively thin and shiny metal devices vanity wins out and some
poor developer spends an extended period of time surrounded by a
growing array of empty bottles until the underlying reason becomes
apparent. Said developer presents this patch, which simply merges
adjacent regions if they happen to be contiguous and have the same EFI
memory type and caching attributes.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7daae27..a46a73e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -498,13 +498,41 @@ static void __init runtime_code_page_mkexec(void)
  */
 void __init efi_enter_virtual_mode(void)
 {
-	efi_memory_desc_t *md;
+	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
 	u64 end, systab, addr, npages, end_pfn;
 	void *p, *va;
 
 	efi.systab = NULL;
+
+	/* Merge contiguous regions of the same type and attribute */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		u64 prev_size;
+		md = p;
+
+		if (!prev_md) {
+			prev_md = md;
+			continue;
+		}
+
+		if (prev_md->type != md->type ||
+		    prev_md->attribute != md->attribute) {
+			prev_md = md;
+			continue;
+		}
+
+		prev_size = prev_md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->phys_addr == (prev_md->phys_addr + prev_size)) {
+			prev_md->num_pages += md->num_pages;
+			md->type = EFI_RESERVED_TYPE;
+			md->attribute = 0;
+			continue;
+		}
+		prev_md = md;
+	}
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
-- 
1.7.5

