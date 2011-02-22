Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1BVOMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:12:03 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:60696 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1BVOMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:12:00 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <015501cbcdae$6961c5d0$3c255170$@mprc.pku.edu.cn> <201102171819.52845.arnd@arndb.de>
In-Reply-To: <201102171819.52845.arnd@arndb.de>
Subject: RE: [PATCH 10/12] unicore32 machine related files: pci bus handling
Date: Tue, 22 Feb 2011 22:11:52 +0800
Message-ID: <018801cbd29a$7400d800$5c028800$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGmett9JsWVJRUIPSe0CypunCVk1AFTnicklE2hvKA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 1:20 AM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCH 10/12] unicore32 machine related files: pci bus handling
> 
> On Wednesday 16 February 2011, Guan Xuetao wrote:
> > +{
> > +       PCICFG_ADDR = CONFIG_CMD(bus, devfn, where);
> > +       switch (size) {
> > +       case 1:
> > +               *value = (PCICFG_DATA >> ((where & 3) * 8)) & 0xFF;
> > +               break;
> > +       case 2:
> 
> It took me a while to figure out what this actually does. PCICFG_ADDR
> and PCICFG_DATA are pointers to MMIO registers, which you should not
> simply dereference. A lot of things can go wrong there, especially
> if future machines move to weakly ordered I/O subsystem or have
> multiple CPUs, but even for the simple case, the compiler has
> a lot of ways to mess this up.
> 
> As explained in my reply to the "hardware registers" patch, all these
> pointers should be marked as __iomem, so that sparse warns about
> dangerous accesses such as the one here.
> 
> The code above should be written as
> 
> {
>        writel(CONFIG_CMD(bus, devfn, where), PCICFG_ADDR);
>        switch (size) {
>        case 1:
>                *value = readl(PCICFG_DATA >> ((where & 3) * 8)) & 0xFF;
>                break;
>        case 2:
Please see following patch:
arch/unicore32/kernel/pci.c |   58 +++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
index d4e55e2..65c265e 100644
--- a/arch/unicore32/kernel/pci.c
+++ b/arch/unicore32/kernel/pci.c
@@ -30,16 +30,16 @@ static int
 puv3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 			int size, u32 *value)
 {
-	PCICFG_ADDR = CONFIG_CMD(bus, devfn, where);
+	writel(CONFIG_CMD(bus, devfn, where), PCICFG_ADDR);
 	switch (size) {
 	case 1:
-		*value = (PCICFG_DATA >> ((where & 3) * 8)) & 0xFF;
+		*value = (readl(PCICFG_DATA) >> ((where & 3) * 8)) & 0xFF;
 		break;
 	case 2:
-		*value = (PCICFG_DATA >> ((where & 2) * 8)) & 0xFFFF;
+		*value = (readl(PCICFG_DATA) >> ((where & 2) * 8)) & 0xFFFF;
 		break;
 	case 4:
-		*value = PCICFG_DATA;
+		*value = readl(PCICFG_DATA);
 		break;
 	}
 	return PCIBIOS_SUCCESSFUL;
@@ -49,18 +49,18 @@ static int
 puv3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 			int size, u32 value)
 {
-	PCICFG_ADDR = CONFIG_CMD(bus, devfn, where);
+	writel(CONFIG_CMD(bus, devfn, where), PCICFG_ADDR);
 	switch (size) {
 	case 1:
-		PCICFG_DATA = (PCICFG_DATA & ~FMASK(8, (where&3)*8))
-			| FIELD(value, 8, (where&3)*8);
+		writel((readl(PCICFG_DATA) & ~FMASK(8, (where&3)*8))
+			| FIELD(value, 8, (where&3)*8), PCICFG_DATA);
 		break;
 	case 2:
-		PCICFG_DATA = (PCICFG_DATA & ~FMASK(16, (where&2)*8))
-			| FIELD(value, 16, (where&2)*8);
+		writel((readl(PCICFG_DATA) & ~FMASK(16, (where&2)*8))
+			| FIELD(value, 16, (where&2)*8), PCICFG_DATA);
 		break;
 	case 4:
-		PCICFG_DATA = value;
+		writel(value, PCICFG_DATA);
 		break;
 	}
 	return PCIBIOS_SUCCESSFUL;
@@ -75,31 +75,31 @@ void pci_puv3_preinit(void)
 {
 	printk(KERN_DEBUG "PCI: PKUnity PCI Controller Initializing ...\n");
 	/* config PCI bridge base */
-	PCICFG_BRIBASE = PKUNITY_PCIBRI_BASE;
+	writel(PKUNITY_PCIBRI_BASE, PCICFG_BRIBASE);
 
-	PCIBRI_AHBCTL0 = 0;
-	PCIBRI_AHBBAR0 = PKUNITY_PCIBRI_BASE | PCIBRI_BARx_MEM;
-	PCIBRI_AHBAMR0 = 0xFFFF0000;
-	PCIBRI_AHBTAR0 = 0;
+	writel(0, PCIBRI_AHBCTL0);
+	writel(PKUNITY_PCIBRI_BASE | PCIBRI_BARx_MEM, PCIBRI_AHBBAR0);
+	writel(0xFFFF0000, PCIBRI_AHBAMR0);
+	writel(0, PCIBRI_AHBTAR0);
 
-	PCIBRI_AHBCTL1 = PCIBRI_CTLx_AT;
-	PCIBRI_AHBBAR1 = PKUNITY_PCILIO_BASE | PCIBRI_BARx_IO;
-	PCIBRI_AHBAMR1 = 0xFFFF0000;
-	PCIBRI_AHBTAR1 = 0x00000000;
+	writel(PCIBRI_CTLx_AT, PCIBRI_AHBCTL1);
+	writel(PKUNITY_PCILIO_BASE | PCIBRI_BARx_IO, PCIBRI_AHBBAR1);
+	writel(0xFFFF0000, PCIBRI_AHBAMR1);
+	writel(0x00000000, PCIBRI_AHBTAR1);
 
-	PCIBRI_AHBCTL2 = PCIBRI_CTLx_PREF;
-	PCIBRI_AHBBAR2 = PKUNITY_PCIMEM_BASE | PCIBRI_BARx_MEM;
-	PCIBRI_AHBAMR2 = 0xF8000000;
-	PCIBRI_AHBTAR2 = 0;
+	writel(PCIBRI_CTLx_PREF, PCIBRI_AHBCTL2);
+	writel(PKUNITY_PCIMEM_BASE | PCIBRI_BARx_MEM, PCIBRI_AHBBAR2);
+	writel(0xF8000000, PCIBRI_AHBAMR2);
+	writel(0, PCIBRI_AHBTAR2);
 
-	PCIBRI_BAR1 = PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM;
+	writel(PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM, PCIBRI_BAR1);
 
-	PCIBRI_PCICTL0 = PCIBRI_CTLx_AT | PCIBRI_CTLx_PREF;
-	PCIBRI_PCIBAR0 = PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM;
-	PCIBRI_PCIAMR0 = 0xF8000000;
-	PCIBRI_PCITAR0 = PKUNITY_SDRAM_BASE;
+	writel(PCIBRI_CTLx_AT | PCIBRI_CTLx_PREF, PCIBRI_PCICTL0);
+	writel(PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM, PCIBRI_PCIBAR0);
+	writel(0xF8000000, PCIBRI_PCIAMR0);
+	writel(PKUNITY_SDRAM_BASE, PCIBRI_PCITAR0);
 
-	PCIBRI_CMD = PCIBRI_CMD | PCIBRI_CMD_IO | PCIBRI_CMD_MEM;
+	writel(readl(PCIBRI_CMD) | PCIBRI_CMD_IO | PCIBRI_CMD_MEM, PCIBRI_CMD);
 }
 
 static int __init pci_puv3_map_irq(struct pci_dev *dev, u8 slot, u8 pin)

---

PCI_CFG_DATA must be read/write with 32bit in PKUnity-v3 pci controller.

> 
> 	Arnd

Thanks & Regards.

Guan Xuetao


