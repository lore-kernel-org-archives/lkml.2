Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab2HWSCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:02:18 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:47182 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2HWSCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:02:15 -0400
Date: Thu, 23 Aug 2012 12:02:13 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-pci@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 1/2] PCI: leave MEM and IO decoding disabled during
 64-bit BAR sizing, too
Message-ID: <20120823180213.GA31462@google.com>
References: <20120709181745.18165.93914.stgit@bhelgaas.mtv.corp.google.com>
 <20120709182018.18165.98339.stgit@bhelgaas.mtv.corp.google.com>
 <CAOesGMgUGUG9Z=x6ssumVkAxN6fHoeyAJ3-P8CoaNTGas7-vmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgUGUG9Z=x6ssumVkAxN6fHoeyAJ3-P8CoaNTGas7-vmg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:28:23AM -0700, Olof Johansson wrote:
> Hi,
> 
> On Mon, Jul 9, 2012 at 11:20 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > After 253d2e5498, we disable MEM and IO decoding for most devices while we
> > size 32-bit BARs.  However, we restore the original COMMAND register before
> > we size the upper 32 bits of 64-bit BARs, so we can still cause a conflict.
> >
> > This patch waits to restore the original COMMAND register until we're
> > completely finished sizing the BAR.
> >
> > Reference: https://lkml.org/lkml/2007/8/25/154
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> This patch causes boot lockup on PA Semi hardware, since it disables
> the bar on the UART that is used for console, and it has printks
> between the old and the new re-enable location. If I boot with 'debug'
> level for printk, I hit this. If I boot with just regular console
> args, I don't.
> 
> I'm guessing any other platform that uses MMIO-based UART on PCI for
> console will have similar issues. I can verify on Chrome OS x86
> hardware tomorrow if legacy powerpc isn't important enough to care
> about. :-)
> 
> I have no proposal for a fix for this. Can you please consider
> reverting for 3.6 unless someone has a better idea?

Thanks a lot for finding and debugging this!

Can you try the patch below?


commit cfc29ece86d648e63fb46de81b2bf8e3e107672c
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Thu Aug 23 10:53:08 2012 -0600

    PCI: Don't print anything while decoding is disabled
    
    If we try to print to the console device while its decoding is disabled,
    the system will hang.
    
    Reported-by: Olof Johansson <olof@lixom.net>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6c143b4..9f8a6b7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -144,15 +144,13 @@ static inline unsigned long decode_bar(struct pci_dev *dev, u32 bar)
 	case PCI_BASE_ADDRESS_MEM_TYPE_32:
 		break;
 	case PCI_BASE_ADDRESS_MEM_TYPE_1M:
-		dev_info(&dev->dev, "1M mem BAR treated as 32-bit BAR\n");
+		/* 1M mem BAR treated as 32-bit BAR */
 		break;
 	case PCI_BASE_ADDRESS_MEM_TYPE_64:
 		flags |= IORESOURCE_MEM_64;
 		break;
 	default:
-		dev_warn(&dev->dev,
-			 "mem unknown type %x treated as 32-bit BAR\n",
-			 mem_type);
+		/* mem unknown type treated as 32-bit BAR */
 		break;
 	}
 	return flags;
@@ -173,9 +171,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	u32 l, sz, mask;
 	u16 orig_cmd;
 	struct pci_bus_region region;
+	bool bar_too_big = false, bar_disabled = false;
 
 	mask = type ? PCI_ROM_ADDRESS_MASK : ~0;
 
+	/* No printks while decoding is disabled! */
 	if (!dev->mmio_always_on) {
 		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
 		pci_write_config_word(dev, PCI_COMMAND,
@@ -240,8 +240,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			goto fail;
 
 		if ((sizeof(resource_size_t) < 8) && (sz64 > 0x100000000ULL)) {
-			dev_err(&dev->dev, "reg %x: can't handle 64-bit BAR\n",
-				pos);
+			bar_too_big = true;
 			goto fail;
 		}
 
@@ -252,12 +251,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			region.start = 0;
 			region.end = sz64;
 			pcibios_bus_to_resource(dev, res, &region);
+			bar_disabled = true;
 		} else {
 			region.start = l64;
 			region.end = l64 + sz64;
 			pcibios_bus_to_resource(dev, res, &region);
-			dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n",
-				   pos, res);
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -268,18 +266,23 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		region.start = l;
 		region.end = l + sz;
 		pcibios_bus_to_resource(dev, res, &region);
-
-		dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n", pos, res);
 	}
 
- out:
+	goto out;
+
+
+fail:
+	res->flags = 0;
+out:
 	if (!dev->mmio_always_on)
 		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 
+	if (bar_too_big)
+		dev_err(&dev->dev, "reg %x: can't handle 64-bit BAR\n", pos);
+	if (res->flags && !bar_disabled)
+		dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n", pos, res);
+
 	return (res->flags & IORESOURCE_MEM_64) ? 1 : 0;
- fail:
-	res->flags = 0;
-	goto out;
 }
 
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
