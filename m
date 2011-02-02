Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1BBA4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:56:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:54278 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab1BBAon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960741"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ivdoorn@gmail.com, IvDoorn@gmail.com, helmut.schaa@googlemail.com,
        linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [94/139] rt2x00: Fix max TX power settings
Message-Id: <20110202004452.2551A3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ivo van Doorn <ivdoorn@gmail.com>

commit 8d1331b37d5b656a7a8e561f8e9d7661dd00c910 upstream.

During initialization each driver reads the default TX power
for each individual channel. However mac80211 only accepts the
maximum value (which is also handled as default value).

As a result, the TX power of the device was being limited to
the default value, which is often quite low compared to the
real maximum acceptable value.

This patch allows each driver to set the maximum value on a
per-channel basis which is forwarded to mac80211. The default
value will be preserved for now, in case we want to update
mac80211 to differentiate between the maximum and default txpower.

This fixes bug complaining about limited TX power values like:
https://bugzilla.kernel.org/show_bug.cgi?id=16358

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/rt2x00/rt2400pci.c |    6 ++-
 drivers/net/wireless/rt2x00/rt2500pci.c |   12 ++++--
 drivers/net/wireless/rt2x00/rt2500usb.c |   12 ++++--
 drivers/net/wireless/rt2x00/rt2800.h    |    7 +++
 drivers/net/wireless/rt2x00/rt2800lib.c |   59 ++++++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt2x00.h    |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 -
 drivers/net/wireless/rt2x00/rt61pci.c   |   12 ++++--
 drivers/net/wireless/rt2x00/rt73usb.c   |   12 ++++--
 9 files changed, 82 insertions(+), 45 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2400pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt2400pci.c
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1462,8 +1462,10 @@ static int rt2400pci_probe_hw_mode(struc
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = TXPOWER_FROM_DEV(MAX_TXPOWER);
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	return 0;
 }
Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2500pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt2500pci.c
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1780,12 +1780,16 @@ static int rt2500pci_probe_hw_mode(struc
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_TXPOWER;
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	if (spec->num_channels > 14) {
-		for (i = 14; i < spec->num_channels; i++)
-			info[i].tx_power1 = DEFAULT_TXPOWER;
+		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_TXPOWER;
+			info[i].default_power1 = DEFAULT_TXPOWER;
+		}
 	}
 
 	return 0;
Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2500usb.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt2500usb.c
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1690,12 +1690,16 @@ static int rt2500usb_probe_hw_mode(struc
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_TXPOWER;
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	if (spec->num_channels > 14) {
-		for (i = 14; i < spec->num_channels; i++)
-			info[i].tx_power1 = DEFAULT_TXPOWER;
+		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_TXPOWER;
+			info[i].default_power1 = DEFAULT_TXPOWER;
+		}
 	}
 
 	return 0;
Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2800.h
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt2800.h
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2800.h
@@ -1770,6 +1770,13 @@ struct mac_iveiv_entry {
 #define EEPROM_RSSI_A2_LNA_A2		FIELD16(0xff00)
 
 /*
+ * EEPROM Maximum TX power values
+ */
+#define EEPROM_MAX_TX_POWER		0x0027
+#define EEPROM_MAX_TX_POWER_24GHZ	FIELD16(0x00ff)
+#define EEPROM_MAX_TX_POWER_5GHZ	FIELD16(0xff00)
+
+/*
  * EEPROM TXpower delta: 20MHZ AND 40 MHZ use different power.
  *	This is delta in 40MHZ.
  * VALUE: Tx Power dalta value (MAX=4)
Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2800lib.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt2800lib.c
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -840,27 +840,27 @@ static void rt2800_config_channel_rf2xxx
 		 * double meaning, and we should set a 7DBm boost flag.
 		 */
 		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_A_7DBM_BOOST,
-				   (info->tx_power1 >= 0));
+				   (info->default_power1 >= 0));
 
-		if (info->tx_power1 < 0)
-			info->tx_power1 += 7;
+		if (info->default_power1 < 0)
+			info->default_power1 += 7;
 
 		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_A,
-				   TXPOWER_A_TO_DEV(info->tx_power1));
+				   TXPOWER_A_TO_DEV(info->default_power1));
 
 		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_A_7DBM_BOOST,
-				   (info->tx_power2 >= 0));
+				   (info->default_power2 >= 0));
 
-		if (info->tx_power2 < 0)
-			info->tx_power2 += 7;
+		if (info->default_power2 < 0)
+			info->default_power2 += 7;
 
 		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_A,
-				   TXPOWER_A_TO_DEV(info->tx_power2));
+				   TXPOWER_A_TO_DEV(info->default_power2));
 	} else {
 		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_G,
-				   TXPOWER_G_TO_DEV(info->tx_power1));
+				   TXPOWER_G_TO_DEV(info->default_power1));
 		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_G,
