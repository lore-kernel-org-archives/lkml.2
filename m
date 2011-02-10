Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab1BJRQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:16:02 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44655 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab1BJRPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:55 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 19/30] amd64_edac: Add support for interleaved region swapping
Date: Thu, 10 Feb 2011 18:15:22 +0100
Message-Id: <1297358133-14320-20-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

On revC3 and revE Fam10h machines and later, non-interleaved graphics
framebuffer memory under the 16G mark can be swapped with a region
located at the bottom of memory so that the GPU can use the interleaved
region and thus two channels. Add support for that.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h |    2 ++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 7a7bd77..9ea1bb4 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1331,6 +1331,42 @@ static int f10_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
 	return cs_found;
 }
 
+/*
+ * See F2x10C. Non-interleaved graphics framebuffer memory under the 16G is
+ * swapped with a region located at the bottom of memory so that the GPU can use
+ * the interleaved region and thus two channels.
+ */
+static u64 f10_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
+{
+	u32 swap_reg, swap_base, swap_limit, rgn_size, tmp_addr;
+
+	if (boot_cpu_data.x86 == 0x10) {
+		/* only revC3 and revE have that feature */
+		if (boot_cpu_data.x86_model < 4 ||
+		    (boot_cpu_data.x86_model < 0xa &&
+		     boot_cpu_data.x86_mask < 3))
+			return sys_addr;
+	}
+
+	amd64_read_dct_pci_cfg(pvt, SWAP_INTLV_REG, &swap_reg);
+
+	if (!(swap_reg & 0x1))
+		return sys_addr;
+
+	swap_base	= (swap_reg >> 3) & 0x7f;
+	swap_limit	= (swap_reg >> 11) & 0x7f;
+	rgn_size	= (swap_reg >> 20) & 0x7f;
+	tmp_addr	= sys_addr >> 27;
+
+	if (!(sys_addr >> 34) &&
+	    (((tmp_addr >= swap_base) &&
+	     (tmp_addr <= swap_limit)) ||
+	     (tmp_addr < rgn_size)))
+		return sys_addr ^ (u64)swap_base << 27;
+
+	return sys_addr;
+}
+
 /* For a given @dram_range, check if @sys_addr falls within it. */
 static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 				  u64 sys_addr, int *nid, int *chan_sel)
@@ -1352,6 +1388,8 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 	    (intlv_sel != ((sys_addr >> 12) & intlv_en)))
 		return -EINVAL;
 
+	sys_addr = f10_swap_interleaved_region(pvt, sys_addr);
+
 	dct_sel_base = dct_sel_baseaddr(pvt);
 
 	/*
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 6ae8aa8..85e3acb 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -239,6 +239,8 @@
 #define dct_dram_enabled(pvt)		((pvt)->dct_sel_lo & BIT(8))
 #define dct_memory_cleared(pvt)		((pvt)->dct_sel_lo & BIT(10))
 
+#define SWAP_INTLV_REG			0x10c
+
 #define DCT_SEL_HI			0x114
 
 /*
-- 
1.7.4.rc2

