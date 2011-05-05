Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1EETUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:20:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab1EETUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:20:10 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 5/5] efi: Ensure that the entirity of a region is mapped
Date: Thu,  5 May 2011 15:19:46 -0400
Message-Id: <1304623186-18261-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1304623186-18261-1-git-send-email-mjg@redhat.com>
References: <1304623186-18261-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible for init_memory_mapping() to fail to map the entire region
if it crosses a boundary, so ensure that we complete the mapping.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi_64.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 94d6b39..2649426 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -89,8 +89,10 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 		return ioremap(phys_addr, size);
 
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
-	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size)
-		return NULL;
+	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
+		unsigned long top = last_map_pfn << PAGE_SHIFT;
+		efi_ioremap(top, size - (top - phys_addr), type);
+	}
 
 	return (void __iomem *)__va(phys_addr);
 }
-- 
1.7.5

