Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2CGChM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:37:12 -0500
Received: from masquerade.micron.com ([137.201.242.130]:19159 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2CGChK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:37:10 -0500
From: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: [PATCH] mtip32xx: fix incorrect value set for drv_cleanup_done, and
 re-initialize and start port in mtip_restart_port()
Thread-Topic: [PATCH] mtip32xx: fix incorrect value set for
 drv_cleanup_done, and re-initialize and start port in mtip_restart_port()
Thread-Index: Acz8CxdAsPtD08EbRYiU4SWXhxmdeQ==
Date: Wed, 7 Mar 2012 02:37:07 +0000
Message-ID: <4F56C9A8.90103@micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
x-ms-exchange-imapappendstamp: NTXBOICAS03.micron.com (14.01.0355.001)
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-6.500.1024-18758.003
x-tm-as-result: No--29.796400-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D1450D99DB05C4AB832FCD8A20239EF@exchange>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Asai Thambi S P <asamymuthupa@micron.com>

This patch includes two changes:
	* fix incorrect value set for drv_cleanup_done
	* re-initialize and start port in mtip_restart_port()

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 8eb81c9..04f69e6 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -422,6 +422,10 @@ static void mtip_init_port(struct mtip_port *port)
 	/* Clear any pending interrupts for this port */
 	writel(readl(port->mmio + PORT_IRQ_STAT), port->mmio + PORT_IRQ_STAT);
 
+	/* Clear any pending interrupts on the HBA. */
+	writel(readl(port->dd->mmio + HOST_IRQ_STAT),
+					port->dd->mmio + HOST_IRQ_STAT);
+
 	/* Enable port interrupts */
 	writel(DEF_PORT_IRQ, port->mmio + PORT_IRQ_MASK);
 }
@@ -490,11 +494,9 @@ static void mtip_restart_port(struct mtip_port *port)
 		dev_warn(&port->dd->pdev->dev,
 			"COM reset failed\n");
 
-	/* Clear SError, the PxSERR.DIAG.x should be set so clear it */
-	writel(readl(port->mmio + PORT_SCR_ERR), port->mmio + PORT_SCR_ERR);
+	mtip_init_port(port);
+	mtip_start_port(port);
 
-	/* Enable the DMA engine */
-	mtip_enable_engine(port, 1);
 }
 
 /*
@@ -3359,9 +3361,6 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 	}
 
-	/* Set the atomic variable as 1 in case of SRSI */
-	atomic_set(&dd->drv_cleanup_done, true);
-
 	atomic_set(&dd->resumeflag, false);
 
 	/* Attach the private data to this PCI device.  */
@@ -3434,8 +3433,8 @@ iomap_err:
 	pci_set_drvdata(pdev, NULL);
 	return rv;
 done:
-	/* Set the atomic variable as 0 in case of SRSI */
-	atomic_set(&dd->drv_cleanup_done, true);
+	/* Set the atomic variable as 0 */
+	atomic_set(&dd->drv_cleanup_done, false);
 
 	return rv;
 }
@@ -3463,8 +3462,6 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 			}
 		}
 	}
-	/* Set the atomic variable as 1 in case of SRSI */
-	atomic_set(&dd->drv_cleanup_done, true);
 
 	/* Clean up the block layer. */
 	mtip_block_remove(dd);
-- 
1.7.1

