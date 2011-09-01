Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1IAPnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:43:51 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36611 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab1IAPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:43:47 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFHii0PETdN
X-RZG-CLASS-ID: mo00
Date: Thu, 1 Sep 2011 17:43:40 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-ide@vger.kernel.org
Cc: KY Srinivasan <kys@microsoft.com>, devel@linuxdriverproject.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org
Subject: [PATCH RFC] ata_piix: ignore disks in a hyper-v guest
Message-ID: <20110901154340.GA12375@aepfle.de>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <20110830124856.GA17520@aepfle.de>
 <6E21E5352C11B742B20C142EB499E048081B5363@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110830174330.GE22868@kroah.com>
 <20110830180434.GA10090@aepfle.de>
 <20110830181945.GC24865@kroah.com>
 <20110831091156.GA16104@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110831091156.GA16104@aepfle.de>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, Olaf Hering wrote:

> After some more testing it looks like the hv_blkvsc driver claimed the
> ide major #3, so the ide_core could not bind to the emulated IDE
> hardware. The modprobe.conf rules prevented that ata_piix gets loaded.
> If I force a module load order of 'ata_piix ;hv_blkvsc' both ata_piix
> and hv_blkvsc will bind to the same drive, just as shown in my previous
> mail. So there is appearently no way to shutdown the IDE ports like it
> is done with xen_emul_unplug= option for Xen guests.
> 
> Maybe some hack is needed for a hyper-v specific unplug if Windows does
> indeed lack that feature. Now that ata_piix is compiled into the kernel,
> there is nothing to a modprobe.conf rule can "fix".

Here is an attempt to ignore disks in a hyper-v disks, and let ata_piix
handle only the configured cdrom devices (iso of physical).
If the disks are not ignored, they will appear twice, once through
ata_piix and once through hv_storvsc.

Once hv_storvsc can also handle the configured cdrom devices, the added
piix_pata_read_id() function can be removed again. Only the check in
piix_init() or something similar needs to be done.

Maybe there is a better way enable only ATA_DEV_ATAPI?


Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/ata/ata_piix.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -98,6 +98,10 @@
 #define DRV_NAME	"ata_piix"
 #define DRV_VERSION	"2.13"
 
+#if defined(CONFIG_HYPERV_STORAGE) || defined(CONFIG_HYPERV_STORAGE_MODULE)
+#define PIIX_IGNORE_ATA_ON_HYPERV 1
+#endif
+
 enum {
 	PIIX_IOCFG		= 0x54, /* IDE I/O configuration register */
 	ICH5_PMR		= 0x90, /* port mapping register */
@@ -164,6 +168,7 @@ struct piix_host_priv {
 static int piix_init_one(struct pci_dev *pdev,
 			 const struct pci_device_id *ent);
 static void piix_remove_one(struct pci_dev *pdev);
+static unsigned int piix_pata_read_id(struct ata_device *adev, struct ata_taskfile *tf, u16 *id);
 static int piix_pata_prereset(struct ata_link *link, unsigned long deadline);
 static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
@@ -346,6 +351,7 @@ static struct ata_port_operations piix_p
 	.set_piomode		= piix_set_piomode,
 	.set_dmamode		= piix_set_dmamode,
 	.prereset		= piix_pata_prereset,
+	.read_id		= piix_pata_read_id,
 };
 
 static struct ata_port_operations piix_vmw_ops = {
@@ -619,6 +625,24 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
+#if defined(PIIX_IGNORE_ATA_ON_HYPERV)
+static int piix_msft_hyperv(void)
+{
+	static const struct dmi_system_id hv_dmi_ident[]  = {
+		{
+			.ident = "Hyper-V",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+				DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+			},
+		},
+		{ }	/* terminate list */
+	};
+	return !!dmi_check_system(hv_dmi_ident);
+}
+#endif
+
 struct ich_laptop {
 	u16 device;
 	u16 subvendor;
@@ -702,6 +726,29 @@ static int piix_pata_prereset(struct ata
 	return ata_sff_prereset(link, deadline);
 }
 
+/**
+ *
+ */
+static unsigned int piix_pata_read_id(struct ata_device *adev, struct ata_taskfile *tf, u16 *id)
+{
+	unsigned int err_mask = ata_do_dev_read_id(adev, tf, id);
+#if defined(PIIX_IGNORE_ATA_ON_HYPERV)
+	/*
+	 * Ignore disks in a hyper-v guest.
+	 * There is no unplug protocol like it is done with xen_emul_unplug= option.
+	 * Emulate the unplug by ignoring disks when the hv_storvsc driver is enabled.
+	 * If the disks are not ignored, they will appear twice: once through piix and once through hv_storvsc.
+	 * Because hv_storvsc does not handle ATAPI devices, the piix driver is still required.
+	 * Once hv_storvsc handles all devices, this function can be removed and the whole driver should be disabled in a hyper-v guest.
+	 */
+	if (ata_id_is_ata(id) && piix_msft_hyperv()) {
+		ata_dev_printk(adev, KERN_WARNING, "ATA device ignored in Hyper-V guest\n");
+		id[ATA_ID_CONFIG] |= (1 << 15);
+	}
+#endif
+	return err_mask;
+}
+
 static DEFINE_SPINLOCK(piix_lock);
 
 /**
@@ -1679,6 +1726,13 @@ static int __init piix_init(void)
 {
 	int rc;
 
+#if defined(PIIX_IGNORE_ATA_ON_HYPERV)
+	/* disabled until hv_storvsc drives also cdrom devices */
+	if (0 && piix_msft_hyperv()) {
+		printk(KERN_DEBUG "%s: hv_storvsc will bind to storage\n", __func__);
+		return -ENODEV;
+	}
+#endif
 	DPRINTK("pci_register_driver\n");
 	rc = pci_register_driver(&piix_pci_driver);
 	if (rc)
