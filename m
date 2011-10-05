Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935240Ab1JERaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:30:08 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2357 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935224Ab1JERaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:30:04 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.lapis-semi.com>,
        "Jean Delvare" <khali@linux-fr.org>, "Ben Dooks" <ben-linux@fluff.org>,
        "Wolfram Sang" <w.sang@pengutronix.de>, "Qi Wang" <qi.wang@intel.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "yong.y.wang@intel.com" <yong.y.wang@intel.com>,
        "joel.clark@intel.com" <joel.clark@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>,
        "toshiharu-linux@dsn.lapis-semi.com" 
	<toshiharu-linux@dsn.lapis-semi.com>
Date: Wed, 5 Oct 2011 10:29:52 -0700
Subject: RE: [PATCH 2/7 v2] i2c-eg20t: delete 10bit access processing
Thread-Topic: [PATCH 2/7 v2] i2c-eg20t: delete 10bit access processing
Thread-Index: AcyDFi3uZ2KP52iIStKC8yrNrY4xjAAbiIJA
Message-ID: <B6A520E9CD57404AAFC0831E4FB39541A9807DDCB7@IRVEXCHCCR02.corp.ad.broadcom.com>
References: <1317788264-13118-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
 <1317788264-13118-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
In-Reply-To: <1317788264-13118-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 62924A175IS15745193-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any way I can help getting the code fixed instead of removed?

Regards,

-Jeffrey

-----Original Message-----
From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-owner@vger.kernel.org] On Behalf Of Tomoya MORINAGA
Sent: Wednesday, October 05, 2011 12:18 AM
To: Jean Delvare; Ben Dooks; Wolfram Sang; Qi Wang; Linus Walleij; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com; joel.clark@intel.com; kok.howg.ewe@intel.com; toshiharu-linux@dsn.lapis-semi.com; Tomoya MORINAGA
Subject: [PATCH 2/7 v2] i2c-eg20t: delete 10bit access processing

Linux I2C core doesn't support 10bit access formally.
Additionally, we can't test with 10bit mode.
This patch deletes the 10bit access processing.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |   27 +++++++--------------------
 1 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c index f8ccdec..c18210e 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -387,8 +387,6 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 	u8 *buf;
 	u32 length;
 	u32 addr;
-	u32 addr_2_msb;
-	u32 addr_8_lsb;
 	s32 wrcount;
 	void __iomem *p = adap->pch_base_address;
 
@@ -408,25 +406,16 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 	}
 
 	if (msgs->flags & I2C_M_TEN) {
-		addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7);
-		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
-		if (first)
-			pch_i2c_start(adap);
-		if (pch_i2c_wait_for_xfer_complete(adap) == 0 &&
-		    pch_i2c_getack(adap) == 0) {
-			addr_8_lsb = (addr & I2C_ADDR_MSK);
-			iowrite32(addr_8_lsb, p + PCH_I2CDR);
-		} else {
-			pch_i2c_stop(adap);
-			return -ETIME;
-		}
+		pch_err(adap, "10Bit access is not supported\n");
+		return -EINVAL;
 	} else {
 		/* set 7 bit slave address and R/W bit as 0 */
 		iowrite32(addr << 1, p + PCH_I2CDR);
-		if (first)
-			pch_i2c_start(adap);
 	}
 
+	if (first)
+		pch_i2c_start(adap);
+
 	if ((pch_i2c_wait_for_xfer_complete(adap) == 0) &&
 	    (pch_i2c_getack(adap) == 0)) {
 		for (wrcount = 0; wrcount < length; ++wrcount) { @@ -495,7 +484,6 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 	u32 count;
 	u32 length;
 	u32 addr;
-	u32 addr_2_msb;
 	void __iomem *p = adap->pch_base_address;
 
 	length = msgs->len;
@@ -511,9 +499,8 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 	}
 
 	if (msgs->flags & I2C_M_TEN) {
-		addr_2_msb = (((addr & I2C_MSB_2B_MSK) >> 7) | (I2C_RD));
-		iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
-
+		pch_err(adap, "10Bit access is not supported\n");
+		return -EINVAL;
 	} else {
 		/* 7 address bits + R/W bit */
 		addr = (((addr) << 1) | (I2C_RD));
--
1.7.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-i2c" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html


