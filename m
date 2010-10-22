Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0JVBXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:23:08 -0400
Received: from havoc.gtf.org ([69.61.125.42]:47390 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0JVBXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:23:04 -0400
Date: Thu, 21 Oct 2010 21:23:02 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 2.6.37
Message-ID: <20101022012302.GA7487@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Notable changes:

1) Link Power Management (LPM) rewrite

2) ATA transport class

3) Start hammering out support for >512-byte sectors



Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/ABI/testing/sysfs-ata |   99 +++++
 drivers/ata/Makefile                |    2 +-
 drivers/ata/ahci.c                  |    3 -
 drivers/ata/ahci.h                  |    4 +-
 drivers/ata/ahci_platform.c         |    3 -
 drivers/ata/ata_generic.c           |   54 +++-
 drivers/ata/ata_piix.c              |   34 ++-
 drivers/ata/libahci.c               |  194 +++------
 drivers/ata/libata-core.c           |  389 ++++++++----------
 drivers/ata/libata-eh.c             |  254 ++++++++++--
 drivers/ata/libata-pmp.c            |   66 +++-
 drivers/ata/libata-scsi.c           |  204 +++++-----
 drivers/ata/libata-sff.c            |   14 +-
 drivers/ata/libata-transport.c      |  774 +++++++++++++++++++++++++++++++++++
 drivers/ata/libata-transport.h      |   18 +
 drivers/ata/libata.h                |   21 +-
 drivers/ata/pata_bf54x.c            |    6 +-
 drivers/ata/pata_cmd640.c           |   12 +
 drivers/ata/pata_pdc202xx_old.c     |   23 +
 drivers/ata/pata_samsung_cf.c       |    2 +-
 drivers/ata/pata_scc.c              |    4 +-
 drivers/ata/pata_sil680.c           |   16 +-
 drivers/ata/pata_sl82c105.c         |   11 +
 drivers/ata/sata_fsl.c              |   27 +-
 drivers/ata/sata_inic162x.c         |    2 +-
 drivers/ata/sata_mv.c               |   25 +-
 drivers/ata/sata_nv.c               |   57 +--
 drivers/ata/sata_sil24.c            |   14 +-
 drivers/ata/sata_via.c              |    2 +-
 include/linux/ata.h                 |   46 ++-
 include/linux/libata.h              |   65 ++-
 31 files changed, 1815 insertions(+), 630 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-ata
 create mode 100644 drivers/ata/libata-transport.c
 create mode 100644 drivers/ata/libata-transport.h

Alan Cox (1):
      ata: Intel IDE-R support

Andrea Gelmini (1):
      include/linux/libata.h: fix typo

Ben Hutchings (1):
      ata_piix: Add device ID for ICH4-L

Grant Grundler (1):
      [libata] support for > 512 byte sectors (e.g. 4K Native)

Gwendal Grignou (1):
      [libata] Add ATA transport class

Jeff Garzik (1):
      drivers/ata/libata-transport.c: include linux/slab.h

Martin K. Petersen (1):
      libata: Signal that our SATL supports WRITE SAME(16) with UNMAP

Mike Frysinger (1):
      pata_bf54x: fix return type of bfin_set_devctl

Richard Kennedy (1):
      libata: reorder ata_queued_cmd to remove alignment padding on 64 bit builds

Sergei Shtylyov (5):
      pata_sil680: make sil680_sff_exec_command() 'static'
      pata_cmd640: implement sff_irq_check() method
      pata_pdc202xx_old: implement sff_irq_check() method
      pata_sil680: implement sff_irq_check() method
      pata_sl82c105: implement sff_irq_check() method

Tejun Heo (10):
      libata: always use ata_qc_complete_multiple() for NCQ command completions
      libata: clean up lpm related symbols and sysfs show/store functions
      libata: implement sata_link_scr_lpm() and make ata_dev_set_feature() global
      libata: reimplement link power management
      libata: implement LPM support for port multipliers
      ata_piix: implement LPM support
      libata: add @ap to ata_wait_register() and introduce ata_msleep()
      libata: implement cross-port EH exclusion
      ata_piix: remove SIDPR locking
      libahci: fix result_tf handling after an ATA PIO data-in command

Tony Luck (1):
      [libata] Fix section mismatch: ata_sff_exit

Tracey Dent (1):
      Drivers: ata: Makefile: replace the use of <module>-objs with <module>-y

diff --git a/Documentation/ABI/testing/sysfs-ata b/Documentation/ABI/testing/sysfs-ata
new file mode 100644
index 0000000..0a93215
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-ata
@@ -0,0 +1,99 @@
+What:		/sys/class/ata_...
+Date:		August 2008
+Contact:	Gwendal Grignou<gwendal@google.com>
+Description:
+
+Provide a place in sysfs for storing the ATA topology of the system.  This allows
+retrieving various information about ATA objects.
+
+Files under /sys/class/ata_port
+-------------------------------
+
+	For each port, a directory ataX is created where X is the ata_port_id of
+	the port. The device parent is the ata host device.
+
+idle_irq (read)
+
+	Number of IRQ received by the port while idle [some ata HBA only].
+
+nr_pmp_links (read)
+
+	If a SATA Port Multiplier (PM) is connected, number of link behind it.
+
+Files under /sys/class/ata_link
+-------------------------------
+
+	Behind each port, there is a ata_link. If there is a SATA PM in the
+	topology, 15 ata_link objects are created.
+
+	If a link is behind a port, the directory name is linkX, where X is
+	ata_port_id of the port.
+	If a link is behind a PM, its name is linkX.Y where X is ata_port_id
+	of the parent port and Y the PM port.
+
+hw_sata_spd_limit
+
+	Maximum speed supported by the connected SATA device.
+
+sata_spd_limit
+
+	Maximum speed imposed by libata.
+
+sata_spd
+
+	Current speed of the link [1.5, 3Gps,...].
+
+Files under /sys/class/ata_device
+---------------------------------
+
+	Behind each link, up to two ata device are created.
+	The name of the directory is devX[.Y].Z where:
+	- X is ata_port_id of the port where the device is connected,
+	- Y the port of the PM if any, and
+	- Z the device id: for PATA, there is usually 2 devices [0,1],
+	only 1 for SATA.
+
+class
+	Device class. Can be "ata" for disk, "atapi" for packet device,
+	"pmp" for PM, or "none" if no device was found behind the link.
+
+dma_mode
+
+	Transfer modes supported by the device when in DMA mode.
+	Mostly used by PATA device.
+
+pio_mode
+
+	Transfer modes supported by the device when in PIO mode.
+	Mostly used by PATA device.
+
+xfer_mode
+
+	Current transfer mode.
+
+id
+
+	Cached result of IDENTIFY command, as described in ATA8 7.16 and 7.17.
+	Only valid if the device is not a PM.
+
+gscr
+
+	Cached result of the dump of PM GSCR register.
+	Valid registers are:
+	0: 	SATA_PMP_GSCR_PROD_ID,
+	1: 	SATA_PMP_GSCR_REV,
+	2: 	SATA_PMP_GSCR_PORT_INFO,
+	32:	SATA_PMP_GSCR_ERROR,
+	33:	SATA_PMP_GSCR_ERROR_EN,
+	64:	SATA_PMP_GSCR_FEAT,
+	96:	SATA_PMP_GSCR_FEAT_EN,
+	130:	SATA_PMP_GSCR_SII_GPIO
+	Only valid if the device is a PM.
+
+spdn_cnt
+
+	Number of time libata decided to lower the speed of link due to errors.
+
+ering
+
+	Formatted output of the error ring of the device.
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index d5df04a..c501af5 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -99,7 +99,7 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 # Should be last libata driver
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o
 
-libata-objs	:= libata-core.o libata-scsi.o libata-eh.o
+libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 99d0e5a..3288263 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1208,9 +1208,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
 				   0x100 + ap->port_no * 0x80, "port");
 
-		/* set initial link pm policy */
-		ap->pm_policy = NOT_AVAILABLE;
-
 		/* set enclosure management message type */
 		if (ap->flags & ATA_FLAG_EM)
 			ap->em_message_type = hpriv->em_msg_type;
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index e5fdeeb..329cbbb 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -72,6 +72,7 @@ enum {
 	AHCI_CMD_RESET		= (1 << 8),
 	AHCI_CMD_CLR_BUSY	= (1 << 10),
 
+	RX_FIS_PIO_SETUP	= 0x20,	/* offset of PIO Setup FIS data */
 	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
 	RX_FIS_SDB		= 0x58, /* offset of SDB FIS data */
 	RX_FIS_UNK		= 0x60, /* offset of Unknown FIS data */
@@ -201,7 +202,6 @@ enum {
 	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
 	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
 	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
-	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
 	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
 	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
 	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
@@ -216,7 +216,7 @@ enum {
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
 					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
-					  ATA_FLAG_IPM,
+					  ATA_FLAG_LPM,
 
 	ICH_MAP				= 0x90, /* ICH MAP register */
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 84b6432..6fef1fa 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -129,9 +129,6 @@ static int __init ahci_probe(struct platform_device *pdev)
 		ata_port_desc(ap, "mmio %pR", mem);
 		ata_port_desc(ap, "port 0x%x", 0x100 + ap->port_no * 0x80);
 
-		/* set initial link pm policy */
-		ap->pm_policy = NOT_AVAILABLE;
-
 		/* set enclosure management message type */
 		if (ap->flags & ATA_FLAG_EM)
 			ap->em_message_type = hpriv->em_msg_type;
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index cc5f772..6981f76 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -35,6 +35,7 @@
 enum {
 	ATA_GEN_CLASS_MATCH		= (1 << 0),
 	ATA_GEN_FORCE_DMA		= (1 << 1),
+	ATA_GEN_INTEL_IDER		= (1 << 2),
 };
 
 /**
@@ -109,6 +110,49 @@ static struct ata_port_operations generic_port_ops = {
 static int all_generic_ide;		/* Set to claim all devices */
 
 /**
+ *	is_intel_ider		-	identify intel IDE-R devices
+ *	@dev: PCI device
+ *
+ *	Distinguish Intel IDE-R controller devices from other Intel IDE
+ *	devices. IDE-R devices have no timing registers and are in
+ *	most respects virtual. They should be driven by the ata_generic
+ *	driver.
+ *
+ *	IDE-R devices have PCI offset 0xF8.L as zero, later Intel ATA has
+ *	it non zero. All Intel ATA has 0x40 writable (timing), but it is
+ *	not writable on IDE-R devices (this is guaranteed).
+ */
+
+static int is_intel_ider(struct pci_dev *dev)
+{
+	/* For Intel IDE the value at 0xF8 is only zero on IDE-R
+	   interfaces */
+	u32 r;
+	u16 t;
+
+	/* Check the manufacturing ID, it will be zero for IDE-R */
+	pci_read_config_dword(dev, 0xF8, &r);
+	/* Not IDE-R: punt so that ata_(old)piix gets it */
+	if (r != 0)
+		return 0;
+	/* 0xF8 will also be zero on some early Intel IDE devices
+	   but they will have a sane timing register */
+	pci_read_config_word(dev, 0x40, &t);
+	if (t != 0)
+		return 0;
+	/* Finally check if the timing register is writable so that
+	   we eliminate any early devices hot-docked in a docking
+	   station */
+	pci_write_config_word(dev, 0x40, 1);
+	pci_read_config_word(dev, 0x40, &t);
+	if (t) {
+		pci_write_config_word(dev, 0x40, 0);
+		return 0;
+	}
+	return 1;
+}
+
+/**
  *	ata_generic_init		-	attach generic IDE
  *	@dev: PCI device found
  *	@id: match entry
@@ -134,6 +178,10 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 	if ((id->driver_data & ATA_GEN_CLASS_MATCH) && all_generic_ide == 0)
 		return -ENODEV;
 
+	if (id->driver_data & ATA_GEN_INTEL_IDER)
+		if (!is_intel_ider(dev))
+			return -ENODEV;
+
 	/* Devices that need care */
 	if (dev->vendor == PCI_VENDOR_ID_UMC &&
 	    dev->device == PCI_DEVICE_ID_UMC_UM8886A &&
@@ -186,7 +234,11 @@ static struct pci_device_id ata_generic[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
-#endif	
+#endif
+	/* Intel, IDE class device */
+	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 
+	  .driver_data = ATA_GEN_INTEL_IDER },
 	/* Must come last. If you add entries adjust this table appropriately */
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL),
 	  .driver_data = ATA_GEN_CLASS_MATCH },
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d712675..6cb14ca 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -158,7 +158,6 @@ struct piix_map_db {
 struct piix_host_priv {
 	const int *map;
 	u32 saved_iocfg;
-	spinlock_t sidpr_lock;	/* FIXME: remove once locking in EH is fixed */
 	void __iomem *sidpr;
 };
 
@@ -175,6 +174,8 @@ static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val);
 static int piix_sidpr_scr_write(struct ata_link *link,
 				unsigned int reg, u32 val);
+static int piix_sidpr_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+			      unsigned hints);
 static bool piix_irq_check(struct ata_port *ap);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
@@ -209,6 +210,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x248A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* Intel ICH3 (E7500/1) UDMA 100 */
 	{ 0x8086, 0x248B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	/* Intel ICH4-L */
+	{ 0x8086, 0x24C1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* Intel ICH4 (i845GV, i845E, i852, i855) UDMA 100 */
 	{ 0x8086, 0x24CA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	{ 0x8086, 0x24CB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
@@ -348,11 +351,22 @@ static struct ata_port_operations ich_pata_ops = {
 	.set_dmamode		= ich_set_dmamode,
 };
 
+static struct device_attribute *piix_sidpr_shost_attrs[] = {
+	&dev_attr_link_power_management_policy,
+	NULL
+};
+
+static struct scsi_host_template piix_sidpr_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+	.shost_attrs		= piix_sidpr_shost_attrs,
+};
+
 static struct ata_port_operations piix_sidpr_sata_ops = {
 	.inherits		= &piix_sata_ops,
 	.hardreset		= sata_std_hardreset,
 	.scr_read		= piix_sidpr_scr_read,
 	.scr_write		= piix_sidpr_scr_write,
+	.set_lpm		= piix_sidpr_set_lpm,
 };
 
 static const struct piix_map_db ich5_map_db = {
@@ -956,15 +970,12 @@ static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val)
 {
 	struct piix_host_priv *hpriv = link->ap->host->private_data;
-	unsigned long flags;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
-	spin_lock_irqsave(&hpriv->sidpr_lock, flags);
 	piix_sidpr_sel(link, reg);
 	*val = ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
-	spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
 	return 0;
 }
 
@@ -972,18 +983,21 @@ static int piix_sidpr_scr_write(struct ata_link *link,
 				unsigned int reg, u32 val)
 {
 	struct piix_host_priv *hpriv = link->ap->host->private_data;
-	unsigned long flags;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
-	spin_lock_irqsave(&hpriv->sidpr_lock, flags);
 	piix_sidpr_sel(link, reg);
 	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
-	spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
 	return 0;
 }
 
+static int piix_sidpr_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+			      unsigned hints)
+{
+	return sata_link_scr_lpm(link, policy, false);
+}
+
 static bool piix_irq_check(struct ata_port *ap)
 {
 	if (unlikely(!ap->ioaddr.bmdma_addr))
@@ -1543,6 +1557,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
 	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
+	struct scsi_host_template *sht = &piix_sht;
 	unsigned long port_flags;
 	struct ata_host *host;
 	struct piix_host_priv *hpriv;
@@ -1577,7 +1592,6 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
-	spin_lock_init(&hpriv->sidpr_lock);
 
 	/* Save IOCFG, this will be used for cable detection, quirk
 	 * detection and restoration on detach.  This is necessary
@@ -1612,6 +1626,8 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 		rc = piix_init_sidpr(host);
 		if (rc)
 			return rc;
+		if (host->ports[0]->ops == &piix_sidpr_sata_ops)
+			sht = &piix_sidpr_sht;
 	}
 
 	/* apply IOCFG bit18 quirk */
@@ -1638,7 +1654,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	host->flags |= ATA_HOST_PARALLEL_SCAN;
 
 	pci_set_master(pdev);
-	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, &piix_sht);
+	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
 }
 
 static void piix_remove_one(struct pci_dev *pdev)
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 8eea309..ebc08d6 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -56,9 +56,8 @@ MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)
 module_param_named(ignore_sss, ahci_ignore_sss, int, 0444);
 MODULE_PARM_DESC(ignore_sss, "Ignore staggered spinup flag (0=don't ignore, 1=ignore)");
 
-static int ahci_enable_alpm(struct ata_port *ap,
-		enum link_pm policy);
-static void ahci_disable_alpm(struct ata_port *ap);
+static int ahci_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+			unsigned hints);
 static ssize_t ahci_led_show(struct ata_port *ap, char *buf);
 static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 			      size_t size);
