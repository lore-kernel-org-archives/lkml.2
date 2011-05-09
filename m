Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1EIVU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:20:26 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35725 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754440Ab1EIVUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:20:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rl395ZokoFSecPeuzH1PJEtlseaedG49PVbN/N29GoijeFwFZmZfpEo+4itbJ77ZWrHgrK6Nvjo98R3Jw/dMw4rboN5bIXFM8PntrhzB+nt6SGaqmnqa8FTF1pdoFjwI;
Date: Mon, 9 May 2011 14:20:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource
 allocation.
Message-ID: <20110509142014.617e3100@jbarnes-desktop>
In-Reply-To: <4DC64C58.70203@kernel.org>
References: <4DC250A6.9040802@kernel.org>
	<20110506081243.GF16782@ram-laptop>
	<4DC4586C.6020308@kernel.org>
	<20110507015240.GN16782@ram-laptop>
	<4DC4B059.3030502@kernel.org>
	<4DC64C58.70203@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 May 2011 00:55:04 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> During pci remove/rescan testing found:
> 
> [  541.141614] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
> [  541.141965] pci 0000:c0:03.0:   bridge window [io  0x1000-0x0fff]
> [  541.159181] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
> [  541.159540] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
> [  541.179374] pci 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
> [  541.199198] pci 0000:c0:03.0: Error enabling bridge (-22), continuing
> [  541.199202] pci 0000:c0:03.0: enabling bus mastering
> [  541.199209] pci 0000:c0:03.0: setting latency timer to 64
> [  541.199917] pcieport 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
> [  541.199963] pcieport: probe of 0000:c0:03.0 failed with error -22
> 
> This bug was uncovered by commit
> | commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
> | Author: Ram Pai <linuxram@us.ibm.com>
> | Date:   Mon Feb 14 17:43:20 2011 -0800
> |
> |    PCI: pre-allocate additional resources to devices only after successful allocation of essential resources.
> 
> After that commit, pci_hotplug_io_size is changed to additional_io_size from minium size.
> So it will not go through resource_size(res) != 0 path,  and will not be reset there.
> 
> The root cause is: pci_bridge_check_ranges will set RESOURCE_IO flag for pci
> bridge, and later if children do not need IO resource. those bridge
> resources will not need to be allocated. but flags is still there. that will
> confuse the the pci_enable_bridges later.
> 
> related code:
> | static void assign_requested_resources_sorted(struct resource_list *head,
> |                                  struct resource_list_x *fail_head)
> | {
> |         struct resource *res;
> |         struct resource_list *list;
> |         int idx;
> |
> |         for (list = head->next; list; list = list->next) {
> |                 res = list->res;
> |                 idx = res - &list->dev->resource[0];
> |                 if (resource_size(res) && pci_assign_resource(list->dev, idx)) {
> | ...
> |                         reset_resource(res);
> |                 }
> |         }
> | }
> 
> We can not just reset resource there, because will still need to use flag for addition resource allocation afterwards.
> 
> At last, We have to add pci_bridge_check_resources() to close the loop.
> 
> after patch, will get right result:
> [  621.206655] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
> [  621.206912] pci 0000:c0:03.0:   bridge window [io  disabled]
> [  621.226594] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
> [  621.226904] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
> [  621.247012] pci 0000:c0:03.0: enabling bus mastering
> [  621.247275] pci 0000:c0:03.0: setting latency timer to 64
> [  621.267656] pcieport 0000:c0:03.0: setting latency timer to 64
> [  621.268134] pcieport 0000:c0:03.0: irq 160 for MSI/MSI-X
> [  621.286832] pcieport 0000:c0:03.0: Signaling PME through PCIe PME interrupt
> [  621.306360] pci 0000:c4:00.0: Signaling PME through PCIe PME interrupt
> [  621.306684] pcie_pme 0000:c0:03.0:pcie01: service driver pcie_pme loaded
> [  621.326512] aer 0000:c0:03.0:pcie02: service driver aer loaded
> [  621.326911] pciehp 0000:c0:03.0:pcie04: Hotplug Controller:
> 
> -v2: update description.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Why do I keep getting the feeling that our resource handling code is
made of duct tape and bailing wire?  The fact that we can't just clear
the resource and the flag where we discover the allocation failure
suggests that maybe we should be splitting our bus and device
allocation code a bit more.

Clearly we don't want to allocate resources (especially scarce ones
like I/O space) when we don't actually need them, but I think it's
going to be tough to handle all supported cases without real resource
move support in the core and drivers.

That said, if this doesn't break other cases I guess it's a fairly
minimal fix.

Linus?  Bjorn?  Ram?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
