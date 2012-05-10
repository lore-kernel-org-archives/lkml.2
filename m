Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942Ab2EJRlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:41:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58690 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760610Ab2EJRgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:55 -0400
Message-Id: <20120510173136.987290066@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, Jens Axboe <axboe@kernel.dk>
Subject: [ 47/52] mtip32xx: fix incorrect value set for drv_cleanup_done, and
 re-initialize and start port in mtip_restart_port()
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asai Thambi S P <asamymuthupa@micron.com>

commit 22be2e6e13ac09b20000582ac34d47fb0029a6da upstream.

This patch includes two changes:
	* fix incorrect value set for drv_cleanup_done
	* re-initialize and start port in mtip_restart_port()

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/mtip32xx/mtip32xx.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -422,6 +422,10 @@ static void mtip_init_port(struct mtip_p
 	/* Clear any pending interrupts for this port */
 	writel(readl(port->mmio + PORT_IRQ_STAT), port->mmio + PORT_IRQ_STAT);
 
+	/* Clear any pending interrupts on the HBA. */
+	writel(readl(port->dd->mmio + HOST_IRQ_STAT),
+					port->dd->mmio + HOST_IRQ_STAT);
+
 	/* Enable port interrupts */
 	writel(DEF_PORT_IRQ, port->mmio + PORT_IRQ_MASK);
 }
@@ -490,11 +494,9 @@ static void mtip_restart_port(struct mti
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
@@ -3359,9 +3361,6 @@ static int mtip_pci_probe(struct pci_dev
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
@@ -3463,8 +3462,6 @@ static void mtip_pci_remove(struct pci_d
 			}
 		}
 	}
-	/* Set the atomic variable as 1 in case of SRSI */
-	atomic_set(&dd->drv_cleanup_done, true);
 
 	/* Clean up the block layer. */
 	mtip_block_remove(dd);


