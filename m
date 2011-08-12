Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1HNQG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1HNQGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:53 2011
Message-Id: <20110812210553.343873320@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [14/90] ath9k: skip ->config_pci_powersave() if PCIe port has ASPM disabled
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit d4930086bdd0c08a8b3a4d66a9c702297cb74a99 upstream.

We receive many bug reports about system hang during suspend/resume
when ath9k driver is in use. Adrian Chadd remarked that this problem
happens on systems that have ASPM disabled.

To do not hit the bug, skip doing ->config_pci_powersave magic if PCIe
downstream port device, which ath9k device is connected to, has ASPM
disabled.

Bug was introduced by:

commit 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f
Author: Vivek Natarajan <vnatarajan@atheros.com>
Date:   Mon Apr 5 14:48:04 2010 +0530

    ath9k: Add support for newer AR9285 chipsets.

Patch should address:
https://bugzilla.kernel.org/show_bug.cgi?id=37462
https://bugzilla.kernel.org/show_bug.cgi?id=37082
https://bugzilla.redhat.com/show_bug.cgi?id=697157

however I did not receive confirmation about that, except from Camilo
Mesias, whose system stops hang regularly with this patch (but still
hangs from time to time, but this is probably some other bug).

Tested-by: Camilo Mesias <camilo@mesias.co.uk>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    6 +-----
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    6 +-----
 drivers/net/wireless/ath/ath9k/hw.c        |   11 +++++++++--
 drivers/net/wireless/ath/ath9k/hw.h        |    3 ++-
 drivers/net/wireless/ath/ath9k/pci.c       |   27 +++++++++++++++++++++++++++
 5 files changed, 40 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -309,11 +309,7 @@ static void ar9002_hw_configpcipowersave
 	u8 i;
 	u32 val;
 
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
+	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
 		return;
 
 	/* Nothing to do on restore for 11N */
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -351,11 +351,7 @@ static void ar9003_hw_configpcipowersave
 					 int restore,
 					 int power_off)
 {
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
+	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
 		return;
 
 	/* Nothing to do on restore for 11N */
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -299,6 +299,14 @@ static void ath9k_hw_disablepcie(struct
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 }
 
+static void ath9k_hw_aspm_init(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (common->bus_ops->aspm_init)
+		common->bus_ops->aspm_init(common);
+}
+
 /* This should work for all families including legacy */
 static bool ath9k_hw_chip_test(struct ath_hw *ah)
 {
@@ -359,7 +367,6 @@ static void ath9k_hw_init_config(struct
 	ah->config.additional_swba_backoff = 0;
 	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
-	ah->config.pcie_powersave_enable = 0;
 	ah->config.pcie_clock_req = 0;
 	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
@@ -577,7 +584,7 @@ static int __ath9k_hw_init(struct ath_hw
 
 
 	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, 0, 0);
+		ath9k_hw_aspm_init(ah);
 	else
 		ath9k_hw_disablepcie(ah);
 
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -215,7 +215,6 @@ struct ath9k_ops_config {
 	int additional_swba_backoff;
 	int ack_6mb;
 	u32 cwm_ignore_extcca;
-	u8 pcie_powersave_enable;
 	bool pcieSerDesWrite;
 	u8 pcie_clock_req;
 	u32 pcie_waen;
@@ -671,6 +670,7 @@ struct ath_hw {
 
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
+	bool aspm_enabled;
 	bool is_monitoring;
 	bool need_an_top2_fixup;
 	u16 tx_trig_level;
@@ -870,6 +870,7 @@ struct ath_bus_ops {
 	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
 	void (*bt_coex_prep)(struct ath_common *common);
 	void (*extn_synch_en)(struct ath_common *common);
+	void (*aspm_init)(struct ath_common *common);
 };
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -16,6 +16,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/ath9k_platform.h>
 #include "ath9k.h"
 
@@ -115,12 +116,38 @@ static void ath_pci_extn_synch_enable(st
 	pci_write_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, lnkctl);
 }
 
+static void ath_pci_aspm_init(struct ath_common *common)
+{
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+	struct pci_dev *parent;
+	int pos;
+	u8 aspm;
+
+	if (!pci_is_pcie(pdev))
+		return;
+
+	parent = pdev->bus->self;
+	if (WARN_ON(!parent))
+		return;
+
+	pos = pci_pcie_cap(parent);
+	pci_read_config_byte(parent, pos +  PCI_EXP_LNKCTL, &aspm);
+	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
+		ah->aspm_enabled = true;
+		/* Initialize PCIe PM and SERDES registers. */
+		ath9k_hw_configpcipowersave(ah, 0, 0);
+	}
+}
+
 static const struct ath_bus_ops ath_pci_bus_ops = {
 	.ath_bus_type = ATH_PCI,
 	.read_cachesize = ath_pci_read_cachesize,
 	.eeprom_read = ath_pci_eeprom_read,
 	.bt_coex_prep = ath_pci_bt_coex_prep,
 	.extn_synch_en = ath_pci_extn_synch_enable,
+	.aspm_init = ath_pci_aspm_init,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)


