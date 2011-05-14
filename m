Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab1ENBGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 21:06:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63801 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab1ENBGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 21:06:35 -0400
Message-ID: <4DCDD589.8010309@kernel.org>
Date: Fri, 13 May 2011 18:06:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource allocation.
References: <20110506081243.GF16782@ram-laptop>	<4DC4586C.6020308@kernel.org>	<20110507015240.GN16782@ram-laptop>	<4DC4B059.3030502@kernel.org>	<4DC64C58.70203@kernel.org>	<20110509142014.617e3100@jbarnes-desktop>	<BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com>	<4DC9E415.5010402@kernel.org>	<20110512180638.GA5012@ram-laptop>	<BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>	<20110512182229.GQ8195@ram-laptop>	<20110512113726.123fd85b@jbarnes-desktop>	<BANLkTikt_oWhYHZwVMnrxvow4j+zkPuFCQ@mail.gmail.com> <20110512123412.64e9b4cc@jbarnes-desktop>
In-Reply-To: <20110512123412.64e9b4cc@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4DCDD594.004D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 12:34 PM, Jesse Barnes wrote:
> On Thu, 12 May 2011 12:18:43 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Thu, May 12, 2011 at 11:37 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>>
>>> Linus, I don't have anything else queued up, so you may as well take
>>> this one directly if you want it in 2.6.39.  It's a regression fix, but
>>> resource changes always make me nervous.  Alternately, I could put it
>>> into 2.6.40 instead, the backport to 2.6.39.x if it survives until
>>> 2.6.40-rc2 or so...
>>
>> Considering the trouble resource allocation always ends up being, I'd
>> almost prefer that "mark it for stable and put it in the 2.6.40
>> queue".
>>
>> Afaik this problem hasn't actually hit any "normal" users, has it? So ...
> 
> Sounds good, thanks.  Yeah I don't think it's hit anyone but Yinghai
> (at least I don't know of any other reports).
> 

please check this one, it should be safe for 2.6.39 ?

Thanks

Yinghai

[PATCH -v3] PCI: Clear bridge resource flags if requested size is 0

During pci remove/rescan testing found:

[  541.141614] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
[  541.141965] pci 0000:c0:03.0:   bridge window [io  0x1000-0x0fff]
[  541.159181] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
[  541.159540] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
[  541.179374] pci 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
[  541.199198] pci 0000:c0:03.0: Error enabling bridge (-22), continuing
[  541.199202] pci 0000:c0:03.0: enabling bus mastering
[  541.199209] pci 0000:c0:03.0: setting latency timer to 64
[  541.199917] pcieport 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
[  541.199963] pcieport: probe of 0000:c0:03.0 failed with error -22

This bug was caused by commit
| commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
| Author: Ram Pai <linuxram@us.ibm.com>
| Date:   Mon Feb 14 17:43:20 2011 -0800
|
|    PCI: pre-allocate additional resources to devices only after successful allocation of essential resources.

After that commit, pci_hotplug_io_size is changed to additional_io_size from
minium size.
So it will not go through resource_size(res) != 0 path,  and will not be reset.

The root cause is: pci_bridge_check_ranges will set RESOURCE_IO flag for pci
bridge, and later if children do not need IO resource. those bridge
resources will not need to be allocated. but flags is still there. that will
confuse the the pci_enable_bridges later.

related code:
| static void assign_requested_resources_sorted(struct resource_list *head,
|                                  struct resource_list_x *fail_head)
| {
|         struct resource *res;
|         struct resource_list *list;
|         int idx;
|
|         for (list = head->next; list; list = list->next) {
|                 res = list->res;
|                 idx = res - &list->dev->resource[0];
|                 if (resource_size(res) && pci_assign_resource(list->dev, idx)) {
| ...
|                         reset_resource(res);
|                 }
|         }
| }

At last, We have to clear the flags in pbus_size_mem/io when requested size == 0 and !add_head.
becasue this case it will not go through adjust_resources_sorted().

just make size1 = size0 when !add_head. it will make flags get cleared.

At the same time when requested size == 0, add_size != 0, will still have in head and add_list.
because we do not clear the flags for it.

after patch, will get right result:
[  621.206655] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
[  621.206912] pci 0000:c0:03.0:   bridge window [io  disabled]
[  621.226594] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
[  621.226904] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
[  621.247012] pci 0000:c0:03.0: enabling bus mastering
[  621.247275] pci 0000:c0:03.0: setting latency timer to 64
[  621.267656] pcieport 0000:c0:03.0: setting latency timer to 64
[  621.268134] pcieport 0000:c0:03.0: irq 160 for MSI/MSI-X
[  621.286832] pcieport 0000:c0:03.0: Signaling PME through PCIe PME interrupt
[  621.306360] pci 0000:c4:00.0: Signaling PME through PCIe PME interrupt
[  621.306684] pcie_pme 0000:c0:03.0:pcie01: service driver pcie_pme loaded
[  621.326512] aer 0000:c0:03.0:pcie02: service driver aer loaded
[  621.326911] pciehp 0000:c0:03.0:pcie04: Hotplug Controller:

v3: more simple fix. also fix one typo in pbus_size_mem

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -579,7 +579,7 @@ static void pbus_size_io(struct pci_bus
 	}
 	size0 = calculate_iosize(size, min_size, size1,
 			resource_size(b_res), 4096);
-	size1 = !add_size? size0:
+	size1 = (!add_head || (add_head && !add_size)) ? size0 :
 		calculate_iosize(size, min_size+add_size, size1,
 			resource_size(b_res), 4096);
 	if (!size0 && !size1) {
@@ -677,7 +677,7 @@ static int pbus_size_mem(struct pci_bus
 		align += aligns[order];
 	}
 	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), min_align);
-	size1 = !add_size ? size :
+	size1 = (!add_head || (add_head && !add_size)) ? size0 :
 		calculate_memsize(size, min_size+add_size, 0,
 				resource_size(b_res), min_align);
 	if (!size0 && !size1) {