-				   TXPOWER_G_TO_DEV(info->tx_power2));
+				   TXPOWER_G_TO_DEV(info->default_power2));
 	}
 
 	rt2x00_set_field32(&rf->rf4, RF4_HT40, conf_is_ht40(conf));
@@ -900,13 +900,11 @@ static void rt2800_config_channel_rf3xxx
 	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 12, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
-			  TXPOWER_G_TO_DEV(info->tx_power1));
+	rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER, info->default_power1);
 	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 13, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
-			  TXPOWER_G_TO_DEV(info->tx_power2));
+	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER, info->default_power2);
 	rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
@@ -2226,6 +2224,13 @@ int rt2800_validate_eeprom(struct rt2x00
 				   default_lna_gain);
 	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
 
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_MAX_TX_POWER, &word);
+	if (rt2x00_get_field16(word, EEPROM_MAX_TX_POWER_24GHZ) == 0xff)
+		rt2x00_set_field16(&word, EEPROM_MAX_TX_POWER_24GHZ, MAX_G_TXPOWER);
+	if (rt2x00_get_field16(word, EEPROM_MAX_TX_POWER_5GHZ) == 0xff)
+		rt2x00_set_field16(&word, EEPROM_MAX_TX_POWER_5GHZ, MAX_A_TXPOWER);
+	rt2x00_eeprom_write(rt2x00dev, EEPROM_MAX_TX_POWER, word);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_validate_eeprom);
@@ -2466,9 +2471,10 @@ int rt2800_probe_hw_mode(struct rt2x00_d
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power1;
-	char *tx_power2;
+	char *default_power1;
+	char *default_power2;
 	unsigned int i;
+	unsigned short max_power;
 	u16 eeprom;
 
 	/*
@@ -2566,21 +2572,26 @@ int rt2800_probe_hw_mode(struct rt2x00_d
 
 	spec->channels_info = info;
 
-	tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
-	tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_MAX_TX_POWER, &eeprom);
+	max_power = rt2x00_get_field16(eeprom, EEPROM_MAX_TX_POWER_24GHZ);
+	default_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
+	default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
 
 	for (i = 0; i < 14; i++) {
-		info[i].tx_power1 = TXPOWER_G_FROM_DEV(tx_power1[i]);
-		info[i].tx_power2 = TXPOWER_G_FROM_DEV(tx_power2[i]);
+		info[i].max_power = max_power;
+		info[i].default_power1 = TXPOWER_G_FROM_DEV(default_power1[i]);
+		info[i].default_power2 = TXPOWER_G_FROM_DEV(default_power2[i]);
 	}
 
 	if (spec->num_channels > 14) {
-		tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
-		tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
+		max_power = rt2x00_get_field16(eeprom, EEPROM_MAX_TX_POWER_5GHZ);
+		default_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
+		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
-			info[i].tx_power1 = TXPOWER_A_FROM_DEV(tx_power1[i]);
-			info[i].tx_power2 = TXPOWER_A_FROM_DEV(tx_power2[i]);
+			info[i].max_power = max_power;
+			info[i].default_power1 = TXPOWER_A_FROM_DEV(default_power1[i]);
+			info[i].default_power2 = TXPOWER_A_FROM_DEV(default_power2[i]);
 		}
 	}
 
Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2x00.h
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt2x00.h
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2x00.h
@@ -211,8 +211,9 @@ struct channel_info {
 	unsigned int flags;
 #define GEOGRAPHY_ALLOWED	0x00000001
 
-	short tx_power1;
-	short tx_power2;
+	short max_power;
+	short default_power1;
+	short default_power2;
 };
 
 /*
Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2x00dev.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -605,7 +605,7 @@ static int rt2x00lib_probe_hw_modes(stru
 	for (i = 0; i < spec->num_channels; i++) {
 		rt2x00lib_channel(&channels[i],
 				  spec->channels[i].channel,
-				  spec->channels_info[i].tx_power1, i);
+				  spec->channels_info[i].max_power, i);
 	}
 
 	/*
Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt61pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt61pci.c
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2605,13 +2605,17 @@ static int rt61pci_probe_hw_mode(struct 
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_TXPOWER;
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	if (spec->num_channels > 14) {
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
-		for (i = 14; i < spec->num_channels; i++)
-			info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_TXPOWER;
+			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+		}
 	}
 
 	return 0;
Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt73usb.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt73usb.c
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2092,13 +2092,17 @@ static int rt73usb_probe_hw_mode(struct 
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_TXPOWER;
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	if (spec->num_channels > 14) {
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
-		for (i = 14; i < spec->num_channels; i++)
-			info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_TXPOWER;
+			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+		}
 	}
 
 	return 0;
