Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0GNT1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:27:52 -0400
Received: from mail.candelatech.com ([208.74.158.172]:53010 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0GNT1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:27:51 -0400
Message-ID: <4C3E0FB4.8020500@candelatech.com>
Date: Wed, 14 Jul 2010 12:27:48 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com> <20100713191958.260478c0@virtuousgeek.org> <4C3E077C.9040609@zytor.com>
In-Reply-To: <4C3E077C.9040609@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 11:52 AM, H. Peter Anvin wrote:
> So I suggest the following changes...
>
> On 07/13/2010 07:19 PM, Jesse Barnes wrote:
>>>
>>> static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
>>> {
>>> 	int pos;
>>> 	u32 pcie_cap = 0, cap_data;
>>> 	printk("fixed_bar_cap, bus: %p  devfn: %u\n", bus, devfn);
>>> 	pos = PCIE_CAP_OFFSET;
>>> 	while (pos) {
>
> while (pos>= PCIE_CAP_OFFSET) {
>
>>> 		printk("Before read..\n");
>>> 		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
>>> 					  devfn, pos, 4,&pcie_cap))
>>> 			return 0;
>>> 		printk("pcie_cap: %u", pcie_cap);
>>> 		
>     -		if (pcie_cap == 0xffffffff)
>     -			return 0;
> 		
>     +		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
>     +		    PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
>     +			break;

This seems to work for me.  I'm using this patch against
2.6.34.y:

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 1cdc02c..ee93fd0 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -61,13 +61,14 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
         if (!raw_pci_ext_ops)
                 return 0;

-       while (pos) {
+       while (pos >= PCIE_CAP_OFFSET) {
                 if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
                                           devfn, pos, 4, &pcie_cap))
                         return 0;

-               if (pcie_cap == 0xffffffff)
-                       return 0;
+               if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
+                   PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
+                       break;

                 if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
                         raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
@@ -76,7 +77,7 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
                                 return pos;
                 }

-               pos = pcie_cap >> 20;
+               pos = (pcie_cap >> 20) & 0xffc;
         }

         return 0;


Thanks,
Ben


> 		
>>> 		printk("Checking vendor..\n");
>
>>> 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
>>> 			printk("reading domain_nr\n");
>>> 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
>>> 					      devfn, pos + 4, 4,&cap_data);
>>> 			printk("cap_data: %u\n", cap_data);
>>> 			if ((cap_data&  0xffff) == PCIE_VNDR_CAP_ID_FIXED_BAR)
>>> 				return pos;
>>> 		}
>>>
>>> 		pos = pcie_cap>>  20;
>
> 		pos = (pcie_cap>>  20)&  0xffc;
>
>>> 		printk("pos after shift: %i\n", pos);
>>> 	}
>>>
>>> 	printk("Returning from fixed_bar_cap\n");
>>> 	return 0;
>>> }
>>>
>>>
>>
>> I thought a related bug was fixed already; the code should be returning
>> all zeros for non-existent BAR reads.
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

