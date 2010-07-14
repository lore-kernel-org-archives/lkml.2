Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0GNBRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 21:17:20 -0400
Received: from mail.candelatech.com ([208.74.158.172]:44837 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0GNBRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 21:17:19 -0400
Message-ID: <4C3D101E.5010605@candelatech.com>
Date: Tue, 13 Jul 2010 18:17:18 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
        jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com>
In-Reply-To: <4C3D067C.10507@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:36 PM, Ben Greear wrote:
> We're seeing boot failures on multiple machines, running FC8 and
> F11. I bisected on an FC8 32-bit system. Newer hardware works,
> but these older ones do not.
>
> A console log of the hang is found later in this email.
>
> Please let me know if you would like any additional information,
> and I will be happy to test patches.
>
> The same failure happens in 2.6.34.1, so the fix does not appear to
> be in the stable tree yet.


I added some printks to the offending code.  It seems the problem
is that the fixed_bar_cap method in arch/x86/pci/mrst.c loops forever:

# Endless loop of this spewing to console...

pcie_cap: 268435456Checking vendor..
pos after shift: 256
Before read..
pcie_cap: 268435456Checking vendor..
pos after shift: 256
Before read..
pcie_cap: 268435456Checking vendor..
pos after shift: 256
Before read..
pcie_cap: 268435456Checking vendor..
pos after shift: 256
Before read..
pcie_cap: 268435456Checking vendor..
pos after shift: 256
Before read..
pcie_cap: 268435456Checking vendor..


static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
{
	int pos;
	u32 pcie_cap = 0, cap_data;
	printk("fixed_bar_cap, bus: %p  devfn: %u\n", bus, devfn);
	pos = PCIE_CAP_OFFSET;
	while (pos) {
		printk("Before read..\n");
		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
					  devfn, pos, 4, &pcie_cap))
			return 0;
		printk("pcie_cap: %u", pcie_cap);
		
		if (pcie_cap == 0xffffffff)
			return 0;

		printk("Checking vendor..\n");
		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
			printk("reading domain_nr\n");
			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
					      devfn, pos + 4, 4, &cap_data);
			printk("cap_data: %u\n", cap_data);
			if ((cap_data & 0xffff) == PCIE_VNDR_CAP_ID_FIXED_BAR)
				return pos;
		}

		pos = pcie_cap >> 20;
		printk("pos after shift: %i\n", pos);
	}

	printk("Returning from fixed_bar_cap\n");
	return 0;
}


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

