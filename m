Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab2C2OAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:00:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36442 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab2C2OAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:00:10 -0400
Message-ID: <235AEF3080A4490EBDC3952C6B33CFC9@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "LKML" <linux-kernel@vger.kernel.org>,
        "'KY Srinivasan'" <kys@microsoft.com>
Cc: "Olaf Hering" <olaf@aepfle.de>, "Andy Whitcroft" <apw@canonical.com>
Subject: Linux on Hyper-V -- use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the DVD-ROM / CD-ROM device handling) Fw: [PATCH RFC] ata_piix: ignore disks in a hyper-v guest
Date: Thu, 29 Mar 2012 17:00:05 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

   Shortly:

 IMHO, need apply 1/2 ( or combined ) solution problem related "ata_piix.c" in Hyper-V enviroment:


 "UBUNTU Way" Solution -- tested with
Ubuntu 12.04 LTS (Precise Pangolin) Daily Build 2012-03-13
precise-desktop-amd64.iso
, work Ok



 "OpenSUSE Way" Solution  -- tested with
{
OpenSUSE  v12.2-Milestone1 09-Feb-2012 16:01  741M

http://download.opensuse.org/distribution/12.2-Milestone1/iso/
[
http://ftp.byfly.by/pub/opensuse/distribution/12.2-Milestone1/iso/openSUSE-KDE-LiveCD-Build0151-x86_64.iso
]
•Last modified: Thu, 09 Feb 2012 15:01:45 GMT (Unix time: 1328799705)
•SHA-1 Hash: 2d9063b7a3ae0c0e43cd91c1ad97ad62b712db18
•MD5 Hash: 220687642130915637357791fe4b5fd1
}
, work Ok



---

 1 Problem , 2 solution:

Problem:

http://marc.info/?l=linux-ide&m=131489185106149&w=2
==
From:       Olaf Hering <olaf (at) aepfle (dot) de>
Date:       2011-09-01 15:43:40
Subject:    [PATCH RFC] ata_piix: ignore disks in a hyper-v guest

> both ata_piix and hv_blkvsc ( VVM: on 2012-03-XX  hv_storvsc) will bind to the same drive

 . . .

Here is an attempt ( VVM: on 2012-03-XX worked solution see "OpenSUSE Way") to
ignore disks in a hyper-v disks, and let ata_piix handle only the configured cdrom devices (iso of physical).
If the disks are not ignored, they will appear twice,
once through ata_piix and once through hv_storvsc.
  . . .
==




http://vvm.blog.tut.by/2012/02/16/state-of-linux-on-hyper-v/
==

 . . .

Kernel v3.2: With Arch fork Сhakra: . . .  , but
\dev\sdb is IDE Drive Master Primary ( and not work as need)
and
\dev\sda is IDE Drive Master Primary

i.e.
— \dev\sda = = \dev\sdb

and SCSI not \dev\sdb , but \dev\sdc — IMHO, it is may be not very well ( VVM: on 2012-03-XX  -- de-facto, big problem 
:-( )

see Linux on Hyper-V Image:

 [ Image => see blog ]
 . . .

--------------------------------------------------------------------------------
From: KY Srinivasan
Sent: Tuesday, February 21, 2012 7:37 PM
To: Miasnikov Victor
Subject: RE: . . . b) patches to ata_piix need in _official_ kernel RE: Ubuntu: ata_piix.prefer_ms_hyperv=0 Fw: Problem: 
\dev\sda == \dev\sdb Fw: IDE drives to hv_storvsc and drops hv_blkvsc Fw: State of Linux on Hyper-V
. . .
With regards to the ata_piix changes, we will try to push that upstream shortly. ( VVM: on  2012-03-29 -- IMHO, need 
start work :-( )

K. Y

==




http://kernel.opensuse.org/cgit/kernel-source/commit/?id=d0bebdb606bad2545622f61225707f061bd6eba5
==
  If the disks are not ignored, they will appear twice: once through piix and once through hv_storvsc.
hv_storvsc can not handle ATAPI devices  because they can only be accessed
through the emulated code path (not through the vm_bus channel),
the piix driver is still required.
==



http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-precise.git;a=commit;h=a896e46ae52619bf4f34cdb342c2862071f5c25c
===
UBUNTU: SAUCE: ata_piix: defer disks to the Hyper-V drivers by default
author Andy Whitcroft <apw@canonical.com>
  . . .
Mon, 19 Mar 2012 17:30:08 +0000 (11:30 -0600)
  . . .

UBUNTU: SAUCE: ata_piix: defer disks to the Hyper-V drivers by default

 When we are hosted on a Microsoft Hyper-V hypervisor
the guest disks are exposed both via the Hyper-V paravirtualised drivers and via an emulated SATA disk drive.
In this case we want to use the paravirtualised drivers if we can as they are much more efficient.
Note that the Hyper-V paravirtualised drivers only expose the virtual hard disk devices,
the CDROM/DVD devices must still be enumerated.
Check the disk type when picking up its ID and if it appears to be a disk just report it disconnected.

BugLink: http://bugs.launchpad.net/bugs/929545
BugLink: http://bugs.launchpad.net/bugs/942316
Signed-off-by: Andy Whitcroft <apw@canonical.com>

===





Solutions:

use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the DVD-ROM CD-ROM device handling)
 Or
