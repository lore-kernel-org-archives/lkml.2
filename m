Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1AFA4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:56:51 -0500
Received: from kroah.org ([198.145.64.141]:35593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab1AFA32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:28 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002300.412824585@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [040/152] ath9k_hw: fix endian issues with CTLs on AR9003
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit e702ba18f25887c76d26c8a85cc1706463c62e9a upstream.

Parsing data using bitfields is messy, because it makes endian handling
much harder. AR9002 and earlier got it right, AR9003 got it wrong.
This might lead to either using too high or too low tx power values,
depending on frequency and eeprom settings.
Fix it by getting rid of the CTL related bitfields entirely and use
masks instead.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   79 ++++++++++++-------------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    9 --
 drivers/net/wireless/ath/ath9k/eeprom.c        |    6 -
 drivers/net/wireless/ath/ath9k/eeprom.h        |   13 +---
 4 files changed, 50 insertions(+), 57 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -55,6 +55,8 @@
 #define SUB_NUM_CTL_MODES_AT_5G_40 2    /* excluding HT40, EXT-OFDM */
 #define SUB_NUM_CTL_MODES_AT_2G_40 3    /* excluding HT40, EXT-OFDM, EXT-CCK */
 
+#define CTL(_tpower, _flag) ((_tpower) | ((_flag) << 6))
+
 static const struct ar9300_eeprom ar9300_default = {
 	.eepromVersion = 2,
 	.templateVersion = 2,
@@ -290,20 +292,21 @@ static const struct ar9300_eeprom ar9300
 		}
 	 },
 	.ctlPowerData_2G = {
-		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
-		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
-		 { { {60, 1}, {60, 0}, {60, 0}, {60, 1} } },
-
-		 { { {60, 1}, {60, 0}, {0, 0}, {0, 0} } },
-		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
-		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
-
-		 { { {60, 0}, {60, 1}, {60, 1}, {60, 0} } },
-		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
-		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
-
-		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
-		 { { {60, 0}, {60, 1}, {60, 1}, {60, 1} } },
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
+		 { { CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 1) } },
+
+		 { { CTL(60, 1), CTL(60, 0), CTL(0, 0), CTL(0, 0) } },
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
+
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 1), CTL(60, 0) } },
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
+
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 0) } },
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 1), CTL(60, 1) } },
+		 { { CTL(60, 0), CTL(60, 1), CTL(60, 1), CTL(60, 1) } },
 	 },
 	.modalHeader5G = {
 		/* 4 idle,t1,t2,b (4 bits per setting) */
@@ -568,56 +571,56 @@ static const struct ar9300_eeprom ar9300
 	.ctlPowerData_5G = {
 		{
 			{
-				{60, 1}, {60, 1}, {60, 1}, {60, 1},
-				{60, 1}, {60, 1}, {60, 1}, {60, 0},
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 1),
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 0),
 			}
 		},
 		{
 			{
-				{60, 1}, {60, 1}, {60, 1}, {60, 1},
-				{60, 1}, {60, 1}, {60, 1}, {60, 0},
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 1),
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 0),
 			}
 		},
 		{
 			{
-				{60, 0}, {60, 1}, {60, 0}, {60, 1},
-				{60, 1}, {60, 1}, {60, 1}, {60, 1},
+				CTL(60, 0), CTL(60, 1), CTL(60, 0), CTL(60, 1),
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 1),
 			}
 		},
 		{
 			{
-				{60, 0}, {60, 1}, {60, 1}, {60, 0},
-				{60, 1}, {60, 0}, {60, 0}, {60, 0},
+				CTL(60, 0), CTL(60, 1), CTL(60, 1), CTL(60, 0),
+				CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0),
 			}
 		},
 		{
 			{
-				{60, 1}, {60, 1}, {60, 1}, {60, 0},
-				{60, 0}, {60, 0}, {60, 0}, {60, 0},
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 0),
+				CTL(60, 0), CTL(60, 0), CTL(60, 0), CTL(60, 0),
 			}
 		},
 		{
 			{
-				{60, 1}, {60, 1}, {60, 1}, {60, 1},
-				{60, 1}, {60, 0}, {60, 0}, {60, 0},
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 1),
+				CTL(60, 1), CTL(60, 0), CTL(60, 0), CTL(60, 0),
 			}
 		},
 		{
 			{
-				{60, 1}, {60, 1}, {60, 1}, {60, 1},
-				{60, 1}, {60, 1}, {60, 1}, {60, 1},
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 1),
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 1),
 			}
 		},
 		{
 			{
-				{60, 1}, {60, 1}, {60, 0}, {60, 1},
-				{60, 1}, {60, 1}, {60, 1}, {60, 0},
+				CTL(60, 1), CTL(60, 1), CTL(60, 0), CTL(60, 1),
+				CTL(60, 1), CTL(60, 1), CTL(60, 1), CTL(60, 0),
 			}
 		},
 		{
 			{
-				{60, 1}, {60, 0}, {60, 1}, {60, 1},
-				{60, 1}, {60, 1}, {60, 0}, {60, 1},
+				CTL(60, 1), CTL(60, 0), CTL(60, 1), CTL(60, 1),
+				CTL(60, 1), CTL(60, 1), CTL(60, 0), CTL(60, 1),
 			}
 		},
 	 }
