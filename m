Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab0CZCYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:24:31 -0400
Received: from daleenterprise.com ([67.78.11.229]:56652 "EHLO
	daleenterprise.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0CZCYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:24:30 -0400
X-Greylist: delayed 1341 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 22:24:30 EDT
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Transfer-Encoding: 7bit
Message-Id: <22829ADB-1F3C-4DC4-83A9-F3E9F37DAA35@macftphttp.serverbox.org>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: websrvr <websrvr@macftphttp.serverbox.org>
Subject: nVidia related rom issue.
Date: Thu, 25 Mar 2010 22:02:05 -0400
X-Mailer: Apple Mail (2.752.2)
MTA-Interface: amavisd-new-2.3.3 (2005-08-22) + Maia Mailguard 1.0.1 at daleenterprise.com
X-Spam-Scanned: using SpamAssassin 3.1.7 (2006-10-05) at daleenterprise.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm hoping that someone here can help me with an issue I'm having.

First, this is not specifically linux kernel related but an  
integration of some of the linux code in a boot loader.

I don't have all the structs used in the kernel and most of the  
functions don't exist (some I have ported over) however I do believe  
I have the basics minimum requirements.

The specific issue I'm having is when a system contains more than one  
nvidia card, I am unable to obtain a copy of the rom for the  
additional card which is needed for patching and to extract and  
provide some data for the OS to utilize.

I currently grab all of the base regs (0..5), their type, mask and  
size and save them in a struct (in case they are needed).

I have implemented the nv_rd08, nv_rd32, nv_wr08 and nv_wr32  
functions which I deciphered back to the build_mmio_read and  
build_mmio_write macro's which I have added and they do work.

I can verify that my implementation of load_vbios_pramin() and  
load_vbios_prom() work for the primary card (depending on it's type)  
but the secondary card seems completely invisible and is preventing  
multi-card support.

I have a 7300 GS which uses the load_vbios_prom() function (when it  
is the only card in the System) and a 9400GT which uses the  
load_vbios_pramin() function (when it is the only card in the System)  
but when 2 cards exist the second card is not enabled and I can't get  
the rom.

What do I need to do to make the second card visible or at least  
extract it's rom?


some code which might help show what I've got so far.

++++++++++++++++

void load_vbios_pci(pci_dt_t *dev, uint8_t *data)
{
     if (pci_config_read16(dev->dev.addr, PCI_COMMAND) &  
(PCI_COMMAND_IO | PCI_COMMAND_MEMORY))
     {
         // primary video is shadowed at 0x000C0000
         bcopy((char *)0x000C0000, data, NV_PROM_SIZE);
         return;
     }

     /* try to shadow second card at 0xD0000 - I also tried 0xC0000  
which didn't work */
     uint32_t use_addr = 0x000D0000 | IORESOURCE_ROM_ENABLE |  
IORESOURCE_ROM_SHADOW /*| IORESOURCE_ROM_COPY*/;
     pci_config_write32(dev->dev.addr, PCI_ROM_ADDRESS, use_addr );

     bcopy((char *)0x000D0000, data, NV_PROM_SIZE);

     /* restore state */
     uint32_t rom_addr = pci_config_read32(dev->dev.addr,  
PCI_ROM_ADDRESS) & PCI_ROM_ADDRESS_MASK;
     pci_config_write32(dev->dev.addr, PCI_ROM_ADDRESS, rom_addr);
}

++++++++++++++++

typedef struct {
     uint32_t        :2;
     uint32_t    reg :6;
     uint32_t    func:3;
     uint32_t    dev :5;
     uint32_t    bus :8;
     uint32_t        :7;
     uint32_t    eb  :1;
} pci_addr_t;

typedef union {
     pci_addr_t  bits;
     uint32_t    addr;
} pci_dev_t;

typedef struct pci_dt_t {
     pci_dev_t   dev;

     uint16_t    vendor_id;
     uint16_t    device_id;
     uint16_t    subsys_vendor_id;
     uint16_t    subsys_device_id;
     uint16_t    class_id;
     uint8_t     header_type;
     uint8_t     card_type;
     uint8_t     chipset;
     uint32_t    base_reg_0;
     uint32_t    base_size_0;
     uint32_t    base_mask_0;
     uint8_t     base_type_0;
     uint32_t    base_reg_1;
     uint32_t    base_size_1;
     uint32_t    base_mask_1;
     uint8_t     base_type_1;
     uint32_t    base_reg_2;
     uint32_t    base_size_2;
     uint32_t    base_mask_2;
     uint8_t     base_type_2;
     uint32_t    base_reg_3;
     uint32_t    base_size_3;
     uint32_t    base_mask_3;
     uint8_t     base_type_3;
     uint32_t    base_reg_4;
     uint32_t    base_size_4;
     uint32_t    base_mask_4;
     uint8_t     base_type_4;
     uint32_t    base_reg_5;
     uint32_t    base_size_5;
     uint32_t    base_mask_5;
     uint8_t     base_type_5;

     struct pci_dt_t    *parent;
     struct pci_dt_t    *children;
     struct pci_dt_t    *next;
} pci_dt_t;

