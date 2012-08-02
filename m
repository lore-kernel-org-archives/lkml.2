Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2HBAgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 20:36:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29134 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2HBAgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 20:36:50 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: David Airlie <airlied@linux.ie>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] intel-gtt: Read 64bit for gmar_bus_addr
Date: Wed,  1 Aug 2012 17:36:41 -0700
Message-Id: <1343867801-12925-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That bar could be 64bit pref mem.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

---
 drivers/char/agp/intel-gtt.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/char/agp/intel-gtt.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/intel-gtt.c
+++ linux-2.6/drivers/char/agp/intel-gtt.c
@@ -649,8 +649,10 @@ static void intel_gtt_cleanup(void)
 static int intel_gtt_init(void)
 {
 	u32 gma_addr;
+	u32 addr_hi = 0;
 	u32 gtt_map_size;
 	int ret;
+	int pos;
 
 	ret = intel_private.driver->setup();
 	if (ret != 0)
@@ -696,13 +698,17 @@ static int intel_gtt_init(void)
 	}
 
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
 
 	intel_private.base.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
+	intel_private.base.gma_bus_addr |= (u64)addr_hi << 32;
 
 	return 0;
 }
