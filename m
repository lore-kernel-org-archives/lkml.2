Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0GNCUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:20:19 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:58555 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754665Ab0GNCUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:20:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TJxnvZGBLaVhSmvr9qAxUoukuT/LJTAVe0Hkge46k1C4NgkYv7haWAEHiBeh/9guWMIen3CUToxzEpNW5njbrQDLoUSVafPTa1hOioVCpr9/hKJsSaGiOLr1oYRwzt23;
Date: Tue, 13 Jul 2010 19:19:58 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected: 
 de08e2c26
Message-ID: <20100713191958.260478c0@virtuousgeek.org>
In-Reply-To: <4C3D101E.5010605@candelatech.com>
References: <4C3D067C.10507@candelatech.com>
	<4C3D101E.5010605@candelatech.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 18:17:18 -0700
Ben Greear <greearb@candelatech.com> wrote:

> On 07/13/2010 05:36 PM, Ben Greear wrote:
> > We're seeing boot failures on multiple machines, running FC8 and
> > F11. I bisected on an FC8 32-bit system. Newer hardware works,
> > but these older ones do not.
> >
> > A console log of the hang is found later in this email.
> >
> > Please let me know if you would like any additional information,
> > and I will be happy to test patches.
> >
> > The same failure happens in 2.6.34.1, so the fix does not appear to
> > be in the stable tree yet.
> 
> 
> I added some printks to the offending code.  It seems the problem
> is that the fixed_bar_cap method in arch/x86/pci/mrst.c loops forever:
> 
> # Endless loop of this spewing to console...
> 
> pcie_cap: 268435456Checking vendor..
> pos after shift: 256
> Before read..
> pcie_cap: 268435456Checking vendor..
> pos after shift: 256
> Before read..
> pcie_cap: 268435456Checking vendor..
> pos after shift: 256
> Before read..
> pcie_cap: 268435456Checking vendor..
> pos after shift: 256
> Before read..
> pcie_cap: 268435456Checking vendor..
> pos after shift: 256
> Before read..
> pcie_cap: 268435456Checking vendor..
> 
> 
> static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
> {
> 	int pos;
> 	u32 pcie_cap = 0, cap_data;
> 	printk("fixed_bar_cap, bus: %p  devfn: %u\n", bus, devfn);
> 	pos = PCIE_CAP_OFFSET;
> 	while (pos) {
> 		printk("Before read..\n");
> 		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
> 					  devfn, pos, 4, &pcie_cap))
> 			return 0;
> 		printk("pcie_cap: %u", pcie_cap);
> 		
> 		if (pcie_cap == 0xffffffff)
> 			return 0;
> 
> 		printk("Checking vendor..\n");
> 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
> 			printk("reading domain_nr\n");
> 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
> 					      devfn, pos + 4, 4, &cap_data);
> 			printk("cap_data: %u\n", cap_data);
> 			if ((cap_data & 0xffff) == PCIE_VNDR_CAP_ID_FIXED_BAR)
> 				return pos;
> 		}
> 
> 		pos = pcie_cap >> 20;
> 		printk("pos after shift: %i\n", pos);
> 	}
> 
> 	printk("Returning from fixed_bar_cap\n");
> 	return 0;
> }
> 
> 

I thought a related bug was fixed already; the code should be returning
all zeros for non-existent BAR reads.

-- 
Jesse Barnes, Intel Open Source Technology Center
