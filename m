Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1IUPmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:42:54 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3492 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1IUPmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:42:53 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>,
        "Jean Delvare" <khali@linux-fr.org>, "Ben Dooks" <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Qi Wang" <qi.wang@intel.com>,
        "yong.y.wang@intel.com" <yong.y.wang@intel.com>,
        "joel.clark@intel.com" <joel.clark@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Date: Wed, 21 Sep 2011 08:42:32 -0700
Subject: RE: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
Thread-Topic: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
Thread-Index: Acx4NAI6yZ+Ry7/DQf2F5wOmPfy2qQAQNniQ
Message-ID: <B6A520E9CD57404AAFC0831E4FB39541A98073AC7E@IRVEXCHCCR02.corp.ad.broadcom.com>
References: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6264D8E85IS10520914-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is i2c device coming out that uses 10-bit address.

Regards,

-Jeffrey

-----Original Message-----
From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-owner@vger.kernel.org] On Behalf Of Tomoya MORINAGA
Sent: Wednesday, September 21, 2011 3:52 AM
To: Jean Delvare; Ben Dooks; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Qi Wang; yong.y.wang@intel.com; joel.clark@intel.com; kok.howg.ewe@intel.com; toshiharu-linux@dsn.okisemi.com; Tomoya MORINAGA
Subject: [PATCH 3/7] i2c-eg20t: delete 10bit access processing

Linux I2C core doesn't support 10bit access formally.
Additionally, we can't test with 10bit mode.
This patch deletes the 10bit access processing.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |   27 +++++++--------------------
 1 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c index 21ade63..a87a878 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -389,8 +389,6 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 	u8 *buf;
 	u32 length;
 	u32 addr;
-	u32 addr_2_msb;
-	u32 addr_8_lsb;
 	s32 wrcount;
 	void __iomem *p = adap->pch_base_address;
 
@@ -410,25 +408,16 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
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
 		for (wrcount = 0; wrcount < length; ++wrcount) { @@ -497,7 +486,6 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 	u32 count;
 	u32 length;
 	u32 addr;
-	u32 addr_2_msb;
 	void __iomem *p = adap->pch_base_address;
 
 	length = msgs->len;
@@ -513,9 +501,8 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
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
1.7.4.4

--
To unsubscribe from this list: send the line "unsubscribe linux-i2c" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html


