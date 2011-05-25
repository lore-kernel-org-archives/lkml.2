Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1EYFpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:45:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40024 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1EYFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:45:53 -0400
Message-ID: <4DDC9775.7000802@kernel.org>
Date: Tue, 24 May 2011 22:45:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: David Woodhouse <dwmw2@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci, dmar: Update dmar units devices list during hotplug
References: <4DC6E569.1060808@kernel.org> <1305843308.3100.10.camel@x201>	 <1306234696.7218.14.camel@i7.infradead.org> <1306258959.3100.79.camel@x201>		  <4DDC0858.3090406@kernel.org> <1306267639.3100.102.camel@x201>	  <4DDC26FE.6070207@kernel.org> <1306276736.3100.107.camel@x201> <4DDC38FE.5010700@kernel.org>
In-Reply-To: <4DDC38FE.5010700@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DDC9782.0086,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 04:02 PM, Yinghai Lu wrote:
> On 05/24/2011 03:38 PM, Alex Williamson wrote:
>> On Tue, 2011-05-24 at 14:45 -0700, Yinghai Lu wrote:
>>> No, it does not work.
>>
>> I didn't say this wasn't without some effort, just thought it might give
>> you a jump start.
> 
> ok, let me debug it tonight.
> 
> looks like that pdev is not freed, but already get removed from the device tree.
> 
> may need to pass pci_dev pointer directly.
> 

keep getting:

[  784.364244] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
[  784.364253] in_atomic(): 0, irqs_disabled(): 1, pid: 29398, name: work_for_cpu
[  784.364259] INFO: lockdep is turned off.
[  784.364265] irq event stamp: 0
[  784.364271] hardirqs last  enabled at (0): [<          (null)>]           (null)
[  784.364282] hardirqs last disabled at (0): [<ffffffff8107ba5e>] copy_process+0x43b/0xd95
[  784.364305] softirqs last  enabled at (0): [<ffffffff8107ba5e>] copy_process+0x43b/0xd95
[  784.364318] softirqs last disabled at (0): [<          (null)>]           (null)
[  784.364332] Pid: 29398, comm: work_for_cpu Not tainted 2.6.39-tip-yh-06791-gb282579-dirty #1047
[  784.364339] Call Trace:
[  784.364375]  [<ffffffff810ad12a>] ? print_irqtrace_events+0xd0/0xd4
[  784.364392]  [<ffffffff81071572>] __might_sleep+0xf2/0xf6
[  784.364410]  [<ffffffff81c20fc0>] down_read+0x26/0x91
[  784.364429]  [<ffffffff8134c089>] pci_find_next_bus+0x45/0x75
[  784.364442]  [<ffffffff8134c0fa>] pci_find_bus+0x41/0x54
[  784.364457]  [<ffffffff8136263f>] dmar_get_scope_dev+0x2f/0xe3
[  784.364474]  [<ffffffff813353ad>] ? random32+0x19/0x1b
[  784.364488]  [<ffffffff8136273d>] dmar_match_scope+0x4a/0xb6
[  784.364502]  [<ffffffff813628d4>] dmar_find_matched_drhd_unit+0x55/0x6f
[  784.364519]  [<ffffffff81367018>] get_domain_for_dev.clone.2+0x103/0x392
[  784.364533]  [<ffffffff81367459>] __get_valid_domain_for_dev+0x14/0x88
[  784.364546]  [<ffffffff813676c5>] __intel_map_single+0x58/0x174
[  784.364559]  [<ffffffff813678eb>] intel_alloc_coherent+0xc7/0xee
[  784.364575]  [<ffffffff811281dc>] pool_alloc_page.clone.0+0xc9/0x140
[  784.364588]  [<ffffffff811282d8>] dma_pool_alloc+0x85/0x131
[  784.364603]  [<ffffffff81134b8c>] ? should_failslab+0x44/0x48
[  784.364618]  [<ffffffff81132d62>] ? kmem_cache_alloc_trace+0x5e/0x123
[  784.364635]  [<ffffffff818429aa>] ehci_qh_alloc+0x59/0xd2
[  784.364649]  [<ffffffff81844451>] ehci_mem_init.clone.1+0x84/0x25c
[  784.364660]  [<ffffffff8184471b>] ehci_init+0xf2/0x245
[  784.364671]  [<ffffffff81844999>] ehci_pci_setup+0x12b/0x564
[  784.364687]  [<ffffffff818323d5>] usb_add_hcd+0x10f/0x318
[  784.364703]  [<ffffffff8183e31e>] usb_hcd_pci_probe+0x1e4/0x312
[  784.364722]  [<ffffffff8134ae25>] local_pci_probe+0x4d/0x96
[  784.364739]  [<ffffffff81093c4b>] ? cwq_dec_nr_in_flight+0x81/0x81
[  784.364754]  [<ffffffff81093c63>] do_work_for_cpu+0x18/0x2b
[  784.364770]  [<ffffffff81093c4b>] ? cwq_dec_nr_in_flight+0x81/0x81
[  784.364787]  [<ffffffff81099ea5>] kthread+0xa0/0xa8
[  784.364801]  [<ffffffff810adbcc>] ? trace_hardirqs_on_caller+0x1f/0x178
[  784.364818]  [<ffffffff81c2a214>] kernel_thread_helper+0x4/0x10
[  784.364832]  [<ffffffff81c224cc>] ? _raw_spin_unlock_irq+0x30/0x36
[  784.364846]  [<ffffffff810add32>] ? trace_hardirqs_on+0xd/0xf
[  784.364861]  [<ffffffff81c227c0>] ? retint_restore_args+0xe/0xe
[  784.364880]  [<ffffffff81099e05>] ? __init_kthread_worker+0x5b/0x5b
[  784.364893]  [<ffffffff81c2a210>] ? gs_change+0xb/0xb
[  784.364902] DMAR: Device scope device [0000:40:00.00] not found
[  784.364910] DMAR: Device scope device [0000:40:01.00] not found
[  784.364931] DMAR: Device scope device [0000:40:03.00] not found
[  784.364948] DMAR: Device scope device [0000:40:05.00] not found
[  784.364961] DMAR: Device scope device [0000:40:07.00] not found
[  784.364978] DMAR: Device scope device [0000:40:09.00] not found
[  784.365019] DMAR: Device scope device [0000:80:00.00] not found
[  784.365034] DMAR: Device scope device [0000:80:01.00] not found
[  784.365053] DMAR: Device scope device [0000:80:03.00] not found
[  784.365075] DMAR: Device scope device [0000:80:05.00] not found
[  784.365094] DMAR: Device scope device [0000:80:07.00] not found
[  784.365116] DMAR: Device scope device [0000:80:09.00] not found
[  784.365166] DMAR: Device scope device [0000:c0:00.00] not found
[  784.365193] DMAR: Device scope device [0000:c0:01.00] not found
[  784.365216] DMAR: Device scope device [0000:c0:03.00] not found
[  784.365243] DMAR: Device scope device [0000:c0:05.00] not found
[  784.365266] DMAR: Device scope device [0000:c0:07.00] not found
[  784.365284] DMAR: Device scope device [0000:c0:09.00] not found


updated patch:

---

 drivers/pci/dmar.c        |  164 ++++++++++++++++++++++++----------------------
 drivers/pci/intel-iommu.c |  161 +++++++++++++++++++++++++--------------------
 include/linux/dmar.h      |   29 ++++++--
 3 files changed, 202 insertions(+), 152 deletions(-)


Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -61,8 +61,8 @@ static void __init dmar_register_drhd_un
 		list_add(&drhd->list, &dmar_drhd_units);
 }
 