@@ -164,8 +163,7 @@ struct ata_port_operations ahci_ops = {
 	.pmp_attach		= ahci_pmp_attach,
 	.pmp_detach		= ahci_pmp_detach,
 
-	.enable_pm		= ahci_enable_alpm,
-	.disable_pm		= ahci_disable_alpm,
+	.set_lpm		= ahci_set_lpm,
 	.em_show		= ahci_led_show,
 	.em_store		= ahci_led_store,
 	.sw_activity_show	= ahci_activity_show,
@@ -569,7 +567,7 @@ int ahci_stop_engine(struct ata_port *ap)
 	writel(tmp, port_mmio + PORT_CMD);
 
 	/* wait for engine to stop. This could be as long as 500 msec */
-	tmp = ata_wait_register(port_mmio + PORT_CMD,
+	tmp = ata_wait_register(ap, port_mmio + PORT_CMD,
 				PORT_CMD_LIST_ON, PORT_CMD_LIST_ON, 1, 500);
 	if (tmp & PORT_CMD_LIST_ON)
 		return -EIO;
@@ -616,7 +614,7 @@ static int ahci_stop_fis_rx(struct ata_port *ap)
 	writel(tmp, port_mmio + PORT_CMD);
 
 	/* wait for completion, spec says 500ms, give it 1000 */
-	tmp = ata_wait_register(port_mmio + PORT_CMD, PORT_CMD_FIS_ON,
+	tmp = ata_wait_register(ap, port_mmio + PORT_CMD, PORT_CMD_FIS_ON,
 				PORT_CMD_FIS_ON, 10, 1000);
 	if (tmp & PORT_CMD_FIS_ON)
 		return -EBUSY;
@@ -642,127 +640,56 @@ static void ahci_power_up(struct ata_port *ap)
 	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
 }
 
-static void ahci_disable_alpm(struct ata_port *ap)
+static int ahci_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+			unsigned int hints)
 {
+	struct ata_port *ap = link->ap;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd;
 	struct ahci_port_priv *pp = ap->private_data;
-
-	/* IPM bits should be disabled by libata-core */
-	/* get the existing command bits */
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/* disable ALPM and ASP */
-	cmd &= ~PORT_CMD_ASP;
-	cmd &= ~PORT_CMD_ALPE;
-
-	/* force the interface back to active */
-	cmd |= PORT_CMD_ICC_ACTIVE;
-
-	/* write out new cmd value */
-	writel(cmd, port_mmio + PORT_CMD);
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/* wait 10ms to be sure we've come out of any low power state */
-	msleep(10);
-
-	/* clear out any PhyRdy stuff from interrupt status */
-	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
-
-	/* go ahead and clean out PhyRdy Change from Serror too */
-	ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
-
-	/*
-	 * Clear flag to indicate that we should ignore all PhyRdy
-	 * state changes
-	 */
-	hpriv->flags &= ~AHCI_HFLAG_NO_HOTPLUG;
-
-	/*
-	 * Enable interrupts on Phy Ready.
-	 */
-	pp->intr_mask |= PORT_IRQ_PHYRDY;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-
-	/*
-	 * don't change the link pm policy - we can be called
-	 * just to turn of link pm temporarily
-	 */
-}
-
-static int ahci_enable_alpm(struct ata_port *ap,
-	enum link_pm policy)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
 	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd;
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 asp;
 
-	/* Make sure the host is capable of link power management */
-	if (!(hpriv->cap & HOST_CAP_ALPM))
-		return -EINVAL;
-
-	switch (policy) {
-	case MAX_PERFORMANCE:
-	case NOT_AVAILABLE:
+	if (policy != ATA_LPM_MAX_POWER) {
 		/*
-		 * if we came here with NOT_AVAILABLE,
-		 * it just means this is the first time we
-		 * have tried to enable - default to max performance,
-		 * and let the user go to lower power modes on request.
+		 * Disable interrupts on Phy Ready. This keeps us from
+		 * getting woken up due to spurious phy ready
+		 * interrupts.
 		 */
-		ahci_disable_alpm(ap);
-		return 0;
-	case MIN_POWER:
-		/* configure HBA to enter SLUMBER */
-		asp = PORT_CMD_ASP;
-		break;
-	case MEDIUM_POWER:
-		/* configure HBA to enter PARTIAL */
-		asp = 0;
-		break;
-	default:
-		return -EINVAL;
+		pp->intr_mask &= ~PORT_IRQ_PHYRDY;
+		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+		sata_link_scr_lpm(link, policy, false);
 	}
 
-	/*
-	 * Disable interrupts on Phy Ready. This keeps us from
-	 * getting woken up due to spurious phy ready interrupts
-	 * TBD - Hot plug should be done via polling now, is
-	 * that even supported?
-	 */
-	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+	if (hpriv->cap & HOST_CAP_ALPM) {
+		u32 cmd = readl(port_mmio + PORT_CMD);
 
-	/*
-	 * Set a flag to indicate that we should ignore all PhyRdy
-	 * state changes since these can happen now whenever we
-	 * change link state
-	 */
-	hpriv->flags |= AHCI_HFLAG_NO_HOTPLUG;
+		if (policy == ATA_LPM_MAX_POWER || !(hints & ATA_LPM_HIPM)) {
+			cmd &= ~(PORT_CMD_ASP | PORT_CMD_ALPE);
+			cmd |= PORT_CMD_ICC_ACTIVE;
 
-	/* get the existing command bits */
-	cmd = readl(port_mmio + PORT_CMD);
+			writel(cmd, port_mmio + PORT_CMD);
+			readl(port_mmio + PORT_CMD);
 
-	/*
-	 * Set ASP based on Policy
-	 */
-	cmd |= asp;
+			/* wait 10ms to be sure we've come out of LPM state */
+			ata_msleep(ap, 10);
+		} else {
+			cmd |= PORT_CMD_ALPE;
+			if (policy == ATA_LPM_MIN_POWER)
+				cmd |= PORT_CMD_ASP;
 
-	/*
-	 * Setting this bit will instruct the HBA to aggressively
-	 * enter a lower power link state when it's appropriate and
-	 * based on the value set above for ASP
-	 */
-	cmd |= PORT_CMD_ALPE;
+			/* write out new cmd value */
+			writel(cmd, port_mmio + PORT_CMD);
+		}
+	}
 
-	/* write out new cmd value */
-	writel(cmd, port_mmio + PORT_CMD);
-	cmd = readl(port_mmio + PORT_CMD);
+	if (policy == ATA_LPM_MAX_POWER) {
+		sata_link_scr_lpm(link, policy, false);
+
+		/* turn PHYRDY IRQ back on */
+		pp->intr_mask |= PORT_IRQ_PHYRDY;
+		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+	}
 
-	/* IPM bits should be set by libata-core */
 	return 0;
 }
 
@@ -813,7 +740,7 @@ static void ahci_start_port(struct ata_port *ap)
 							       emp->led_state,
 							       4);
 				if (rc == -EBUSY)
-					msleep(1);
+					ata_msleep(ap, 1);
 				else
 					break;
 			}
@@ -872,7 +799,7 @@ int ahci_reset_controller(struct ata_host *host)
 		 * reset must complete within 1 second, or
 		 * the hardware should be considered fried.
 		 */
-		tmp = ata_wait_register(mmio + HOST_CTL, HOST_RESET,
+		tmp = ata_wait_register(NULL, mmio + HOST_CTL, HOST_RESET,
 					HOST_RESET, 10, 1000);
 
 		if (tmp & HOST_RESET) {
@@ -1252,7 +1179,7 @@ int ahci_kick_engine(struct ata_port *ap)
 	writel(tmp, port_mmio + PORT_CMD);
 
 	rc = 0;
-	tmp = ata_wait_register(port_mmio + PORT_CMD,
+	tmp = ata_wait_register(ap, port_mmio + PORT_CMD,
 				PORT_CMD_CLO, PORT_CMD_CLO, 1, 500);
 	if (tmp & PORT_CMD_CLO)
 		rc = -EIO;
@@ -1282,8 +1209,8 @@ static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 	writel(1, port_mmio + PORT_CMD_ISSUE);
 
 	if (timeout_msec) {
-		tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
-					1, timeout_msec);
+		tmp = ata_wait_register(ap, port_mmio + PORT_CMD_ISSUE,
+					0x1, 0x1, 1, timeout_msec);
 		if (tmp & 0x1) {
 			ahci_kick_engine(ap);
 			return -EBUSY;
@@ -1330,7 +1257,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	}
 
 	/* spec says at least 5us, but be generous and sleep for 1ms */
-	msleep(1);
+	ata_msleep(ap, 1);
 
 	/* issue the second D2H Register FIS */
 	tf.ctl &= ~ATA_SRST;
@@ -1660,15 +1587,10 @@ static void ahci_port_intr(struct ata_port *ap)
 	if (unlikely(resetting))
 		status &= ~PORT_IRQ_BAD_PMP;
 
-	/* If we are getting PhyRdy, this is
-	 * just a power state change, we should
-	 * clear out this, plus the PhyRdy/Comm
-	 * Wake bits from Serror
-	 */
-	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
-		(status & PORT_IRQ_PHYRDY)) {
+	/* if LPM is enabled, PHYRDY doesn't mean anything */
+	if (ap->link.lpm_policy > ATA_LPM_MAX_POWER) {
 		status &= ~PORT_IRQ_PHYRDY;
-		ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
+		ahci_scr_write(&ap->link, SCR_ERROR, SERR_PHYRDY_CHG);
 	}
 
 	if (unlikely(status & PORT_IRQ_ERROR)) {
@@ -1830,12 +1752,24 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct ahci_port_priv *pp = qc->ap->private_data;
-	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	u8 *rx_fis = pp->rx_fis;
 
 	if (pp->fbs_enabled)
-		d2h_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
+		rx_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
+
+	/*
+	 * After a successful execution of an ATA PIO data-in command,
+	 * the device doesn't send D2H Reg FIS to update the TF and
+	 * the host should take TF and E_Status from the preceding PIO
+	 * Setup FIS.
+	 */
+	if (qc->tf.protocol == ATA_PROT_PIO && qc->dma_dir == DMA_FROM_DEVICE &&
+	    !(qc->flags & ATA_QCFLAG_FAILED)) {
+		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
+		qc->result_tf.command = (rx_fis + RX_FIS_PIO_SETUP)[15];
+	} else
+		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
 
-	ata_tf_from_fis(d2h_fis, &qc->result_tf);
 	return true;
 }
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 932eaee..7f77c67 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -68,7 +68,7 @@
 #include <linux/ratelimit.h>
 
 #include "libata.h"
-
+#include "libata-transport.h"
 
 /* debounce timing parameters in msecs { interval, duration, timeout } */
 const unsigned long sata_deb_timing_normal[]		= {   5,  100, 2000 };
@@ -91,8 +91,6 @@ const struct ata_port_operations sata_port_ops = {
 static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
-static unsigned int ata_dev_set_feature(struct ata_device *dev,
-					u8 enable, u8 feature);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
@@ -1017,7 +1015,7 @@ const char *ata_mode_string(unsigned long xfer_mask)
 	return "<n/a>";
 }
 
-static const char *sata_spd_string(unsigned int spd)
+const char *sata_spd_string(unsigned int spd)
 {
 	static const char * const spd_str[] = {
 		"1.5 Gbps",
@@ -1030,182 +1028,6 @@ static const char *sata_spd_string(unsigned int spd)
 	return spd_str[spd - 1];
 }
 
-static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
-{
-	struct ata_link *link = dev->link;
-	struct ata_port *ap = link->ap;
-	u32 scontrol;
-	unsigned int err_mask;
-	int rc;
-
-	/*
-	 * disallow DIPM for drivers which haven't set
-	 * ATA_FLAG_IPM.  This is because when DIPM is enabled,
-	 * phy ready will be set in the interrupt status on
-	 * state changes, which will cause some drivers to
-	 * think there are errors - additionally drivers will
-	 * need to disable hot plug.
-	 */
-	if (!(ap->flags & ATA_FLAG_IPM) || !ata_dev_enabled(dev)) {
-		ap->pm_policy = NOT_AVAILABLE;
-		return -EINVAL;
-	}
-
-	/*
-	 * For DIPM, we will only enable it for the
-	 * min_power setting.
-	 *
-	 * Why?  Because Disks are too stupid to know that
-	 * If the host rejects a request to go to SLUMBER
-	 * they should retry at PARTIAL, and instead it
-	 * just would give up.  So, for medium_power to
-	 * work at all, we need to only allow HIPM.
-	 */
-	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
-	if (rc)
-		return rc;
-
-	switch (policy) {
-	case MIN_POWER:
-		/* no restrictions on IPM transitions */
-		scontrol &= ~(0x3 << 8);
-		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
-		if (rc)
-			return rc;
-
-		/* enable DIPM */
-		if (dev->flags & ATA_DFLAG_DIPM)
-			err_mask = ata_dev_set_feature(dev,
-					SETFEATURES_SATA_ENABLE, SATA_DIPM);
-		break;
-	case MEDIUM_POWER:
-		/* allow IPM to PARTIAL */
-		scontrol &= ~(0x1 << 8);
-		scontrol |= (0x2 << 8);
-		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
-		if (rc)
-			return rc;
-
-		/*
-		 * we don't have to disable DIPM since IPM flags
-		 * disallow transitions to SLUMBER, which effectively
-		 * disable DIPM if it does not support PARTIAL
-		 */
-		break;
-	case NOT_AVAILABLE:
-	case MAX_PERFORMANCE:
-		/* disable all IPM transitions */
-		scontrol |= (0x3 << 8);
-		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
-		if (rc)
-			return rc;
-
-		/*
-		 * we don't have to disable DIPM since IPM flags
-		 * disallow all transitions which effectively
-		 * disable DIPM anyway.
-		 */
-		break;
-	}
-
-	/* FIXME: handle SET FEATURES failure */
-	(void) err_mask;
-
-	return 0;
-}
-
-/**
- *	ata_dev_enable_pm - enable SATA interface power management
- *	@dev:  device to enable power management
- *	@policy: the link power management policy
- *
- *	Enable SATA Interface power management.  This will enable
- *	Device Interface Power Management (DIPM) for min_power
- * 	policy, and then call driver specific callbacks for
- *	enabling Host Initiated Power management.
- *
- *	Locking: Caller.
- *	Returns: -EINVAL if IPM is not supported, 0 otherwise.
- */
-void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy)
-{
-	int rc = 0;
-	struct ata_port *ap = dev->link->ap;
-
-	/* set HIPM first, then DIPM */
-	if (ap->ops->enable_pm)
-		rc = ap->ops->enable_pm(ap, policy);
-	if (rc)
-		goto enable_pm_out;
-	rc = ata_dev_set_dipm(dev, policy);
-
-enable_pm_out:
-	if (rc)
-		ap->pm_policy = MAX_PERFORMANCE;
-	else
-		ap->pm_policy = policy;
-	return /* rc */;	/* hopefully we can use 'rc' eventually */
-}
-
-#ifdef CONFIG_PM
-/**
- *	ata_dev_disable_pm - disable SATA interface power management
- *	@dev: device to disable power management
- *
- *	Disable SATA Interface power management.  This will disable
- *	Device Interface Power Management (DIPM) without changing
- * 	policy,  call driver specific callbacks for disabling Host
- * 	Initiated Power management.
- *
- *	Locking: Caller.
- *	Returns: void
- */
-static void ata_dev_disable_pm(struct ata_device *dev)
-{
-	struct ata_port *ap = dev->link->ap;
-
-	ata_dev_set_dipm(dev, MAX_PERFORMANCE);
-	if (ap->ops->disable_pm)
-		ap->ops->disable_pm(ap);
-}
-#endif	/* CONFIG_PM */
-
-void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
-{
-	ap->pm_policy = policy;
-	ap->link.eh_info.action |= ATA_EH_LPM;
-	ap->link.eh_info.flags |= ATA_EHI_NO_AUTOPSY;
-	ata_port_schedule_eh(ap);
-}
-
-#ifdef CONFIG_PM
-static void ata_lpm_enable(struct ata_host *host)
-{
-	struct ata_link *link;
-	struct ata_port *ap;
-	struct ata_device *dev;
-	int i;
-
-	for (i = 0; i < host->n_ports; i++) {
-		ap = host->ports[i];
-		ata_for_each_link(link, ap, EDGE) {
-			ata_for_each_dev(dev, link, ALL)
-				ata_dev_disable_pm(dev);
-		}
-	}
-}
-
-static void ata_lpm_disable(struct ata_host *host)
-{
-	int i;
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		ata_lpm_schedule(ap, ap->pm_policy);
-	}
-}
-#endif	/* CONFIG_PM */
-
 /**
  *	ata_dev_classify - determine device type based on ATA-spec signature
  *	@tf: ATA taskfile register set for device to be identified
@@ -1806,8 +1628,14 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 		}
 	}
 
+	if (ap->ops->error_handler)
+		ata_eh_release(ap);
+
 	rc = wait_for_completion_timeout(&wait, msecs_to_jiffies(timeout));
 
+	if (ap->ops->error_handler)
+		ata_eh_acquire(ap);
+
 	ata_sff_flush_pio_task(ap);
 
 	if (!rc) {
@@ -2564,13 +2392,6 @@ int ata_dev_configure(struct ata_device *dev)
 	if (dev->flags & ATA_DFLAG_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
-	if (!(dev->horkage & ATA_HORKAGE_IPM)) {
-		if (ata_id_has_hipm(dev->id))
-			dev->flags |= ATA_DFLAG_HIPM;
-		if (ata_id_has_dipm(dev->id))
-			dev->flags |= ATA_DFLAG_DIPM;
-	}
-
 	/* Limit PATA drive on SATA cable bridge transfers to udma5,
 	   200 sectors */
 	if (ata_dev_knobble(dev)) {
@@ -2591,13 +2412,6 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
-	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_IPM) {
-		dev->horkage |= ATA_HORKAGE_IPM;
-
-		/* reset link pm_policy for this port to no pm */
-		ap->pm_policy = MAX_PERFORMANCE;
-	}
-
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -3596,7 +3410,7 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 			warned = 1;
 		}
 
-		msleep(50);
+		ata_msleep(link->ap, 50);
 	}
 }
 
@@ -3617,7 +3431,7 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
 				int (*check_ready)(struct ata_link *link))
 {
-	msleep(ATA_WAIT_AFTER_RESET);
+	ata_msleep(link->ap, ATA_WAIT_AFTER_RESET);
 
 	return ata_wait_ready(link, deadline, check_ready);
 }
@@ -3628,7 +3442,7 @@ int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
  *	@params: timing parameters { interval, duratinon, timeout } in msec
  *	@deadline: deadline jiffies for the operation
  *
-*	Make sure SStatus of @link reaches stable state, determined by
+ *	Make sure SStatus of @link reaches stable state, determined by
  *	holding the same value where DET is not 1 for @duration polled
  *	every @interval, before @timeout.  Timeout constraints the
  *	beginning of the stable state.  Because DET gets stuck at 1 on
