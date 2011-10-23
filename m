Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1JWRPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:15:40 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60850 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1JWRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:15:38 -0400
Date: Sun, 23 Oct 2011 19:12:14 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH staging 6/6] et131x: uncloak PCIe capabilities.
Message-ID: <20111023171214.GF28657@electric-eye.fr.zoreil.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com> <20111023093651.GA22285@kroah.com> <20111023094231.GA3409@msilap.einon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023094231.GA3409@msilap.einon>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXME: it should be possible to get rid of ET1310_PCI_L0L1LATENCY as well.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/staging/et131x/et131x.c |   53 ++++++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 79ca1d3..2a0b794 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -155,7 +155,6 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 #define fMP_ADAPTER_FAIL_SEND_MASK	0x3ff00000
 
 /* Some offsets in PCI config space that are actually used. */
-#define ET1310_PCI_MAX_PYLD		0x4C
 #define ET1310_PCI_MAC_ADDRESS		0xA4
 #define ET1310_PCI_EEPROM_STATUS	0xB2
 #define ET1310_PCI_ACK_NACK		0xC0
@@ -4024,24 +4023,31 @@ static void et131x_hwaddr_init(struct et131x_adapter *adapter)
 static int et131x_pci_init(struct et131x_adapter *adapter,
 						struct pci_dev *pdev)
 {
-	int i;
-	u8 max_payload;
-	u8 read_size_reg;
+	int cap = pci_pcie_cap(pdev);
+	u16 max_payload;
+	u16 ctl;
+	int i, rc;
 
-	if (et131x_init_eeprom(adapter) < 0)
-		return -EIO;
+	rc = et131x_init_eeprom(adapter);
+	if (rc < 0)
+		goto out;
 
+	if (!cap) {
+		dev_err(&pdev->dev, "Missing PCIe capabilities\n");
+		goto err_out;
+	}
+		
 	/* Let's set up the PORT LOGIC Register.  First we need to know what
 	 * the max_payload_size is
 	 */
-	if (pci_read_config_byte(pdev, ET1310_PCI_MAX_PYLD, &max_payload)) {
+	if (pci_read_config_word(pdev, cap + PCI_EXP_DEVCAP, &max_payload)) {
 		dev_err(&pdev->dev,
 		    "Could not read PCI config space for Max Payload Size\n");
-		return -EIO;
+		goto err_out;
 	}
 
 	/* Program the Ack/Nak latency and replay timers */
-	max_payload &= 0x07;	/* Only the lower 3 bits are valid */
+	max_payload &= 0x07;
 
 	if (max_payload < 2) {
 		static const u16 acknak[2] = { 0x76, 0xD0 };
@@ -4051,13 +4057,13 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 					       acknak[max_payload])) {
 			dev_err(&pdev->dev,
 			  "Could not write PCI config space for ACK/NAK\n");
-			return -EIO;
+			goto err_out;
 		}
 		if (pci_write_config_word(pdev, ET1310_PCI_REPLAY,
 					       replay[max_payload])) {
 			dev_err(&pdev->dev,
 			  "Could not write PCI config space for Replay Timer\n");
-			return -EIO;
+			goto err_out;
 		}
 	}
 
@@ -4067,23 +4073,22 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 	if (pci_write_config_byte(pdev, ET1310_PCI_L0L1LATENCY, 0x11)) {
 		dev_err(&pdev->dev,
 		  "Could not write PCI config space for Latency Timers\n");
-		return -EIO;
+		goto err_out;
 	}
 
 	/* Change the max read size to 2k */
-	if (pci_read_config_byte(pdev, 0x51, &read_size_reg)) {
+	if (pci_read_config_word(pdev, cap + PCI_EXP_DEVCTL, &ctl)) {
 		dev_err(&pdev->dev,
 			"Could not read PCI config space for Max read size\n");
-		return -EIO;
+		goto err_out;
 	}
 
-	read_size_reg &= 0x8f;
-	read_size_reg |= 0x40;
+	ctl = (ctl & ~PCI_EXP_DEVCTL_READRQ) | ( 0x04 << 12);
 
-	if (pci_write_config_byte(pdev, 0x51, read_size_reg)) {
+	if (pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, ctl)) {
 		dev_err(&pdev->dev,
 		      "Could not write PCI config space for Max read size\n");
-		return -EIO;
+		goto err_out;
 	}
 
 	/* Get MAC address from config space if an eeprom exists, otherwise
@@ -4098,11 +4103,15 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 		if (pci_read_config_byte(pdev, ET1310_PCI_MAC_ADDRESS + i,
 					adapter->rom_addr + i)) {
 			dev_err(&pdev->dev, "Could not read PCI config space for MAC address\n");
-			return -EIO;
+			goto err_out;
 		}
 	}
 	memcpy(adapter->addr, adapter->rom_addr, ETH_ALEN);
-	return 0;
+out:
+	return rc;
+err_out:
+	rc = -EIO;
+	goto out;
 }
 
 /**
-- 
1.7.6.4

