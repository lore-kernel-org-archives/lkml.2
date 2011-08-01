Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1HAKN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:13:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35138 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1HAKNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6SLCLxh6vOwLaj5AYXNLrUEtQgfMU_hFCKJVH1dC5neQ@mail.gmail.com>
References: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
	<1311852512-7340-2-git-send-email-dengcheng.zhu@gmail.com>
	<20110728115330.GA29899@linux-mips.org>
	<CAOfQC9-Z31SSv8agzxZ_hvPOOLY8p0F6yc1=o-QPbDwbNxavTg@mail.gmail.com>
	<CAErSpo6SLCLxh6vOwLaj5AYXNLrUEtQgfMU_hFCKJVH1dC5neQ@mail.gmail.com>
Date: Mon, 1 Aug 2011 18:13:49 +0800
Message-ID: <CAOfQC9-vT0F-atsuQ1DRg1cFMzRq3rjfa3hvsemLqnRCJedFkA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: make pci_claim_resource() work with conflict
 resources as appropriate
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Ralf Baechle <ralf@linux-mips.org>
Cc: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was found that PCI quirks claim resources (by calling pci_claim_resource())
*BEFORE* pcibios_fixup_bus() is called. In pcibios_fixup_bus(),
pci_bus->resource[0] for the root bus DOES point to msc_io_resource. If PCI
quirks do the resource claim after the arch-defined pcibios_fixup_bus() being
called, then the problem with Malta goes away.

So, it looks like 2 solutions out there:

1) To manage the call sequence. This seems not a desired one as it affects other
arches.

2) To raise the start point of the system controller's io_resource in
mips_pcibios_init() in arch/mips/mti-malta/malta-pci.c. This will place PCI
quirks' resources at the same level of the system controller's resources.

Ralf and Bjorn, which one sounds good to you?


Deng-Cheng


2011/7/30 Bjorn Helgaas <bhelgaas@google.com>:
> On Fri, Jul 29, 2011 at 12:32 AM, Deng-Cheng Zhu
> <dengcheng.zhu@gmail.com> wrote:
>> I noticed that at 79896cf42f Linus changed the function from insert_resource()
>> to request_resource() (and later evolved into request_resource_conflict()) and
>> he explained the reason. So, in the NIC's case, the problem is that in
>> pci_claim_resource() the function pci_find_parent_resource() returns the root
>> (0x0-0xffffff) rather than the MSC PCI I/O (0x1000-0xffffff).
>
> This seems like the real problem: PCI has the wrong idea of the
> resources available on bus 00.  The pci_bus->resource[0] for bus 00
> points to ioport_resource (the default put there by pci_create_bus()),
> when it should point to to msc_io_resource instead.
>
> Some architectures fill in the pci_bus->resource[] array directly for
> host bridges (for examples, try 'grep -r "resource\[0\] = " arch/').
> On x86 and ia64, we use pci_bus_remove_resources() and
> pci_bus_add_resource(), and I'd prefer that style for new code because
> it hides some ugly implementation details.
>
> I'm a little puzzled that we don't see this problem on more
> architectures.  The grep above only found a few arches that update the
> root bus resources.  I would expect most of the ones it didn't find to
> be broken the same way Malta is.
>
> Bjorn
>