@@ -3665,7 +3479,7 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 	last_jiffies = jiffies;
 
 	while (1) {
-		msleep(interval);
+		ata_msleep(link->ap, interval);
 		if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
 			return rc;
 		cur &= 0xf;
@@ -3730,7 +3544,7 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 		 * immediately after resuming.  Delay 200ms before
 		 * debouncing.
 		 */
-		msleep(200);
+		ata_msleep(link->ap, 200);
 
 		/* is SControl restored correctly? */
 		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
@@ -3760,6 +3574,72 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 }
 
 /**
+ *	sata_link_scr_lpm - manipulate SControl IPM and SPM fields
+ *	@link: ATA link to manipulate SControl for
+ *	@policy: LPM policy to configure
+ *	@spm_wakeup: initiate LPM transition to active state
+ *
+ *	Manipulate the IPM field of the SControl register of @link
+ *	according to @policy.  If @policy is ATA_LPM_MAX_POWER and
+ *	@spm_wakeup is %true, the SPM field is manipulated to wake up
+ *	the link.  This function also clears PHYRDY_CHG before
+ *	returning.
+ *
+ *	LOCKING:
+ *	EH context.
+ *
+ *	RETURNS:
+ *	0 on succes, -errno otherwise.
+ */
+int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+		      bool spm_wakeup)
+{
+	struct ata_eh_context *ehc = &link->eh_context;
+	bool woken_up = false;
+	u32 scontrol;
+	int rc;
+
+	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
+	if (rc)
+		return rc;
+
+	switch (policy) {
+	case ATA_LPM_MAX_POWER:
+		/* disable all LPM transitions */
+		scontrol |= (0x3 << 8);
+		/* initiate transition to active state */
+		if (spm_wakeup) {
+			scontrol |= (0x4 << 12);
+			woken_up = true;
+		}
+		break;
+	case ATA_LPM_MED_POWER:
+		/* allow LPM to PARTIAL */
+		scontrol &= ~(0x1 << 8);
+		scontrol |= (0x2 << 8);
+		break;
+	case ATA_LPM_MIN_POWER:
+		/* no restrictions on LPM transitions */
+		scontrol &= ~(0x3 << 8);
+		break;
+	default:
+		WARN_ON(1);
+	}
+
+	rc = sata_scr_write(link, SCR_CONTROL, scontrol);
+	if (rc)
+		return rc;
+
+	/* give the link time to transit out of LPM state */
+	if (woken_up)
+		msleep(10);
+
+	/* clear PHYRDY_CHG from SError */
+	ehc->i.serror &= ~SERR_PHYRDY_CHG;
+	return sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
+}
+
+/**
  *	ata_std_prereset - prepare for reset
  *	@link: ATA link to be reset
  *	@deadline: deadline jiffies for the operation
@@ -3868,7 +3748,7 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 	/* Couldn't find anything in SATA I/II specs, but AHCI-1.1
 	 * 10.4.2 says at least 1 ms.
 	 */
-	msleep(1);
+	ata_msleep(link->ap, 1);
 
 	/* bring link back */
 	rc = sata_link_resume(link, timing, deadline);
@@ -4551,6 +4431,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
 }
+
 /**
  *	ata_dev_set_feature - Issue SET FEATURES - SATA FEATURES
  *	@dev: Device to which command will be sent
@@ -4566,8 +4447,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
  *	RETURNS:
  *	0 on success, AC_ERR_* mask otherwise.
  */
-static unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable,
-					u8 feature)
+unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable, u8 feature)
 {
 	struct ata_taskfile tf;
 	unsigned int err_mask;
@@ -4943,8 +4823,13 @@ static void ata_verify_xfer(struct ata_queued_cmd *qc)
  *	ata_qc_complete - Complete an active ATA command
  *	@qc: Command to complete
  *
- *	Indicate to the mid and upper layers that an ATA
- *	command has completed, with either an ok or not-ok status.
+ *	Indicate to the mid and upper layers that an ATA command has
+ *	completed, with either an ok or not-ok status.
+ *
+ *	Refrain from calling this function multiple times when
+ *	successfully completing multiple NCQ commands.
+ *	ata_qc_complete_multiple() should be used instead, which will
+ *	properly update IRQ expect state.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -5037,6 +4922,10 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
  *	requests normally.  ap->qc_active and @qc_active is compared
  *	and commands are completed accordingly.
  *
+ *	Always use this function when completing multiple NCQ commands
+ *	from IRQ handlers instead of calling ata_qc_complete()
+ *	multiple times to keep IRQ expect status properly in sync.
+ *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  *
@@ -5422,12 +5311,6 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 	int rc;
 
 	/*
-	 * disable link pm on all ports before requesting
-	 * any pm activity
-	 */
-	ata_lpm_enable(host);
-
-	/*
 	 * On some hardware, device fails to respond after spun down
 	 * for suspend.  As the device won't be used before being
 	 * resumed, we don't need to touch the device.  Ask EH to skip
@@ -5460,9 +5343,6 @@ void ata_host_resume(struct ata_host *host)
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_RESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
-
-	/* reenable link pm */
-	ata_lpm_disable(host);
 }
 #endif
 
@@ -5517,7 +5397,8 @@ void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp)
 	int i;
 
 	/* clear everything except for devices */
-	memset(link, 0, offsetof(struct ata_link, device[0]));
+	memset((void *)link + ATA_LINK_CLEAR_BEGIN, 0,
+	       ATA_LINK_CLEAR_END - ATA_LINK_CLEAR_BEGIN);
 
 	link->ap = ap;
 	link->pmp = pmp;
@@ -5591,7 +5472,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
 	if (!ap)
 		return NULL;
-
+	
 	ap->pflags |= ATA_PFLAG_INITIALIZING;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
@@ -5695,6 +5576,7 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 	dev_set_drvdata(dev, host);
 
 	spin_lock_init(&host->lock);
+	mutex_init(&host->eh_mutex);
 	host->dev = dev;
 	host->n_ports = max_ports;
 
@@ -5992,6 +5874,7 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 		   unsigned long flags, struct ata_port_operations *ops)
 {
 	spin_lock_init(&host->lock);
+	mutex_init(&host->eh_mutex);
 	host->dev = dev;
 	host->flags = flags;
 	host->ops = ops;
@@ -6022,7 +5905,7 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 		spin_lock_irqsave(ap->lock, flags);
 
 		ehi->probe_mask |= ATA_ALL_DEVICES;
-		ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
+		ehi->action |= ATA_EH_RESET;
 		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
 
 		ap->pflags &= ~ATA_PFLAG_INITIALIZING;
@@ -6093,9 +5976,18 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	for (i = 0; i < host->n_ports; i++)
 		host->ports[i]->print_id = ata_print_id++;
 
+	
+	/* Create associated sysfs transport objects  */
+	for (i = 0; i < host->n_ports; i++) {
+		rc = ata_tport_add(host->dev,host->ports[i]);
+		if (rc) {
+			goto err_tadd;
+		}
+	}
+
 	rc = ata_scsi_add_hosts(host, sht);
 	if (rc)
-		return rc;
+		goto err_tadd;
 
 	/* associate with ACPI nodes */
 	ata_acpi_associate(host);
@@ -6136,6 +6028,13 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	}
 
 	return 0;
+
+ err_tadd:
+	while (--i >= 0) {
+		ata_tport_delete(host->ports[i]);
+	}
+	return rc;
+
 }
 
 /**
@@ -6226,6 +6125,13 @@ static void ata_port_detach(struct ata_port *ap)
 	cancel_rearming_delayed_work(&ap->hotplug_task);
 
  skip_eh:
+	if (ap->pmp_link) {
+		int i;
+		for (i = 0; i < SATA_PMP_MAX_PORTS; i++)
+			ata_tlink_delete(&ap->pmp_link[i]);
+	}
+	ata_tport_delete(ap);
+
 	/* remove the associated SCSI host */
 	scsi_remove_host(ap->scsi_host);
 }
@@ -6542,7 +6448,7 @@ static void __init ata_parse_force_param(void)
 
 static int __init ata_init(void)
 {
-	int rc = -ENOMEM;
+	int rc;
 
 	ata_parse_force_param();
 
@@ -6552,12 +6458,25 @@ static int __init ata_init(void)
 		return rc;
 	}
 
+	libata_transport_init();
+	ata_scsi_transport_template = ata_attach_transport();
+	if (!ata_scsi_transport_template) {
+		ata_sff_exit();
+		rc = -ENOMEM;
+		goto err_out;
+	}		
+
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
+
+err_out:
+	return rc;
 }
 
 static void __exit ata_exit(void)
 {
+	ata_release_transport(ata_scsi_transport_template);
+	libata_transport_exit();
 	ata_sff_exit();
 	kfree(ata_force_tbl);
 }
@@ -6573,7 +6492,35 @@ int ata_ratelimit(void)
 }
 
 /**
+ *	ata_msleep - ATA EH owner aware msleep
+ *	@ap: ATA port to attribute the sleep to
+ *	@msecs: duration to sleep in milliseconds
+ *
+ *	Sleeps @msecs.  If the current task is owner of @ap's EH, the
+ *	ownership is released before going to sleep and reacquired
+ *	after the sleep is complete.  IOW, other ports sharing the
+ *	@ap->host will be allowed to own the EH while this task is
+ *	sleeping.
+ *
+ *	LOCKING:
+ *	Might sleep.
+ */
+void ata_msleep(struct ata_port *ap, unsigned int msecs)
+{
+	bool owns_eh = ap && ap->host->eh_owner == current;
+
+	if (owns_eh)
+		ata_eh_release(ap);
+
+	msleep(msecs);
+
+	if (owns_eh)
+		ata_eh_acquire(ap);
+}
+
+/**
  *	ata_wait_register - wait until register value changes
+ *	@ap: ATA port to wait register for, can be NULL
  *	@reg: IO-mapped register
  *	@mask: Mask to apply to read register value
  *	@val: Wait condition
@@ -6595,7 +6542,7 @@ int ata_ratelimit(void)
  *	RETURNS:
  *	The final register value.
  */
-u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
+u32 ata_wait_register(struct ata_port *ap, void __iomem *reg, u32 mask, u32 val,
 		      unsigned long interval, unsigned long timeout)
 {
 	unsigned long deadline;
@@ -6610,7 +6557,7 @@ u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
 	deadline = ata_deadline(jiffies, timeout);
 
 	while ((tmp & mask) == val && time_before(jiffies, deadline)) {
-		msleep(interval);
+		ata_msleep(ap, interval);
 		tmp = ioread32(reg);
 	}
 
@@ -6686,6 +6633,7 @@ EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(ata_wait_after_reset);
 EXPORT_SYMBOL_GPL(sata_link_debounce);
 EXPORT_SYMBOL_GPL(sata_link_resume);
+EXPORT_SYMBOL_GPL(sata_link_scr_lpm);
 EXPORT_SYMBOL_GPL(ata_std_prereset);
 EXPORT_SYMBOL_GPL(sata_link_hardreset);
 EXPORT_SYMBOL_GPL(sata_std_hardreset);
@@ -6693,6 +6641,7 @@ EXPORT_SYMBOL_GPL(ata_std_postreset);
 EXPORT_SYMBOL_GPL(ata_dev_classify);
 EXPORT_SYMBOL_GPL(ata_dev_pair);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
+EXPORT_SYMBOL_GPL(ata_msleep);
 EXPORT_SYMBOL_GPL(ata_wait_register);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index e48302e..5e59050 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -57,6 +57,7 @@ enum {
 	/* error flags */
 	ATA_EFLAG_IS_IO			= (1 << 0),
 	ATA_EFLAG_DUBIOUS_XFER		= (1 << 1),
+	ATA_EFLAG_OLD_ER                = (1 << 31),
 
 	/* error categories */
 	ATA_ECAT_NONE			= 0,
@@ -396,14 +397,9 @@ static struct ata_ering_entry *ata_ering_top(struct ata_ering *ering)
 	return NULL;
 }
 
-static void ata_ering_clear(struct ata_ering *ering)
-{
-	memset(ering, 0, sizeof(*ering));
-}
-
-static int ata_ering_map(struct ata_ering *ering,
-			 int (*map_fn)(struct ata_ering_entry *, void *),
-			 void *arg)
+int ata_ering_map(struct ata_ering *ering,
+		  int (*map_fn)(struct ata_ering_entry *, void *),
+		  void *arg)
 {
 	int idx, rc = 0;
 	struct ata_ering_entry *ent;
@@ -422,6 +418,17 @@ static int ata_ering_map(struct ata_ering *ering,
 	return rc;
 }
 
+int ata_ering_clear_cb(struct ata_ering_entry *ent, void *void_arg)
+{
+	ent->eflags |= ATA_EFLAG_OLD_ER;
+	return 0;
+}
+
+static void ata_ering_clear(struct ata_ering *ering)
+{
+	ata_ering_map(ering, ata_ering_clear_cb, NULL);
+}
+
 static unsigned int ata_eh_dev_action(struct ata_device *dev)
 {
 	struct ata_eh_context *ehc = &dev->link->eh_context;
@@ -456,6 +463,41 @@ static void ata_eh_clear_action(struct ata_link *link, struct ata_device *dev,
 }
 
 /**
+ *	ata_eh_acquire - acquire EH ownership
+ *	@ap: ATA port to acquire EH ownership for
+ *
+ *	Acquire EH ownership for @ap.  This is the basic exclusion
+ *	mechanism for ports sharing a host.  Only one port hanging off
+ *	the same host can claim the ownership of EH.
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+void ata_eh_acquire(struct ata_port *ap)
+{
+	mutex_lock(&ap->host->eh_mutex);
+	WARN_ON_ONCE(ap->host->eh_owner);
+	ap->host->eh_owner = current;
+}
+
+/**
+ *	ata_eh_release - release EH ownership
+ *	@ap: ATA port to release EH ownership for
+ *
+ *	Release EH ownership for @ap if the caller.  The caller must
+ *	have acquired EH ownership using ata_eh_acquire() previously.
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+void ata_eh_release(struct ata_port *ap)
+{
+	WARN_ON_ONCE(ap->host->eh_owner != current);
+	ap->host->eh_owner = NULL;
+	mutex_unlock(&ap->host->eh_mutex);
+}
+
+/**
  *	ata_scsi_timed_out - SCSI layer time out callback
  *	@cmd: timed out SCSI command
  *
@@ -572,19 +614,19 @@ void ata_scsi_error(struct Scsi_Host *host)
 		int nr_timedout = 0;
 
 		spin_lock_irqsave(ap->lock, flags);
-		
+
 		/* This must occur under the ap->lock as we don't want
 		   a polled recovery to race the real interrupt handler
-		   
+
 		   The lost_interrupt handler checks for any completed but
 		   non-notified command and completes much like an IRQ handler.
-		   
+
 		   We then fall into the error recovery code which will treat
 		   this as if normal completion won the race */
 
 		if (ap->ops->lost_interrupt)
 			ap->ops->lost_interrupt(ap);
-			
+
 		list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
 			struct ata_queued_cmd *qc;
 
@@ -628,15 +670,17 @@ void ata_scsi_error(struct Scsi_Host *host)
 		ap->eh_tries = ATA_EH_MAX_TRIES;
 	} else
 		spin_unlock_wait(ap->lock);
-		
+
 	/* If we timed raced normal completion and there is nothing to
 	   recover nr_timedout == 0 why exactly are we doing error recovery ? */
 
- repeat:
 	/* invoke error handler */
 	if (ap->ops->error_handler) {
 		struct ata_link *link;
 
+		/* acquire EH ownership */
+		ata_eh_acquire(ap);
+ repeat:
 		/* kill fast drain timer */
 		del_timer_sync(&ap->fastdrain_timer);
 
@@ -711,6 +755,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 		host->host_eh_scheduled = 0;
 
 		spin_unlock_irqrestore(ap->lock, flags);
+		ata_eh_release(ap);
 	} else {
 		WARN_ON(ata_qc_from_tag(ap, ap->link.active_tag) == NULL);
 		ap->ops->eng_timeout(ap);
@@ -772,7 +817,7 @@ void ata_port_wait_eh(struct ata_port *ap)
 
 	/* make sure SCSI EH is complete */
 	if (scsi_host_in_recovery(ap->scsi_host)) {
-		msleep(10);
+		ata_msleep(ap, 10);
 		goto retry;
 	}
 }
@@ -1573,9 +1618,9 @@ static void ata_eh_analyze_serror(struct ata_link *link)
 	 * host links.  For disabled PMP links, only N bit is
 	 * considered as X bit is left at 1 for link plugging.
 	 */
-	hotplug_mask = 0;
-
-	if (!(link->flags & ATA_LFLAG_DISABLED) || ata_is_host_link(link))
+	if (link->lpm_policy != ATA_LPM_MAX_POWER)
+		hotplug_mask = 0;	/* hotplug doesn't work w/ LPM */
+	else if (!(link->flags & ATA_LFLAG_DISABLED) || ata_is_host_link(link))
 		hotplug_mask = SERR_PHYRDY_CHG | SERR_DEV_XCHG;
 	else
 		hotplug_mask = SERR_PHYRDY_CHG;
@@ -1755,7 +1800,7 @@ static int speed_down_verdict_cb(struct ata_ering_entry *ent, void *void_arg)
 	struct speed_down_verdict_arg *arg = void_arg;
 	int cat;
 
-	if (ent->timestamp < arg->since)
+	if ((ent->eflags & ATA_EFLAG_OLD_ER) || (ent->timestamp < arg->since))
 		return -1;
 
 	cat = ata_eh_categorize_error(ent->eflags, ent->err_mask,
@@ -2777,8 +2822,9 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ata_eh_done(link, NULL, ATA_EH_RESET);
 	if (slave)
 		ata_eh_done(slave, NULL, ATA_EH_RESET);
-	ehc->last_reset = jiffies;	/* update to completion time */
+	ehc->last_reset = jiffies;		/* update to completion time */
 	ehc->i.action |= ATA_EH_REVALIDATE;
+	link->lpm_policy = ATA_LPM_UNKNOWN;	/* reset LPM state */
 
 	rc = 0;
  out:
@@ -2810,8 +2856,10 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			"reset failed (errno=%d), retrying in %u secs\n",
 			rc, DIV_ROUND_UP(jiffies_to_msecs(delta), 1000));
 
+		ata_eh_release(ap);
 		while (delta)
 			delta = schedule_timeout_uninterruptible(delta);
+		ata_eh_acquire(ap);
 	}
 
 	if (try == max_tries - 1) {
@@ -3204,6 +3252,124 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
 	return rc;
 }
 
+/**
+ *	ata_eh_set_lpm - configure SATA interface power management
+ *	@link: link to configure power management
+ *	@policy: the link power management policy
+ *	@r_failed_dev: out parameter for failed device
+ *
+ *	Enable SATA Interface power management.  This will enable
+ *	Device Interface Power Management (DIPM) for min_power
+ * 	policy, and then call driver specific callbacks for
+ *	enabling Host Initiated Power management.
+ *
+ *	LOCKING:
+ *	EH context.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+			  struct ata_device **r_failed_dev)
+{
+	struct ata_port *ap = ata_is_host_link(link) ? link->ap : NULL;
+	struct ata_eh_context *ehc = &link->eh_context;
+	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
+	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
+	unsigned int err_mask;
+	int rc;
+
+	/* if the link or host doesn't do LPM, noop */
+	if ((link->flags & ATA_LFLAG_NO_LPM) || (ap && !ap->ops->set_lpm))
+		return 0;
+
+	/*
+	 * DIPM is enabled only for MIN_POWER as some devices
+	 * misbehave when the host NACKs transition to SLUMBER.  Order
+	 * device and link configurations such that the host always
+	 * allows DIPM requests.
+	 */
+	ata_for_each_dev(dev, link, ENABLED) {
+		bool hipm = ata_id_has_hipm(dev->id);
+		bool dipm = ata_id_has_dipm(dev->id);
+
+		/* find the first enabled and LPM enabled devices */
+		if (!link_dev)
+			link_dev = dev;
+
+		if (!lpm_dev && (hipm || dipm))
+			lpm_dev = dev;
+
+		hints &= ~ATA_LPM_EMPTY;
+		if (!hipm)
+			hints &= ~ATA_LPM_HIPM;
+
+		/* disable DIPM before changing link config */
+		if (policy != ATA_LPM_MIN_POWER && dipm) {
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+			if (err_mask && err_mask != AC_ERR_DEV) {
+				ata_dev_printk(dev, KERN_WARNING,
+					"failed to disable DIPM, Emask 0x%x\n",
+					err_mask);
+				rc = -EIO;
+				goto fail;
+			}
+		}
+	}
+
+	if (ap) {
+		rc = ap->ops->set_lpm(link, policy, hints);
+		if (!rc && ap->slave_link)
+			rc = ap->ops->set_lpm(ap->slave_link, policy, hints);
+	} else
+		rc = sata_pmp_set_lpm(link, policy, hints);
+
+	/*
+	 * Attribute link config failure to the first (LPM) enabled
+	 * device on the link.
+	 */
+	if (rc) {
+		if (rc == -EOPNOTSUPP) {
+			link->flags |= ATA_LFLAG_NO_LPM;
+			return 0;
+		}
+		dev = lpm_dev ? lpm_dev : link_dev;
+		goto fail;
+	}
+
+	/* host config updated, enable DIPM if transitioning to MIN_POWER */
+	ata_for_each_dev(dev, link, ENABLED) {
+		if (policy == ATA_LPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_ENABLE, SATA_DIPM);
+			if (err_mask && err_mask != AC_ERR_DEV) {
+				ata_dev_printk(dev, KERN_WARNING,
+					"failed to enable DIPM, Emask 0x%x\n",
+					err_mask);
+				rc = -EIO;
+				goto fail;
+			}
+		}
+	}
+
+	link->lpm_policy = policy;
+	if (ap && ap->slave_link)
+		ap->slave_link->lpm_policy = policy;
+	return 0;
+
+fail:
+	/* if no device or only one more chance is left, disable LPM */
+	if (!dev || ehc->tries[dev->devno] <= 2) {
+		ata_link_printk(link, KERN_WARNING,
+				"disabling LPM on the link\n");
+		link->flags |= ATA_LFLAG_NO_LPM;
+	}
+	if (r_failed_dev)
+		*r_failed_dev = dev;
+	return rc;
+}
+
 static int ata_link_nr_enabled(struct ata_link *link)
 {
 	struct ata_device *dev;
@@ -3288,6 +3454,16 @@ static int ata_eh_schedule_probe(struct ata_device *dev)
 	ehc->saved_xfer_mode[dev->devno] = 0;
 	ehc->saved_ncq_enabled &= ~(1 << dev->devno);
 
+	/* the link maybe in a deep sleep, wake it up */
+	if (link->lpm_policy > ATA_LPM_MAX_POWER) {
+		if (ata_is_host_link(link))
+			link->ap->ops->set_lpm(link, ATA_LPM_MAX_POWER,
+					       ATA_LPM_EMPTY);
+		else
+			sata_pmp_set_lpm(link, ATA_LPM_MAX_POWER,
+					 ATA_LPM_EMPTY);
+	}
+
 	/* Record and count probe trials on the ering.  The specific
 	 * error mask used is irrelevant.  Because a successful device
 	 * detection clears the ering, this count accumulates only if
@@ -3389,8 +3565,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 {
 	struct ata_link *link;
 	struct ata_device *dev;
-	int nr_failed_devs;
-	int rc;
+	int rc, nr_fails;
 	unsigned long flags, deadline;
 
 	DPRINTK("ENTER\n");
@@ -3431,7 +3606,6 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 
  retry:
 	rc = 0;
-	nr_failed_devs = 0;
 
 	/* if UNLOADING, finish immediately */
 	if (ap->pflags & ATA_PFLAG_UNLOADING)
@@ -3501,8 +3675,10 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		if (time_before_eq(deadline, now))
 			break;
 
+		ata_eh_release(ap);
 		deadline = wait_for_completion_timeout(&ap->park_req_pending,
 						       deadline - now);
+		ata_eh_acquire(ap);
 	} while (deadline);
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ALL) {
@@ -3516,13 +3692,17 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	}
 
 	/* the rest */