ata_piix should not control the disks when hosted on Hyper-V
 Or
Modify the ata_piix driver to recognize that when hosted on Hyper-V, it should not control the disks.



 "UBUNTU Way" Solution:

(

  {
Ubuntu 12.04 (PP) development kernel tree -- Ubuntu-3.2.0-20.33
 http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-precise.git;a=summary
 [
http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-precise.git;a=snapshot;h=870f3e33f86692a751ca7b94a7ad96e114674489;sf=tgz
]
  }
)


 See variant ( i.e. patch only with soruce code related Hyper-V ):

==
--- ..\000\ata_piix.c Thu Jan 05 02:55:44 2012
+++ ata_piix.c Thu Mar 29 13:41:04 2012
@@ -91,12 +91,15 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/gfp.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <linux/dmi.h>
+#ifdef CONFIG_X86
+#include <asm/hypervisor.h>
+#endif

 #define DRV_NAME "ata_piix"
 #define DRV_VERSION "2.13"

 enum {
  PIIX_IOCFG  = 0x54, /* IDE I/O configuration register */
@@ -185,12 +188,35 @@
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
 #endif

 static unsigned int in_module_init = 1;

+static int prefer_ms_hyperv = 1;
+
+unsigned int ata_piix_read_id(struct ata_device *dev,
+                                        struct ata_taskfile *tf, u16 *id)
+{
+ int ret = ata_do_dev_read_id(dev, tf, id);
+
+#ifdef CONFIG_X86
+ /* XXX: note that the device id is in little-endian order, the caller
+  * will shift it to host order, but we are working with little-endian.
+  * As this is _only_ used on x86 we can actually directly access it
+  * as host is also little-endian.
+  */
+ if (!ret && prefer_ms_hyperv && x86_hyper == &x86_hyper_ms_hyperv &&
+       ata_id_is_ata(id)) {
+  ata_dev_printk(dev, KERN_WARNING, "ATA disk ignored deferring to Hyper-V paravirt driver\n");
+
+  return AC_ERR_DEV|AC_ERR_NODEV_HINT;
+ }
+#endif
+ return ret;
+}
+
 static const struct pci_device_id piix_pci_tbl[] = {
  /* Intel PIIX3 for the 430HX etc */
  { 0x8086, 0x7010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_mwdma },
  /* VMware ICH4 */
  { 0x8086, 0x7111, 0x15ad, 0x1976, 0, 0, piix_pata_vmw },
  /* Intel PIIX4 for the 430TX/440BX/MX chipset: UDMA 33 */
@@ -348,12 +374,13 @@
 static struct ata_port_operations piix_pata_ops = {
  .inherits  = &piix_sata_ops,
  .cable_detect  = ata_cable_40wire,
  .set_piomode  = piix_set_piomode,
  .set_dmamode  = piix_set_dmamode,
  .prereset  = piix_pata_prereset,
+ .read_id  = ata_piix_read_id,
 };

 static struct ata_port_operations piix_vmw_ops = {
  .inherits  = &piix_pata_ops,
  .bmdma_status  = piix_vmw_bmdma_status,
 };
@@ -1685,6 +1712,8 @@
 {
  pci_unregister_driver(&piix_pci_driver);
 }

 module_init(piix_init);
 module_exit(piix_exit);
+
+module_param(prefer_ms_hyperv, int, 0);
==




 "OpenSUSE Way" Solution:

http://kernel.opensuse.org/cgit/kernel/commit/?id=aeff3a8fcde6df6e7f26618c5e3bc716a6aa9e85
 http://kernel.opensuse.org/cgit/kernel/tree/drivers/ata/ata_piix.c?id=aeff3a8fcde6df6e7f26618c5e3bc716a6aa9e85
 [
 http://kernel.opensuse.org/cgit/kernel/plain/drivers/ata/ata_piix.c?id=aeff3a8fcde6df6e7f26618c5e3bc716a6aa9e85
]

 See variant ( i.e. patch only with soruce code related Hyper-V ):

==
--- ..\000\ata_piix.c Tue Mar 27 14:39:53 2012
+++ ata_piix.c Tue Mar 27 14:40:31 2012
@@ -162,16 +162,17 @@
  const int *map;
  u32 saved_iocfg;
  void __iomem *sidpr;
 };

 static int piix_init_one(struct pci_dev *pdev,
     const struct pci_device_id *ent);
 static void piix_remove_one(struct pci_dev *pdev);
+static unsigned int piix_pata_read_id(struct ata_device *adev, struct ata_taskfile *tf, u16 *id);
 static int piix_pata_prereset(struct ata_link *link, unsigned long deadline);
 static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
 static u8 piix_vmw_bmdma_status(struct ata_port *ap);
 static int piix_sidpr_scr_read(struct ata_link *link,
           unsigned int reg, u32 *val);
@@ -346,16 +347,17 @@
 };

 static struct ata_port_operations piix_pata_ops = {
  .inherits  = &piix_sata_ops,
  .cable_detect  = ata_cable_40wire,
  .set_piomode  = piix_set_piomode,
  .set_dmamode  = piix_set_dmamode,
  .prereset  = piix_pata_prereset,
+ .read_id  = piix_pata_read_id,
 };

 static struct ata_port_operations piix_vmw_ops = {
  .inherits  = &piix_pata_ops,
  .bmdma_status  = piix_vmw_bmdma_status,
 };

 static struct ata_port_operations ich_pata_ops = {
@@ -633,16 +635,36 @@
 };

 MODULE_AUTHOR("Andre Hedrick, Alan Cox, Andrzej Krzysztofowicz, Jeff Garzik");
 MODULE_DESCRIPTION("SCSI low-level driver for Intel PIIX/ICH ATA controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 MODULE_VERSION(DRV_VERSION);

+static int piix_msft_hyperv(void)
+{
+ int hv = 0;
+#if defined(CONFIG_HYPERV_STORAGE) || defined(CONFIG_HYPERV_STORAGE_MODULE)
+ static const struct dmi_system_id hv_dmi_ident[]  = {
+  {
+   .ident = "Hyper-V",
+   .matches = {
+    DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+    DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+    DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+   },
+  },
+  { } /* terminate list */
+ };
+ hv = !!dmi_check_system(hv_dmi_ident);
+#endif
+ return hv;
+}
+
 struct ich_laptop {
  u16 device;
  u16 subvendor;
  u16 subdevice;
 };

 /*
  * List of laptops that use short cables rather than 80 wire
@@ -722,16 +744,36 @@
 static int piix_pata_prereset(struct ata_link *link, unsigned long deadline)
 {
  struct ata_port *ap = link->ap;
  struct pci_dev *pdev = to_pci_dev(ap->host->dev);

  if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no]))
   return -ENOENT;
  return ata_sff_prereset(link, deadline);
+}
+
+static unsigned int piix_pata_read_id(struct ata_device *adev, struct ata_taskfile *tf, u16 *id)
+{
+ unsigned int err_mask = ata_do_dev_read_id(adev, tf, id);
+ /*
+  * Ignore disks in a hyper-v guest.
+  * There is no unplug protocol like it is done with xen_emul_unplug= option.
+  * Emulate the unplug by ignoring disks when the hv_storvsc driver is enabled.
+  * If the disks are not ignored, they will appear twice: once through
+  * piix and once through hv_storvsc.
+  * hv_storvsc can not handle ATAPI devices because they can only be
+  * accessed through the emulated code path (not through the vm_bus
+  * channel), the piix driver is still required.
+  */
+ if (ata_id_is_ata(id) && piix_msft_hyperv()) {
+  ata_dev_printk(adev, KERN_WARNING, "ATA device ignored in Hyper-V guest\n");
+  id[ATA_ID_CONFIG] |= (1 << 15);
+ }
+ return err_mask;
 }

 static DEFINE_SPINLOCK(piix_lock);

 static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
         u8 pio)
 {
  struct pci_dev *dev = to_pci_dev(ap->host->dev);
==





Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/


