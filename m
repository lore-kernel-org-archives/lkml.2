Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab0GSAZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 20:25:26 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51112 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740Ab0GSAZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 20:25:25 -0400
Message-ID: <4C439B6D.7050103@fusionio.com>
Date: Sun, 18 Jul 2010 18:25:17 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
References: <4C4325E0.5020407@fusionio.com> <20100718184243.GA4062@srcf.ucam.org> <4C4383D9.3060705@pobox.com>
In-Reply-To: <4C4383D9.3060705@pobox.com>
Content-Type: multipart/mixed;
 boundary="------------070603080907000808060408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070603080907000808060408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/18/2010 04:44 PM, Jeff Garzik wrote:
> On 07/18/2010 02:42 PM, Matthew Garrett wrote:
>> On Sun, Jul 18, 2010 at 10:03:44AM -0600, Jens Axboe wrote:
>>> Looking at the specs, I don't see what I am missing to make this
>>> work for resume. I'm assuming that EFI did initialize some bits
>>> that am missing when coming out of resume, but I don't know which
>>> bits.
>>
>> There's no guarantee that the AHCI BAR is programmed by the firmware (it
>> seems to be on the Macs, but won't be on most hardware). Is it getting
>> reprogrammed on resume?
> 
> That's definitely the key question.
> 
> I would have quirked AHCI/piix hardware into AHCI mode long ago, if 
> firmwares defaulting to piix mode would actually program the PCI BAR 
> correctly.
> 
> Or, if the firmware had some way to safely allocate a bus memory range, 
> which we could ourselves program into the PCI BAR.  Some non-PC 
> platforms can do that.

So I've dug a bit further, and I discovered that the AHCI BAR is indeed
not working on resume. I googled and found an older patch from Matthew
that hacks it in, but it still failed on resume. But a bit differently,
it seemed that now only interrupt delivery was problematic. I disabled
msi for this controller, and bingo it now works as expected and
suspend/resumes just fine.

The MSI registers were programmed on resume, so I'm quite sure which
extra bit needs to be fiddled to ensure that MSI works as well.

The patch I'm testing with now is below, it works but of course it a
hack in areas. I'm attaching the output from resume with the debug stuff
in, in case it helps anyone.


diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index f252253..f0f3a9e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1119,6 +1119,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ahci_sb600_enable_64bit(pdev))
 		hpriv->flags &= ~AHCI_HFLAG_32BIT_ONLY;
 
+	/* turn off msi on mbp 6,2 ahci mode */
+	if (pdev->device == 0x3b29)
+		hpriv->flags |= AHCI_HFLAG_NO_MSI;
+
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f4adba2..45e37b9 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -118,7 +118,7 @@ static inline unsigned int pci_calc_resource_flags(unsigned int flags)
 	return IORESOURCE_MEM;
 }
 