-static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
-					   struct pci_dev **dev, u16 segment)
+struct pci_dev *dmar_get_scope_dev(struct acpi_dmar_device_scope *scope,
+				   u16 segment)
 {
 	struct pci_bus *bus;
 	struct pci_dev *pdev = NULL;
@@ -74,7 +74,7 @@ static int __init dmar_parse_one_dev_sco
 	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
 		/ sizeof(struct acpi_dmar_pci_path);
 
-	while (count) {
+	for (; count; path++, count--, bus = pdev->subordinate) {
 		if (pdev)
 			pci_dev_put(pdev);
 		/*
@@ -82,53 +82,77 @@ static int __init dmar_parse_one_dev_sco
 		 * ignore it
 		 */
 		if (!bus) {
-			printk(KERN_WARNING
-			PREFIX "Device scope bus [%d] not found\n",
-			scope->bus);
-			break;
+			printk(KERN_WARNING PREFIX
+			       "Device scope bus [%d] not found\n", scope->bus);
+			return NULL;
 		}
 		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
 		if (!pdev) {
 			printk(KERN_WARNING PREFIX
-			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
-				segment, bus->number, path->dev, path->fn);
-			break;
+			       "Device scope device [%04x:%02x:%02x.%02x] not found\n",
+			       segment, bus->number, path->dev, path->fn);
+			return NULL;
 		}
-		path ++;
-		count --;
-		bus = pdev->subordinate;
-	}
-	if (!pdev) {
-		printk(KERN_WARNING PREFIX
-		"Device scope device [%04x:%02x:%02x.%02x] not found\n",
-		segment, scope->bus, path->dev, path->fn);
-		*dev = NULL;
+	}
+
+	return pdev;
+}
+
+static int dmar_match_scope_one(struct acpi_dmar_device_scope *scope,
+				struct pci_dev *dev, u16 segment)
+{
+	struct pci_dev *pdev;
+	int ret = 0;
+
+	if (segment != pci_domain_nr(dev->bus))
+		return 0;
+
+	pdev = dmar_get_scope_dev(scope, segment);
+	if (!pdev)
 		return 0;
+
+	if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT) {
+		if (dev == pdev)
+			ret = 1;
+	} else {
+		while (dev) {
+			if (dev == pdev) {
+				ret = 1;
+				break;
+			}
+			dev = dev->bus->self;
+		}
 	}
-	if ((scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT && \
-			pdev->subordinate) || (scope->entry_type == \
-			ACPI_DMAR_SCOPE_TYPE_BRIDGE && !pdev->subordinate)) {
-		pci_dev_put(pdev);
-		printk(KERN_WARNING PREFIX
-			"Device scope type does not match for %s\n",
-			 pci_name(pdev));
-		return -EINVAL;
+
+	pci_dev_put(pdev);
+
+	return ret;
+}
+
+int dmar_match_scope(struct acpi_dmar_device_scope **scopes, int cnt,
+		     struct pci_dev *dev, u16 segment)
+{
+	int i;
+
+	for (i = 0; i < cnt; i++) {
+		if (dmar_match_scope_one(scopes[i], dev, segment))
+			return 1;
 	}
-	*dev = pdev;
 	return 0;
 }
 
 static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				       struct pci_dev ***devices, u16 segment)
+				       struct acpi_dmar_device_scope ***scopes)
 {
 	struct acpi_dmar_device_scope *scope;
-	void * tmp = start;
-	int index;
-	int ret;
+	void *tmp = start;
+	int index = 0;
 
 	*cnt = 0;
+
 	while (start < end) {
 		scope = start;
+
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
@@ -138,27 +162,23 @@ static int __init dmar_parse_dev_scope(v
 		}
 		start += scope->length;
 	}
+
 	if (*cnt == 0)
 		return 0;
 
-	*devices = kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
-	if (!*devices)
+	*scopes = kcalloc(*cnt, sizeof(struct acpi_dmar_device_scope *),
+                          GFP_KERNEL);
+	if (!*scopes)
 		return -ENOMEM;
 
 	start = tmp;
-	index = 0;
 	while (start < end) {
 		scope = start;
+
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
-		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE) {
-			ret = dmar_parse_one_dev_scope(scope,
-				&(*devices)[index], segment);
-			if (ret) {
-				kfree(*devices);
-				return ret;
-			}
-			index ++;
-		}
+		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
+			(*scopes)[index++] = scope;
+
 		start += scope->length;
 	}
 
@@ -207,9 +227,8 @@ static int __init dmar_parse_dev(struct
 		return 0;
 
 	ret = dmar_parse_dev_scope((void *)(drhd + 1),
-				((void *)drhd) + drhd->header.length,
-				&dmaru->devices_cnt, &dmaru->devices,
-				drhd->segment);
+				   ((void *)drhd) + drhd->header.length,
+				   &dmaru->scopes_cnt, &dmaru->scopes);
 	if (ret) {
 		list_del(&dmaru->list);
 		kfree(dmaru);
@@ -253,10 +272,10 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rm
 
 	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
 	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
-		((void *)rmrr) + rmrr->header.length,
-		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
+				   ((void *)rmrr) + rmrr->header.length,
+				   &rmrru->scopes_cnt, &rmrru->scopes);
 
