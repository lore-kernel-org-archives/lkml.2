Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1BJRS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:18:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44662 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab1BJRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:58 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 22/30] amd64_edac: Revamp online spare handling
Date: Thu, 10 Feb 2011 18:15:25 +0100
Message-Id: <1297358133-14320-23-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Replace per-DCT macros with smarter ones, drop hack and look for the
spare rank on all chip selects on a channel.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   32 ++++++++++++++------------------
 drivers/edac/amd64_edac.h |    6 ++----
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 1cbe9ca..4bba43e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -393,6 +393,9 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
 #define for_each_chip_select(i, dct, pvt) \
 	for (i = 0; i < pvt->csels[dct].b_cnt; i++)
 
+#define chip_select_base(i, dct, pvt) \
+	pvt->csels[dct].csbases[i]
+
 #define for_each_chip_select_mask(i, dct, pvt) \
 	for (i = 0; i < pvt->csels[dct].m_cnt; i++)
 
@@ -1254,30 +1257,23 @@ static u64 f10_get_norm_dct_addr(struct amd64_pvt *pvt, int range,
 	return (sys_addr & GENMASK(6,47)) - (chan_off & GENMASK(23,47));
 }
 
-/* Hack for the time being - Can we get this from BIOS?? */
-#define	CH0SPARE_RANK	0
-#define	CH1SPARE_RANK	1
-
 /*
  * checks if the csrow passed in is marked as SPARED, if so returns the new
  * spare row
  */
 static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
 {
-	u32 swap_done;
-	u32 bad_dram_cs;
+	int tmp_cs;
 
-	/* Depending on channel, isolate respective SPARING info */
-	if (dct) {
-		swap_done = F10_ONLINE_SPARE_SWAPDONE1(pvt->online_spare);
-		bad_dram_cs = F10_ONLINE_SPARE_BADDRAM_CS1(pvt->online_spare);
-		if (swap_done && (csrow == bad_dram_cs))
-			csrow = CH1SPARE_RANK;
-	} else {
-		swap_done = F10_ONLINE_SPARE_SWAPDONE0(pvt->online_spare);
-		bad_dram_cs = F10_ONLINE_SPARE_BADDRAM_CS0(pvt->online_spare);
-		if (swap_done && (csrow == bad_dram_cs))
-			csrow = CH0SPARE_RANK;
+	if (online_spare_swap_done(pvt, dct) &&
+	    csrow == online_spare_bad_dramcs(pvt, dct)) {
+
+		for_each_chip_select(tmp_cs, dct, pvt) {
+			if (chip_select_base(tmp_cs, dct, pvt) & 0x2) {
+				csrow = tmp_cs;
+				break;
+			}
+		}
 	}
 	return csrow;
 }
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 85e3acb..3c60b2f 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -259,10 +259,8 @@
 #define SCRCTRL				0x58
 
 #define F10_ONLINE_SPARE		0xB0
-#define F10_ONLINE_SPARE_SWAPDONE0(x)	((x) & BIT(1))
-#define F10_ONLINE_SPARE_SWAPDONE1(x)	((x) & BIT(3))
-#define F10_ONLINE_SPARE_BADDRAM_CS0(x) (((x) >> 4) & 0x00000007)
-#define F10_ONLINE_SPARE_BADDRAM_CS1(x) (((x) >> 8) & 0x00000007)
+#define online_spare_swap_done(pvt, c)	(((pvt)->online_spare >> (1 + 2 * (c))) & 0x1)
+#define online_spare_bad_dramcs(pvt, c)	(((pvt)->online_spare >> (4 + 4 * (c))) & 0x7)
 
 #define F10_NB_ARRAY_ADDR		0xB8
 #define F10_NB_ARRAY_DRAM_ECC		BIT(31)
-- 
1.7.4.rc2