@@ -1827,9 +1830,9 @@ static u16 ar9003_hw_get_direct_edge_pow
 	struct cal_ctl_data_5g *ctl_5g = eep->ctlPowerData_5G;
 
 	if (is2GHz)
-		return ctl_2g[idx].ctlEdges[edge].tPower;
+		return CTL_EDGE_TPOWER(ctl_2g[idx].ctlEdges[edge]);
 	else
-		return ctl_5g[idx].ctlEdges[edge].tPower;
+		return CTL_EDGE_TPOWER(ctl_5g[idx].ctlEdges[edge]);
 }
 
 static u16 ar9003_hw_get_indirect_edge_power(struct ar9300_eeprom *eep,
@@ -1847,12 +1850,12 @@ static u16 ar9003_hw_get_indirect_edge_p
 
 	if (is2GHz) {
 		if (ath9k_hw_fbin2freq(ctl_freqbin[edge - 1], 1) < freq &&
-		    ctl_2g[idx].ctlEdges[edge - 1].flag)
-			return ctl_2g[idx].ctlEdges[edge - 1].tPower;
+		    CTL_EDGE_FLAGS(ctl_2g[idx].ctlEdges[edge - 1]))
+			return CTL_EDGE_TPOWER(ctl_2g[idx].ctlEdges[edge - 1]);
 	} else {
 		if (ath9k_hw_fbin2freq(ctl_freqbin[edge - 1], 0) < freq &&
-		    ctl_5g[idx].ctlEdges[edge - 1].flag)
-			return ctl_5g[idx].ctlEdges[edge - 1].tPower;
+		    CTL_EDGE_FLAGS(ctl_5g[idx].ctlEdges[edge - 1]))
+			return CTL_EDGE_TPOWER(ctl_5g[idx].ctlEdges[edge - 1]);
 	}
 
 	return AR9300_MAX_RATE_POWER;
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -261,17 +261,12 @@ struct cal_tgt_pow_ht {
 	u8 tPow2x[14];
 } __packed;
 
-struct cal_ctl_edge_pwr {
-	u8 tPower:6,
-	   flag:2;
-} __packed;
-
 struct cal_ctl_data_2g {
-	struct cal_ctl_edge_pwr ctlEdges[AR9300_NUM_BAND_EDGES_2G];
+	u8 ctlEdges[AR9300_NUM_BAND_EDGES_2G];
 } __packed;
 
 struct cal_ctl_data_5g {
-	struct cal_ctl_edge_pwr ctlEdges[AR9300_NUM_BAND_EDGES_5G];
+	u8 ctlEdges[AR9300_NUM_BAND_EDGES_5G];
 } __packed;
 
 struct ar9300_eeprom {
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -240,16 +240,16 @@ u16 ath9k_hw_get_max_edge_power(u16 freq
 	for (i = 0; (i < num_band_edges) &&
 		     (pRdEdgesPower[i].bChannel != AR5416_BCHAN_UNUSED); i++) {
 		if (freq == ath9k_hw_fbin2freq(pRdEdgesPower[i].bChannel, is2GHz)) {
-			twiceMaxEdgePower = pRdEdgesPower[i].tPower;
+			twiceMaxEdgePower = CTL_EDGE_TPOWER(pRdEdgesPower[i].ctl);
 			break;
 		} else if ((i > 0) &&
 			   (freq < ath9k_hw_fbin2freq(pRdEdgesPower[i].bChannel,
 						      is2GHz))) {
 			if (ath9k_hw_fbin2freq(pRdEdgesPower[i - 1].bChannel,
 					       is2GHz) < freq &&
-			    pRdEdgesPower[i - 1].flag) {
+			    CTL_EDGE_FLAGS(pRdEdgesPower[i - 1].ctl)) {
 				twiceMaxEdgePower =
-					pRdEdgesPower[i - 1].tPower;
+					CTL_EDGE_TPOWER(pRdEdgesPower[i - 1].ctl);
 			}
 			break;
 		}
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -233,6 +233,9 @@
 
 #define AR9287_CHECKSUM_LOCATION (AR9287_EEP_START_LOC + 1)
 
+#define CTL_EDGE_TPOWER(_ctl) ((_ctl) & 0x3f)
+#define CTL_EDGE_FLAGS(_ctl) (((_ctl) >> 6) & 0x03)
+
 enum eeprom_param {
 	EEP_NFTHRESH_5,
 	EEP_NFTHRESH_2,
@@ -533,18 +536,10 @@ struct cal_target_power_ht {
 	u8 tPow2x[8];
 } __packed;
 
-
-#ifdef __BIG_ENDIAN_BITFIELD
-struct cal_ctl_edges {
-	u8 bChannel;
-	u8 flag:2, tPower:6;
-} __packed;
-#else
 struct cal_ctl_edges {
 	u8 bChannel;
-	u8 tPower:6, flag:2;
+	u8 ctl;
 } __packed;
-#endif
 
 struct cal_data_op_loop_ar9287 {
 	u8 pwrPdg[2][5];