-	if (ret || (rmrru->devices_cnt == 0)) {
+	if (ret || (rmrru->scopes_cnt == 0)) {
 		list_del(&rmrru->list);
 		kfree(rmrru);
 	}
@@ -293,10 +312,9 @@ static int __init atsr_parse_dev(struct
 
 	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
 	rc = dmar_parse_dev_scope((void *)(atsr + 1),
-				(void *)atsr + atsr->header.length,
-				&atsru->devices_cnt, &atsru->devices,
-				atsr->segment);
-	if (rc || !atsru->devices_cnt) {
+				  (void *)atsr + atsr->header.length,
+				  &atsru->scopes_cnt, &atsru->scopes);
+	if (rc || !atsru->scopes_cnt) {
 		list_del(&atsru->list);
 		kfree(atsru);
 	}
@@ -310,6 +328,7 @@ int dmar_find_matched_atsr_unit(struct p
 	struct pci_bus *bus;
 	struct acpi_dmar_atsr *atsr;
 	struct dmar_atsr_unit *atsru;
+	struct pci_dev *pdev;
 
 	dev = pci_physfn(dev);
 
@@ -330,10 +349,18 @@ found:
 			return 0;
 
 		if (bridge->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
-			for (i = 0; i < atsru->devices_cnt; i++)
-				if (atsru->devices[i] == bridge)
+			for (i = 0; i < atsru->scopes_cnt; i++) {
+				pdev = dmar_get_scope_dev(atsru->scopes[i],
+							  atsr->segment);
+				if (!pdev)
+					continue;
+
+				if (pdev == bridge) {
+					pci_dev_put(pdev);
 					return 1;
-			break;
+				}
+				pci_dev_put(pdev);
+			}
 		}
 	}
 
@@ -513,23 +540,6 @@ parse_dmar_table(void)
 	return ret;
 }
 
-static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
-			  struct pci_dev *dev)
-{
-	int index;
-
-	while (dev) {
-		for (index = 0; index < cnt; index++)
-			if (dev == devices[index])
-				return 1;
-
-		/* Check our parent */
-		dev = dev->bus->self;
-	}
-
-	return 0;
-}
-
 struct dmar_drhd_unit *
 dmar_find_matched_drhd_unit(struct pci_dev *dev)
 {
@@ -544,11 +554,11 @@ dmar_find_matched_drhd_unit(struct pci_d
 				    header);
 
 		if (dmaru->include_all &&
-		    drhd->segment == pci_domain_nr(dev->bus))
+		    dmaru->segment == pci_domain_nr(dev->bus))
 			return dmaru;
 
-		if (dmar_pci_device_match(dmaru->devices,
-					  dmaru->devices_cnt, dev))
+		if (dmar_match_scope(dmaru->scopes, dmaru->scopes_cnt,
+				     dev, dmaru->segment))
 			return dmaru;
 	}
 
Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -562,34 +562,49 @@ static void domain_update_iommu_cap(stru
 	domain_update_iommu_snooping(domain);
 }
 
