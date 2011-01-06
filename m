Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1AFA3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:32 -0500
Received: from kroah.org ([198.145.64.141]:35590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab1AFA31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:27 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002300.317532990@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [039/152] ath9k: Fix bug in reading input gpio state for ar9003
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit 9306990a656d9cfd8bf3586938012729c1f2ea50 upstream.

The register which gives input gpio state is 0x404c for ar9003,
currently 0x4048 is wrongly used. This will disable RF and make
it unusable on some of AR9003.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c  |    3 ++-
 drivers/net/wireless/ath/ath9k/reg.h |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2351,7 +2351,8 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah,
 		val = REG_READ(ah, AR7010_GPIO_IN);
 		return (MS(val, AR7010_GPIO_IN_VAL) & AR_GPIO_BIT(gpio)) == 0;
 	} else if (AR_SREV_9300_20_OR_LATER(ah))
-		return MS_REG_READ(AR9300, gpio) != 0;
+		return (MS(REG_READ(ah, AR_GPIO_IN), AR9300_GPIO_IN_VAL) &
+			AR_GPIO_BIT(gpio)) != 0;
 	else if (AR_SREV_9271(ah))
 		return MS_REG_READ(AR9271, gpio) != 0;
 	else if (AR_SREV_9287_10_OR_LATER(ah))
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1019,11 +1019,13 @@ enum {
 #define AR9287_GPIO_IN_VAL_S                     11
 #define AR9271_GPIO_IN_VAL                       0xFFFF0000
 #define AR9271_GPIO_IN_VAL_S                     16
-#define AR9300_GPIO_IN_VAL                       0x0001FFFF
-#define AR9300_GPIO_IN_VAL_S                     0
 #define AR7010_GPIO_IN_VAL                       0x0000FFFF
 #define AR7010_GPIO_IN_VAL_S                     0
 
+#define AR_GPIO_IN				 0x404c
+#define AR9300_GPIO_IN_VAL                       0x0001FFFF
+#define AR9300_GPIO_IN_VAL_S                     0
+
 #define AR_GPIO_OE_OUT                           (AR_SREV_9300_20_OR_LATER(ah) ? 0x4050 : 0x404c)
 #define AR_GPIO_OE_OUT_DRV                       0x3
 #define AR_GPIO_OE_OUT_DRV_NO                    0x0


