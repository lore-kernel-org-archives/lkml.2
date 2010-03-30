Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0C3XuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:50:19 -0400
Received: from kroah.org ([198.145.64.141]:45851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab0C3XTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:42 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:41 2010
Message-Id: <20100330224741.032655311@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [032/156] ath9k: add support for 802.11n bonded out AR2427
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

This is a backport of of upstream commit:

5ffaf8a361b4c9025963959a744f21d8173c7669

Some single chip family devices are sold in the market with
802.11n bonded out, these have no hardware capability for
02.11n but ath9k can still support them. These are called
AR2427.

Reported-by: Rolf Leggewie <bugzilla.kernel.org@rolf.leggewie.biz>
Tested-by: Bernhard Reiter <ockham@raz.or.at>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c   |    7 ++++++-
 drivers/net/wireless/ath/ath9k/hw.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    4 +++-
 drivers/net/wireless/ath/ath9k/pci.c  |    1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -380,7 +380,6 @@ static void ath9k_hw_init_config(struct
 	ah->config.pcie_clock_req = 0;
 	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
-	ah->config.ht_enable = 1;
 	ah->config.ofdm_trig_low = 200;
 	ah->config.ofdm_trig_high = 500;
 	ah->config.cck_trig_high = 200;
@@ -392,6 +391,11 @@ static void ath9k_hw_init_config(struct
 		ah->config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
+	if (ah->hw_version.devid != AR2427_DEVID_PCIE)
+		ah->config.ht_enable = 1;
+	else
+		ah->config.ht_enable = 0;
+
 	ah->config.intr_mitigation = true;
 
 	/*
@@ -590,6 +594,7 @@ static bool ath9k_hw_devid_supported(u16
 	case AR5416_DEVID_AR9287_PCI:
 	case AR5416_DEVID_AR9287_PCIE:
 	case AR9271_USB:
+	case AR2427_DEVID_PCIE:
 		return true;
 	default:
 		break;
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -40,6 +40,7 @@
 #define AR9280_DEVID_PCI	0x0029
 #define AR9280_DEVID_PCIE	0x002a
 #define AR9285_DEVID_PCIE	0x002b
+#define AR2427_DEVID_PCIE	0x002c
 
 #define AR5416_AR9100_DEVID	0x000b
 
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1854,11 +1854,13 @@ void ath_set_hw_capab(struct ath_softc *
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT;
 
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
+		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -25,6 +25,7 @@ static struct pci_device_id ath_pci_id_t
 	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x002B) }, /* PCI-E */
+	{ PCI_VDEVICE(ATHEROS, 0x002C) }, /* PCI-E 802.11n bonded out */
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
 	{ 0 }


