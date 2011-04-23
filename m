Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1DWHOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 03:14:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58739 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1DWHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 03:14:26 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/3] amd64_edac: Erratum #637 workaround
Date: Sat, 23 Apr 2011 09:13:59 +0200
Message-Id: <1303542839-28442-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F15h CPUs may report a non-DRAM address when reporting an error address
belonging to a CC6 state save area. Add a workaround to detect this
condition and compute the actual DRAM address of the error as documented
in the Revision Guide for AMD Family 15h Models 00h-0Fh Processors.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   52 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/edac/amd64_edac.h |    1 +
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 91f620f..03b0011 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -933,15 +933,63 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 /* On F10h and later ErrAddr is MC4_ADDR[47:1] */
 static u64 get_error_address(struct mce *m)
 {
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u64 addr;
 	u8 start_bit = 1;
 	u8 end_bit   = 47;
 
-	if (boot_cpu_data.x86 == 0xf) {
+	if (c->x86 == 0xf) {
 		start_bit = 3;
 		end_bit   = 39;
 	}
 
-	return m->addr & GENMASK(start_bit, end_bit);
+	addr = m->addr & GENMASK(start_bit, end_bit);
+
+	/*
+	 * Erratum 637 workaround
+	 */
+	if (c->x86 == 0x15) {
+		struct amd64_pvt *pvt;
+		u64 cc6_base, tmp_addr;
+		u32 tmp;
+		u8 mce_nid, intlv_en;
+
+		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
+			return addr;
+
+		mce_nid	= amd_get_nb_id(m->extcpu);
+		pvt	= mcis[mce_nid]->pvt_info;
+
+		amd64_read_pci_cfg(pvt->F1, DRAM_LOCAL_NODE_LIM, &tmp);
+		intlv_en = tmp >> 21 & 0x7;
+
+		/* add [47:27] + 3 trailing bits */
+		cc6_base  = (tmp & GENMASK(0, 20)) << 3;
+
+		/* reverse and add DramIntlvEn */
+		cc6_base |= intlv_en ^ 0x7;
+
+		/* pin at [47:24] */
+		cc6_base <<= 24;
+
+		if (!intlv_en)
+			return cc6_base | (addr & GENMASK(0, 23));
+
+		amd64_read_pci_cfg(pvt->F1, DRAM_LOCAL_NODE_BASE, &tmp);
+
+							/* faster log2 */
+		tmp_addr  = (addr & GENMASK(12, 23)) << __fls(intlv_en + 1);
+
+		/* OR DramIntlvSel into bits [14:12] */
+		tmp_addr |= (tmp & GENMASK(21, 23)) >> 9;
+
+		/* add remaining [11:0] bits from original MC4_ADDR */
+		tmp_addr |= addr & GENMASK(0, 11);
+
+		return cc6_base | tmp_addr;
+	}
+
+	return addr;
 }
 
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 0110930..9a666cb 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -196,6 +196,7 @@
 
 #define DCT_CFG_SEL			0x10C
 
+#define DRAM_LOCAL_NODE_BASE		0x120
 #define DRAM_LOCAL_NODE_LIM		0x124
 
 #define DRAM_BASE_HI			0x140
-- 
1.7.4.rc2