-	ata_for_each_link(link, ap, EDGE) {
+	nr_fails = 0;
+	ata_for_each_link(link, ap, PMP_FIRST) {
 		struct ata_eh_context *ehc = &link->eh_context;
 
+		if (sata_pmp_attached(ap) && ata_is_host_link(link))
+			goto config_lpm;
+
 		/* revalidate existing devices and attach new ones */
 		rc = ata_eh_revalidate_and_attach(link, &dev);
 		if (rc)
-			goto dev_fail;
+			goto rest_fail;
 
 		/* if PMP got attached, return, pmp EH will take care of it */
 		if (link->device->class == ATA_DEV_PMP) {
@@ -3534,7 +3714,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		if (ehc->i.flags & ATA_EHI_SETMODE) {
 			rc = ata_set_mode(link, &dev);
 			if (rc)
-				goto dev_fail;
+				goto rest_fail;
 			ehc->i.flags &= ~ATA_EHI_SETMODE;
 		}
 
@@ -3547,7 +3727,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 					continue;
 				rc = atapi_eh_clear_ua(dev);
 				if (rc)
-					goto dev_fail;
+					goto rest_fail;
 			}
 		}
 
@@ -3557,21 +3737,25 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 				continue;
 			rc = ata_eh_maybe_retry_flush(dev);
 			if (rc)
-				goto dev_fail;
+				goto rest_fail;
 		}
 
+	config_lpm:
 		/* configure link power saving */
-		if (ehc->i.action & ATA_EH_LPM)
-			ata_for_each_dev(dev, link, ALL)
-				ata_dev_enable_pm(dev, ap->pm_policy);
+		if (link->lpm_policy != ap->target_lpm_policy) {
+			rc = ata_eh_set_lpm(link, ap->target_lpm_policy, &dev);
+			if (rc)
+				goto rest_fail;
+		}
 
 		/* this link is okay now */
 		ehc->i.flags = 0;
 		continue;
 
-dev_fail:
-		nr_failed_devs++;
-		ata_eh_handle_dev_fail(dev, rc);
+	rest_fail:
+		nr_fails++;
+		if (dev)
+			ata_eh_handle_dev_fail(dev, rc);
 
 		if (ap->pflags & ATA_PFLAG_FROZEN) {
 			/* PMP reset requires working host port.
@@ -3583,7 +3767,7 @@ dev_fail:
 		}
 	}
 
-	if (nr_failed_devs)
+	if (nr_fails)
 		goto retry;
 
  out:
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 224faab..3120596 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -11,6 +11,7 @@
 #include <linux/libata.h>
 #include <linux/slab.h>
 #include "libata.h"
+#include "libata-transport.h"
 
 const struct ata_port_operations sata_pmp_port_ops = {
 	.inherits		= &sata_port_ops,
@@ -185,6 +186,27 @@ int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val)
 }
 
 /**
+ *	sata_pmp_set_lpm - configure LPM for a PMP link
+ *	@link: PMP link to configure LPM for
+ *	@policy: target LPM policy
+ *	@hints: LPM hints
+ *
+ *	Configure LPM for @link.  This function will contain any PMP
+ *	specific workarounds if necessary.
+ *
+ *	LOCKING:
+ *	EH context.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+int sata_pmp_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+		     unsigned hints)
+{
+	return sata_link_scr_lpm(link, policy, true);
+}
+
+/**
  *	sata_pmp_read_gscr - read GSCR block of SATA PMP
  *	@dev: PMP device
  *	@gscr: buffer to read GSCR block into
@@ -312,10 +334,10 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 	return rc;
 }
 
-static int sata_pmp_init_links(struct ata_port *ap, int nr_ports)
+static int sata_pmp_init_links (struct ata_port *ap, int nr_ports)
 {
 	struct ata_link *pmp_link = ap->pmp_link;
-	int i;
+	int i, err;
 
 	if (!pmp_link) {
 		pmp_link = kzalloc(sizeof(pmp_link[0]) * SATA_PMP_MAX_PORTS,
@@ -327,6 +349,13 @@ static int sata_pmp_init_links(struct ata_port *ap, int nr_ports)
 			ata_link_init(ap, &pmp_link[i], i);
 
 		ap->pmp_link = pmp_link;
+
+		for (i = 0; i < SATA_PMP_MAX_PORTS; i++) {
+			err = ata_tlink_add(&pmp_link[i]);
+			if (err) {
+				goto err_tlink;
+			}
+		}
 	}
 
 	for (i = 0; i < nr_ports; i++) {
@@ -339,6 +368,12 @@ static int sata_pmp_init_links(struct ata_port *ap, int nr_ports)
 	}
 
 	return 0;
+  err_tlink:
+	while (--i >= 0)
+		ata_tlink_delete(&pmp_link[i]);
+	kfree(pmp_link);
+	ap->pmp_link = NULL;
+	return err;
 }
 
 static void sata_pmp_quirks(struct ata_port *ap)
@@ -351,6 +386,9 @@ static void sata_pmp_quirks(struct ata_port *ap)
 	if (vendor == 0x1095 && devid == 0x3726) {
 		/* sil3726 quirks */
 		ata_for_each_link(link, ap, EDGE) {
+			/* link reports offline after LPM */
+			link->flags |= ATA_LFLAG_NO_LPM;
+
 			/* Class code report is unreliable and SRST
 			 * times out under certain configurations.
 			 */
@@ -366,6 +404,9 @@ static void sata_pmp_quirks(struct ata_port *ap)
 	} else if (vendor == 0x1095 && devid == 0x4723) {
 		/* sil4723 quirks */
 		ata_for_each_link(link, ap, EDGE) {
+			/* link reports offline after LPM */
+			link->flags |= ATA_LFLAG_NO_LPM;
+
 			/* class code report is unreliable */
 			if (link->pmp < 2)
 				link->flags |= ATA_LFLAG_ASSUME_ATA;
@@ -378,6 +419,9 @@ static void sata_pmp_quirks(struct ata_port *ap)
 	} else if (vendor == 0x1095 && devid == 0x4726) {
 		/* sil4726 quirks */
 		ata_for_each_link(link, ap, EDGE) {
+			/* link reports offline after LPM */
+			link->flags |= ATA_LFLAG_NO_LPM;
+
 			/* Class code report is unreliable and SRST
 			 * times out under certain configurations.
 			 * Config device can be at port 0 or 5 and
@@ -938,15 +982,25 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 	if (rc)
 		goto link_fail;
 
-	/* Connection status might have changed while resetting other
-	 * links, check SATA_PMP_GSCR_ERROR before returning.
-	 */
-
 	/* clear SNotification */
 	rc = sata_scr_read(&ap->link, SCR_NOTIFICATION, &sntf);
 	if (rc == 0)
 		sata_scr_write(&ap->link, SCR_NOTIFICATION, sntf);
 
+	/*
+	 * If LPM is active on any fan-out port, hotplug wouldn't
+	 * work.  Return w/ PHY event notification disabled.
+	 */
+	ata_for_each_link(link, ap, EDGE)
+		if (link->lpm_policy > ATA_LPM_MAX_POWER)
+			return 0;
+
+	/*
+	 * Connection status might have changed while resetting other
+	 * links, enable notification and check SATA_PMP_GSCR_ERROR
+	 * before returning.
+	 */
+
 	/* enable notification */
 	if (pmp_dev->flags & ATA_DFLAG_AN) {
 		gscr[SATA_PMP_GSCR_FEAT_EN] |= SATA_PMP_FEAT_NOTIFY;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a89172c..d050e07 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -51,8 +51,8 @@
 #include <asm/unaligned.h>
 
 #include "libata.h"
+#include "libata-transport.h"
 
-#define SECTOR_SIZE		512
 #define ATA_SCSI_RBUF_SIZE	4096
 
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
@@ -64,9 +64,6 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 					const struct scsi_device *scsidev);
 static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
-static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun);
-
 
 #define RW_RECOVERY_MPAGE 0x1
 #define RW_RECOVERY_MPAGE_LEN 12
@@ -106,83 +103,55 @@ static const u8 def_control_mpage[CONTROL_MPAGE_LEN] = {
 	0, 30	/* extended self test time, see 05-359r1 */
 };
 
-/*
- * libata transport template.  libata doesn't do real transport stuff.
- * It just needs the eh_timed_out hook.
- */
-static struct scsi_transport_template ata_scsi_transport_template = {
-	.eh_strategy_handler	= ata_scsi_error,
-	.eh_timed_out		= ata_scsi_timed_out,
-	.user_scan		= ata_scsi_user_scan,
-};
-
-
-static const struct {
-	enum link_pm	value;
-	const char	*name;
-} link_pm_policy[] = {
-	{ NOT_AVAILABLE, "max_performance" },
-	{ MIN_POWER, "min_power" },
-	{ MAX_PERFORMANCE, "max_performance" },
-	{ MEDIUM_POWER, "medium_power" },
+static const char *ata_lpm_policy_names[] = {
+	[ATA_LPM_UNKNOWN]	= "max_performance",
+	[ATA_LPM_MAX_POWER]	= "max_performance",
+	[ATA_LPM_MED_POWER]	= "medium_power",
+	[ATA_LPM_MIN_POWER]	= "min_power",
 };
 
-static const char *ata_scsi_lpm_get(enum link_pm policy)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(link_pm_policy); i++)
-		if (link_pm_policy[i].value == policy)
-			return link_pm_policy[i].name;
-
-	return NULL;
-}
-
-static ssize_t ata_scsi_lpm_put(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
+static ssize_t ata_scsi_lpm_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ata_port *ap = ata_shost_to_port(shost);
-	enum link_pm policy = 0;
-	int i;
+	enum ata_lpm_policy policy;
+	unsigned long flags;
 
-	/*
-	 * we are skipping array location 0 on purpose - this
-	 * is because a value of NOT_AVAILABLE is displayed
-	 * to the user as max_performance, but when the user
-	 * writes "max_performance", they actually want the
-	 * value to match MAX_PERFORMANCE.
-	 */
-	for (i = 1; i < ARRAY_SIZE(link_pm_policy); i++) {
-		const int len = strlen(link_pm_policy[i].name);
-		if (strncmp(link_pm_policy[i].name, buf, len) == 0) {
-			policy = link_pm_policy[i].value;
+	/* UNKNOWN is internal state, iterate from MAX_POWER */
+	for (policy = ATA_LPM_MAX_POWER;
+	     policy < ARRAY_SIZE(ata_lpm_policy_names); policy++) {
+		const char *name = ata_lpm_policy_names[policy];
+
+		if (strncmp(name, buf, strlen(name)) == 0)
 			break;
-		}
 	}
-	if (!policy)
+	if (policy == ARRAY_SIZE(ata_lpm_policy_names))
 		return -EINVAL;
 
-	ata_lpm_schedule(ap, policy);
+	spin_lock_irqsave(ap->lock, flags);
+	ap->target_lpm_policy = policy;
+	ata_port_schedule_eh(ap);
+	spin_unlock_irqrestore(ap->lock, flags);
+
 	return count;
 }
 
-static ssize_t
-ata_scsi_lpm_show(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t ata_scsi_lpm_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ata_port *ap = ata_shost_to_port(shost);
-	const char *policy =
-		ata_scsi_lpm_get(ap->pm_policy);
 
-	if (!policy)
+	if (ap->target_lpm_policy >= ARRAY_SIZE(ata_lpm_policy_names))
 		return -EINVAL;
 
-	return snprintf(buf, 23, "%s\n", policy);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			ata_lpm_policy_names[ap->target_lpm_policy]);
 }
 DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
-		ata_scsi_lpm_show, ata_scsi_lpm_put);
+	    ata_scsi_lpm_show, ata_scsi_lpm_store);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
 static ssize_t ata_scsi_park_show(struct device *device,
@@ -516,7 +485,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 
 	if (args[3]) {
-		argsize = SECTOR_SIZE * args[3];
+		argsize = ATA_SECT_SIZE * args[3];
 		argbuf = kmalloc(argsize, GFP_KERNEL);
 		if (argbuf == NULL) {
 			rc = -ENOMEM;
@@ -1150,8 +1119,9 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
 		/* ATA devices must be sector aligned */
+		sdev->sector_size = ata_id_logical_sector_size(dev->id);
 		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_SECT_SIZE - 1);
+					       sdev->sector_size - 1);
 		sdev->manage_start_stop = 1;
 	}
 
@@ -1166,6 +1136,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
 
+	dev->sdev = sdev;
 	return 0;
 }
 
@@ -1696,7 +1667,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		goto nothing_to_do;
 
 	qc->flags |= ATA_QCFLAG_IO;
