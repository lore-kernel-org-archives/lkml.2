Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab0H3SeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:34:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34174 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0H3SeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cczfsCJ60GZFcDY8ZNtcMxjefrWlCuv3vLrDdcx5mV2ZOZIAvxHwU5Joo0KGD7MgRQ
         k4PbSgf/CH/Ec5avhLgOHY6mFYhHQ2VnpkKvi7dLyMSnK6yc5GUu0M+vTmqt7YkfsejM
         qfThwUvkgbK8DOHSxCtc2C4BkOwGvq7Idtzj0=
Date: Mon, 30 Aug 2010 21:04:01 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Andi Kleen <andi@firstfloor.org>, Bob Copeland <me@bobcopeland.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2] bitops: Provide generic sign_extend32 function
Message-ID: <20100830190400.GB4749@loge.amd.com>
References: <20100827101651.GC5348@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827101651.GC5348@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

This patch moves code out from wireless drivers where two different
functions are defined in three code locations for the same purpose and
provides a common function to sign extend a 32-bit value.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/net/wireless/ath/ath5k/phy.c        |    8 +-------
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   12 ++++++------
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   12 ++++++------
 drivers/net/wireless/ath/ath9k/hw.h         |    6 ------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   20 ++------------------
 include/linux/bitops.h                      |   11 +++++++++++
 7 files changed, 30 insertions(+), 47 deletions(-)

Differences to first version.
(1) Rename to sign_extend32 - it handles only 32-bit values
(2) Adapt function calls in ath*k code - the common function uses bit
    position (0..31) instead of number of bits (1..32)


Andreas

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 6284c38..c9295b4 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1101,18 +1101,12 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
   PHY calibration
 \*****************/
 
-static int sign_extend(int val, const int nbits)
-{
-	int order = BIT(nbits-1);
-	return (val ^ order) - order;
-}
-
 static s32 ath5k_hw_read_measured_noise_floor(struct ath5k_hw *ah)
 {
 	s32 val;
 
 	val = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
-	return sign_extend(AR5K_REG_MS(val, AR5K_PHY_NF_MINCCA_PWR), 9);
+	return sign_extend32(AR5K_REG_MS(val, AR5K_PHY_NF_MINCCA_PWR), 8);
 }
 
 void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 3d2c867..0a7d136 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1498,25 +1498,25 @@ static void ar5008_hw_do_getnf(struct ath_hw *ah,
 	int16_t nf;
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA), AR_PHY_MINCCA_PWR);
-	nfarray[0] = sign_extend(nf, 9);
+	nfarray[0] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH1_CCA), AR_PHY_CH1_MINCCA_PWR);
-	nfarray[1] = sign_extend(nf, 9);
+	nfarray[1] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH2_CCA), AR_PHY_CH2_MINCCA_PWR);
-	nfarray[2] = sign_extend(nf, 9);
+	nfarray[2] = sign_extend32(nf, 8);
 
 	if (!IS_CHAN_HT40(ah->curchan))
 		return;
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
-	nfarray[3] = sign_extend(nf, 9);
+	nfarray[3] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA), AR_PHY_CH1_EXT_MINCCA_PWR);
-	nfarray[4] = sign_extend(nf, 9);
+	nfarray[4] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH2_EXT_CCA), AR_PHY_CH2_EXT_MINCCA_PWR);
-	nfarray[5] = sign_extend(nf, 9);
+	nfarray[5] = sign_extend32(nf, 8);
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index adbf031..4b99c33 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -474,21 +474,21 @@ static void ar9002_hw_do_getnf(struct ath_hw *ah,
 	int16_t nf;
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA), AR9280_PHY_MINCCA_PWR);
-	nfarray[0] = sign_extend(nf, 9);
+	nfarray[0] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR9280_PHY_EXT_MINCCA_PWR);
 	if (IS_CHAN_HT40(ah->curchan))
-		nfarray[3] = sign_extend(nf, 9);
+		nfarray[3] = sign_extend32(nf, 8);
 
 	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		return;
 
 	nf = MS(REG_READ(ah, AR_PHY_CH1_CCA), AR9280_PHY_CH1_MINCCA_PWR);
