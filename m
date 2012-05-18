Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946570Ab2ERXWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:22:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946539Ab2ERXFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:18 -0400
Message-Id: <20120518211604.274932211@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jon Mason <jdmason@kudzu.us>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Laight <David.Laight@ACULAB.COM>, Joe Perches <joe@perches.com>
Subject: [ 53/54] pch_gbe: Do not abort probe on bad MAC
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit 2b53d07891630dead46d65c8f896955fd3ae0302 upstream.

If the MAC is invalid or not implemented, do not abort the probe. Issue
a warning and prevent bringing the interface up until a MAC is set manually
(via ifconfig $IFACE hw ether $MAC).

Tested on two platforms, one with a valid MAC, the other without a MAC. The real
MAC is used if present, the interface fails to come up until the MAC is set on
the other. They successfully get an IP over DHCP and pass a simple ping and
login over ssh test.

This is meant to allow the Inforce SYS940X development board:
http://www.inforcecomputing.com/SYS940X_ECX.html
(and others suffering from a missing MAC) to work with the mainline kernel.
Without this patch, the probe will fail and the interface will not be created,
preventing the user from configuring the MAC manually.

This does not make any attempt to address a missing or invalid MAC for the
pch_phub driver.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Alan Cox <alan@linux.intel.com>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Jon Mason <jdmason@kudzu.us>
CC: netdev@vger.kernel.org
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: David Laight <David.Laight@ACULAB.COM>
CC: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

---
 drivers/net/pch_gbe/pch_gbe_main.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -1710,6 +1710,12 @@ int pch_gbe_up(struct pch_gbe_adapter *a
 	struct pch_gbe_rx_ring *rx_ring = adapter->rx_ring;
 	int err;
 
+	/* Ensure we have a valid MAC */
+	if (!is_valid_ether_addr(adapter->hw.mac.addr)) {
+		pr_err("Error: Invalid MAC address\n");
+		return -EINVAL;
+	}
+
 	/* hardware has been reset, we need to reload some things */
 	pch_gbe_set_multi(netdev);
 
@@ -2402,9 +2408,14 @@ static int pch_gbe_probe(struct pci_dev
 
 	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
-		dev_err(&pdev->dev, "Invalid MAC Address\n");
-		ret = -EIO;
-		goto err_free_adapter;
+		/*
+		 * If the MAC is invalid (or just missing), display a warning
+		 * but do not abort setting up the device. pch_gbe_up will
+		 * prevent the interface from being brought up until a valid MAC
+		 * is set.
+		 */
+		dev_err(&pdev->dev, "Invalid MAC address, "
+		                    "interface disabled.\n");
 	}
 	setup_timer(&adapter->watchdog_timer, pch_gbe_watchdog,
 		    (unsigned long)adapter);


