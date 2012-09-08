Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab2IHQcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 12:32:36 -0400
Received: from smtp1.uu.se ([130.238.7.54]:52890 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab2IHQcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 12:32:31 -0400
X-Spam-Flag: NO
X-Spam-Score: -3.835
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20555.29361.138287.766030@pilspetsen.it.uu.se>
Date: Sat, 8 Sep 2012 18:30:41 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Adko Branil <adkobranil@yahoo.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Borislav Petkov <bp@alien8.de>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dan Merillat <dan.merillat@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
In-Reply-To: <1347017576.44763.YahooMailNeo@web124703.mail.ne1.yahoo.com>
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com>
	<20120826130152.GA20021@liondog.tnic>
	<1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com>
	<20120827215952.GA18719@liondog.tnic>
	<1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com>
	<20120830095808.GB24680@liondog.tnic>
	<1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com>
	<20547.48101.900727.735398@pilspetsen.it.uu.se>
	<1347017576.44763.YahooMailNeo@web124703.mail.ne1.yahoo.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adko Branil writes:
 > After updating bios no more crashes happened, i tested it many times
 > on heavy HDD IO loads, with many kernels (including CONFIG_PREEMPT
 > kernels). But now if enable "Cool'n' Quiet" option in bios, 
 > CONFIG_PREEMPT_VOLUNTARY kernel with passed "nosmp" at boot time,
 > crashes during boot process with kernel panic, while  CONFIG_PREEMPT
 > kernlel without "nosmp" works fine  - but it is another story i think,
 > should not be related with the crashes when it was old bios, and i
 > think it is probably "nosmp" the reason. (i have never changed cpu
 > frequency of this cpu at all) When "Cool'n' Quiet" is disabled, the
 > system works perfectly adequately with all kind of kernels i tried.
 > Except that this warning message in dmesg still appears (if it is
 > problem at all). I put here this message for "nosmp" case as well,
 > kernel is 3.5.2:
 > 
 > [    1.912494] =================================
 > [    1.912494] [ INFO: inconsistent lock state ]
 > [    1.912494] 3.5.2 #4 Not tainted
 > [    1.912494] ---------------------------------
 > [    1.912494] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
 > [    1.912494] swapper/0/1 [HC1[1]:SC1[1]:HE0:SE0] takes:
 > [    1.912494]  (&(&host->lock)->rlock){?.+...}, at: [<ffffffff818f4e47>] ata_bmdma_interrupt+0x27/0x1d0
 > [    1.912494] {HARDIRQ-ON-W} state was registered at:
 > [    1.912494]   [<ffffffff810998fb>] __lock_acquire+0x61b/0x1af0
 > [    1.912494]   [<ffffffff8109b31a>] lock_acquire+0x8a/0x110
 > [    1.912494]   [<ffffffff81b4d051>] _raw_spin_lock+0x31/0x40
 > [    1.912494]   [<ffffffff8190b3c5>] pdc_sata_hardreset+0x85/0x100

Please try the patch below, which implements the fix I described a
week ago. It's for 3.6-rc4 but should work in any recent kernel.
Without this patch one of my test machines always throws a lockdep
warning involving pdc_sata_hardreset and pdc_interrupt during bootup,
but with the patch the warning is gone, as expected.

If it works for you I'll add your Tested-by: and submit it properly.

/Mikael

--- linux-3.6-rc4/drivers/ata/sata_promise.c.~1~	2012-09-08 12:18:24.000000000 +0200
+++ linux-3.6-rc4/drivers/ata/sata_promise.c	2012-09-08 17:55:49.000000000 +0200
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