-	nfarray[1] = sign_extend(nf, 9);
+	nfarray[1] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA), AR9280_PHY_CH1_EXT_MINCCA_PWR);
 	if (IS_CHAN_HT40(ah->curchan))
-		nfarray[4] = sign_extend(nf, 9);
+		nfarray[4] = sign_extend32(nf, 8);
 }
 
 static void ar9002_hw_set_nf_limits(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index a491854..e52634e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1025,25 +1025,25 @@ static void ar9003_hw_do_getnf(struct ath_hw *ah,
 	int16_t nf;
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA_0), AR_PHY_MINCCA_PWR);
-	nfarray[0] = sign_extend(nf, 9);
+	nfarray[0] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA_1), AR_PHY_CH1_MINCCA_PWR);
-	nfarray[1] = sign_extend(nf, 9);
+	nfarray[1] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_CCA_2), AR_PHY_CH2_MINCCA_PWR);
-	nfarray[2] = sign_extend(nf, 9);
+	nfarray[2] = sign_extend32(nf, 8);
 
 	if (!IS_CHAN_HT40(ah->curchan))
 		return;
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
-	nfarray[3] = sign_extend(nf, 9);
+	nfarray[3] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_1), AR_PHY_CH1_EXT_MINCCA_PWR);
-	nfarray[4] = sign_extend(nf, 9);
+	nfarray[4] = sign_extend32(nf, 8);
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_2), AR_PHY_CH2_EXT_MINCCA_PWR);
-	nfarray[5] = sign_extend(nf, 9);
+	nfarray[5] = sign_extend32(nf, 8);
 }
 
 static void ar9003_hw_set_nf_limits(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 399f7c1..5dad02f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -858,12 +858,6 @@ static inline struct ath_hw_ops *ath9k_hw_ops(struct ath_hw *ah)
 	return &ah->ops;
 }
 
-static inline int sign_extend(int val, const int nbits)
-{
-	int order = BIT(nbits-1);
-	return (val ^ order) - order;
-}
-
 /* Initialization, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_deinit(struct ath_hw *ah);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d92b729..92ded39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1551,22 +1551,6 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 }
 
 /**
- * sign_extend - Sign extend a value using specified bit as sign-bit
- *
- * Example: sign_extend(9, 3) would return -7 as bit3 of 1001b is 1
- * and bit0..2 is 001b which when sign extended to 1111111111111001b is -7.
- *
- * @param oper value to sign extend
- * @param index 0 based bit index (0<=index<32) to sign bit
- */
-static s32 sign_extend(u32 oper, int index)
-{
-	u8 shift = 31 - index;
-
-	return (s32)(oper << shift) >> shift;
-}
-
-/**
  * iwl4965_hw_get_temperature - return the calibrated temperature (in Kelvin)
  * @statistics: Provides the temperature reading from the uCode
  *
@@ -1603,9 +1587,9 @@ static int iwl4965_hw_get_temperature(struct iwl_priv *priv)
 	 * "initialize" ALIVE response.
 	 */
 	if (!test_bit(STATUS_TEMPERATURE, &priv->status))
-		vt = sign_extend(R4, 23);
+		vt = sign_extend32(R4, 23);
 	else
-		vt = sign_extend(le32_to_cpu(priv->_agn.statistics.
+		vt = sign_extend32(le32_to_cpu(priv->_agn.statistics.
 				 general.common.temperature), 23);
 
 	IWL_DEBUG_TEMP(priv, "Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index fc68053..a68246e 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -109,6 +109,17 @@ static inline __u8 ror8(__u8 word, unsigned int shift)
 	return (word >> shift) | (word << (8 - shift));
 }
 
+/**
+ * sign_extend32 - sign extend a 32-bit value using specified bit as sign-bit
+ * @value: value to sign extend
+ * @index: 0 based bit index (0<=index<32) to sign bit
+ */
+static inline __s32 sign_extend32(__u32 value, int index)
+{
+	__u8 shift = 31 - index;
+	return (__s32)(value << shift) >> shift;
+}
+
 static inline unsigned fls_long(unsigned long l)
 {
 	if (sizeof(l) == 4)
-- 
1.6.4.4

