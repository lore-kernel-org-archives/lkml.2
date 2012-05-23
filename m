Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2EWGhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:37:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32499 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965149Ab2EWGez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:34:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Airlie <airlied@linux.ie>
Subject: [PATCH 03/11] intel-gtt: Read 64bit for gmar_bus_addr
Date: Tue, 22 May 2012 23:34:29 -0700
Message-Id: <1337754877-19759-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That bar could be 64bit pref mem.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/char/agp/intel-gtt.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 7f025fb..77e150e 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -770,16 +770,22 @@ static void i830_write_entry(dma_addr_t addr, unsigned int entry,
 static bool intel_enable_gtt(void)
 {
 	u32 gma_addr;
+	u32 addr_hi = 0;
 	u8 __iomem *reg;
+	int pos;
 
 	if (INTEL_GTT_GEN <= 2)
-		pci_read_config_dword(intel_private.pcidev, I810_GMADDR,
-				      &gma_addr);
+		pos = I810_GMADDR;
 	else
-		pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
-				      &gma_addr);
+		pos = I915_GMADDR;
+
+	pci_read_config_dword(intel_private.pcidev, pos, &gma_addr);
+
+	if (gma_addr & PCI_BASE_ADDRESS_MEM_TYPE_64)
+		pci_read_config_dword(intel_private.pcidev, pos + 4, &addr_hi);
 
 	intel_private.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
+	intel_private.gma_bus_addr |= (u64)addr_hi << 32;
 
 	if (INTEL_GTT_GEN >= 6)
 	    return true;
-- 
1.7.7