-static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
+static struct intel_iommu *__device_to_iommu(struct pci_dev *pdev)
 {
-	struct dmar_drhd_unit *drhd = NULL;
-	int i;
+	struct dmar_drhd_unit *dmaru = NULL;
+	struct intel_iommu *found = NULL;
+	int segment = pci_domain_nr(pdev->bus);
 
-	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
+	for_each_drhd_unit(dmaru) {
+		if (dmaru->ignored)
 			continue;
-		if (segment != drhd->segment)
+		if (segment != dmaru->segment)
 			continue;
 
-		for (i = 0; i < drhd->devices_cnt; i++) {
-			if (drhd->devices[i] &&
-			    drhd->devices[i]->bus->number == bus &&
-			    drhd->devices[i]->devfn == devfn)
-				return drhd->iommu;
-			if (drhd->devices[i] &&
-			    drhd->devices[i]->subordinate &&
-			    drhd->devices[i]->subordinate->number <= bus &&
-			    drhd->devices[i]->subordinate->subordinate >= bus)
-				return drhd->iommu;
+		if (dmaru->include_all) {
+			found = dmaru->iommu;
+			break;
+		}
+
+		if (dmar_match_scope(dmaru->scopes, dmaru->scopes_cnt,
+				     pdev, dmaru->segment)) {
+			found = dmaru->iommu;
+			break;
 		}
 
-		if (drhd->include_all)
-			return drhd->iommu;
 	}
 
-	return NULL;
+	return found;
+}
+
+static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
+{
+	struct pci_dev *pdev;
+	struct intel_iommu *found = NULL;
+
+	pdev = pci_get_domain_bus_and_slot(segment, bus, devfn);
+
+	if (!pdev)
+		return NULL;
+
+	found = __device_to_iommu(pdev);
+
+	pci_dev_put(pdev);
+
+	return found;
 }
 
 static void domain_flush_cache(struct dmar_domain *domain,
@@ -990,12 +1005,12 @@ static void __iommu_flush_iotlb(struct i
 }
 
 static struct device_domain_info *iommu_support_dev_iotlb(
-	struct dmar_domain *domain, int segment, u8 bus, u8 devfn)
+	struct dmar_domain *domain, struct intel_iommu *iommu,
+	int segment, u8 bus, u8 devfn)
 {
 	int found = 0;
 	unsigned long flags;
 	struct device_domain_info *info;
-	struct intel_iommu *iommu = device_to_iommu(segment, bus, devfn);
 
 	if (!ecap_dev_iotlb_support(iommu->ecap))
 		return NULL;
@@ -1441,8 +1456,8 @@ static void domain_exit(struct dmar_doma
 	free_domain_mem(domain);
 }
 
-static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
-				 u8 bus, u8 devfn, int translation)
+static int domain_context_mapping_one(struct dmar_domain *domain,
+				      struct pci_dev *pdev, int translation)
 {
 	struct context_entry *context;
 	unsigned long flags;
@@ -1461,11 +1476,12 @@ static int domain_context_mapping_one(st
 	BUG_ON(translation != CONTEXT_TT_PASS_THROUGH &&
 	       translation != CONTEXT_TT_MULTI_LEVEL);
 
-	iommu = device_to_iommu(segment, bus, devfn);
+	iommu = __device_to_iommu(pdev);
 	if (!iommu)
 		return -ENODEV;
 
-	context = device_to_context_entry(iommu, bus, devfn);
+	context = device_to_context_entry(iommu, pdev->bus->number,
+						 pdev->devfn);
 	if (!context)
 		return -ENOMEM;
 	spin_lock_irqsave(&iommu->lock, flags);
@@ -1522,7 +1538,7 @@ static int domain_context_mapping_one(st
 	context_set_domain_id(context, id);
 
 	if (translation != CONTEXT_TT_PASS_THROUGH) {
-		info = iommu_support_dev_iotlb(domain, segment, bus, devfn);
+		info = iommu_support_dev_iotlb(domain, iommu, pdev);
 		translation = info ? CONTEXT_TT_DEV_IOTLB :
 				     CONTEXT_TT_MULTI_LEVEL;
 	}
@@ -1578,9 +1594,7 @@ domain_context_mapping(struct dmar_domai
 	int ret;
 	struct pci_dev *tmp, *parent;
 
-	ret = domain_context_mapping_one(domain, pci_domain_nr(pdev->bus),
-					 pdev->bus->number, pdev->devfn,
-					 translation);
+	ret = domain_context_mapping_one(domain, pdev, translation);
 	if (ret)
 		return ret;
 
@@ -1591,25 +1605,19 @@ domain_context_mapping(struct dmar_domai
 	/* Secondary interface's bus number and devfn 0 */
 	parent = pdev->bus->self;
 	while (parent != tmp) {
-		ret = domain_context_mapping_one(domain,
-						 pci_domain_nr(parent->bus),
-						 parent->bus->number,
-						 parent->devfn, translation);
+		ret = domain_context_mapping_one(domain, parent, translation);
 		if (ret)
 			return ret;
 		parent = parent->bus->self;
 	}
-	if (pci_is_pcie(tmp)) /* this is a PCIe-to-PCI bridge */
-		return domain_context_mapping_one(domain,
-					pci_domain_nr(tmp->subordinate),
-					tmp->subordinate->number, 0,
-					translation);
-	else /* this is a legacy PCI bridge */
-		return domain_context_mapping_one(domain,
-						  pci_domain_nr(tmp->bus),
-						  tmp->bus->number,
-						  tmp->devfn,
-						  translation);
+	if (pci_is_pcie(tmp)) {
+		 /* this is a PCIe-to-PCI bridge */
+		struct pci_dev *child = pci_get_slot(tmp->subordinate, 0);
+		ret = domain_context_mapping_one(domain, child, translation);
+		pci_dev_put(child);
+		return ret;
+	} else /* this is a legacy PCI bridge */
+		return domain_context_mapping_one(domain, tmp, translation);
 }
 
 static int domain_context_mapped(struct pci_dev *pdev)
@@ -1618,8 +1626,7 @@ static int domain_context_mapped(struct
 	struct pci_dev *tmp, *parent;
 	struct intel_iommu *iommu;
 
-	iommu = device_to_iommu(pci_domain_nr(pdev->bus), pdev->bus->number,
-				pdev->devfn);
+	iommu = __device_to_iommu(pdev);
 	if (!iommu)
 		return -ENODEV;
 
@@ -2233,7 +2240,7 @@ static int __init init_dmars(int force_o
 	struct dmar_rmrr_unit *rmrr;
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
-	int i, ret;
+	int ret;
 
 	/*
 	 * for each drhd
@@ -2382,18 +2389,22 @@ static int __init init_dmars(int force_o
 	 */
 	printk(KERN_INFO "IOMMU: Setting RMRR:\n");
 	for_each_rmrr_units(rmrr) {
-		for (i = 0; i < rmrr->devices_cnt; i++) {
-			pdev = rmrr->devices[i];
-			/*
-			 * some BIOS lists non-exist devices in DMAR
-			 * table.
-			 */
+		struct acpi_dmar_reserved_memory *rmrrh;
+		int i;
+
+		rmrrh = container_of(rmrr->hdr,
+				     struct acpi_dmar_reserved_memory, header);
+
+		for (i = 0; i < rmrr->scopes_cnt; i++) {
+			pdev = dmar_get_scope_dev(rmrr->scopes[i],
+						  rmrrh->segment);
 			if (!pdev)
 				continue;
-			ret = iommu_prepare_rmrr_dev(rmrr, pdev);
-			if (ret)
+
+			if (iommu_prepare_rmrr_dev(rmrr, pdev))
 				printk(KERN_ERR
 				       "IOMMU: mapping reserved region failed\n");
+			pci_dev_put(pdev);
 		}
 	}
 
@@ -3075,15 +3086,21 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_I
 static void __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;
+	struct pci_dev *pdev;
 
 	for_each_drhd_unit(drhd) {
 		if (!drhd->include_all) {
 			int i;
-			for (i = 0; i < drhd->devices_cnt; i++)
-				if (drhd->devices[i] != NULL)
+			for (i = 0; i < drhd->scopes_cnt; i++) {
+				pdev = dmar_get_scope_dev(drhd->scopes[i],
+							  drhd->segment);
+				if (pdev) {
+					pci_dev_put(pdev);
 					break;
+				}
+			}
 			/* ignore DMAR unit if no pci devices exist */
-			if (i == drhd->devices_cnt)
+			if (i == drhd->scopes_cnt)
 				drhd->ignored = 1;
 		}
 	}
@@ -3096,20 +3113,28 @@ static void __init init_no_remapping_dev
 		if (drhd->ignored || drhd->include_all)
 			continue;
 
-		for (i = 0; i < drhd->devices_cnt; i++)
-			if (drhd->devices[i] &&
-				!IS_GFX_DEVICE(drhd->devices[i]))
+		for (i = 0; i < drhd->scopes_cnt; i++) {
+			pdev = dmar_get_scope_dev(drhd->scopes[i],
+						  drhd->segment);
+			if (pdev && !IS_GFX_DEVICE(pdev)) {
+				pci_dev_put(pdev);
 				break;
+			}
+			pci_dev_put(pdev);
+		}
 
-		if (i < drhd->devices_cnt)
+		if (i < drhd->scopes_cnt)
 			continue;
 
 		/* bypass IOMMU if it is just for gfx devices */
 		drhd->ignored = 1;
-		for (i = 0; i < drhd->devices_cnt; i++) {
-			if (!drhd->devices[i])
+		for (i = 0; i < drhd->scopes_cnt; i++) {
+			pdev = dmar_get_scope_dev(drhd->scopes[i],
+						  drhd->segment);
+			if (!pdev)
 				continue;
-			drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
+			pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
+			pci_dev_put(pdev);
 		}
 	}
 }
@@ -3378,8 +3403,7 @@ static void domain_remove_one_dev_info(s
 	int found = 0;
 	struct list_head *entry, *tmp;
 
-	iommu = device_to_iommu(pci_domain_nr(pdev->bus), pdev->bus->number,
-				pdev->devfn);
+	iommu = __device_to_iommu(pdev);
 	if (!iommu)
 		return;
 
@@ -3622,8 +3646,7 @@ static int intel_iommu_attach_device(str
 		}
 	}
 
-	iommu = device_to_iommu(pci_domain_nr(pdev->bus), pdev->bus->number,
-				pdev->devfn);
+	iommu = __device_to_iommu(pdev);
 	if (!iommu)
 		return -ENODEV;
 
Index: linux-2.6/include/linux/dmar.h
===================================================================
--- linux-2.6.orig/include/linux/dmar.h
+++ linux-2.6/include/linux/dmar.h
@@ -32,8 +32,8 @@ struct dmar_drhd_unit {
 	struct list_head list;		/* list of drhd units	*/
 	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	reg_base_addr;		/* register base address*/
-	struct	pci_dev **devices; 	/* target device array	*/
-	int	devices_cnt;		/* target device count	*/
+	struct	acpi_dmar_device_scope **scopes; /* target scope array	*/
+	int	scopes_cnt;		/* target scope count	*/
 	u16	segment;		/* PCI domain		*/
 	u8	ignored:1; 		/* ignore drhd		*/
 	u8	include_all:1;
@@ -55,6 +55,9 @@ extern struct list_head dmar_drhd_units;
 
 extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
+extern int dmar_match_scope(struct acpi_dmar_device_scope **, int,
+			    struct pci_dev *, u16);
+extern struct pci_dev *dmar_get_scope_dev(struct acpi_dmar_device_scope *, u16);
 
 /* Intel IOMMU detection */
 extern int detect_intel_iommu(void);
@@ -72,6 +75,20 @@ static inline int dmar_table_init(void)
 {
 	return -ENODEV;
 }
+
+static inline int dmar_match_scope(struct acpi_dmar_device_scope **scopes,
+				   int cnt, struct pci_dev *dev, u16 segment)
+{
+	return 0;
+}
+
+static inline struct pci_dev *dmar_get_scope_dev(
+					struct acpi_dmar_device_scope *scope,
+					u16 segment)
+{
+	return NULL;
+}
+
 static inline int enable_drhd_fault_handling(void)
 {
 	return -1;
@@ -212,8 +229,8 @@ struct dmar_rmrr_unit {
 	struct acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	base_address;		/* reserved base address*/
 	u64	end_address;		/* reserved end address */
-	struct pci_dev **devices;	/* target devices */
-	int	devices_cnt;		/* target device count */
+	struct	acpi_dmar_device_scope **scopes; /* target scope array */
+	int	scopes_cnt;		/* target scope count */
 };
 
 #define for_each_rmrr_units(rmrr) \
@@ -222,8 +239,8 @@ struct dmar_rmrr_unit {
 struct dmar_atsr_unit {
 	struct list_head list;		/* list of ATSR units */
 	struct acpi_dmar_header *hdr;	/* ACPI header */
-	struct pci_dev **devices;	/* target devices */
-	int devices_cnt;		/* target device count */
+	struct acpi_dmar_device_scope **scopes;	/* target scope array */
+	int scopes_cnt;		/* target scope count */
 	u8 include_all:1;		/* include all ports */
 };
 
