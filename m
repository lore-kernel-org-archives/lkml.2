Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab0GNSws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:52:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48710 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab0GNSwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:52:47 -0400
Message-ID: <4C3E077C.9040609@zytor.com>
Date: Wed, 14 Jul 2010 11:52:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ben Greear <greearb@candelatech.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com> <20100713191958.260478c0@virtuousgeek.org>
In-Reply-To: <20100713191958.260478c0@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I suggest the following changes...

On 07/13/2010 07:19 PM, Jesse Barnes wrote:
>>
>> static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
>> {
>> 	int pos;
>> 	u32 pcie_cap = 0, cap_data;
>> 	printk("fixed_bar_cap, bus: %p  devfn: %u\n", bus, devfn);
>> 	pos = PCIE_CAP_OFFSET;
>> 	while (pos) {

while (pos >= PCIE_CAP_OFFSET) {

>> 		printk("Before read..\n");
>> 		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
>> 					  devfn, pos, 4, &pcie_cap))
>> 			return 0;
>> 		printk("pcie_cap: %u", pcie_cap);
>> 		
   -		if (pcie_cap == 0xffffffff)
   -			return 0;
		
   +		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
   +		    PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
   +			break;
		
>> 		printk("Checking vendor..\n");

>> 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
>> 			printk("reading domain_nr\n");
>> 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
>> 					      devfn, pos + 4, 4, &cap_data);
>> 			printk("cap_data: %u\n", cap_data);
>> 			if ((cap_data & 0xffff) == PCIE_VNDR_CAP_ID_FIXED_BAR)
>> 				return pos;
>> 		}
>>
>> 		pos = pcie_cap >> 20;

		pos = (pcie_cap >> 20) & 0xffc;

>> 		printk("pos after shift: %i\n", pos);
>> 	}
>>
>> 	printk("Returning from fixed_bar_cap\n");
>> 	return 0;
>> }
>>
>>
> 
> I thought a related bug was fixed already; the code should be returning
> all zeros for non-existent BAR reads.
> 

