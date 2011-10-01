Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1JAKQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:16:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47522 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab1JAKPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:15:44 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 5/8] staging: et131x: Fix add_timer() from et131x_open
Date: Sat,  1 Oct 2011 11:14:14 +0100
Message-Id: <1317464057-18231-5-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error_timer was only getting initialised and an initial jiffies value set following a probe.
This could result in the timer needlessly expiring immediately after et131x_open is called.
Now this is all done from the open call instead.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README           |    1 -
 drivers/staging/et131x/et131x.h         |    1 +
 drivers/staging/et131x/et131x_initpci.c |    7 -------
 drivers/staging/et131x/et131x_netdev.c  |    4 ++++
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index 42c388d..a0ebaa0 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -9,7 +9,6 @@ Note, the powermanagement options were removed from the vendor provided
 driver as they did not build properly at the time.
 
 TODO:
-	- add_timer call in et131x_netdev.c is correct?
 	- Implement a few more kernel Parameter (set mac )
 
 Please send patches to:
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 15486d1..c8f5ab1 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -52,6 +52,7 @@
 int et131x_init_eeprom(struct et131x_adapter *adapter);
 
 /* et131x_initpci.c */
+void et131x_error_timer_handler(unsigned long data);
 void et131x_configure_global_regs(struct et131x_adapter *adapter);
 void et131x_enable_interrupts(struct et131x_adapter *adapter);
 void et131x_disable_interrupts(struct et131x_adapter *adapter);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index e166fde..8bff4a0 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -750,10 +750,6 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	/* Copy address into the net_device struct */
 	memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
 
-	adapter->error_timer.expires = jiffies + TX_ERROR_PERIOD * HZ / 1000;
-	adapter->error_timer.function = et131x_error_timer_handler;
-	adapter->error_timer.data = (unsigned long)adapter;
-
 	/* Init variable for counting how long we do not have link status */
 	adapter->boot_coma = 0;
 	et1310_disable_phy_coma(adapter);
@@ -795,9 +791,6 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	/* Setup et1310 as per the documentation */
 	et131x_adapter_setup(adapter);
 
-	/* Create a timer to count errors received by the NIC */
-	init_timer(&adapter->error_timer);
-
 	/* We can enable interrupts now
 	 *
 	 *  NOTE - Because registration of interrupt handler is done in the
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 6ec4a0f..2184682 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -187,6 +187,10 @@ int et131x_open(struct net_device *netdev)
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
 	/* Start the timer to track NIC errors */
+	init_timer(&adapter->error_timer);
+	adapter->error_timer.expires = jiffies + TX_ERROR_PERIOD * HZ / 1000;
+	adapter->error_timer.function = et131x_error_timer_handler;
+	adapter->error_timer.data = (unsigned long)adapter;
 	add_timer(&adapter->error_timer);
 
 	/* Register our IRQ */
-- 
1.7.6.4

