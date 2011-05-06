Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1EFUWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:22:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43986 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab1EFUWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:22:39 -0400
Message-ID: <4DC4586C.6020308@kernel.org>
Date: Fri, 06 May 2011 13:22:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] pci: Check bridge resources after resource allocation.
References: <4DC250A6.9040802@kernel.org> <20110506081243.GF16782@ram-laptop>
In-Reply-To: <20110506081243.GF16782@ram-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DC4586F.003D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2011 01:12 AM, Ram Pai wrote:
> On Thu, May 05, 2011 at 12:24:22AM -0700, Yinghai Lu wrote:
>>
>> During pci remove/rescan testing found:
>>
>> [  541.141614] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
>> [  541.141965] pci 0000:c0:03.0:   bridge window [io  0x1000-0x0fff]
>> [  541.159181] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
>> [  541.159540] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
>> [  541.179374] pci 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
>> [  541.199198] pci 0000:c0:03.0: Error enabling bridge (-22), continuing
>> [  541.199202] pci 0000:c0:03.0: enabling bus mastering
>> [  541.199209] pci 0000:c0:03.0: setting latency timer to 64
>> [  541.199917] pcieport 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
>> [  541.199963] pcieport: probe of 0000:c0:03.0 failed with error -22
>>
>> This bug was uncovered by commit
>> | commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
>> | Author: Ram Pai <linuxram@us.ibm.com>
>> | Date:   Mon Feb 14 17:43:20 2011 -0800
>> |
>> |    PCI: pre-allocate additional resources to devices only after successful allo
>> cation of essential resources.
>>
>> After that commit, pci_hotplug_io_size is changed to additional_io_size from minium size. So it will not get into failed list, and will not be reset there.
>>
>> The root cause is: pci_bridge_check_ranges will set RESOURCE_IO flag for pci
>> bridge, and later if children does not need to IO resource. those bridge
>> resources will not need to be allocated. but flags still there.
>>
>> Add pci_bridge_check_resources() to close the loop.
> 
> How about resetting the resource in  adjust_resources_sorted() if  call to
> adjust_resource() fails, and the resource is left with zero size?
> 
> Something like this:
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 8e73abf..77e8454 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -157,8 +157,11 @@ static void adjust_resources_sorted(struct resource_list_x *add_head,
>                          if(pci_assign_resource(list->dev, idx))
>                                 reset_resource(res);
>                 } else if (add_size) {
> -                       adjust_resource(res, res->start,
> -                               resource_size(res) + add_size);
> +                       if (adjust_resource(res, res->start,
> +                               resource_size(res) + add_size) && 
> +                               !resource_size(res)) {
> +                               reset_resource(res);
> +                       }
>                 }
>  out:
>                 tmp = list;
> 
> 

no, adjust_resource will not change resource size to zero.

also pci_assign_unassigned_bridge_resources ==> pci_bus_size_bridges, it will not take add_list. 

following patch works too.

[PATCH] pci: Using add_list in pcie hotplug path.

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

This bug was uncovered by commit
| commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
| Author: Ram Pai <linuxram@us.ibm.com>
| Date:   Mon Feb 14 17:43:20 2011 -0800
|
|    PCI: pre-allocate additional resources to devices only after successful allo
cation of essential resources.

After that commit, pci_hotplug_io_size is changed to additional_io_size from minium size.
So it will not get into failed list, and will not be reset there.

It turns out we need to add_head for those calling.
So those resource get reset properly.

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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -217,13 +217,14 @@ static void __assign_resources_sorted(st
 }
 
 static void pdev_assign_resources_sorted(struct pci_dev *dev,
+				 struct resource_list_x *add_head,
 				 struct resource_list_x *fail_head)
 {
 	struct resource_list head;
 
 	head.next = NULL;
 	__dev_sort_resources(dev, &head);
-	__assign_resources_sorted(&head, NULL, fail_head);
+	__assign_resources_sorted(&head, add_head, fail_head);
 
 }
 
@@ -852,17 +853,19 @@ void __ref pci_bus_assign_resources(cons
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
 static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
+					 struct resource_list_x *add_head,
 					 struct resource_list_x *fail_head)
 {
 	struct pci_bus *b;
 
-	pdev_assign_resources_sorted((struct pci_dev *)bridge, fail_head);
+	pdev_assign_resources_sorted((struct pci_dev *)bridge,
+					 add_head, fail_head);
 
 	b = bridge->subordinate;
 	if (!b)
 		return;
 
-	__pci_bus_assign_resources(b, NULL, fail_head);
+	__pci_bus_assign_resources(b, add_head, fail_head);
 
 	switch (bridge->class >> 8) {
 	case PCI_CLASS_BRIDGE_PCI:
@@ -1129,6 +1132,8 @@ enable_and_dump:
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 {
 	struct pci_bus *parent = bridge->subordinate;
+	struct resource_list_x add_list; /* list of resources that
+					want additional resources */
 	int tried_times = 0;
 	struct resource_list_x head, *list;
 	int retval;
@@ -1136,11 +1141,12 @@ void pci_assign_unassigned_bridge_resour
 				  IORESOURCE_PREFETCH;
 
 	head.next = NULL;
+	add_list.next = NULL;
 
 again:
-	pci_bus_size_bridges(parent);
-	__pci_bridge_assign_resources(bridge, &head);
-
+	__pci_bus_size_bridges(parent, &add_list);
+	__pci_bridge_assign_resources(bridge, &add_list, &head);
+	BUG_ON(add_list.next);
 	tried_times++;
 
 	if (!head.next)






