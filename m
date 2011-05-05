Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1EEUjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:39:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1EEUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:39:53 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=3rvgeqzMqd0A:10 a=lRdenv755oAA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=VcDgEAV9snQKhSZKTzsA:9 a=XTpm0jwfgN1aOO3zrZYA:7 a=CjuIK1q_8ugA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Thu, 05 May 2011 15:39:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linux-wireless@vger.kernel.org
Cc: chaoming_li@realsil.com.cn, linux-kernel@vger.kernel.org
Subject: [RFC] rtlwifi: Remove large arrays from stack - a question
Message-ID: <4dc30b12.uDIivxjeQot+s05F%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In driver rtlwifi, one routine places two relatively large arrays on the
stack - a 1D u8 array of size 128, and a 2D array of u16 with 128 * 4 elements.
With the next driver to be used with rtlwifi, the sizes will be 256 and
256 * 4 respectively. As that will make the 2D array be 2048 bytes, I have
changed the code to use kmalloc to allocate the space as shown in the patch
below. This code has been tested.

This method performs 6 kmalloc operations. My understanding is that each one
allocates a page of memory, which makes the code allocate 6 KiB rather than
the previous 5 * 128 or 5 * 256 bytes. This routine is called once for each
load of an upper-level driver that uses rtlwifi.

Given that the large arrays on the stack needed to be removed, I see three 
possible options:

1. Leave it this way as 6 allocations of O(0) are trivial.

2. Switch to a single allocation of up to 1280 B and set the pointers manually.

3. Add the arrays to a structure maintained by the upper-level driver, which
   would make the memory usage be permanent.

My inclination is to use option 1. Are there strong arguments for one of the
other alternatives, or any that I have not considered?

Thanks,

Larry


Index: wireless-testing-new/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/efuse.c
@@ -235,7 +235,7 @@ void read_efuse(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 efuse_tbl[rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]];
+	u8 *efuse_tbl;
 	u8 rtemp8[1];
 	u16 efuse_addr = 0;
 	u8 offset, wren;
@@ -245,7 +245,7 @@ void read_efuse(struct ieee80211_hw *hw,
 		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
 	const u32 efuse_len =
 		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
-	u16 efuse_word[efuse_max_section][EFUSE_MAX_WORD_UNIT];
+	u16 **efuse_word;
 	u16 efuse_utilized = 0;
 	u8 efuse_usage;
 
@@ -256,9 +256,24 @@ void read_efuse(struct ieee80211_hw *hw,
 		return;
 	}
 
+	/* allocate memory for efuse_tbl and efuse_word */
+	efuse_tbl = kmalloc(rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE] *
+			    sizeof(u8), GFP_KERNEL);
+	if (!efuse_tbl)
+		return;
+	efuse_word = kmalloc(EFUSE_MAX_WORD_UNIT * sizeof(u16 *), GFP_KERNEL);
+	if (!efuse_word)
+		goto done;
+	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
+		efuse_word[i] = kmalloc(efuse_max_section * sizeof(u16),
+				        GFP_KERNEL);
+		if (!efuse_word[i])
+			goto done;
+	}
+
 	for (i = 0; i < efuse_max_section; i++)
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++)
-			efuse_word[i][j] = 0xFFFF;
+			efuse_word[j][i] = 0xFFFF;
 
 	read_efuse_byte(hw, efuse_addr, rtemp8);
 	if (*rtemp8 != 0xFF) {
@@ -285,7 +300,7 @@ void read_efuse(struct ieee80211_hw *hw,
 					read_efuse_byte(hw, efuse_addr, rtemp8);
 					efuse_addr++;
 					efuse_utilized++;
-					efuse_word[offset][i] = (*rtemp8 & 0xff);
+					efuse_word[i][offset] = (*rtemp8 & 0xff);
 
 					if (efuse_addr >= efuse_len)
 						break;
@@ -297,7 +312,7 @@ void read_efuse(struct ieee80211_hw *hw,
 					read_efuse_byte(hw, efuse_addr, rtemp8);
 					efuse_addr++;
 					efuse_utilized++;
-					efuse_word[offset][i] |=
+					efuse_word[i][offset] |=
 					    (((u16)*rtemp8 << 8) & 0xff00);
 
 					if (efuse_addr >= efuse_len)
@@ -320,9 +335,9 @@ void read_efuse(struct ieee80211_hw *hw,
 	for (i = 0; i < efuse_max_section; i++) {
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++) {
 			efuse_tbl[(i * 8) + (j * 2)] =
-			    (efuse_word[i][j] & 0xff);
+			    (efuse_word[j][i] & 0xff);
 			efuse_tbl[(i * 8) + ((j * 2) + 1)] =
-			    ((efuse_word[i][j] >> 8) & 0xff);
+			    ((efuse_word[j][i] >> 8) & 0xff);
 		}
 	}
 
@@ -336,6 +351,11 @@ void read_efuse(struct ieee80211_hw *hw,
 				      (u8 *)&efuse_utilized);
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_EFUSE_USAGE,
 				      (u8 *)&efuse_usage);
+done:
+	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++)
+		kfree(efuse_word[i]);
+	kfree(efuse_word);
+	kfree(efuse_tbl);
 }
 
 bool efuse_shadow_update_chk(struct ieee80211_hw *hw)
