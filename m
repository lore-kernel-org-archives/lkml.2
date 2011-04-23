Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1DWHO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 03:14:28 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58735 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1DWHOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 03:14:25 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/3] amd64_edac: Factor in CC6 save area
Date: Sat, 23 Apr 2011 09:13:58 +0200
Message-Id: <1303542839-28442-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F15h and later use a portion of DRAM as a CC6 storage area. BIOS
programs D18F1x[17C:140,7C:40] DRAM Base/Limit accordingly by
subtracting the storage area from the DRAM limit setting. However, in
order for edac to consider that part of DRAM too, we need to include it
into the per-node range.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   28 +++++++++++++++++++++++++++-
 drivers/edac/amd64_edac.h |    2 ++
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8dff05b..91f620f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -946,12 +946,13 @@ static u64 get_error_address(struct mce *m)
 
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
+	struct cpuinfo_x86 *c = &boot_cpu_data;
 	int off = range << 3;
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_LO + off,  &pvt->ranges[range].base.lo);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_LO + off, &pvt->ranges[range].lim.lo);
 
-	if (boot_cpu_data.x86 == 0xf)
+	if (c->x86 == 0xf)
 		return;
 
 	if (!dram_rw(pvt, range))
@@ -959,6 +960,31 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_HI + off,  &pvt->ranges[range].base.hi);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_HI + off, &pvt->ranges[range].lim.hi);
+
+	/* Factor in CC6 save area by reading dst node's limit reg */
+	if (c->x86 == 0x15) {
+		struct pci_dev *f1 = NULL;
+		u8 nid = dram_dst_node(pvt, range);
+		u32 llim;
+
+		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
+		if (WARN_ON(!f1))
+			return;
+
+		amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
+
+		pvt->ranges[range].lim.lo &= GENMASK(0, 15);
+
+					    /* {[39:27],111b} */
+		pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
+
+		pvt->ranges[range].lim.hi &= GENMASK(0, 7);
+
+					    /* [47:40] */
+		pvt->ranges[range].lim.hi |= llim >> 13;
+
+		pci_dev_put(f1);
+	}
 }
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 11be36a..0110930 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -196,6 +196,8 @@
 
 #define DCT_CFG_SEL			0x10C
 
+#define DRAM_LOCAL_NODE_LIM		0x124
+
 #define DRAM_BASE_HI			0x140
 #define DRAM_LIMIT_HI			0x144
 
-- 
1.7.4.rc2