-static u64 pci_size(u64 base, u64 maxbase, u64 mask)
+u64 pci_size(u64 base, u64 maxbase, u64 mask)
 {
 	u64 size = mask & maxbase;	/* Find the significant bits */
 	if (!size)
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 477345d..f153749 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1020,6 +1020,205 @@ static void quirk_disable_pxb(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
 
+struct pch_reg {
+	unsigned int offset;
+	unsigned int size;
+	const char *name;
+};
+
+static struct pch_reg pch_regs[] = {
+	{
+		.offset = 0x09,
+		.size	= 1,
+		.name	= "PI",
+	},
+	{
+		.offset = 0x0a,
+		.size	= 1,
+		.name	= "SCC",
+	},
+	{
+		.offset = 0x3c,
+		.size	= 1,
+		.name	= "INT_LN",
+	},
+	{
+		.offset = 0x3d,
+		.size	= 1,
+		.name	= "INT_PN",
+	},
+	{
+		.offset = 0x74,
+		.size	= 2,
+		.name	= "PMCS",
+	},
+	{
+		.offset = 0x82,
+		.size	= 2,
+		.name	= "MSIMC",
+	},
+	{
+		.offset = 0x84,
+		.size	= 4,
+		.name	= "MSIMA",
+	},
+	{
+		.offset = 0x88,
+		.size	= 2,
+		.name	= "MSIMD",
+	},
+	{
+		.offset = 0x90,
+		.size	= 2,
+		.name	= "MAP",
+	},
+	{
+		.offset = 0x92,
+		.size	= 2,
+		.name	= "PCS",
+	},
+	{
+		.offset = 0x94,
+		.size	= 4,
+		.name	= "SCLKCG",
+	},
+	{
+		.offset = 0x9c,
+		.size	= 4,
+		.name	= "SCLKGC",
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+static void dump_regs(struct pci_dev *pdev, const char *msg)
+{
+	struct pch_reg *pr;
+	u8 byte;
+	u16 word;
+	u32 dword;
+	int i;
+
+	printk("%s:\n", msg);
+	for (i = 0; pch_regs[i].name; i++) {
+		int val;
+
+		pr = &pch_regs[i];
+		switch (pr->size) {
+		case 1:
+			pci_read_config_byte(pdev, pr->offset, &byte);
+			val = byte;
+			break;
+		case 2:
+			pci_read_config_word(pdev, pr->offset, &word);
+			val = word;
+			break;
+		case 4:
+			pci_read_config_dword(pdev, pr->offset, &dword);
+			val = dword;
+			break;
+		default:
+			val = -1;
+		}
+		printk("  reg %s(%x): %x\n", pr->name, pr->offset, val);
+	}
+}
+
+static void show_regions(struct pci_dev *pdev, const char *msg)
+{
+	int i;
+
+	printk("%s: \n", msg);
+	for (i = 0; i <= 5; i++)
+		printk("  BAR %d, res %pR\n", i, &pdev->resource[i]);
+		
+}
+
+/*
+ * This enables AHCI mode on Macbook Pro 6,2 and others based on Intels
+ * 5 series / 3400 series chipset.
+ *
+ * Info found here http://www.intel.com/Assets/PDF/datasheet/322169.pdf
+ */
+static void quirk_pch_ahci(struct pci_dev *pdev)
+{
+	u16 mode;
+
+	/*
+	 * 0x90 is the MAP register offset
+	 */
+	pci_read_config_word(pdev, 0x90, &mode);
+
+	/*
+	 * MAP.MV must be 0x00 to allow ahci enable
+	 */
+	if (mode & 0x03)
+		return;
+
+	/*
+	 * Already in AHCI mode?
+	 */
+	if (mode & (1 << 6))
+		return;
+
+	/*
+	 * MAP.SMS bit 6 is AHCI mode, MAP.SC bit 5 is port config
+	 */
+	mode = (1 << 6) | (1 << 5);
+	pci_write_config_word(pdev, 0x90, mode);
+
+	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE ||
+	    (pdev->class >> 8) == PCI_CLASS_STORAGE_SATA_AHCI) {
+		pci_write_config_byte(pdev, PCI_CLASS_PROG, 0x01);
+		pci_write_config_byte(pdev, PCI_CLASS_DEVICE, 0x06);
+		pdev->class = PCI_CLASS_STORAGE_SATA_AHCI;
+	}
+
+	/*
+	 * Re-read device id, it has now changed
+	 */
+	pci_read_config_word(pdev, PCI_DEVICE_ID, &pdev->device);
+
+	dump_regs(pdev, "boot");
+	show_regions(pdev, "boot");
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3b28, quirk_pch_ahci);
+
+static void pch_update_bar(struct pci_dev *pdev)
+{
+	if (pcim_iomap_regions(pdev, 1 << 5, "AHCI quirk")) {
+		int ret;
+
+		printk("AHCI BAR not set - attempting to program... ");
+		pdev->resource[5].flags = IORESOURCE_MEM;
+		ret = pci_allocate_resource(pdev, 5);
+		if (ret)
+			printk (KERN_INFO "Failed to allocate new region\n");
+		else
+			printk (KERN_INFO "Succeeded\n");
+	} else
+		pcim_iounmap_regions(pdev, 1 << 5);
+}
+
+static void quirk_pch_ahci_resume(struct pci_dev *pdev)
+{
+	show_regions(pdev, "resume");
+	dump_regs(pdev, "resume-pre");
+
+	quirk_pch_ahci(pdev);
+#if 0
+	pci_write_config_word(pdev, 0x74, 1 << 8);
+	pci_write_config_dword(pdev, 0x94, 0x3c000183);
+	pci_write_config_dword(pdev, 0x84, 0x00);
+	pci_write_config_word(pdev, 0x88, 0x00);
+#endif
+
+	dump_regs(pdev, "resume-post");
+	pch_update_bar(pdev);
+}
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x3b29, quirk_pch_ahci_resume);
+
 static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
 {
 	/* set SBX00/Hudson-2 SATA in IDE mode to AHCI mode */
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 92379e2..3255dd6 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -25,6 +25,59 @@
 #include <linux/slab.h>
 #include "pci.h"
 
+int pci_allocate_resource(struct pci_dev *dev, int resno)
+{
+	int err;
+	u32 size, mask, reg;
+	resource_size_t start;
+	struct resource *res = &dev->resource[resno];
+	struct resource *bres = pci_find_parent_resource(dev, res);
+
+	if (!bres) {
+		BUG();
+	}
+
+	if (!bres)
+		return -ENOMEM;
+	
+	if (res->flags & IORESOURCE_IO) {
+		mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
+		start = PCIBIOS_MIN_IO;
+	} else {
+		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
+		start = PCIBIOS_MIN_MEM;
+	}
+
+	if (resno < 6)
+		reg = PCI_BASE_ADDRESS_0 + 4 * resno;
+	else
+		return -EINVAL;
+
+	pci_write_config_dword(dev, reg, ~0);
+	pci_read_config_dword(dev, reg, &size);
+
+	if (!size || size == 0xffffffff)
+		return 0;
+
+	size = pci_size(0, size, mask);
+	
+	if (res->start != 0 && res->end != 0)
+		release_resource (res);
+
+	err = allocate_resource (bres, res, size+1, start, ~0U, 1024, NULL,
+				 NULL);
+
+	if (err) {
+		printk ("Failed to allocate a resource\n");
+		return err;
+	}
+
+	pci_update_resource(dev, resno);
+
+	return 0;
+}
+EXPORT_SYMBOL(pci_allocate_resource);
+
 
 void pci_update_resource(struct pci_dev *dev, int resno)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7cb0084..4385c9d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -849,6 +849,8 @@ void pdev_sort_resources(struct pci_dev *, struct resource_list *);
 int pci_enable_resources(struct pci_dev *, int mask);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
 		    int (*)(struct pci_dev *, u8, u8));
+int pci_allocate_resource(struct pci_dev *dev, int resno);
+u64 pci_size(u64 base, u64 maxbase, u64 mask);
 #define HAVE_PCI_REQ_REGIONS	2
 int __must_check pci_request_regions(struct pci_dev *, const char *);
 int __must_check pci_request_regions_exclusive(struct pci_dev *, const char *);

-- 
Jens Axboe


--------------070603080907000808060408
Content-Type: text/plain;
 name="ahci-resume-debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ahci-resume-debug"

ahci 0000:00:1f.2: restoring config space at offset 0xf (was 0x200, writing 0x20b)
ahci 0000:00:1f.2: restoring config space at offset 0xd (was 0x70, writing 0x80)
ahci 0000:00:1f.2: restoring config space at offset 0x9 (was 0xffe1, writing 0xa2800000)
ahci 0000:00:1f.2: restoring config space at offset 0x8 (was 0xff01, writing 0x3021)
ahci 0000:00:1f.2: restoring config space at offset 0x7 (was 0xff2d, writing 0x3139)
ahci 0000:00:1f.2: restoring config space at offset 0x6 (was 0xff19, writing 0x3121)
ahci 0000:00:1f.2: restoring config space at offset 0x5 (was 0xff25, writing 0x313d)
ahci 0000:00:1f.2: restoring config space at offset 0x4 (was 0xff11, writing 0x3129)
ahci 0000:00:1f.2: restoring config space at offset 0x2 (was 0x1018b06, writing 0x1060106)
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00007)
ahci 0000:00:1f.2: restoring config space at offset 0x0 (was 0x3b288086, writing 0x3b298086)
resume: 
  BAR 0, res [io  0x3128-0x312f]
  BAR 1, res [io  0x313c-0x313f]
  BAR 2, res [io  0x3120-0x3127]
  BAR 3, res [io  0x3138-0x313b]
  BAR 4, res [io  0x3020-0x303f]
  BAR 5, res [mem 0xa2800000-0xa28007ff]
resume-pre:
  reg PI(9): 8b
  reg SCC(a): 1
  reg INT_LN(3c): b
  reg INT_PN(3d): 2
  reg PMCS(74): 8
  reg MSIMC(82): 0
  reg MSIMA(84): 0
  reg MSIMD(88): 0
  reg MAP(90): 3c00
  reg PCS(92): 8303
  reg SCLKCG(94): 3c000183
  reg SCLKGC(9c): 1
boot:
  reg PI(9): 1
  reg SCC(a): 6
  reg INT_LN(3c): b
  reg INT_PN(3d): 2
  reg PMCS(74): 8
  reg MSIMC(82): 0
  reg MSIMA(84): 0
  reg MSIMD(88): 0
  reg MAP(90): 3c60
  reg PCS(92): 8303
  reg SCLKCG(94): 3c000183
  reg SCLKGC(9c): 1
boot: 
  BAR 0, res [io  0x3128-0x312f]
  BAR 1, res [io  0x313c-0x313f]
  BAR 2, res [io  0x3120-0x3127]
  BAR 3, res [io  0x3138-0x313b]
  BAR 4, res [io  0x3020-0x303f]
  BAR 5, res [mem 0xa2800000-0xa28007ff]
resume-post:
  reg PI(9): 1
  reg SCC(a): 6
  reg INT_LN(3c): b
  reg INT_PN(3d): 2
  reg PMCS(74): 8
  reg MSIMC(82): 0
  reg MSIMA(84): 0
  reg MSIMD(88): 0
  reg MAP(90): 3c60
  reg PCS(92): 8303
  reg SCLKCG(94): 3c000183
  reg SCLKGC(9c): 1
ahci 0000:00:1f.2: BAR 5: can't reserve [mem 0xa2800000-0xa28007ff]
AHCI BAR not set - attempting to program... 
ahci 0000:00:1f.2: BAR 5: set to [mem 0xa2800000-0xa28007ff] (PCI address [0xa2800000-0xa28007ff]
Succeeded

--------------070603080907000808060408--