-	qc->nbytes = n_block * ATA_SECT_SIZE;
+	qc->nbytes = n_block * scmd->device->sector_size;
 
 	rc = ata_build_rw_tf(&qc->tf, qc->dev, block, n_block, tf_flags,
 			     qc->tag);
@@ -2001,6 +1972,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 		0x89,	/* page 0x89, ata info page */
 		0xb0,	/* page 0xb0, block limits page */
 		0xb1,	/* page 0xb1, block device characteristics page */
+		0xb2,	/* page 0xb2, thin provisioning page */
 	};
 
 	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
@@ -2123,7 +2095,7 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 
 static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 {
-	u32 min_io_sectors;
+	u16 min_io_sectors;
 
 	rbuf[1] = 0xb0;
 	rbuf[3] = 0x3c;		/* required VPD size with unmap support */
@@ -2135,10 +2107,7 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	 * logical than physical sector size we need to figure out what the
 	 * latter is.
 	 */
-	if (ata_id_has_large_logical_sectors(args->id))
-		min_io_sectors = ata_id_logical_per_physical_sectors(args->id);
-	else
-		min_io_sectors = 1;
+	min_io_sectors = 1 << ata_id_log2_per_physical_sector(args->id);
 	put_unaligned_be16(min_io_sectors, &rbuf[6]);
 
 	/*
@@ -2172,6 +2141,16 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
+{
+	/* SCSI Thin Provisioning VPD page: SBC-3 rev 22 or later */
+	rbuf[1] = 0xb2;
+	rbuf[3] = 0x4;
+	rbuf[5] = 1 << 6;	/* TPWS */
+
+	return 0;
+}
+
 /**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -2397,21 +2376,13 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_device *dev = args->dev;
 	u64 last_lba = dev->n_sectors - 1; /* LBA of the last block */
-	u8 log_per_phys = 0;
-	u16 lowest_aligned = 0;
-	u16 word_106 = dev->id[106];
-	u16 word_209 = dev->id[209];
-
-	if ((word_106 & 0xc000) == 0x4000) {
-		/* Number and offset of logical sectors per physical sector */
-		if (word_106 & (1 << 13))
-			log_per_phys = word_106 & 0xf;
-		if ((word_209 & 0xc000) == 0x4000) {
-			u16 first = dev->id[209] & 0x3fff;
-			if (first > 0)
-				lowest_aligned = (1 << log_per_phys) - first;
-		}
-	}
+	u32 sector_size; /* physical sector size in bytes */
+	u8 log2_per_phys;
+	u16 lowest_aligned;
+
+	sector_size = ata_id_logical_sector_size(dev->id);
+	log2_per_phys = ata_id_log2_per_physical_sector(dev->id);
+	lowest_aligned = ata_id_logical_sector_offset(dev->id, log2_per_phys);
 
 	VPRINTK("ENTER\n");
 
@@ -2426,8 +2397,10 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[3] = last_lba;
 
 		/* sector size */
