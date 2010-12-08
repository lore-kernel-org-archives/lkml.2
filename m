Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab0LHB6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:58:06 -0500
Received: from kroah.org ([198.145.64.141]:48500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867Ab0LHA73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:29 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:24 2010
Message-Id: <20101208005724.770204870@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        kyungwan.nam@atheros.com, amod.bodas@atheros.com,
        david.quan@atheros.com,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [034/289] ath9k_hw: Fix AR9280 surprise removal during frequent idle on/off
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit f119da3015712dc32bdf1c311652479e02dcb49a upstream.

Bit 22 of AR_WA should be set to fix the situation where chip reset
is asynchronous to clock of analog shift registers, such that when
reset is released, it could mess up the values of analog shift registers
and cause some hw issue on AR9280.

This bit is write only, but the driver does a read-modify-write
on AR_WA without setting bit 22 in ar9002_hw_configpcipowersave()
during radio disable. This causes surprise removal of hw. It can
never recover from this state and the hw will become usable only
after a power on/off cycle, and sometimes only during a cold reboot.

This issue can be triggered by doing frequent roaming with the
simple/test-roam script available from the wifi-test project [1]
when roaming between APs quickly. When roaming there is a is a high
possibility that the device being put into idle (radio disable) state
by mac80211 during AUTH->ASSOC. A device hardware reset would fail
and the kernel would output:

[40251.363799] ath: AWAKE -> FULL-SLEEP
[40251.363815] ieee80211 phy17: device no longer idle - working
[40251.363817] ath: Marking phy17 as not-idle
[40251.363819] ath: FULL-SLEEP -> AWAKE
[40251.415978] pciehp 0000:00:1c.3:pcie04: Card not present on Slot(3)
[40251.419896] ath: ah->misc_mode 0x4
[40251.428138] pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
[40251.532247] ath: timeout (100000 us) on reg 0x9860: 0xffffffff & 0x00000001 != 0x00000000
[40251.532250] ath: Unable to reset channel (2462 MHz), reset status -5
[40251.532422] ath: Set channel: 5745 MHz
[40251.540639] ath: Failed to stop TX DMA in 100 msec after killing last frame
[40251.548826] ath: Failed to stop TX DMA in 100 msec after killing last frame
[40251.557023] ath: Failed to stop TX DMA in 100 msec after killing last frame
[40251.565211] ath: Failed to stop TX DMA in 100 msec after killing last frame
[40251.573415] ath: Failed to stop TX DMA in 100 msec after killing last frame
[40251.581603] ath: Failed to stop TX DMA in 100 msec after killing last frame
[40251.581606] ath: Failed to stop TX DMA. Resetting hardware!
[40251.592679] ath: DMA failed to stop in 10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff
[40251.703330] ath: timeout (100000 us) on reg 0x7000: 0xffffffff & 0x00000003 != 0x00000000
[40251.703333] ath: RTC stuck in MAC reset
[40251.703334] ath: Chip reset failed
[40251.703335] ath: Unable to reset hardware; reset status -22

This is currently only reproducible with some HB92 (Half Mini-PCIE)
cards but the fix applies to all AR9280 cards. This patch fixes this
issue by setting bit 22 during radio disable.

This patch has fixes for all kernels that has ath9k.

[1] http://wireless.kernel.org/en/developers/Testing/wifi-test

Cc: kyungwan.nam@atheros.com
Cc: amod.bodas@atheros.com
Cc: david.quan@atheros.com
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    3 +++
 drivers/net/wireless/ath/ath9k/reg.h       |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -411,6 +411,9 @@ static void ar9002_hw_configpcipowersave
 			val &= ~(AR_WA_BIT6 | AR_WA_BIT7);
 		}
 
+		if (AR_SREV_9280(ah))
+			val |= AR_WA_BIT22;
+
 		if (AR_SREV_9285E_20(ah))
 			val |= AR_WA_BIT23;
 
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -709,6 +709,7 @@
 #define AR_WA_RESET_EN                  (1 << 18) /* Sw Control to enable PCI-Reset to POR (bit 15) */
 #define AR_WA_ANALOG_SHIFT              (1 << 20)
 #define AR_WA_POR_SHORT                 (1 << 21) /* PCI-E Phy reset control */
+#define AR_WA_BIT22			(1 << 22)
 #define AR9285_WA_DEFAULT		0x004a050b
 #define AR9280_WA_DEFAULT           	0x0040073b
 #define AR_WA_DEFAULT               	0x0000073f


