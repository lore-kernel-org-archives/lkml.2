Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0JOWhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 18:37:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50872 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab0JOWh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 18:37:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: Convert to new PCI PM framework
Date: Sat, 16 Oct 2010 00:36:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010160036.17653.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The ath9k driver uses the legacy PCI power management (suspend
and resume) callbacks that apparently cause intermittent problems
to happen (the adapter sometimes doesn't resume correctly on my
Acer Ferrari One).  Make it use the new PCI PM and let the PCI core
code handle the PCI-specific details of power transitions.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/wireless/ath/ath9k/pci.c |   40 +++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

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
@@ -293,7 +284,23 @@ static int ath_pci_resume(struct pci_dev
 	return 0;
 }
 
-#endif /* CONFIG_PM */
+static const struct dev_pm_ops ath9k_pm_ops = {
+	.suspend = ath_pci_suspend,
+	.resume = ath_pci_resume,
+	.freeze = ath_pci_suspend,
+	.thaw = ath_pci_resume,
+	.poweroff = ath_pci_suspend,
+	.restore = ath_pci_resume,
+};
+
+#define ATH9K_PM_OPS	(&ath9k_pm_ops)
+
+#else /* !CONFIG_PM */
+
+#define ATH9K_PM_OPS	NULL
+
+#endif /* !CONFIG_PM */
+
 
 MODULE_DEVICE_TABLE(pci, ath_pci_id_table);
 
@@ -302,10 +309,7 @@ static struct pci_driver ath_pci_driver 
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
