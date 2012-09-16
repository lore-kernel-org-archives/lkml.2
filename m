Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2IPSzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 14:55:38 -0400
Received: from smtp1.uu.se ([130.238.7.54]:57820 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab2IPSzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 14:55:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20566.8247.775868.16409@pilspetsen.it.uu.se>
Date: Sun, 16 Sep 2012 20:53:43 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-ide@vger.kernel.org
Subject: [PATCH] sata_promise: fix hardreset lockdep error
Cc: linux-kernel@vger.kernel.org, Adko Branil <adkobranil@yahoo.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sata_promise's pdc_hard_reset_port() needs to serialize because it
flips a port-specific bit in controller register that's shared by
all ports. The code takes the ata host lock for this, but that's
broken because an interrupt may arrive on our irq during the hard
reset sequence, and that too will take the ata host lock. With
lockdep enabled a big nasty warning is seen.

Fixed by adding private state to the ata host structure, containing
a second lock used only for serializing the hard reset sequences.
This eliminated the lockdep warnings both on my test rig and on
the original reporter's machine.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Tested-by: Adko Branil <adkobranil@yahoo.com>
Cc: stable@vger.kernel.org
---
This bug affects 2.6.32 and newer kernels.

 drivers/ata/sata_promise.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -rupN linux-3.6-rc5/drivers/ata/sata_promise.c linux-3.6-rc5.sata_promise-hardreset-lockdep-fix/drivers/ata/sata_promise.c
--- linux-3.6-rc5/drivers/ata/sata_promise.c	2012-09-09 16:31:11.000000000 +0200
+++ linux-3.6-rc5.sata_promise-hardreset-lockdep-fix/drivers/ata/sata_promise.c	2012-09-09 16:36:38.000000000 +0200
@@ -147,6 +147,10 @@ struct pdc_port_priv {
 	dma_addr_t		pkt_dma;
 };
 
+struct pdc_host_priv {
+	spinlock_t hard_reset_lock;
+};
+
 static int pdc_sata_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int pdc_sata_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int pdc_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
@@ -801,9 +805,10 @@ static void pdc_hard_reset_port(struct a
 	void __iomem *host_mmio = ap->host->iomap[PDC_MMIO_BAR];
 	void __iomem *pcictl_b1_mmio = host_mmio + PDC_PCI_CTL + 1;
 	unsigned int ata_no = pdc_ata_port_to_ata_no(ap);
+	struct pdc_host_priv *hpriv = ap->host->private_data;
 	u8 tmp;
 
-	spin_lock(&ap->host->lock);
+	spin_lock(&hpriv->hard_reset_lock);
 
 	tmp = readb(pcictl_b1_mmio);
 	tmp &= ~(0x10 << ata_no);
@@ -814,7 +819,7 @@ static void pdc_hard_reset_port(struct a
 	writeb(tmp, pcictl_b1_mmio);
 	readb(pcictl_b1_mmio); /* flush */
 
-	spin_unlock(&ap->host->lock);
+	spin_unlock(&hpriv->hard_reset_lock);
 }
 
 static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
@@ -1182,6 +1187,7 @@ static int pdc_ata_init_one(struct pci_d
 	const struct ata_port_info *pi = &pdc_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[PDC_MAX_PORTS];
 	struct ata_host *host;
+	struct pdc_host_priv *hpriv;
 	void __iomem *host_mmio;
 	int n_ports, i, rc;
 	int is_sataii_tx4;
@@ -1218,6 +1224,11 @@ static int pdc_ata_init_one(struct pci_d
 		dev_err(&pdev->dev, "failed to allocate host\n");
 		return -ENOMEM;
 	}
+	hpriv = devm_kzalloc(&pdev->dev, sizeof *hpriv, GFP_KERNEL);
+	if (!hpriv)
+		return -ENOMEM;
+	spin_lock_init(&hpriv->hard_reset_lock);
+	host->private_data = hpriv;
 	host->iomap = pcim_iomap_table(pdev);
 
 	is_sataii_tx4 = pdc_is_sataii_tx4(pi->flags);
