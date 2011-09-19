Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1ISFi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 01:38:56 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:59691 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1ISFiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 01:38:54 -0400
Date: Mon, 19 Sep 2011 15:38:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the sound tree with the mips tree
Message-Id: <20110919153853.3a72dc31a93db552eefcba2b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
arch/mips/alchemy/devboards/db1x00/platform.c between several commits
from the mips tree and commit b2ce305dda48 ("ASoC: Add a DB1x00 AC97
machine driver") from the sound tree.

Mainly context changes.  I fixed it up (I think - see below) and can
carry the fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/alchemy/devboards/db1x00/platform.c
index 8704865,7057d28..0000000
--- a/arch/mips/alchemy/devboards/db1x00/platform.c
+++ b/arch/mips/alchemy/devboards/db1x00/platform.c
@@@ -19,10 -19,12 +19,12 @@@
   */
  
  #include <linux/init.h>
 +#include <linux/dma-mapping.h>
+ #include <linux/interrupt.h>
  #include <linux/platform_device.h>
  
  #include <asm/mach-au1x00/au1000.h>
+ #include <asm/mach-au1x00/au1000_dma.h>
 -#include <asm/mach-au1x00/au1xxx.h>
  #include <asm/mach-db1x00/bcsr.h>
  #include "../platform.h"
  
@@@ -88,182 -88,79 +90,227 @@@ struct pci_dev
  #endif
  #endif
  
 +#ifdef CONFIG_PCI
 +#ifdef CONFIG_MIPS_DB1500
 +static int db1xxx_map_pci_irq(const struct pci_dev *d, u8 slot, u8 pin)
 +{
 +	if ((slot < 12) || (slot > 13) || pin == 0)
 +		return -1;
 +	if (slot == 12)
 +		return (pin == 1) ? AU1500_PCI_INTA : 0xff;
 +	if (slot == 13) {
 +		switch (pin) {
 +		case 1: return AU1500_PCI_INTA;
 +		case 2: return AU1500_PCI_INTB;
 +		case 3: return AU1500_PCI_INTC;
 +		case 4: return AU1500_PCI_INTD;
 +		}
 +	}
 +	return -1;
 +}
 +#endif
 +
 +#ifdef CONFIG_MIPS_DB1550
 +static int db1xxx_map_pci_irq(const struct pci_dev *d, u8 slot, u8 pin)
 +{
 +	if ((slot < 11) || (slot > 13) || pin == 0)
 +		return -1;
 +	if (slot == 11)
 +		return (pin == 1) ? AU1550_PCI_INTC : 0xff;
 +	if (slot == 12) {
 +		switch (pin) {
 +		case 1: return AU1550_PCI_INTB;
 +		case 2: return AU1550_PCI_INTC;
 +		case 3: return AU1550_PCI_INTD;
 +		case 4: return AU1550_PCI_INTA;
 +		}
 +	}
 +	if (slot == 13) {
 +		switch (pin) {
 +		case 1: return AU1550_PCI_INTA;
 +		case 2: return AU1550_PCI_INTB;
 +		case 3: return AU1550_PCI_INTC;
 +		case 4: return AU1550_PCI_INTD;
 +		}
 +	}
 +	return -1;
 +}
 +#endif
 +
 +#ifdef CONFIG_MIPS_BOSPORUS
 +static int db1xxx_map_pci_irq(const struct pci_dev *d, u8 slot, u8 pin)
 +{
 +	if ((slot < 11) || (slot > 13) || pin == 0)
 +		return -1;
 +	if (slot == 12)
 +		return (pin == 1) ? AU1500_PCI_INTA : 0xff;
 +	if (slot == 11) {
 +		switch (pin) {
 +		case 1: return AU1500_PCI_INTA;
 +		case 2: return AU1500_PCI_INTB;
 +		default: return 0xff;
 +		}
 +	}
 +	if (slot == 13) {
 +		switch (pin) {
 +		case 1: return AU1500_PCI_INTA;
 +		case 2: return AU1500_PCI_INTB;
 +		case 3: return AU1500_PCI_INTC;
 +		case 4: return AU1500_PCI_INTD;
 +		}
 +	}
 +	return -1;
 +}
 +#endif
 +
 +#ifdef CONFIG_MIPS_MIRAGE
 +static int db1xxx_map_pci_irq(const struct pci_dev *d, u8 slot, u8 pin)
 +{
 +	if ((slot < 11) || (slot > 13) || pin == 0)
 +		return -1;
 +	if (slot == 11)
 +		return (pin == 1) ? AU1500_PCI_INTD : 0xff;
 +	if (slot == 12)
 +		return (pin == 3) ? AU1500_PCI_INTC : 0xff;
 +	if (slot == 13) {
 +		switch (pin) {
 +		case 1: return AU1500_PCI_INTA;
 +		case 2: return AU1500_PCI_INTB;
 +		default: return 0xff;
 +		}
 +	}
 +	return -1;
 +}
 +#endif
 +
 +static struct resource alchemy_pci_host_res[] = {
 +	[0] = {
 +		.start	= AU1500_PCI_PHYS_ADDR,
 +		.end	= AU1500_PCI_PHYS_ADDR + 0xfff,
 +		.flags	= IORESOURCE_MEM,
 +	},
 +};
 +
 +static struct alchemy_pci_platdata db1xxx_pci_pd = {
 +	.board_map_irq	= db1xxx_map_pci_irq,
 +};
 +
 +static struct platform_device db1xxx_pci_host_dev = {
 +	.dev.platform_data = &db1xxx_pci_pd,
 +	.name		= "alchemy-pci",
 +	.id		= 0,
 +	.num_resources	= ARRAY_SIZE(alchemy_pci_host_res),
 +	.resource	= alchemy_pci_host_res,
 +};
 +
 +static int __init db15x0_pci_init(void)
 +{
 +	return platform_device_register(&db1xxx_pci_host_dev);
 +}
 +/* must be arch_initcall; MIPS PCI scans busses in a subsys_initcall */
 +arch_initcall(db15x0_pci_init);
 +#endif
 +
 +#ifdef CONFIG_MIPS_DB1100
 +static struct resource au1100_lcd_resources[] = {
 +	[0] = {
 +		.start	= AU1100_LCD_PHYS_ADDR,
 +		.end	= AU1100_LCD_PHYS_ADDR + 0x800 - 1,
 +		.flags	= IORESOURCE_MEM,
 +	},
 +	[1] = {
 +		.start	= AU1100_LCD_INT,
 +		.end	= AU1100_LCD_INT,
 +		.flags	= IORESOURCE_IRQ,
 +	}
 +};
 +
 +static u64 au1100_lcd_dmamask = DMA_BIT_MASK(32);
 +
 +static struct platform_device au1100_lcd_device = {
 +	.name		= "au1100-lcd",
 +	.id		= 0,
 +	.dev = {
 +		.dma_mask		= &au1100_lcd_dmamask,
 +		.coherent_dma_mask	= DMA_BIT_MASK(32),
 +	},
 +	.num_resources	= ARRAY_SIZE(au1100_lcd_resources),
 +	.resource	= au1100_lcd_resources,
 +};
 +#endif
 +
+ static struct resource alchemy_ac97c_res[] = {
+ 	[0] = {
+ 		.start	= AU1000_AC97_PHYS_ADDR,
+ 		.end	= AU1000_AC97_PHYS_ADDR + 0xfff,
+ 		.flags	= IORESOURCE_MEM,
+ 	},
+ 	[1] = {
+ 		.start	= DMA_ID_AC97C_TX,
+ 		.end	= DMA_ID_AC97C_TX,
+ 		.flags	= IORESOURCE_DMA,
+ 	},
+ 	[2] = {
+ 		.start	= DMA_ID_AC97C_RX,
+ 		.end	= DMA_ID_AC97C_RX,
+ 		.flags	= IORESOURCE_DMA,
+ 	},
+ };
+ 
+ static struct platform_device alchemy_ac97c_dev = {
+ 	.name		= "alchemy-ac97c",
+ 	.id		= -1,
+ 	.resource	= alchemy_ac97c_res,
+ 	.num_resources	= ARRAY_SIZE(alchemy_ac97c_res),
+ };
+ 
+ static struct platform_device alchemy_ac97c_dma_dev = {
+ 	.name		= "alchemy-pcm-dma",
+ 	.id		= 0,
+ };
+ 
+ static struct platform_device db1x00_codec_dev = {
+ 	.name		= "ac97-codec",
+ 	.id		= -1,
+ };
+ 
+ static struct platform_device db1x00_audio_dev = {
+ 	.name		= "db1000-audio",
+ };
+ 
  static int __init db1xxx_dev_init(void)
  {
  #ifdef DB1XXX_HAS_PCMCIA
 -	db1x_register_pcmcia_socket(PCMCIA_ATTR_PHYS_ADDR,
 -				    PCMCIA_ATTR_PHYS_ADDR + 0x000400000 - 1,
 -				    PCMCIA_MEM_PHYS_ADDR,
 -				    PCMCIA_MEM_PHYS_ADDR  + 0x000400000 - 1,
 -				    PCMCIA_IO_PHYS_ADDR,
 -				    PCMCIA_IO_PHYS_ADDR   + 0x000010000 - 1,
 -				    DB1XXX_PCMCIA_CARD0,
 -				    DB1XXX_PCMCIA_CD0,
 -				    /*DB1XXX_PCMCIA_STSCHG0*/0,
 -				    0,
 -				    0);
 -
 -	db1x_register_pcmcia_socket(PCMCIA_ATTR_PHYS_ADDR + 0x004000000,
 -				    PCMCIA_ATTR_PHYS_ADDR + 0x004400000 - 1,
 -				    PCMCIA_MEM_PHYS_ADDR  + 0x004000000,
 -				    PCMCIA_MEM_PHYS_ADDR  + 0x004400000 - 1,
 -				    PCMCIA_IO_PHYS_ADDR   + 0x004000000,
 -				    PCMCIA_IO_PHYS_ADDR   + 0x004010000 - 1,
 -				    DB1XXX_PCMCIA_CARD1,
 -				    DB1XXX_PCMCIA_CD1,
 -				    /*DB1XXX_PCMCIA_STSCHG1*/0,
 -				    0,
 -				    1);
 +	db1x_register_pcmcia_socket(
 +		AU1000_PCMCIA_ATTR_PHYS_ADDR,
 +		AU1000_PCMCIA_ATTR_PHYS_ADDR + 0x000400000 - 1,
 +		AU1000_PCMCIA_MEM_PHYS_ADDR,
 +		AU1000_PCMCIA_MEM_PHYS_ADDR  + 0x000400000 - 1,
 +		AU1000_PCMCIA_IO_PHYS_ADDR,
 +		AU1000_PCMCIA_IO_PHYS_ADDR   + 0x000010000 - 1,
 +		DB1XXX_PCMCIA_CARD0, DB1XXX_PCMCIA_CD0,
 +		/*DB1XXX_PCMCIA_STSCHG0*/0, 0, 0);
 +
 +	db1x_register_pcmcia_socket(
 +		AU1000_PCMCIA_ATTR_PHYS_ADDR + 0x004000000,
 +		AU1000_PCMCIA_ATTR_PHYS_ADDR + 0x004400000 - 1,
 +		AU1000_PCMCIA_MEM_PHYS_ADDR  + 0x004000000,
 +		AU1000_PCMCIA_MEM_PHYS_ADDR  + 0x004400000 - 1,
 +		AU1000_PCMCIA_IO_PHYS_ADDR   + 0x004000000,
 +		AU1000_PCMCIA_IO_PHYS_ADDR   + 0x004010000 - 1,
 +		DB1XXX_PCMCIA_CARD1, DB1XXX_PCMCIA_CD1,
 +		/*DB1XXX_PCMCIA_STSCHG1*/0, 0, 1);
 +#endif
 +#ifdef CONFIG_MIPS_DB1100
 +	platform_device_register(&au1100_lcd_device);
  #endif
  	db1x_register_norflash(BOARD_FLASH_SIZE, BOARD_FLASH_WIDTH, F_SWAPPED);
+ 
+ 	platform_device_register(&db1x00_codec_dev);
+ 	platform_device_register(&alchemy_ac97c_dma_dev);
+ 	platform_device_register(&alchemy_ac97c_dev);
+ 	platform_device_register(&db1x00_audio_dev);
+ 
  	return 0;
  }
  device_initcall(db1xxx_dev_init);