-		rbuf[6] = ATA_SECT_SIZE >> 8;
-		rbuf[7] = ATA_SECT_SIZE & 0xff;
+		rbuf[4] = sector_size >> (8 * 3);
+		rbuf[5] = sector_size >> (8 * 2);
+		rbuf[6] = sector_size >> (8 * 1);
+		rbuf[7] = sector_size;
 	} else {
 		/* sector count, 64-bit */
 		rbuf[0] = last_lba >> (8 * 7);
@@ -2440,11 +2413,13 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[7] = last_lba;
 
 		/* sector size */
-		rbuf[10] = ATA_SECT_SIZE >> 8;
-		rbuf[11] = ATA_SECT_SIZE & 0xff;
+		rbuf[ 8] = sector_size >> (8 * 3);
+		rbuf[ 9] = sector_size >> (8 * 2);
+		rbuf[10] = sector_size >> (8 * 1);
+		rbuf[11] = sector_size;
 
 		rbuf[12] = 0;
-		rbuf[13] = log_per_phys;
+		rbuf[13] = log2_per_phys;
 		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
 		rbuf[15] = lowest_aligned;
 
@@ -2888,9 +2863,8 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	tf->device = dev->devno ?
 		tf->device | ATA_DEV1 : tf->device & ~ATA_DEV1;
 
-	/* READ/WRITE LONG use a non-standard sect_size */
-	qc->sect_size = ATA_SECT_SIZE;
 	switch (tf->command) {
+	/* READ/WRITE LONG use a non-standard sect_size */
 	case ATA_CMD_READ_LONG:
 	case ATA_CMD_READ_LONG_ONCE:
 	case ATA_CMD_WRITE_LONG:
@@ -2898,6 +2872,45 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		if (tf->protocol != ATA_PROT_PIO || tf->nsect != 1)
 			goto invalid_fld;
 		qc->sect_size = scsi_bufflen(scmd);
+		break;
+
+	/* commands using reported Logical Block size (e.g. 512 or 4K) */
+	case ATA_CMD_CFA_WRITE_NE:
+	case ATA_CMD_CFA_TRANS_SECT:
+	case ATA_CMD_CFA_WRITE_MULT_NE:
+	/* XXX: case ATA_CMD_CFA_WRITE_SECTORS_WITHOUT_ERASE: */
+	case ATA_CMD_READ:
+	case ATA_CMD_READ_EXT:
+	case ATA_CMD_READ_QUEUED:
+	/* XXX: case ATA_CMD_READ_QUEUED_EXT: */
+	case ATA_CMD_FPDMA_READ:
+	case ATA_CMD_READ_MULTI:
+	case ATA_CMD_READ_MULTI_EXT:
+	case ATA_CMD_PIO_READ:
+	case ATA_CMD_PIO_READ_EXT:
+	case ATA_CMD_READ_STREAM_DMA_EXT:
+	case ATA_CMD_READ_STREAM_EXT:
+	case ATA_CMD_VERIFY:
+	case ATA_CMD_VERIFY_EXT:
+	case ATA_CMD_WRITE:
+	case ATA_CMD_WRITE_EXT:
+	case ATA_CMD_WRITE_FUA_EXT:
+	case ATA_CMD_WRITE_QUEUED:
+	case ATA_CMD_WRITE_QUEUED_FUA_EXT:
+	case ATA_CMD_FPDMA_WRITE:
+	case ATA_CMD_WRITE_MULTI:
+	case ATA_CMD_WRITE_MULTI_EXT:
+	case ATA_CMD_WRITE_MULTI_FUA_EXT:
+	case ATA_CMD_PIO_WRITE:
+	case ATA_CMD_PIO_WRITE_EXT:
+	case ATA_CMD_WRITE_STREAM_DMA_EXT:
+	case ATA_CMD_WRITE_STREAM_EXT:
+		qc->sect_size = scmd->device->sector_size;
+		break;
+
+	/* Everything else uses 512 byte "sectors" */
+	default:
+		qc->sect_size = ATA_SECT_SIZE;
 	}
 
 	/*
@@ -3250,6 +3263,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case 0xb1:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
 			break;
+		case 0xb2:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b2);
+			break;
 		default:
 			ata_scsi_invalid_field(cmd, done);
 			break;
@@ -3334,7 +3350,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		*(struct ata_port **)&shost->hostdata[0] = ap;
 		ap->scsi_host = shost;
 
-		shost->transportt = &ata_scsi_transport_template;
+		shost->transportt = ata_scsi_transport_template;
 		shost->unique_id = ap->print_id;
 		shost->max_id = 16;
 		shost->max_lun = 1;
@@ -3393,6 +3409,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
+			} else {
+				dev->sdev = NULL;
 			}
 		}
 	}
@@ -3616,8 +3634,8 @@ void ata_scsi_hotplug(struct work_struct *work)
  *	RETURNS:
  *	Zero.
  */
-static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun)
+int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
+		       unsigned int id, unsigned int lun)
 {
 	struct ata_port *ap = ata_shost_to_port(shost);
 	unsigned long flags;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index e30c537..14d18bf 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -222,7 +222,7 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 	timeout = ata_deadline(timer_start, tmout_pat);
 	while (status != 0xff && (status & ATA_BUSY) &&
 	       time_before(jiffies, timeout)) {
-		msleep(50);
+		ata_msleep(ap, 50);
 		status = ata_sff_busy_wait(ap, ATA_BUSY, 3);
 	}
 
@@ -234,7 +234,7 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 	timeout = ata_deadline(timer_start, tmout);
 	while (status != 0xff && (status & ATA_BUSY) &&
 	       time_before(jiffies, timeout)) {
-		msleep(50);
+		ata_msleep(ap, 50);
 		status = ap->ops->sff_check_status(ap);
 	}
 
@@ -360,7 +360,7 @@ static void ata_dev_select(struct ata_port *ap, unsigned int device,
 
 	if (wait) {
 		if (can_sleep && ap->link.device[device].class == ATA_DEV_ATAPI)
-			msleep(150);
+			ata_msleep(ap, 150);
 		ata_wait_idle(ap);
 	}
 }
@@ -1356,7 +1356,7 @@ fsm_start:
 	 */
 	status = ata_sff_busy_wait(ap, ATA_BUSY, 5);
 	if (status & ATA_BUSY) {
-		msleep(2);
+		ata_msleep(ap, 2);
 		status = ata_sff_busy_wait(ap, ATA_BUSY, 10);
 		if (status & ATA_BUSY) {
 			ata_sff_queue_pio_task(link, ATA_SHORT_PAUSE);
@@ -1937,7 +1937,7 @@ int ata_sff_wait_after_reset(struct ata_link *link, unsigned int devmask,
 	unsigned int dev1 = devmask & (1 << 1);
 	int rc, ret = 0;
 
-	msleep(ATA_WAIT_AFTER_RESET);
+	ata_msleep(ap, ATA_WAIT_AFTER_RESET);
 
 	/* always check readiness of the master device */
 	rc = ata_sff_wait_ready(link, deadline);
@@ -1966,7 +1966,7 @@ int ata_sff_wait_after_reset(struct ata_link *link, unsigned int devmask,
 			lbal = ioread8(ioaddr->lbal_addr);
 			if ((nsect == 1) && (lbal == 1))
 				break;
-			msleep(50);	/* give drive a breather */
+			ata_msleep(ap, 50);	/* give drive a breather */
 		}
 
 		rc = ata_sff_wait_ready(link, deadline);
@@ -3342,7 +3342,7 @@ int __init ata_sff_init(void)
 	return 0;
 }
 
-void __exit ata_sff_exit(void)
+void ata_sff_exit(void)
 {
 	destroy_workqueue(ata_sff_wq);
 }
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
new file mode 100644
index 0000000..ce9dc62
--- /dev/null
+++ b/drivers/ata/libata-transport.c
@@ -0,0 +1,774 @@
+/*
+ *  Copyright 2008 ioogle, Inc.  All rights reserved.
+ *	Released under GPL v2.
+ *
+ * Libata transport class.
+ *
+ * The ATA transport class contains common code to deal with ATA HBAs,
+ * an approximated representation of ATA topologies in the driver model,
+ * and various sysfs attributes to expose these topologies and management
+ * interfaces to user-space.
+ *
+ * There are 3 objects defined in in this class:
+ * - ata_port
+ * - ata_link
+ * - ata_device
+ * Each port has a link object. Each link can have up to two devices for PATA
+ * and generally one for SATA.
+ * If there is SATA port multiplier [PMP], 15 additional ata_link object are
+ * created.
+ *
+ * These objects are created when the ata host is initialized and when a PMP is
+ * found. They are removed only when the HBA is removed, cleaned before the
+ * error handler runs.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <scsi/scsi_transport.h>
+#include <linux/libata.h>
+#include <linux/hdreg.h>
+#include <linux/uaccess.h>
+
+#include "libata.h"
+#include "libata-transport.h"
+
+#define ATA_PORT_ATTRS		2
+#define ATA_LINK_ATTRS		3
+#define ATA_DEV_ATTRS		9
+
+struct scsi_transport_template;
+struct scsi_transport_template *ata_scsi_transport_template;
+
+struct ata_internal {
+	struct scsi_transport_template t;
+
+	struct device_attribute private_port_attrs[ATA_PORT_ATTRS];
+	struct device_attribute private_link_attrs[ATA_LINK_ATTRS];
+	struct device_attribute private_dev_attrs[ATA_DEV_ATTRS];
+
+	struct transport_container link_attr_cont;
+	struct transport_container dev_attr_cont;
+
+	/*
+	 * The array of null terminated pointers to attributes
+	 * needed by scsi_sysfs.c
+	 */
+	struct device_attribute *link_attrs[ATA_LINK_ATTRS + 1];
+	struct device_attribute *port_attrs[ATA_PORT_ATTRS + 1];
+	struct device_attribute *dev_attrs[ATA_DEV_ATTRS + 1];
+};
+#define to_ata_internal(tmpl)	container_of(tmpl, struct ata_internal, t)
+
+
+#define tdev_to_device(d)					\
+	container_of((d), struct ata_device, tdev)
+#define transport_class_to_dev(dev)				\
+	tdev_to_device((dev)->parent)
+
+#define tdev_to_link(d)						\
+	container_of((d), struct ata_link, tdev)
+#define transport_class_to_link(dev)				\
+	tdev_to_link((dev)->parent)
+
+#define tdev_to_port(d)						\
+	container_of((d), struct ata_port, tdev)
+#define transport_class_to_port(dev)				\
+	tdev_to_port((dev)->parent)
+
+
+/* Device objects are always created whit link objects */
+static int ata_tdev_add(struct ata_device *dev);
+static void ata_tdev_delete(struct ata_device *dev);
+
+
+/*
+ * Hack to allow attributes of the same name in different objects.
+ */
+#define ATA_DEVICE_ATTR(_prefix,_name,_mode,_show,_store) \
+	struct device_attribute device_attr_##_prefix##_##_name = \
+	__ATTR(_name,_mode,_show,_store)
+
+#define ata_bitfield_name_match(title, table)			\
+static ssize_t							\
+get_ata_##title##_names(u32 table_key, char *buf)		\
+{								\
+	char *prefix = "";					\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+		if (table[i].value & table_key) {		\
+			len += sprintf(buf + len, "%s%s",	\
+				prefix, table[i].name);		\
+			prefix = ", ";				\
+		}						\
+	}							\
+	len += sprintf(buf + len, "\n");			\
+	return len;						\
+}
+
+#define ata_bitfield_name_search(title, table)			\
+static ssize_t							\
+get_ata_##title##_names(u32 table_key, char *buf)		\
+{								\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+		if (table[i].value == table_key) {		\
+			len += sprintf(buf + len, "%s",		\
+				table[i].name);			\
+			break;					\
+		}						\
+	}							\
+	len += sprintf(buf + len, "\n");			\
+	return len;						\
+}
+
+static struct {
+	u32		value;
+	char		*name;
+} ata_class_names[] = {
+	{ ATA_DEV_UNKNOWN,		"unknown" },
+	{ ATA_DEV_ATA,			"ata" },
+	{ ATA_DEV_ATA_UNSUP,		"ata" },
+	{ ATA_DEV_ATAPI,		"atapi" },
+	{ ATA_DEV_ATAPI_UNSUP,		"atapi" },
+	{ ATA_DEV_PMP,			"pmp" },
+	{ ATA_DEV_PMP_UNSUP,		"pmp" },
+	{ ATA_DEV_SEMB,			"semb" },
+	{ ATA_DEV_SEMB_UNSUP,		"semb" },
+	{ ATA_DEV_NONE,			"none" }
+};
+ata_bitfield_name_search(class, ata_class_names)
+
+
+static struct {
+	u32		value;
+	char		*name;
+} ata_err_names[] = {
+	{ AC_ERR_DEV,			"DeviceError" },
+	{ AC_ERR_HSM,			"HostStateMachineError" },
+	{ AC_ERR_TIMEOUT,		"Timeout" },
+	{ AC_ERR_MEDIA,			"MediaError" },
+	{ AC_ERR_ATA_BUS,		"BusError" },
+	{ AC_ERR_HOST_BUS,		"HostBusError" },
+	{ AC_ERR_SYSTEM,		"SystemError" },
+	{ AC_ERR_INVALID,		"InvalidArg" },
+	{ AC_ERR_OTHER,			"Unknown" },
+	{ AC_ERR_NODEV_HINT,		"NoDeviceHint" },
+	{ AC_ERR_NCQ,		 	"NCQError" }
+};
+ata_bitfield_name_match(err, ata_err_names)
+
+static struct {
+	u32		value;
+	char		*name;
+} ata_xfer_names[] = {
+	{ XFER_UDMA_7,			"XFER_UDMA_7" },
+	{ XFER_UDMA_6,			"XFER_UDMA_6" },
+	{ XFER_UDMA_5,			"XFER_UDMA_5" },
+	{ XFER_UDMA_4,			"XFER_UDMA_4" },
+	{ XFER_UDMA_3,			"XFER_UDMA_3" },
+	{ XFER_UDMA_2,			"XFER_UDMA_2" },
+	{ XFER_UDMA_1,			"XFER_UDMA_1" },
+	{ XFER_UDMA_0,			"XFER_UDMA_0" },
+	{ XFER_MW_DMA_4,		"XFER_MW_DMA_4" },
+	{ XFER_MW_DMA_3,		"XFER_MW_DMA_3" },
+	{ XFER_MW_DMA_2,		"XFER_MW_DMA_2" },
+	{ XFER_MW_DMA_1,		"XFER_MW_DMA_1" },
+	{ XFER_MW_DMA_0,		"XFER_MW_DMA_0" },
+	{ XFER_SW_DMA_2,		"XFER_SW_DMA_2" },
+	{ XFER_SW_DMA_1,		"XFER_SW_DMA_1" },
+	{ XFER_SW_DMA_0,		"XFER_SW_DMA_0" },
+	{ XFER_PIO_6,			"XFER_PIO_6" },
+	{ XFER_PIO_5,			"XFER_PIO_5" },
+	{ XFER_PIO_4,			"XFER_PIO_4" },
+	{ XFER_PIO_3,			"XFER_PIO_3" },
+	{ XFER_PIO_2,			"XFER_PIO_2" },
+	{ XFER_PIO_1,			"XFER_PIO_1" },
+	{ XFER_PIO_0,			"XFER_PIO_0" },
+	{ XFER_PIO_SLOW,		"XFER_PIO_SLOW" }
+};
+ata_bitfield_name_match(xfer,ata_xfer_names)
+
+/*
+ * ATA Port attributes
+ */
+#define ata_port_show_simple(field, name, format_string, cast)		\
+static ssize_t								\
+show_ata_port_##name(struct device *dev,				\
+		     struct device_attribute *attr, char *buf)		\
+{									\
+	struct ata_port *ap = transport_class_to_port(dev);		\
+									\
+	return snprintf(buf, 20, format_string, cast ap->field);	\
+}
+
+#define ata_port_simple_attr(field, name, format_string, type)		\
+	ata_port_show_simple(field, name, format_string, (type))	\
+static DEVICE_ATTR(name, S_IRUGO, show_ata_port_##name, NULL)
+
+ata_port_simple_attr(nr_pmp_links, nr_pmp_links, "%d\n", int);
+ata_port_simple_attr(stats.idle_irq, idle_irq, "%ld\n", unsigned long);
+
+static DECLARE_TRANSPORT_CLASS(ata_port_class,
+			       "ata_port", NULL, NULL, NULL);
+
+static void ata_tport_release(struct device *dev)
+{
+	put_device(dev->parent);
+}
+
+/**
+ * ata_is_port --  check if a struct device represents a ATA port
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a ATA Port, %0 else
+ */
+int ata_is_port(const struct device *dev)
+{
+	return dev->release == ata_tport_release;
+}
+
+static int ata_tport_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	if (!ata_is_port(dev))
+		return 0;
+	return &ata_scsi_transport_template->host_attrs.ac == cont;
+}
+
+/**
+ * ata_tport_delete  --  remove ATA PORT
+ * @port:	ATA PORT to remove
+ *
+ * Removes the specified ATA PORT.  Remove the associated link as well.
+ */
+void ata_tport_delete(struct ata_port *ap)
+{
+	struct device *dev = &ap->tdev;
+
+	ata_tlink_delete(&ap->link);
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev);
+}
+
+/** ata_tport_add - initialize a transport ATA port structure
+ *
+ * @parent:	parent device
+ * @ap:		existing ata_port structure
+ *
+ * Initialize a ATA port structure for sysfs.  It will be added to the device
+ * tree below the device specified by @parent which could be a PCI device.
+ *
+ * Returns %0 on success
+ */
+int ata_tport_add(struct device *parent,
+		  struct ata_port *ap)
+{
+	int error;
+	struct device *dev = &ap->tdev;
+
+	device_initialize(dev);
+
+	dev->parent = get_device(parent);
+	dev->release = ata_tport_release;
+	dev_set_name(dev, "ata%d", ap->print_id);
+	transport_setup_device(dev);
+	error = device_add(dev);
+	if (error) {
+		goto tport_err;
+	}
+
+	transport_add_device(dev);
+	transport_configure_device(dev);
+
+	error = ata_tlink_add(&ap->link);
+	if (error) {
+		goto tport_link_err;
+	}
+	return 0;
+
+ tport_link_err:
+	transport_remove_device(dev);
+	device_del(dev);
+
+ tport_err:
+	transport_destroy_device(dev);
+	put_device(dev);
+	return error;
+}
+
+
+/*
+ * ATA link attributes
+ */
+
+
+#define ata_link_show_linkspeed(field)					\
+static ssize_t								\
+show_ata_link_##field(struct device *dev,				\
+		      struct device_attribute *attr, char *buf)		\
+{									\
+	struct ata_link *link = transport_class_to_link(dev);		\
+									\
+	return sprintf(buf,"%s\n", sata_spd_string(fls(link->field)));	\
+}
+
+#define ata_link_linkspeed_attr(field)					\
+	ata_link_show_linkspeed(field)					\
+static DEVICE_ATTR(field, S_IRUGO, show_ata_link_##field, NULL)
+
+ata_link_linkspeed_attr(hw_sata_spd_limit);
+ata_link_linkspeed_attr(sata_spd_limit);
+ata_link_linkspeed_attr(sata_spd);
+
+
+static DECLARE_TRANSPORT_CLASS(ata_link_class,
+		"ata_link", NULL, NULL, NULL);
+
+static void ata_tlink_release(struct device *dev)
+{
+	put_device(dev->parent);
+}
+
+/**
+ * ata_is_link --  check if a struct device represents a ATA link
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a ATA link, %0 else
+ */
+int ata_is_link(const struct device *dev)
+{
+	return dev->release == ata_tlink_release;
+}
+
+static int ata_tlink_match(struct attribute_container *cont,
+			   struct device *dev)
+{
+	struct ata_internal* i = to_ata_internal(ata_scsi_transport_template);
+	if (!ata_is_link(dev))
+		return 0;
+	return &i->link_attr_cont.ac == cont;
+}
+
+/**
+ * ata_tlink_delete  --  remove ATA LINK
+ * @port:	ATA LINK to remove
+ *
+ * Removes the specified ATA LINK.  remove associated ATA device(s) as well.
+ */
+void ata_tlink_delete(struct ata_link *link)
+{
+	struct device *dev = &link->tdev;
+	struct ata_device *ata_dev;
+
+	ata_for_each_dev(ata_dev, link, ALL) {
+		ata_tdev_delete(ata_dev);
+	}
+
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
+	put_device(dev);
+}
+
+/**
+ * ata_tlink_add  --  initialize a transport ATA link structure
+ * @link:	allocated ata_link structure.
+ *
+ * Initialize an ATA LINK structure for sysfs.  It will be added in the
+ * device tree below the ATA PORT it belongs to.
+ *
+ * Returns %0 on success
+ */
+int ata_tlink_add(struct ata_link *link)
+{
+	struct device *dev = &link->tdev;
+	struct ata_port *ap = link->ap;
+	struct ata_device *ata_dev;
+	int error;
+
+	device_initialize(dev);
+	dev->parent = get_device(&ap->tdev);
+	dev->release = ata_tlink_release;
+	if (ata_is_host_link(link))
+		dev_set_name(dev, "link%d", ap->print_id);
+        else
+		dev_set_name(dev, "link%d.%d", ap->print_id, link->pmp);
+
+	transport_setup_device(dev);
+
+	error = device_add(dev);
+	if (error) {
+		goto tlink_err;
+	}
+
+	transport_add_device(dev);
+	transport_configure_device(dev);
+
+	ata_for_each_dev(ata_dev, link, ALL) {
+		error = ata_tdev_add(ata_dev);
+		if (error) {
+			goto tlink_dev_err;
+		}
+	}
+	return 0;
+  tlink_dev_err:
+	while (--ata_dev >= link->device) {
+		ata_tdev_delete(ata_dev);
+	}
+	transport_remove_device(dev);
+	device_del(dev);
+  tlink_err:
+	transport_destroy_device(dev);
+	put_device(dev);
+	return error;
+}
+
+/*
+ * ATA device attributes
+ */
+
+#define ata_dev_show_class(title, field)				\
+static ssize_t								\
+show_ata_dev_##field(struct device *dev,				\
+		     struct device_attribute *attr, char *buf)		\
+{									\
+	struct ata_device *ata_dev = transport_class_to_dev(dev);	\
+									\
+	return get_ata_##title##_names(ata_dev->field, buf);		\
+}
+
+#define ata_dev_attr(title, field)					\
+	ata_dev_show_class(title, field)				\
+static DEVICE_ATTR(field, S_IRUGO, show_ata_dev_##field, NULL)
+
+ata_dev_attr(class, class);
+ata_dev_attr(xfer, pio_mode);
+ata_dev_attr(xfer, dma_mode);
+ata_dev_attr(xfer, xfer_mode);
+
+
+#define ata_dev_show_simple(field, format_string, cast)		\
+static ssize_t								\
+show_ata_dev_##field(struct device *dev,				\
+		     struct device_attribute *attr, char *buf)		\
+{									\
+	struct ata_device *ata_dev = transport_class_to_dev(dev);	\
+									\
+	return snprintf(buf, 20, format_string, cast ata_dev->field);	\
+}
+
+#define ata_dev_simple_attr(field, format_string, type)	\
+	ata_dev_show_simple(field, format_string, (type))	\
+static DEVICE_ATTR(field, S_IRUGO, 			\
+		   show_ata_dev_##field, NULL)
+
+ata_dev_simple_attr(spdn_cnt, "%d\n", int);
+
+struct ata_show_ering_arg {
+	char* buf;
+	int written;
+};
+
+static int ata_show_ering(struct ata_ering_entry *ent, void *void_arg)
+{
+	struct ata_show_ering_arg* arg = void_arg;
+	struct timespec time;
+
+	jiffies_to_timespec(ent->timestamp,&time);
+	arg->written += sprintf(arg->buf + arg->written,
+			       "[%5lu.%06lu]",
+			       time.tv_sec, time.tv_nsec);
+	arg->written += get_ata_err_names(ent->err_mask,
+					  arg->buf + arg->written);
+	return 0;
+}
+
+static ssize_t
+show_ata_dev_ering(struct device *dev,
+		   struct device_attribute *attr, char *buf)
+{
+	struct ata_device *ata_dev = transport_class_to_dev(dev);
+	struct ata_show_ering_arg arg = { buf, 0 };
+
+	ata_ering_map(&ata_dev->ering, ata_show_ering, &arg);
+	return arg.written;
+}
+
+
+static DEVICE_ATTR(ering, S_IRUGO, show_ata_dev_ering, NULL);
+
+static ssize_t
+show_ata_dev_id(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ata_device *ata_dev = transport_class_to_dev(dev);
+	int written = 0, i = 0;
+
+	if (ata_dev->class == ATA_DEV_PMP)
+		return 0;
+	for(i=0;i<ATA_ID_WORDS;i++)  {
+		written += snprintf(buf+written, 20, "%04x%c",
+				    ata_dev->id[i],
+				    ((i+1) & 7) ? ' ' : '\n');
+	}
+	return written;
+}
+
+static DEVICE_ATTR(id, S_IRUGO, show_ata_dev_id, NULL);
+
+static ssize_t
+show_ata_dev_gscr(struct device *dev,
+		  struct device_attribute *attr, char *buf)
+{
+	struct ata_device *ata_dev = transport_class_to_dev(dev);
+	int written = 0, i = 0;
+
+	if (ata_dev->class != ATA_DEV_PMP)
+		return 0;
+	for(i=0;i<SATA_PMP_GSCR_DWORDS;i++)  {
+		written += snprintf(buf+written, 20, "%08x%c",
+				    ata_dev->gscr[i],
+				    ((i+1) & 3) ? ' ' : '\n');
+	}
+	if (SATA_PMP_GSCR_DWORDS & 3)
+		buf[written-1] = '\n';
+	return written;
+}
+
+static DEVICE_ATTR(gscr, S_IRUGO, show_ata_dev_gscr, NULL);
+
+static DECLARE_TRANSPORT_CLASS(ata_dev_class,
+			       "ata_device", NULL, NULL, NULL);
+
+static void ata_tdev_release(struct device *dev)
+{
+	put_device(dev->parent);
+}
+
+/**
+ * ata_is_ata_dev  --  check if a struct device represents a ATA device
+ * @dev:	device to check
+ *
+ * Returns:
+ *	%1 if the device represents a ATA device, %0 else
+ */
+int ata_is_ata_dev(const struct device *dev)
+{
+	return dev->release == ata_tdev_release;
+}
+
+static int ata_tdev_match(struct attribute_container *cont,
+			  struct device *dev)
+{
+	struct ata_internal* i = to_ata_internal(ata_scsi_transport_template);
+	if (!ata_is_ata_dev(dev))
+		return 0;
+	return &i->dev_attr_cont.ac == cont;
+}
+
+/**
+ * ata_tdev_free  --  free a ATA LINK
+ * @dev:	ATA PHY to free
+ *
+ * Frees the specified ATA PHY.
+ *
+ * Note:
+ *   This function must only be called on a PHY that has not
+ *   successfully been added using ata_tdev_add().
+ */
+static void ata_tdev_free(struct ata_device *dev)
+{
+	transport_destroy_device(&dev->tdev);
+	put_device(&dev->tdev);
+}
+
+/**
+ * ata_tdev_delete  --  remove ATA device
+ * @port:	ATA PORT to remove
+ *
+ * Removes the specified ATA device.
+ */
+static void ata_tdev_delete(struct ata_device *ata_dev)
+{
+	struct device *dev = &ata_dev->tdev;
+
+	transport_remove_device(dev);
+	device_del(dev);
+	ata_tdev_free(ata_dev);
+}
+
+
+/**
+ * ata_tdev_add  --  initialize a transport ATA device structure.
+ * @ata_dev:	ata_dev structure.
+ *
+ * Initialize an ATA device structure for sysfs.  It will be added in the
+ * device tree below the ATA LINK device it belongs to.
+ *
+ * Returns %0 on success
+ */
+static int ata_tdev_add(struct ata_device *ata_dev)
+{
+	struct device *dev = &ata_dev->tdev;
+	struct ata_link *link = ata_dev->link;
+	struct ata_port *ap = link->ap;
+	int error;
+
+	device_initialize(dev);
+	dev->parent = get_device(&link->tdev);
+	dev->release = ata_tdev_release;
+	if (ata_is_host_link(link))
+		dev_set_name(dev, "dev%d.%d", ap->print_id,ata_dev->devno);
+        else
+		dev_set_name(dev, "dev%d.%d.0", ap->print_id, link->pmp);
+
+	transport_setup_device(dev);
+	error = device_add(dev);
+	if (error) {
+		ata_tdev_free(ata_dev);
+		return error;
+	}
+
+	transport_add_device(dev);
+	transport_configure_device(dev);
+	return 0;
+}
+
+
+/*
+ * Setup / Teardown code
+ */
+
+#define SETUP_TEMPLATE(attrb, field, perm, test)			\
+	i->private_##attrb[count] = dev_attr_##field;		       	\
+	i->private_##attrb[count].attr.mode = perm;			\
+	i->attrb[count] = &i->private_##attrb[count];			\
+	if (test)							\
+		count++
+
+#define SETUP_LINK_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(link_attrs, field, S_IRUGO, 1)
+
+#define SETUP_PORT_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(port_attrs, field, S_IRUGO, 1)
+
+#define SETUP_DEV_ATTRIBUTE(field)					\
+	SETUP_TEMPLATE(dev_attrs, field, S_IRUGO, 1)
+
+/**
+ * ata_attach_transport  --  instantiate ATA transport template
+ */
+struct scsi_transport_template *ata_attach_transport(void)
+{
+	struct ata_internal *i;
+	int count;
+
+	i = kzalloc(sizeof(struct ata_internal), GFP_KERNEL);
+	if (!i)
+		return NULL;
+
+	i->t.eh_strategy_handler	= ata_scsi_error;
+	i->t.eh_timed_out		= ata_scsi_timed_out;
+	i->t.user_scan			= ata_scsi_user_scan;
+
+	i->t.host_attrs.ac.attrs = &i->port_attrs[0];
+	i->t.host_attrs.ac.class = &ata_port_class.class;
+	i->t.host_attrs.ac.match = ata_tport_match;
+	transport_container_register(&i->t.host_attrs);
+
+	i->link_attr_cont.ac.class = &ata_link_class.class;
+	i->link_attr_cont.ac.attrs = &i->link_attrs[0];
+	i->link_attr_cont.ac.match = ata_tlink_match;
+	transport_container_register(&i->link_attr_cont);
+
+	i->dev_attr_cont.ac.class = &ata_dev_class.class;
+	i->dev_attr_cont.ac.attrs = &i->dev_attrs[0];
+	i->dev_attr_cont.ac.match = ata_tdev_match;
+	transport_container_register(&i->dev_attr_cont);
+
+	count = 0;
+	SETUP_PORT_ATTRIBUTE(nr_pmp_links);
+	SETUP_PORT_ATTRIBUTE(idle_irq);
+	BUG_ON(count > ATA_PORT_ATTRS);
+	i->port_attrs[count] = NULL;
+
+	count = 0;
+	SETUP_LINK_ATTRIBUTE(hw_sata_spd_limit);
+	SETUP_LINK_ATTRIBUTE(sata_spd_limit);
+	SETUP_LINK_ATTRIBUTE(sata_spd);
+	BUG_ON(count > ATA_LINK_ATTRS);
+	i->link_attrs[count] = NULL;
+
+	count = 0;
+	SETUP_DEV_ATTRIBUTE(class);
+	SETUP_DEV_ATTRIBUTE(pio_mode);
+	SETUP_DEV_ATTRIBUTE(dma_mode);
+	SETUP_DEV_ATTRIBUTE(xfer_mode);
+	SETUP_DEV_ATTRIBUTE(spdn_cnt);
+	SETUP_DEV_ATTRIBUTE(ering);
+	SETUP_DEV_ATTRIBUTE(id);
+	SETUP_DEV_ATTRIBUTE(gscr);
+	BUG_ON(count > ATA_DEV_ATTRS);
+	i->dev_attrs[count] = NULL;
+
+	return &i->t;
+}
+
+/**
+ * ata_release_transport  --  release ATA transport template instance
+ * @t:		transport template instance
+ */
+void ata_release_transport(struct scsi_transport_template *t)
+{
+	struct ata_internal *i = to_ata_internal(t);
+
+	transport_container_unregister(&i->t.host_attrs);
+	transport_container_unregister(&i->link_attr_cont);
+	transport_container_unregister(&i->dev_attr_cont);
+
+	kfree(i);
+}
+
+__init int libata_transport_init(void)
+{
+	int error;
+
+	error = transport_class_register(&ata_link_class);
+	if (error)
+		goto out_unregister_transport;
+	error = transport_class_register(&ata_port_class);
+	if (error)
+		goto out_unregister_link;
+	error = transport_class_register(&ata_dev_class);
+	if (error)
+		goto out_unregister_port;
+	return 0;
+
+ out_unregister_port:
+	transport_class_unregister(&ata_port_class);
+ out_unregister_link:
+	transport_class_unregister(&ata_link_class);
+ out_unregister_transport:
+	return error;
+
+}
+
+void __exit libata_transport_exit(void)
+{
+	transport_class_unregister(&ata_link_class);
+	transport_class_unregister(&ata_port_class);
+	transport_class_unregister(&ata_dev_class);
+}
diff --git a/drivers/ata/libata-transport.h b/drivers/ata/libata-transport.h
new file mode 100644
index 0000000..2820cf8
--- /dev/null
+++ b/drivers/ata/libata-transport.h
@@ -0,0 +1,18 @@
+#ifndef _LIBATA_TRANSPORT_H
+#define _LIBATA_TRANSPORT_H
+
+
+extern struct scsi_transport_template *ata_scsi_transport_template;
+
+int ata_tlink_add(struct ata_link *link);
+void ata_tlink_delete(struct ata_link *link);
+
+int ata_tport_add(struct device *parent, struct ata_port *ap);
+void ata_tport_delete(struct ata_port *ap);
+
+struct scsi_transport_template *ata_attach_transport(void);
+void ata_release_transport(struct scsi_transport_template *t);
+
+__init int libata_transport_init(void);
+void __exit libata_transport_exit(void);
+#endif
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 9ce1ecc..a9be110 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -86,6 +86,8 @@ extern int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_link *link, u32 spd_limit);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
+extern unsigned int ata_dev_set_feature(struct ata_device *dev,
+					u8 enable, u8 feature);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
 extern void ata_qc_free(struct ata_queued_cmd *qc);
 extern void ata_qc_issue(struct ata_queued_cmd *qc);
