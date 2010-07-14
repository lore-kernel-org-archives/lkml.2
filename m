Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab0GNS7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:59:25 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:33156 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754153Ab0GNS7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:59:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DIwbAAM36/fk1xG+8JNAeZ7JAq2gNetuLHmTmAGjXVAjKuFlGU5oEgbqLiInaVv4KO7PCJFhKPzxqM6Di9C0eF2NyGeTKzVPVijFMFJyB7PrrgxP8Q5ueElgfD3SzM3F;
Date: Wed, 14 Jul 2010 11:59:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Greear <greearb@candelatech.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected: 
 de08e2c26
Message-ID: <20100714115904.7004be74@virtuousgeek.org>
In-Reply-To: <4C3E077C.9040609@zytor.com>
References: <4C3D067C.10507@candelatech.com>
	<4C3D101E.5010605@candelatech.com>
	<20100713191958.260478c0@virtuousgeek.org>
	<4C3E077C.9040609@zytor.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 11:52:44 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> So I suggest the following changes...
> 
> On 07/13/2010 07:19 PM, Jesse Barnes wrote:
> >>
> >> static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
> >> {
> >> 	int pos;
> >> 	u32 pcie_cap = 0, cap_data;
> >> 	printk("fixed_bar_cap, bus: %p  devfn: %u\n", bus, devfn);
> >> 	pos = PCIE_CAP_OFFSET;
> >> 	while (pos) {
> 
> while (pos >= PCIE_CAP_OFFSET) {
> 
> >> 		printk("Before read..\n");
> >> 		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
> >> 					  devfn, pos, 4, &pcie_cap))
> >> 			return 0;
> >> 		printk("pcie_cap: %u", pcie_cap);
> >> 		
>    -		if (pcie_cap == 0xffffffff)
>    -			return 0;
> 		
>    +		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
>    +		    PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
>    +			break;
> 		
> >> 		printk("Checking vendor..\n");
> 
> >> 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
> >> 			printk("reading domain_nr\n");
> >> 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
> >> 					      devfn, pos + 4, 4, &cap_data);
> >> 			printk("cap_data: %u\n", cap_data);
> >> 			if ((cap_data & 0xffff) == PCIE_VNDR_CAP_ID_FIXED_BAR)
> >> 				return pos;
> >> 		}
> >>
> >> 		pos = pcie_cap >> 20;
> 
> 		pos = (pcie_cap >> 20) & 0xffc;
> 
> >> 		printk("pos after shift: %i\n", pos);
> >> 	}
> >>
> >> 	printk("Returning from fixed_bar_cap\n");
> >> 	return 0;
> >> }
> >>
> >>
> > 
> > I thought a related bug was fixed already; the code should be returning
> > all zeros for non-existent BAR reads.

Changes look ok to me, though I'd prefer not hitting this code at all
on non-Moorestown if at all possible.

-- 
Jesse Barnes, Intel Open Source Technology Center
