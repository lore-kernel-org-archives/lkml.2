Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab0LSXdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 18:33:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39527 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932557Ab0LSXd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 18:33:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: Do not use legacy PCI power management
Date: Mon, 20 Dec 2010 00:32:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        "John W. Linville" <linville@tuxdriver.com>
References: <201010160036.17653.rjw@sisk.pl>
In-Reply-To: <201010160036.17653.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012200032.21704.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The ath9k driver uses legacy PCI power management (system suspend
and resume) callbacks, so make it use struct dev_pm_ops callbacks and
let the PCI subsystem handle all of the PCI-specific details of
system power transitions.

This change has been tested on Acer Ferrari One with the
Atheros AR928X PCI Express network adapter (rev. 01).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

This patch has been sent already once under a slightly different subject
and with a different changelog.  I'm not sure what happened to it that time,
so here it goes again.

I'm quite confident it doesn't break things and it simplifies the driver's
suspend and resume routines quite a bit, so please apply.

Thanks,
Rafael

---
 drivers/net/wireless/ath/ath9k/pci.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/net/wireless/ath/ath9k/pci.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/ath/ath9k/pci.c
+++ linux-2.6/drivers/net/wireless/ath/ath9k/pci.c
@@ -247,34 +247,25 @@ static void ath_pci_remove(struct pci_de
 
 #ifdef CONFIG_PM
 
-static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int ath_pci_suspend(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
 	return 0;
 }
 
-static int ath_pci_resume(struct pci_dev *pdev)
+static int ath_pci_resume(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	u32 val;
-	int err;
-
-	pci_restore_state(pdev);
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
 
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
@@ -293,7 +284,15 @@ static int ath_pci_resume(struct pci_dev
 	return 0;
 }
 
-#endif /* CONFIG_PM */
+static SIMPLE_DEV_PM_OPS(ath9k_pm_ops, ath_pci_suspend, ath_pci_resume);
+#define ATH9K_PM_OPS	(&ath9k_pm_ops)
+
+#else /* !CONFIG_PM */
+
+#define ATH9K_PM_OPS	NULL
+
+#endif /* !CONFIG_PM */
+
 
 MODULE_DEVICE_TABLE(pci, ath_pci_id_table);
 
@@ -302,10 +301,7 @@ static struct pci_driver ath_pci_driver
 	.id_table   = ath_pci_id_table,
 	.probe      = ath_pci_probe,
 	.remove     = ath_pci_remove,
-#ifdef CONFIG_PM
-	.suspend    = ath_pci_suspend,
-	.resume     = ath_pci_resume,
-#endif /* CONFIG_PM */
+	.driver.pm  = ATH9K_PM_OPS,
 };
 
 int ath_pci_init(void)
