Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab0GASdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:33:31 -0400
Received: from kroah.org ([198.145.64.141]:40727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090Ab0GASYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:08 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:16 2010
Message-Id: <20100701173216.260247956@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [patch 112/149] ath9k: add support for 802.11n bonded out AR2427
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 5ffaf8a361b4c9025963959a744f21d8173c7669 upstream.

Some single chip family devices are sold in the market with
802.11n bonded out, these have no hardware capability for
802.11n but ath9k can still support them. These are called
AR2427.

[bwh: backported to 2.6.32]
Reported-by: Rolf Leggewie <bugzilla.kernel.org@rolf.leggewie.biz>
Tested-by: Bernhard Reiter <ockham@raz.or.at>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c   |    7 ++++++-
 drivers/net/wireless/ath/ath9k/hw.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    4 +++-
 drivers/net/wireless/ath/ath9k/pci.c  |    1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -398,7 +398,6 @@ static void ath9k_hw_init_config(struct
 	ah->config.pcie_clock_req = 0;
 	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
-	ah->config.ht_enable = 1;
 	ah->config.ofdm_trig_low = 200;
 	ah->config.ofdm_trig_high = 500;
 	ah->config.cck_trig_high = 200;
@@ -412,6 +411,11 @@ static void ath9k_hw_init_config(struct
 		ah->config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
+	if (ah->hw_version.devid != AR2427_DEVID_PCIE)
+		ah->config.ht_enable = 1;
+	else
+		ah->config.ht_enable = 0;
+
 	ah->config.intr_mitigation = true;
 
 	/*
@@ -617,6 +621,7 @@ static bool ath9k_hw_devid_supported(u16
 	case AR9285_DEVID_PCIE:
 	case AR5416_DEVID_AR9287_PCI:
 	case AR5416_DEVID_AR9287_PCIE:
+	case AR2427_DEVID_PCIE:
 		return true;
 	default:
 		break;
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -37,6 +37,7 @@
 #define AR9280_DEVID_PCI	0x0029
 #define AR9280_DEVID_PCIE	0x002a
 #define AR9285_DEVID_PCIE	0x002b
+#define AR2427_DEVID_PCIE	0x002c
 #define AR5416_AR9100_DEVID	0x000b
 #define	AR_SUBVENDOR_ID_NOG	0x0e11
 #define AR_SUBVENDOR_ID_NEW_A	0x7065
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1541,12 +1541,14 @@ void ath_set_hw_capab(struct ath_softc *
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SPECTRUM_MGMT;
 
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
+		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
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