@@ -100,8 +102,7 @@ extern int sata_link_init_spd(struct ata_link *link);
 extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
-extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
-extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
+extern const char *sata_spd_string(unsigned int spd);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
@@ -137,10 +138,15 @@ extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
+extern int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
+			      unsigned int id, unsigned int lun);
+
 
 /* libata-eh.c */
 extern unsigned long ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
 extern void ata_internal_cmd_timed_out(struct ata_device *dev, u8 cmd);
+extern void ata_eh_acquire(struct ata_port *ap);
+extern void ata_eh_release(struct ata_port *ap);
 extern enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern void ata_scsi_error(struct Scsi_Host *host);
 extern void ata_port_wait_eh(struct ata_port *ap);
@@ -164,11 +170,16 @@ extern int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			  ata_postreset_fn_t postreset,
 			  struct ata_link **r_failed_disk);
 extern void ata_eh_finish(struct ata_port *ap);
+extern int ata_ering_map(struct ata_ering *ering,
+			 int (*map_fn)(struct ata_ering_entry *, void *),
+		  	 void *arg);
 
 /* libata-pmp.c */
 #ifdef CONFIG_SATA_PMP
 extern int sata_pmp_scr_read(struct ata_link *link, int reg, u32 *val);
 extern int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val);
+extern int sata_pmp_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+			    unsigned hints);
 extern int sata_pmp_attach(struct ata_device *dev);
 #else /* CONFIG_SATA_PMP */
 static inline int sata_pmp_scr_read(struct ata_link *link, int reg, u32 *val)
@@ -181,6 +192,12 @@ static inline int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val)
 	return -EINVAL;
 }
 
+static inline int sata_pmp_set_lpm(struct ata_link *link,
+				   enum ata_lpm_policy policy, unsigned hints)
+{
+	return -EINVAL;
+}
+
 static inline int sata_pmp_attach(struct ata_device *dev)
 {
 	return -EINVAL;
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 9cae65d..ec2c777 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -826,7 +826,7 @@ static void bfin_dev_select(struct ata_port *ap, unsigned int device)
  *	@ctl: value to write
  */
 
-static u8 bfin_set_devctl(struct ata_port *ap, u8 ctl)
+static void bfin_set_devctl(struct ata_port *ap, u8 ctl)
 {
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 	write_atapi_register(base, ATA_REG_CTRL, ctl);
@@ -1046,7 +1046,7 @@ static void bfin_bus_post_reset(struct ata_port *ap, unsigned int devmask)
 			dev1 = 0;
 			break;
 		}
-		msleep(50);	/* give drive a breather */
+		ata_msleep(ap, 50);	/* give drive a breather */
 	}
 	if (dev1)
 		ata_sff_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
@@ -1087,7 +1087,7 @@ static unsigned int bfin_bus_softreset(struct ata_port *ap,
 	 *
 	 * Old drivers/ide uses the 2mS rule and then waits for ready
 	 */
-	msleep(150);
+	ata_msleep(ap, 150);
 
 	/* Before we perform post reset processing we want to see if
 	 * the bus shows 0xFF because the odd clown forgets the D7
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index e5f289f..549d28d 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -161,6 +161,17 @@ static int cmd640_port_start(struct ata_port *ap)
 	return 0;
 }
 
+static bool cmd640_sff_irq_check(struct ata_port *ap)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	int irq_reg		= ap->port_no ? ARTIM23 : CFR;
+	u8  irq_stat, irq_mask	= ap->port_no ? 0x10 : 0x04;
+
+	pci_read_config_byte(pdev, irq_reg, &irq_stat);
+
+	return irq_stat & irq_mask;
+}
+
 static struct scsi_host_template cmd640_sht = {
 	ATA_PIO_SHT(DRV_NAME),
 };
@@ -169,6 +180,7 @@ static struct ata_port_operations cmd640_port_ops = {
 	.inherits	= &ata_sff_port_ops,
 	/* In theory xfer_noirq is not needed once we kill the prefetcher */
 	.sff_data_xfer	= ata_sff_data_xfer_noirq,
+	.sff_irq_check	= cmd640_sff_irq_check,
 	.qc_issue	= cmd640_qc_issue,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= cmd640_set_piomode,
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index c39f213..c2ed586 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -44,6 +44,27 @@ static void pdc202xx_exec_command(struct ata_port *ap,
 	ndelay(400);
 }
 
+static bool pdc202xx_irq_check(struct ata_port *ap)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	unsigned long master	= pci_resource_start(pdev, 4);
+	u8 sc1d			= inb(master + 0x1d);
+
+	if (ap->port_no) {
+		/*
+		 * bit 7: error, bit 6: interrupting,
+		 * bit 5: FIFO full, bit 4: FIFO empty
+		 */
+		return sc1d & 0x40;
+	} else	{
+		/*
+		 * bit 3: error, bit 2: interrupting,
+		 * bit 1: FIFO full, bit 0: FIFO empty
+		 */
+		return sc1d & 0x04;
+	}
+}
+
 /**
  *	pdc202xx_configure_piomode	-	set chip PIO timing
  *	@ap: ATA interface
@@ -282,6 +303,7 @@ static struct ata_port_operations pdc2024x_port_ops = {
 	.set_dmamode		= pdc202xx_set_dmamode,
 
 	.sff_exec_command	= pdc202xx_exec_command,
+	.sff_irq_check		= pdc202xx_irq_check,
 };
 
 static struct ata_port_operations pdc2026x_port_ops = {
@@ -297,6 +319,7 @@ static struct ata_port_operations pdc2026x_port_ops = {
 	.port_start		= pdc2026x_port_start,
 
 	.sff_exec_command	= pdc202xx_exec_command,
+	.sff_irq_check		= pdc202xx_irq_check,
 };
 
 static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index 6f9cfb2..8a51d67 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -322,7 +322,7 @@ static int pata_s3c_wait_after_reset(struct ata_link *link,
 {
 	int rc;
 
-	msleep(ATA_WAIT_AFTER_RESET);
+	ata_msleep(link->ap, ATA_WAIT_AFTER_RESET);
 
 	/* always check readiness of the master device */
 	rc = ata_sff_wait_ready(link, deadline);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index fe36966..093715c 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -530,7 +530,7 @@ static int scc_wait_after_reset(struct ata_link *link, unsigned int devmask,
 	 *
 	 * Old drivers/ide uses the 2mS rule and then waits for ready.
 	 */
-	msleep(150);
+	ata_msleep(ap, 150);
 
 	/* always check readiness of the master device */
 	rc = ata_sff_wait_ready(link, deadline);
@@ -559,7 +559,7 @@ static int scc_wait_after_reset(struct ata_link *link, unsigned int devmask,
 			lbal = in_be32(ioaddr->lbal_addr);
 			if ((nsect == 1) && (lbal == 1))
 				break;
-			msleep(50);	/* give drive a breather */
+			ata_msleep(ap, 50);	/* give drive a breather */
 		}
 
 		rc = ata_sff_wait_ready(link, deadline);
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index d3190d7..00eefbd 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -202,14 +202,25 @@ static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-void sil680_sff_exec_command(struct ata_port *ap,
-					const struct ata_taskfile *tf)
+static void sil680_sff_exec_command(struct ata_port *ap,
+				    const struct ata_taskfile *tf)
 {
 	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
 	iowrite8(tf->command, ap->ioaddr.command_addr);
 	ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
 }
 
+static bool sil680_sff_irq_check(struct ata_port *ap)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	unsigned long addr	= sil680_selreg(ap, 1);
+	u8 val;
+
+	pci_read_config_byte(pdev, addr, &val);
+
+	return val & 0x08;
+}
+
 static struct scsi_host_template sil680_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -218,6 +229,7 @@ static struct scsi_host_template sil680_sht = {
 static struct ata_port_operations sil680_port_ops = {
 	.inherits		= &ata_bmdma32_port_ops,
 	.sff_exec_command	= sil680_sff_exec_command,
+	.sff_irq_check		= sil680_sff_irq_check,
 	.cable_detect		= sil680_cable_detect,
 	.set_piomode		= sil680_set_piomode,
 	.set_dmamode		= sil680_set_dmamode,
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 98548f6..7f5d020 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -227,6 +227,16 @@ static int sl82c105_qc_defer(struct ata_queued_cmd *qc)
 	return 0;
 }
 
+static bool sl82c105_sff_irq_check(struct ata_port *ap)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	u32 val, mask		= ap->port_no ? CTRL_IDE_IRQB : CTRL_IDE_IRQA;
+
+	pci_read_config_dword(pdev, 0x40, &val);
+
+	return val & mask;
+}
+
 static struct scsi_host_template sl82c105_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -239,6 +249,7 @@ static struct ata_port_operations sl82c105_port_ops = {
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= sl82c105_set_piomode,
 	.prereset	= sl82c105_pre_reset,
+	.sff_irq_check	= sl82c105_sff_irq_check,
 };
 
 /**
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 7325f77..b0214d0 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -678,7 +678,7 @@ static void sata_fsl_port_stop(struct ata_port *ap)
 	iowrite32(temp, hcr_base + HCONTROL);
 
 	/* Poll for controller to go offline - should happen immediately */
-	ata_wait_register(hcr_base + HSTATUS, ONLINE, ONLINE, 1, 1);
+	ata_wait_register(ap, hcr_base + HSTATUS, ONLINE, ONLINE, 1, 1);
 
 	ap->private_data = NULL;
 	dma_free_coherent(dev, SATA_FSL_PORT_PRIV_DMA_SZ,
@@ -729,7 +729,8 @@ try_offline_again:
 	iowrite32(temp, hcr_base + HCONTROL);
 
 	/* Poll for controller to go offline */
-	temp = ata_wait_register(hcr_base + HSTATUS, ONLINE, ONLINE, 1, 500);
+	temp = ata_wait_register(ap, hcr_base + HSTATUS, ONLINE, ONLINE,
+				 1, 500);
 
 	if (temp & ONLINE) {
 		ata_port_printk(ap, KERN_ERR,
@@ -752,7 +753,7 @@ try_offline_again:
 	/*
 	 * PHY reset should remain asserted for atleast 1ms
 	 */
-	msleep(1);
+	ata_msleep(ap, 1);
 
 	/*
 	 * Now, bring the host controller online again, this can take time
@@ -766,7 +767,7 @@ try_offline_again:
 	temp |= HCONTROL_PMP_ATTACHED;
 	iowrite32(temp, hcr_base + HCONTROL);
 
-	temp = ata_wait_register(hcr_base + HSTATUS, ONLINE, 0, 1, 500);
+	temp = ata_wait_register(ap, hcr_base + HSTATUS, ONLINE, 0, 1, 500);
 
 	if (!(temp & ONLINE)) {
 		ata_port_printk(ap, KERN_ERR,
@@ -784,7 +785,7 @@ try_offline_again:
 	 * presence
 	 */
 
-	temp = ata_wait_register(hcr_base + HSTATUS, 0xFF, 0, 1, 500);
+	temp = ata_wait_register(ap, hcr_base + HSTATUS, 0xFF, 0, 1, 500);
 	if ((!(temp & 0x10)) || ata_link_offline(link)) {
 		ata_port_printk(ap, KERN_WARNING,
 				"No Device OR PHYRDY change,Hstatus = 0x%x\n",
@@ -797,7 +798,7 @@ try_offline_again:
 	 * Wait for the first D2H from device,i.e,signature update notification
 	 */
 	start_jiffies = jiffies;
-	temp = ata_wait_register(hcr_base + HSTATUS, 0xFF, 0x10,
+	temp = ata_wait_register(ap, hcr_base + HSTATUS, 0xFF, 0x10,
 			500, jiffies_to_msecs(deadline - start_jiffies));
 
 	if ((temp & 0xFF) != 0x18) {
@@ -880,7 +881,7 @@ static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
 		iowrite32(pmp, CQPMP + hcr_base);
 	iowrite32(1, CQ + hcr_base);
 
-	temp = ata_wait_register(CQ + hcr_base, 0x1, 0x1, 1, 5000);
+	temp = ata_wait_register(ap, CQ + hcr_base, 0x1, 0x1, 1, 5000);
 	if (temp & 0x1) {
 		ata_port_printk(ap, KERN_WARNING, "ATA_SRST issue failed\n");
 
@@ -896,7 +897,7 @@ static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
 		goto err;
 	}
 
-	msleep(1);
+	ata_msleep(ap, 1);
 
 	/*
 	 * SATA device enters reset state after receving a Control register
@@ -915,7 +916,7 @@ static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
 	if (pmp != SATA_PMP_CTRL_PORT)
 		iowrite32(pmp, CQPMP + hcr_base);
 	iowrite32(1, CQ + hcr_base);
-	msleep(150);		/* ?? */
+	ata_msleep(ap, 150);		/* ?? */
 
 	/*
 	 * The above command would have signalled an interrupt on command
@@ -1137,17 +1138,13 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 			ioread32(hcr_base + CE));
 
 		for (i = 0; i < SATA_FSL_QUEUE_DEPTH; i++) {
-			if (done_mask & (1 << i)) {
-				qc = ata_qc_from_tag(ap, i);
-				if (qc) {
-					ata_qc_complete(qc);
-				}
+			if (done_mask & (1 << i))
 				DPRINTK
 				    ("completing ncq cmd,tag=%d,CC=0x%x,CA=0x%x\n",
 				     i, ioread32(hcr_base + CC),
 				     ioread32(hcr_base + CA));
-			}
 		}
+		ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
 		return;
 
 	} else if ((ap->qc_active & (1 << ATA_TAG_INTERNAL))) {
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index a36149e..83a4447 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -614,7 +614,7 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 
 	writew(IDMA_CTL_RST_ATA, idma_ctl);
 	readw(idma_ctl);	/* flush */
-	msleep(1);
+	ata_msleep(ap, 1);
 	writew(0, idma_ctl);
 
 	rc = sata_link_resume(link, timing, deadline);
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index a9fd970..bf74a36 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2743,18 +2743,11 @@ static void mv_err_intr(struct ata_port *ap)
 	}
 }
 
-static void mv_process_crpb_response(struct ata_port *ap,
+static bool mv_process_crpb_response(struct ata_port *ap,
 		struct mv_crpb *response, unsigned int tag, int ncq_enabled)
 {
 	u8 ata_status;
 	u16 edma_status = le16_to_cpu(response->flags);
-	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, tag);
-
-	if (unlikely(!qc)) {
-		ata_port_printk(ap, KERN_ERR, "%s: no qc for tag=%d\n",
-				__func__, tag);
-		return;
-	}
 
 	/*
 	 * edma_status from a response queue entry:
@@ -2768,13 +2761,14 @@ static void mv_process_crpb_response(struct ata_port *ap,
 			 * Error will be seen/handled by
 			 * mv_err_intr().  So do nothing at all here.
 			 */
-			return;
+			return false;
 		}
 	}
 	ata_status = edma_status >> CRPB_FLAG_STATUS_SHIFT;
 	if (!ac_err_mask(ata_status))
-		ata_qc_complete(qc);
+		return true;
 	/* else: leave it for mv_err_intr() */
+	return false;
 }
 
 static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp)
@@ -2783,6 +2777,7 @@ static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	u32 in_index;
 	bool work_done = false;
+	u32 done_mask = 0;
 	int ncq_enabled = (pp->pp_flags & MV_PP_FLAG_NCQ_EN);
 
 	/* Get the hardware queue position index */
@@ -2803,15 +2798,19 @@ static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp
 			/* Gen II/IIE: get command tag from CRPB entry */
 			tag = le16_to_cpu(response->id) & 0x1f;
 		}
-		mv_process_crpb_response(ap, response, tag, ncq_enabled);
+		if (mv_process_crpb_response(ap, response, tag, ncq_enabled))
+			done_mask |= 1 << tag;
 		work_done = true;
 	}
 
-	/* Update the software queue position index in hardware */
-	if (work_done)
+	if (work_done) {
+		ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
+
+		/* Update the software queue position index in hardware */
 		writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) |
 			 (pp->resp_idx << EDMA_RSP_Q_PTR_SHIFT),
 			 port_mmio + EDMA_RSP_Q_OUT_PTR);
+	}
 }
 
 static void mv_port_intr(struct ata_port *ap, u32 port_cause)
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index cb89ef8..7254e25 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -873,29 +873,11 @@ static int nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
 			ata_port_freeze(ap);
 		else
 			ata_port_abort(ap);
-		return 1;
+		return -1;
 	}
 
