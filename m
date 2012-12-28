Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2L1TTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55434 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932276Ab2L1TTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:03 -0500
Message-Id: <20121228190347.578347707@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikael Pettersson <mikpe@it.uu.se>, Adko Branil <adkobranil@yahoo.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 083/173] sata_promise: fix hardreset lockdep error
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikael Pettersson <mikpe@it.uu.se>

commit 3100d49d3cd236443faae9d81137c81b22d36003 upstream.

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
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/sata_promise.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 489c817..fb0dd87 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
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
@@ -801,9 +805,10 @@ static void pdc_hard_reset_port(struct ata_port *ap)
 	void __iomem *host_mmio = ap->host->iomap[PDC_MMIO_BAR];
 	void __iomem *pcictl_b1_mmio = host_mmio + PDC_PCI_CTL + 1;
 	unsigned int ata_no = pdc_ata_port_to_ata_no(ap);
+	struct pdc_host_priv *hpriv = ap->host->private_data;
 	u8 tmp;
 
-	spin_lock(&ap->host->lock);
+	spin_lock(&hpriv->hard_reset_lock);
 
 	tmp = readb(pcictl_b1_mmio);
 	tmp &= ~(0x10 << ata_no);
@@ -814,7 +819,7 @@ static void pdc_hard_reset_port(struct ata_port *ap)
 	writeb(tmp, pcictl_b1_mmio);
 	readb(pcictl_b1_mmio); /* flush */
 
-	spin_unlock(&ap->host->lock);
+	spin_unlock(&hpriv->hard_reset_lock);
 }
 
 static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
@@ -1182,6 +1187,7 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 	const struct ata_port_info *pi = &pdc_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[PDC_MAX_PORTS];
 	struct ata_host *host;
+	struct pdc_host_priv *hpriv;
 	void __iomem *host_mmio;
 	int n_ports, i, rc;
 	int is_sataii_tx4;
@@ -1218,6 +1224,11 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
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


