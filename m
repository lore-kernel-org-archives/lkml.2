Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab0GNTBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:01:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:41314 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0GNTBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,203,1278313200"; 
   d="scan'208";a="818138136"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Greear <greearb@candelatech.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 14 Jul 2010 12:01:04 -0700
Subject: RE: Regression:  2.6.34 boot fails on E5405 system, bisected:
  de08e2c26
Thread-Topic: Regression:  2.6.34 boot fails on E5405 system, bisected:
  de08e2c26
Thread-Index: Acsjhqzl8+1PTdkwRt2Xv4eNAau1FQAAAtMQ
Message-ID: <43F901BD926A4E43B106BF17856F0755EA8EEA9B@orsmsx508.amr.corp.intel.com>
References: <4C3D067C.10507@candelatech.com>
	<4C3D101E.5010605@candelatech.com>
	<20100713191958.260478c0@virtuousgeek.org>	<4C3E077C.9040609@zytor.com>
 <20100714115904.7004be74@virtuousgeek.org>
In-Reply-To: <20100714115904.7004be74@virtuousgeek.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org]
>Sent: Wednesday, July 14, 2010 11:59 AM
>To: H. Peter Anvin
>Cc: Ben Greear; linux-kernel; Pan, Jacob jun
>Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected:
>de08e2c26
>
>On Wed, 14 Jul 2010 11:52:44 -0700
>"H. Peter Anvin" <hpa@zytor.com> wrote:
>
>> So I suggest the following changes...
>>
>> On 07/13/2010 07:19 PM, Jesse Barnes wrote:
>> >>
>> >> static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
>> >> {
>> >> 	int pos;
>> >> 	u32 pcie_cap = 0, cap_data;
>> >> 	printk("fixed_bar_cap, bus: %p  devfn: %u\n", bus, devfn);
>> >> 	pos = PCIE_CAP_OFFSET;
>> >> 	while (pos) {
>>
>> while (pos >= PCIE_CAP_OFFSET) {
>>
>> >> 		printk("Before read..\n");
>> >> 		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
>> >> 					  devfn, pos, 4, &pcie_cap))
>> >> 			return 0;
>> >> 		printk("pcie_cap: %u", pcie_cap);
>> >>
>>    -		if (pcie_cap == 0xffffffff)
>>    -			return 0;
>>
>>    +		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
>>    +		    PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
>>    +			break;
>>
>> >> 		printk("Checking vendor..\n");
>>
>> >> 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
>> >> 			printk("reading domain_nr\n");
>> >> 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
>> >> 					      devfn, pos + 4, 4, &cap_data);
>> >> 			printk("cap_data: %u\n", cap_data);
>> >> 			if ((cap_data & 0xffff) == PCIE_VNDR_CAP_ID_FIXED_BAR)
>> >> 				return pos;
>> >> 		}
>> >>
>> >> 		pos = pcie_cap >> 20;
>>
>> 		pos = (pcie_cap >> 20) & 0xffc;
>>
>> >> 		printk("pos after shift: %i\n", pos);
>> >> 	}
>> >>
>> >> 	printk("Returning from fixed_bar_cap\n");
>> >> 	return 0;
>> >> }
>> >>
>> >>
>> >
>> > I thought a related bug was fixed already; the code should be
>returning
>> > all zeros for non-existent BAR reads.
>
>Changes look ok to me, though I'd prefer not hitting this code at all
>on non-Moorestown if at all possible.

Can we use PCI_EXT_CAP_NEXT to replace this line?
pos = (pcie_cap >> 20) & 0xffc
