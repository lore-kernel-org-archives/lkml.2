Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab0LWU7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 15:59:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49727 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab0LWU7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 15:59:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: thomas@fjellstrom.ca
Subject: Re: Wake On lan and ATL1 nic
Date: Thu, 23 Dec 2010 21:59:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012141756.59591.thomas@fjellstrom.ca> <201012221423.29719.rjw@sisk.pl> <201012230832.00443.thomas@fjellstrom.ca>
In-Reply-To: <201012230832.00443.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012232159.00654.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 23, 2010, Thomas Fjellstrom wrote:
> On December 22, 2010, Rafael J. Wysocki wrote:
> > On Wednesday, December 15, 2010, Thomas Fjellstrom wrote:
> > > I can't seem to get wol to work with my desktop, which has an integrated
> > > ATL1 GbE nic. I can't be absolutely sure if it ever worked, but I think
> > > it did at one point. I can use ethtool to look at the wol status, that
> > > it supports magic-packet wol, and I can enable it, which is done at boot
> > > using an init script. But No matter how many times I try to send a wol
> > > packet to that machine it never wakes up.
> > > 
> > > Looking around on the net seems to say it is supported, and should work,
> > > but I'm not having any luck. Anyone have any hints?
> > 
> > It works for me with 2.6.37-rc7 and the appended patch applied (at least
> > the machine is woken up from suspend to RAM).  Of course, the adapter
> > needs to be configured for that with the help of ethtool.
> 
> Hi, thanks for making quick work of this. I have one slight problem, my nic 
> seems to use the atl1 driver, and not atl1c. I've tried using atl1c and atl1e, 
> both will load if I modprobe them, but neither actually bring up the device. 
> Even tried blacklisting atl1 first.

I see.

Please try the patch below, then.  It's analogous to the atl1c one, but
it's untested (builds for me).

Thanks,
Rafael


---
 drivers/net/atlx/atl1.c |   77 +++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 46 deletions(-)

Index: linux-2.6/drivers/net/atlx/atl1.c
===================================================================
--- linux-2.6.orig/drivers/net/atlx/atl1.c
+++ linux-2.6/drivers/net/atlx/atl1.c
@@ -950,6 +950,7 @@ static int __devinit atl1_sw_init(struct
 	hw->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	adapter->wol = 0;
+	device_set_wakeup_enable(&adapter->pdev->dev, false);
 	adapter->rx_buffer_len = (hw->max_frame_size + 7) & ~7;
 	adapter->ict = 50000;		/* 100ms */
 	adapter->link_speed = SPEED_0;	/* hardware init */
@@ -2735,15 +2736,15 @@ static int atl1_close(struct net_device
 }
 
 #ifdef CONFIG_PM
-static int atl1_suspend(struct pci_dev *pdev, pm_message_t state)
+static int atl1_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	struct atl1_hw *hw = &adapter->hw;
 	u32 ctrl = 0;
 	u32 wufc = adapter->wol;
 	u32 val;
-	int retval;
 	u16 speed;
 	u16 duplex;
 
@@ -2751,17 +2752,15 @@ static int atl1_suspend(struct pci_dev *
 	if (netif_running(netdev))
 		atl1_down(adapter);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
 	atl1_read_phy_reg(hw, MII_BMSR, (u16 *) & ctrl);
 	atl1_read_phy_reg(hw, MII_BMSR, (u16 *) & ctrl);
 	val = ctrl & BMSR_LSTATUS;
 	if (val)
 		wufc &= ~ATLX_WUFC_LNKC;
+	if (!wufc)
+		goto disable_wol;
 
-	if (val && wufc) {
+	if (val) {
 		val = atl1_get_speed_and_duplex(hw, &speed, &duplex);
 		if (val) {
 			if (netif_msg_ifdown(adapter))
@@ -2798,23 +2797,18 @@ static int atl1_suspend(struct pci_dev *
 		ctrl |= PCIE_PHYMISC_FORCE_RCV_DET;
 		iowrite32(ctrl, hw->hw_addr + REG_PCIE_PHYMISC);
 		ioread32(hw->hw_addr + REG_PCIE_PHYMISC);
-
-		pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
-		goto exit;
-	}
-
-	if (!val && wufc) {
+	} else {
 		ctrl |= (WOL_LINK_CHG_EN | WOL_LINK_CHG_PME_EN);
 		iowrite32(ctrl, hw->hw_addr + REG_WOL_CTRL);
 		ioread32(hw->hw_addr + REG_WOL_CTRL);
 		iowrite32(0, hw->hw_addr + REG_MAC_CTRL);
 		ioread32(hw->hw_addr + REG_MAC_CTRL);
 		hw->phy_configured = false;
-		pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
-		goto exit;
 	}
 
-disable_wol:
+	return 0;
+
+ disable_wol:
 	iowrite32(0, hw->hw_addr + REG_WOL_CTRL);
 	ioread32(hw->hw_addr + REG_WOL_CTRL);
 	ctrl = ioread32(hw->hw_addr + REG_PCIE_PHYMISC);
@@ -2822,37 +2816,17 @@ disable_wol:
 	iowrite32(ctrl, hw->hw_addr + REG_PCIE_PHYMISC);
 	ioread32(hw->hw_addr + REG_PCIE_PHYMISC);
 	hw->phy_configured = false;
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
-exit:
-	if (netif_running(netdev))
-		pci_disable_msi(adapter->pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
 
-static int atl1_resume(struct pci_dev *pdev)
+static int atl1_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct atl1_adapter *adapter = netdev_priv(netdev);
-	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		if (netif_msg_ifup(adapter))
-			dev_printk(KERN_DEBUG, &pdev->dev,
-				"error enabling pci device\n");
-		return err;
-	}
-
-	pci_set_master(pdev);
 	iowrite32(0, adapter->hw.hw_addr + REG_WOL_CTRL);
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-	pci_enable_wake(pdev, PCI_D3cold, 0);
 
 	atl1_reset_hw(&adapter->hw);
 
@@ -2864,16 +2838,25 @@ static int atl1_resume(struct pci_dev *p
 
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(atl1_pm_ops, atl1_suspend, atl1_resume);
+#define ATL1_PM_OPS	(&atl1_pm_ops)
+
 #else
-#define atl1_suspend NULL
-#define atl1_resume NULL
+
+static int atl1_suspend(struct device *dev) { return 0; }
+
+#define ATL1_PM_OPS	NULL
 #endif
 
 static void atl1_shutdown(struct pci_dev *pdev)
 {
-#ifdef CONFIG_PM
-	atl1_suspend(pdev, PMSG_SUSPEND);
-#endif
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct atl1_adapter *adapter = netdev_priv(netdev);
+
+	atl1_suspend(&pdev->dev);
+	pci_wake_from_d3(pdev, adapter->wol);
+	pci_set_power_state(pdev, PCI_D3hot);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -3117,9 +3100,8 @@ static struct pci_driver atl1_driver = {
 	.id_table = atl1_pci_tbl,
 	.probe = atl1_probe,
 	.remove = __devexit_p(atl1_remove),
-	.suspend = atl1_suspend,
-	.resume = atl1_resume,
-	.shutdown = atl1_shutdown
+	.shutdown = atl1_shutdown,
+	.driver.pm = ATL1_PM_OPS,
 };
 
 /*
@@ -3409,6 +3391,9 @@ static int atl1_set_wol(struct net_devic
 	adapter->wol = 0;
 	if (wol->wolopts & WAKE_MAGIC)
 		adapter->wol |= ATLX_WUFC_MAG;
+
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
+
 	return 0;
 }
 