-	if (likely(flags & NV_CPB_RESP_DONE)) {
-		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, cpb_num);
-		VPRINTK("CPB flags done, flags=0x%x\n", flags);
-		if (likely(qc)) {
-			DPRINTK("Completing qc from tag %d\n", cpb_num);
-			ata_qc_complete(qc);
-		} else {
-			struct ata_eh_info *ehi = &ap->link.eh_info;
-			/* Notifier bits set without a command may indicate the drive
-			   is misbehaving. Raise host state machine violation on this
-			   condition. */
-			ata_port_printk(ap, KERN_ERR,
-					"notifier for tag %d with no cmd?\n",
-					cpb_num);
-			ehi->err_mask |= AC_ERR_HSM;
-			ehi->action |= ATA_EH_RESET;
-			ata_port_freeze(ap);
-			return 1;
-		}
-	}
+	if (likely(flags & NV_CPB_RESP_DONE))
+		return 1;
 	return 0;
 }
 
@@ -1018,6 +1000,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			      NV_ADMA_STAT_CPBERR |
 			      NV_ADMA_STAT_CMD_COMPLETE)) {
 			u32 check_commands = notifier_clears[i];
+			u32 done_mask = 0;
 			int pos, rc;
 
 			if (status & NV_ADMA_STAT_CPBERR) {
@@ -1034,10 +1017,13 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 				pos--;
 				rc = nv_adma_check_cpb(ap, pos,
 						notifier_error & (1 << pos));
-				if (unlikely(rc))
+				if (rc > 0)
+					done_mask |= 1 << pos;
+				else if (unlikely(rc < 0))
 					check_commands = 0;
 				check_commands &= ~(1 << pos);
 			}
+			ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
 		}
 	}
 
@@ -2132,7 +2118,6 @@ static int nv_swncq_sdbfis(struct ata_port *ap)
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u32 sactive;
 	u32 done_mask;
-	int i;
 	u8 host_stat;
 	u8 lack_dhfis = 0;
 
@@ -2152,27 +2137,11 @@ static int nv_swncq_sdbfis(struct ata_port *ap)
 	sactive = readl(pp->sactive_block);
 	done_mask = pp->qc_active ^ sactive;
 
-	if (unlikely(done_mask & sactive)) {
-		ata_ehi_clear_desc(ehi);
-		ata_ehi_push_desc(ehi, "illegal SWNCQ:qc_active transition"
-				  "(%08x->%08x)", pp->qc_active, sactive);
-		ehi->err_mask |= AC_ERR_HSM;
-		ehi->action |= ATA_EH_RESET;
-		return -EINVAL;
-	}
-	for (i = 0; i < ATA_MAX_QUEUE; i++) {
-		if (!(done_mask & (1 << i)))
-			continue;
-
-		qc = ata_qc_from_tag(ap, i);
-		if (qc) {
-			ata_qc_complete(qc);
-			pp->qc_active &= ~(1 << i);
-			pp->dhfis_bits &= ~(1 << i);
-			pp->dmafis_bits &= ~(1 << i);
-			pp->sdbfis_bits |= (1 << i);
-		}
-	}
+	pp->qc_active &= ~done_mask;
+	pp->dhfis_bits &= ~done_mask;
+	pp->dmafis_bits &= ~done_mask;
+	pp->sdbfis_bits |= done_mask;
+	ata_qc_complete_multiple(ap, ap->qc_active ^ done_mask);
 
 	if (!ap->qc_active) {
 		DPRINTK("over\n");
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index be7726d..af41c6f 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -589,9 +589,9 @@ static int sil24_init_port(struct ata_port *ap)
 		sil24_clear_pmp(ap);
 
 	writel(PORT_CS_INIT, port + PORT_CTRL_STAT);
-	ata_wait_register(port + PORT_CTRL_STAT,
+	ata_wait_register(ap, port + PORT_CTRL_STAT,
 			  PORT_CS_INIT, PORT_CS_INIT, 10, 100);
-	tmp = ata_wait_register(port + PORT_CTRL_STAT,
+	tmp = ata_wait_register(ap, port + PORT_CTRL_STAT,
 				PORT_CS_RDY, 0, 10, 100);
 
 	if ((tmp & (PORT_CS_INIT | PORT_CS_RDY)) != PORT_CS_RDY) {
@@ -631,7 +631,7 @@ static int sil24_exec_polled_cmd(struct ata_port *ap, int pmp,
 	writel((u64)paddr >> 32, port + PORT_CMD_ACTIVATE + 4);
 
 	irq_mask = (PORT_IRQ_COMPLETE | PORT_IRQ_ERROR) << PORT_IRQ_RAW_SHIFT;
-	irq_stat = ata_wait_register(port + PORT_IRQ_STAT, irq_mask, 0x0,
+	irq_stat = ata_wait_register(ap, port + PORT_IRQ_STAT, irq_mask, 0x0,
 				     10, timeout_msec);
 
 	writel(irq_mask, port + PORT_IRQ_STAT); /* clear IRQs */
@@ -719,9 +719,9 @@ static int sil24_hardreset(struct ata_link *link, unsigned int *class,
 				"state, performing PORT_RST\n");
 
 		writel(PORT_CS_PORT_RST, port + PORT_CTRL_STAT);
-		msleep(10);
+		ata_msleep(ap, 10);
 		writel(PORT_CS_PORT_RST, port + PORT_CTRL_CLR);
-		ata_wait_register(port + PORT_CTRL_STAT, PORT_CS_RDY, 0,
+		ata_wait_register(ap, port + PORT_CTRL_STAT, PORT_CS_RDY, 0,
 				  10, 5000);
 
 		/* restore port configuration */
@@ -740,7 +740,7 @@ static int sil24_hardreset(struct ata_link *link, unsigned int *class,
 		tout_msec = 5000;
 
 	writel(PORT_CS_DEV_RST, port + PORT_CTRL_STAT);
-	tmp = ata_wait_register(port + PORT_CTRL_STAT,
+	tmp = ata_wait_register(ap, port + PORT_CTRL_STAT,
 				PORT_CS_DEV_RST, PORT_CS_DEV_RST, 10,
 				tout_msec);
 
@@ -1253,7 +1253,7 @@ static void sil24_init_controller(struct ata_host *host)
 		tmp = readl(port + PORT_CTRL_STAT);
 		if (tmp & PORT_CS_PORT_RST) {
 			writel(PORT_CS_PORT_RST, port + PORT_CTRL_CLR);
-			tmp = ata_wait_register(port + PORT_CTRL_STAT,
+			tmp = ata_wait_register(NULL, port + PORT_CTRL_STAT,
 						PORT_CS_PORT_RST,
 						PORT_CS_PORT_RST, 10, 100);
 			if (tmp & PORT_CS_PORT_RST)
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 4730c42..c215899 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -349,7 +349,7 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 
 	/* wait for phy to become ready, if necessary */
 	do {
-		msleep(200);
+		ata_msleep(link->ap, 200);
 		svia_scr_read(link, SCR_STATUS, &sstatus);
 		if ((sstatus & 0xf) != 1)
 			break;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index fe6e681..0c4929f 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -89,6 +89,7 @@ enum {
 	ATA_ID_SPG		= 98,
 	ATA_ID_LBA_CAPACITY_2	= 100,
 	ATA_ID_SECTOR_SIZE	= 106,
+	ATA_ID_LOGICAL_SECTOR_SIZE	= 117,	/* and 118 */
 	ATA_ID_LAST_LUN		= 126,
 	ATA_ID_DLF		= 128,
 	ATA_ID_CSFO		= 129,
@@ -640,16 +641,49 @@ static inline int ata_id_flush_ext_enabled(const u16 *id)
 	return (id[ATA_ID_CFS_ENABLE_2] & 0x2400) == 0x2400;
 }
 
-static inline int ata_id_has_large_logical_sectors(const u16 *id)
+static inline u32 ata_id_logical_sector_size(const u16 *id)
 {
-	if ((id[ATA_ID_SECTOR_SIZE] & 0xc000) != 0x4000)
-		return 0;
-	return id[ATA_ID_SECTOR_SIZE] & (1 << 13);
+	/* T13/1699-D Revision 6a, Sep 6, 2008. Page 128.
+	 * IDENTIFY DEVICE data, word 117-118.
+	 * 0xd000 ignores bit 13 (logical:physical > 1)
+	 */
+	if ((id[ATA_ID_SECTOR_SIZE] & 0xd000) == 0x5000)
+		return (((id[ATA_ID_LOGICAL_SECTOR_SIZE+1] << 16)
+			 + id[ATA_ID_LOGICAL_SECTOR_SIZE]) * sizeof(u16)) ;
+	return ATA_SECT_SIZE;
+}
+
+static inline u8 ata_id_log2_per_physical_sector(const u16 *id)
+{
+	/* T13/1699-D Revision 6a, Sep 6, 2008. Page 128.
+	 * IDENTIFY DEVICE data, word 106.
+	 * 0xe000 ignores bit 12 (logical sector > 512 bytes)
+	 */
+	if ((id[ATA_ID_SECTOR_SIZE] & 0xe000) == 0x6000)
+		return (id[ATA_ID_SECTOR_SIZE] & 0xf);
+	return 0;
 }
 
-static inline u16 ata_id_logical_per_physical_sectors(const u16 *id)
+/* Offset of logical sectors relative to physical sectors.
+ *
+ * If device has more than one logical sector per physical sector
+ * (aka 512 byte emulation), vendors might offset the "sector 0" address
+ * so sector 63 is "naturally aligned" - e.g. FAT partition table.
+ * This avoids Read/Mod/Write penalties when using FAT partition table
+ * and updating "well aligned" (FS perspective) physical sectors on every
+ * transaction.
+ */
+static inline u16 ata_id_logical_sector_offset(const u16 *id,
+	 u8 log2_per_phys)
 {
-	return 1 << (id[ATA_ID_SECTOR_SIZE] & 0xf);
+	u16 word_209 = id[209];
+
+	if ((log2_per_phys > 1) && (word_209 & 0xc000) == 0x4000) {
+		u16 first = word_209 & 0x3fff;
+		if (first > 0)
+			return (1 << log2_per_phys) - first;
+	}
+	return 0;
 }
 
 static inline int ata_id_has_lba48(const u16 *id)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 45fb296..15b77b8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -37,6 +37,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/acpi.h>
 #include <linux/cdrom.h>
+#include <linux/sched.h>
 
 /*
  * Define if arch has non-standard setup.  This is a _PCI_ standard
@@ -172,6 +173,7 @@ enum {
 	ATA_LFLAG_NO_RETRY	= (1 << 5), /* don't retry this link */
 	ATA_LFLAG_DISABLED	= (1 << 6), /* link is disabled */
 	ATA_LFLAG_SW_ACTIVITY	= (1 << 7), /* keep activity stats */
+	ATA_LFLAG_NO_LPM	= (1 << 8), /* disable LPM on this link */
 
 	/* struct ata_port flags */
 	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */
@@ -196,7 +198,7 @@ enum {
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
 	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
 	ATA_FLAG_PMP		= (1 << 19), /* controller supports PMP */
-	ATA_FLAG_IPM		= (1 << 20), /* driver can handle IPM */
+	ATA_FLAG_LPM		= (1 << 20), /* driver can handle LPM */
 	ATA_FLAG_EM		= (1 << 21), /* driver supports enclosure
 					      * management */
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
@@ -324,12 +326,11 @@ enum {
 	ATA_EH_HARDRESET	= (1 << 2), /* meaningful only in ->prereset */
 	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_ENABLE_LINK	= (1 << 3),
-	ATA_EH_LPM		= (1 << 4),  /* link power management action */
 	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
 
 	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK,
 	ATA_EH_ALL_ACTIONS	= ATA_EH_REVALIDATE | ATA_EH_RESET |
-				  ATA_EH_ENABLE_LINK | ATA_EH_LPM,
+				  ATA_EH_ENABLE_LINK,
 
 	/* ata_eh_info->flags */
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
@@ -341,7 +342,7 @@ enum {
 	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */
 	ATA_EHI_PRINTINFO	= (1 << 18), /* print configuration info */
 	ATA_EHI_SETMODE		= (1 << 19), /* configure transfer mode */
-	ATA_EHI_POST_SETMODE	= (1 << 20), /* revaildating after setmode */
+	ATA_EHI_POST_SETMODE	= (1 << 20), /* revalidating after setmode */
 
 	ATA_EHI_DID_RESET	= ATA_EHI_DID_SOFTRESET | ATA_EHI_DID_HARDRESET,
 
@@ -377,7 +378,6 @@ enum {
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
 	ATA_HORKAGE_DISABLE	= (1 << 5),	/* Disable it */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
-	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
 	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
 	ATA_HORKAGE_STUCK_ERR	= (1 << 9),	/* stuck ERR on next PACKET */
 	ATA_HORKAGE_BRIDGE_OK	= (1 << 10),	/* no bridge limits */
@@ -464,6 +464,22 @@ enum ata_completion_errors {
 	AC_ERR_NCQ		= (1 << 10), /* marker for offending NCQ qc */
 };
 
+/*
+ * Link power management policy: If you alter this, you also need to
+ * alter libata-scsi.c (for the ascii descriptions)
+ */
+enum ata_lpm_policy {
+	ATA_LPM_UNKNOWN,
+	ATA_LPM_MAX_POWER,
+	ATA_LPM_MED_POWER,
+	ATA_LPM_MIN_POWER,
+};
+
+enum ata_lpm_hints {
+	ATA_LPM_EMPTY		= (1 << 0), /* port empty/probing */
+	ATA_LPM_HIPM		= (1 << 1), /* may use HIPM */
+};
+
 /* forward declarations */
 struct scsi_device;
 struct ata_port_operations;
@@ -478,16 +494,6 @@ typedef int (*ata_reset_fn_t)(struct ata_link *link, unsigned int *classes,
 			      unsigned long deadline);
 typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes);
 
-/*
- * host pm policy: If you alter this, you also need to alter libata-scsi.c
- * (for the ascii descriptions)
- */
-enum link_pm {
-	NOT_AVAILABLE,
-	MIN_POWER,
-	MAX_PERFORMANCE,
-	MEDIUM_POWER,
-};
 extern struct device_attribute dev_attr_link_power_management_policy;
 extern struct device_attribute dev_attr_unload_heads;
 extern struct device_attribute dev_attr_em_message_type;
@@ -530,6 +536,10 @@ struct ata_host {
 	void			*private_data;
 	struct ata_port_operations *ops;
 	unsigned long		flags;
+
+	struct mutex		eh_mutex;
+	struct task_struct	*eh_owner;
+
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
 #endif
@@ -560,13 +570,13 @@ struct ata_queued_cmd {
 	unsigned int		extrabytes;
 	unsigned int		curbytes;
 
-	struct scatterlist	*cursg;
-	unsigned int		cursg_ofs;
-
 	struct scatterlist	sgent;
 
 	struct scatterlist	*sg;
 
+	struct scatterlist	*cursg;
+	unsigned int		cursg_ofs;
+
 	unsigned int		err_mask;
 	struct ata_taskfile	result_tf;
 	ata_qc_cb_t		complete_fn;
@@ -604,6 +614,7 @@ struct ata_device {
 	union acpi_object	*gtf_cache;
 	unsigned int		gtf_filter;
 #endif
+	struct device		tdev;
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
 	u64			n_native_sectors; /* native size, if ATA */
@@ -690,6 +701,7 @@ struct ata_link {
 	struct ata_port		*ap;
 	int			pmp;		/* port multiplier port # */
 
+	struct device		tdev;
 	unsigned int		active_tag;	/* active tag on this link */
 	u32			sactive;	/* active NCQ commands */
 
@@ -699,6 +711,7 @@ struct ata_link {
 	unsigned int		hw_sata_spd_limit;
 	unsigned int		sata_spd_limit;
 	unsigned int		sata_spd;	/* current SATA PHY speed */
+	enum ata_lpm_policy	lpm_policy;
 
 	/* record runtime error info, protected by host_set lock */
 	struct ata_eh_info	eh_info;
@@ -707,6 +720,8 @@ struct ata_link {
 
 	struct ata_device	device[ATA_MAX_DEVICES];
 };
+#define ATA_LINK_CLEAR_BEGIN		offsetof(struct ata_link, active_tag)
+#define ATA_LINK_CLEAR_END		offsetof(struct ata_link, device[0])
 
 struct ata_port {
 	struct Scsi_Host	*scsi_host; /* our co-allocated scsi host */
@@ -752,6 +767,7 @@ struct ata_port {
 	struct ata_port_stats	stats;
 	struct ata_host		*host;
 	struct device 		*dev;
+	struct device		tdev;
 
 	struct mutex		scsi_scan_mutex;
 	struct delayed_work	hotplug_task;
@@ -767,7 +783,7 @@ struct ata_port {
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
-	enum link_pm		pm_policy;
+	enum ata_lpm_policy	target_lpm_policy;
 
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
@@ -833,8 +849,8 @@ struct ata_port_operations {
 	int  (*scr_write)(struct ata_link *link, unsigned int sc_reg, u32 val);
 	void (*pmp_attach)(struct ata_port *ap);
 	void (*pmp_detach)(struct ata_port *ap);
-	int  (*enable_pm)(struct ata_port *ap, enum link_pm policy);
-	void (*disable_pm)(struct ata_port *ap);
+	int  (*set_lpm)(struct ata_link *link, enum ata_lpm_policy policy,
+			unsigned hints);
 
 	/*
 	 * Start, stop, suspend and resume
@@ -946,6 +962,8 @@ extern int sata_link_debounce(struct ata_link *link,
 			const unsigned long *params, unsigned long deadline);
 extern int sata_link_resume(struct ata_link *link, const unsigned long *params,
 			    unsigned long deadline);
+extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+			     bool spm_wakeup);
 extern int sata_link_hardreset(struct ata_link *link,
 			const unsigned long *timing, unsigned long deadline,
 			bool *online, int (*check_ready)(struct ata_link *));
@@ -991,8 +1009,9 @@ extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
 #endif
 extern int ata_ratelimit(void);
-extern u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
-			     unsigned long interval, unsigned long timeout);
+extern void ata_msleep(struct ata_port *ap, unsigned int msecs);
+extern u32 ata_wait_register(struct ata_port *ap, void __iomem *reg, u32 mask,
+			u32 val, unsigned long interval, unsigned long timeout);
 extern int atapi_cmd_type(u8 opcode);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
