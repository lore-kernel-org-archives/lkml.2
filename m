Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2K3L1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:27:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36106 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2K3L1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:27:18 -0500
Date: Fri, 30 Nov 2012 12:27:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 v8] AMD64 EDAC: Fix PCI function lookup
Message-ID: <20121130112714.GC6869@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 04:44:19PM +0800, Daniel J Blueman wrote:
> Fix locating sibling memory controller PCI functions by using the
> correct PCI domain and use Northbridge only if found. Tested on
> multi-socket server and multi-server, multi-socket NumaConnect setup.
> 
> v7: Refactor patches grouping changes
> v8: Restructure searching for PCI function for clarity; use Northbridge
>     only if found
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>

Ok, looks good. I ended up cleaning it up the code for F15h a bit and
fixing it up. Here's the final version:

--
commit 75cdc74742bbf368dfc52bb5041274c95d85a68f
Author: Daniel J Blueman <daniel@numascale-asia.com>
Date:   Fri Nov 30 16:44:19 2012 +0800

    amd64_edac: Fix PCI function lookup
    
    Fix locating sibling memory controller PCI functions by using the
    correct PCI domain and use a northbridge descriptor only if found. We
    need to at least warn if it wasn't found so that it gets fixed and we
    don't go off with wrong results.
    
    Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
    [Boris: remove wrong comment, sanitize code and warn if NB desc lookup fails]
    Signed-off-by: Borislav Petkov <bp@alien8.de>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 60e93faaea18..e22a35224841 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -983,10 +983,29 @@ static u64 get_error_address(struct mce *m)
 	return addr;
 }
 
+static struct pci_dev *pci_get_related_function(unsigned int vendor,
+						unsigned int device,
+						struct pci_dev *related)
+{
+	struct pci_dev *dev = NULL;
+
+	while ((dev = pci_get_device(vendor, device, dev))) {
+		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
+		    (dev->bus->number == related->bus->number) &&
+		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
+			break;
+	}
+
+	return dev;
+}
+
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
+	struct amd_northbridge *nb;
+	struct pci_dev *misc, *f1 = NULL;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 	int off = range << 3;
+	u32 llim;
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_LO + off,  &pvt->ranges[range].base.lo);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_LO + off, &pvt->ranges[range].lim.lo);
@@ -1000,30 +1019,32 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_HI + off,  &pvt->ranges[range].base.hi);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_HI + off, &pvt->ranges[range].lim.hi);
 
-	/* Factor in CC6 save area by reading dst node's limit reg */
-	if (c->x86 == 0x15) {
-		struct pci_dev *f1 = NULL;
-		u8 nid = dram_dst_node(pvt, range);
-		u32 llim;
+	/* F15h: factor in CC6 save area by reading dst node's limit reg */
+	if (c->x86 != 0x15)
+		return;
 
-		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
-		if (WARN_ON(!f1))
-			return;
+	nb = node_to_amd_nb(dram_dst_node(pvt, range));
+	if (WARN_ON(!nb))
+		return;
 
-		amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
+	misc = nb->misc;
+	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
+	if (WARN_ON(!f1))
+		return;
 
-		pvt->ranges[range].lim.lo &= GENMASK(0, 15);
+	amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
 
-					    /* {[39:27],111b} */
-		pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
+	pvt->ranges[range].lim.lo &= GENMASK(0, 15);
 
-		pvt->ranges[range].lim.hi &= GENMASK(0, 7);
+				    /* {[39:27],111b} */
+	pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
 
-					    /* [47:40] */
-		pvt->ranges[range].lim.hi |= llim >> 13;
+	pvt->ranges[range].lim.hi &= GENMASK(0, 7);
 
-		pci_dev_put(f1);
-	}
+				    /* [47:40] */
+	pvt->ranges[range].lim.hi |= llim >> 13;
+
+	pci_dev_put(f1);
 }
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
@@ -1713,23 +1734,6 @@ static struct amd64_family_type amd64_family_types[] = {
 	},
 };
 
-static struct pci_dev *pci_get_related_function(unsigned int vendor,
-						unsigned int device,
-						struct pci_dev *related)
-{
-	struct pci_dev *dev = NULL;
-
-	dev = pci_get_device(vendor, device, dev);
-	while (dev) {
-		if ((dev->bus->number == related->bus->number) &&
-		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
-			break;
-		dev = pci_get_device(vendor, device, dev);
-	}
-
-	return dev;
-}
-
 /*
  * These are tables of eigenvectors (one per line) which can be used for the
  * construction of the syndrome tables. The modified syndrome search algorithm

-- 
Regards/Gruss,
    Boris.
