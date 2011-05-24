Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1EXSM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:12:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48058 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1EXSM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:12:58 -0400
Message-ID: <4DDBF4D1.4090302@kernel.org>
Date: Tue, 24 May 2011 11:11:29 -0700
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
References: <4DC6E569.1060808@kernel.org> <1305843308.3100.10.camel@x201>	 <1306234696.7218.14.camel@i7.infradead.org> <1306258959.3100.79.camel@x201>
In-Reply-To: <1306258959.3100.79.camel@x201>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DDBF4D9.00EA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 10:42 AM, Alex Williamson wrote:
> On Tue, 2011-05-24 at 11:58 +0100, David Woodhouse wrote:
>> On Thu, 2011-05-19 at 16:15 -0600, Alex Williamson wrote:
>>> I think I'd vote for saving some kind of representation of the bus
>>> hierarchy, we probably don't need to list every possible individual
>>> device.  Leaving a broken pointer around to be matched up and restored
>>> later just seems like a continuation of an idea that was bad to begin
>>> with.  Thanks, 
>>
>> I agree. We should just process the original ATSR information in
>> dmar_find_matched_drhd_unit(), rather than comparing with a list of
>> possibly stale pointers.
>>
>> I don't quite understand why the list of PCI devices was *ever* done
>> like that.
> 
> Yinghai,
> 
> I thought I might be running into something similar so spent some time
> taking a different slant coding up the bug you found.  Turns out I
> should have tested your patch first because I wasn't hitting that bug at
> all.  The patch below is a work-in-progress that I think fixes the bug
> by providing a quick means of re-parsing the scope as needed to match
> current struct pci_devs.  It needs testing and cleanup, but feel free to
> run with it (or ignore).  Just figured its better to post than waste the
> code if you end up doing something similar.  Thanks,

yes, will try it.

Thanks

> 
> Alex
> 
> 
> Not for commit
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> index 9cbeb0b..1d7bc58 100644
> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -59,8 +59,8 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
>  		list_add(&drhd->list, &dmar_drhd_units);
>  }
>  
> -static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
> -					   struct pci_dev **dev, u16 segment)
> +struct pci_dev *dmar_get_scope_dev(struct acpi_dmar_device_scope *scope,
> +				   u16 segment)
>  {
>  	struct pci_bus *bus;
>  	struct pci_dev *pdev = NULL;
> @@ -72,7 +72,7 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
>  	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
>  		/ sizeof(struct acpi_dmar_pci_path);
>  
> -	while (count) {
> +	for (; count; path++, count--, bus = pdev->subordinate) {
>  		if (pdev)
>  			pci_dev_put(pdev);
>  		/*
> @@ -80,82 +80,103 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
>  		 * ignore it
>  		 */
>  		if (!bus) {
> -			printk(KERN_WARNING
> -			PREFIX "Device scope bus [%d] not found\n",
> -			scope->bus);
> -			break;
> +			printk(KERN_WARNING PREFIX
> +			       "Device scope bus [%d] not found\n", scope->bus);
> +			return NULL;
>  		}
>  		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
>  		if (!pdev) {
>  			printk(KERN_WARNING PREFIX
> -			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
> -				segment, bus->number, path->dev, path->fn);
> -			break;
> +			       "Device scope device [%04x:%02x:%02x.%02x] not found\n",
> +			       segment, bus->number, path->dev, path->fn);
> +			return NULL;
>  		}
> -		path ++;
> -		count --;
> -		bus = pdev->subordinate;
>  	}
> -	if (!pdev) {
> -		printk(KERN_WARNING PREFIX
> -		"Device scope device [%04x:%02x:%02x.%02x] not found\n",
> -		segment, scope->bus, path->dev, path->fn);
> -		*dev = NULL;
> +
> +	return pdev;
> +}
> +
> +static int dmar_match_scope_one(struct acpi_dmar_device_scope *scope,
> +				struct pci_dev *dev, u16 segment)
> +{
> +	struct pci_dev *pdev;
> +	int ret = 0;
> +
> +	if (segment != pci_domain_nr(dev->bus))
>  		return 0;
> +
> +	pdev = dmar_get_scope_dev(scope, segment);
> +	if (!pdev)
> +		return 0;
> +
> +	if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT) {
> +		if (dev == pdev)
> +			ret = 1;
> +	} else {
> +		while (dev) {
> +			if (dev == pdev) {
> +				ret = 1;
> +				break;
> +			}
> +			dev = dev->bus->self;
> +		}
>  	}
> -	if ((scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT && \
> -			pdev->subordinate) || (scope->entry_type == \
> -			ACPI_DMAR_SCOPE_TYPE_BRIDGE && !pdev->subordinate)) {
> -		pci_dev_put(pdev);
> -		printk(KERN_WARNING PREFIX
> -			"Device scope type does not match for %s\n",
> -			 pci_name(pdev));
> -		return -EINVAL;
> +
> +	pci_dev_put(pdev);
> +
> +	return ret;
> +}
> +
> +int dmar_match_scope(struct acpi_dmar_device_scope **scopes, int cnt,
> +		     struct pci_dev *dev, u16 segment)
> +{
> +	int i;
> +
> +	for (i = 0; i < cnt; i++) {
> +		if (dmar_match_scope_one(scopes[i], dev, segment))
> +			return 1;
>  	}
> -	*dev = pdev;
>  	return 0;
>  }
>  
>  static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
> -				       struct pci_dev ***devices, u16 segment)
> +				       struct acpi_dmar_device_scope ***scopes)
>  {
>  	struct acpi_dmar_device_scope *scope;
> -	void * tmp = start;
> -	int index;
> -	int ret;
> +	void *tmp = start;
> +	int index = 0;
>  
>  	*cnt = 0;
> +
>  	while (start < end) {
>  		scope = start;
> +
>  		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
>  		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
>  			(*cnt)++;
>  		else
>  			printk(KERN_WARNING PREFIX
> -				"Unsupported device scope\n");
> +			       "Unsupported device scope\n");
> +
>  		start += scope->length;
>  	}
> +
>  	if (*cnt == 0)
>  		return 0;
>  
> -	*devices = kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
> -	if (!*devices)
> +	*scopes = kcalloc(*cnt, sizeof(struct acpi_dmar_device_scope *),
> +                          GFP_KERNEL);
> +	if (!*scopes)
>  		return -ENOMEM;
>  
>  	start = tmp;
> -	index = 0;
>  	while (start < end) {
>  		scope = start;
> +
>  		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
> -		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE) {
> -			ret = dmar_parse_one_dev_scope(scope,
> -				&(*devices)[index], segment);
> -			if (ret) {
> -				kfree(*devices);
> -				return ret;
> -			}
> -			index ++;
> -		}
> +		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
> +			(*scopes)[index++] = scope;
> +
>  		start += scope->length;
>  	}
>  
> @@ -204,9 +225,8 @@ static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
>  		return 0;
>  
>  	ret = dmar_parse_dev_scope((void *)(drhd + 1),
> -				((void *)drhd) + drhd->header.length,
> -				&dmaru->devices_cnt, &dmaru->devices,
> -				drhd->segment);
> +				   ((void *)drhd) + drhd->header.length,
> +				   &dmaru->scopes_cnt, &dmaru->scopes);
>  	if (ret) {
>  		list_del(&dmaru->list);
>  		kfree(dmaru);
> @@ -250,10 +270,10 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
>  
>  	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
>  	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
> -		((void *)rmrr) + rmrr->header.length,
> -		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
> +				   ((void *)rmrr) + rmrr->header.length,
> +				   &rmrru->scopes_cnt, &rmrru->scopes);
>  
> -	if (ret || (rmrru->devices_cnt == 0)) {
> +	if (ret || (rmrru->scopes_cnt == 0)) {
>  		list_del(&rmrru->list);
>  		kfree(rmrru);
>  	}
> @@ -290,10 +310,9 @@ static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
>  
>  	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
>  	rc = dmar_parse_dev_scope((void *)(atsr + 1),
> -				(void *)atsr + atsr->header.length,
> -				&atsru->devices_cnt, &atsru->devices,
> -				atsr->segment);
> -	if (rc || !atsru->devices_cnt) {
> +				  (void *)atsr + atsr->header.length,
> +				  &atsru->scopes_cnt, &atsru->scopes);
> +	if (rc || !atsru->scopes_cnt) {
>  		list_del(&atsru->list);
>  		kfree(atsru);
>  	}
> @@ -307,6 +326,7 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
>  	struct pci_bus *bus;
>  	struct acpi_dmar_atsr *atsr;
>  	struct dmar_atsr_unit *atsru;
> +	struct pci_dev *pdev;
>  
>  	list_for_each_entry(atsru, &dmar_atsr_units, list) {
>  		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
> @@ -325,10 +345,18 @@ found:
>  			return 0;
>  
>  		if (bridge->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
> -			for (i = 0; i < atsru->devices_cnt; i++)
> -				if (atsru->devices[i] == bridge)
> +			for (i = 0; i < atsru->scopes_cnt; i++) {
> +				pdev = dmar_get_scope_dev(atsru->scopes[i],
> +							  atsr->segment);
> +				if (!pdev)
> +					continue;
> +
> +				if (pdev == bridge) {
> +					pci_dev_put(pdev);
>  					return 1;
> -			break;
> +				}
> +				pci_dev_put(pdev);
> +			}
>  		}
>  	}
>  
> @@ -475,23 +503,6 @@ parse_dmar_table(void)
>  	return ret;
>  }
>  
> -int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
> -			  struct pci_dev *dev)
> -{
> -	int index;
> -
> -	while (dev) {
> -		for (index = 0; index < cnt; index++)
> -			if (dev == devices[index])
> -				return 1;
> -
> -		/* Check our parent */
> -		dev = dev->bus->self;
> -	}
> -
> -	return 0;
> -}
> -
>  struct dmar_drhd_unit *
>  dmar_find_matched_drhd_unit(struct pci_dev *dev)
>  {
> @@ -504,11 +515,11 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
>  				    header);
>  
>  		if (dmaru->include_all &&
> -		    drhd->segment == pci_domain_nr(dev->bus))
> +		    dmaru->segment == pci_domain_nr(dev->bus))
>  			return dmaru;
>  
> -		if (dmar_pci_device_match(dmaru->devices,
> -					  dmaru->devices_cnt, dev))
> +		if (dmar_match_scope(dmaru->scopes, dmaru->scopes_cnt,
> +				     dev, dmaru->segment))
>  			return dmaru;
>  	}
>  
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index e7ff5b8..7d0b095 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -541,32 +541,34 @@ static void domain_update_iommu_cap(struct dmar_domain *domain)
>  
>  static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
>  {
> -	struct dmar_drhd_unit *drhd = NULL;
> -	int i;
> +	struct dmar_drhd_unit *dmaru = NULL;
> +	struct pci_dev *pdev;
> +	struct intel_iommu *found = NULL;
>  
> -	for_each_drhd_unit(drhd) {
> -		if (drhd->ignored)
> +	pdev = pci_get_domain_bus_and_slot(segment, bus, devfn);
> +
> +	for_each_drhd_unit(dmaru) {
> +		if (dmaru->ignored)
>  			continue;
> -		if (segment != drhd->segment)
> +		if (segment != dmaru->segment)
>  			continue;
>  
> -		for (i = 0; i < drhd->devices_cnt; i++) {
> -			if (drhd->devices[i] &&
> -			    drhd->devices[i]->bus->number == bus &&
> -			    drhd->devices[i]->devfn == devfn)
> -				return drhd->iommu;
> -			if (drhd->devices[i] &&
> -			    drhd->devices[i]->subordinate &&
> -			    drhd->devices[i]->subordinate->number <= bus &&
> -			    drhd->devices[i]->subordinate->subordinate >= bus)
> -				return drhd->iommu;
> +		if (dmaru->include_all) {
> +			found = dmaru->iommu;
> +			break;
> +		}
> +
> +		if (dmar_match_scope(dmaru->scopes, dmaru->scopes_cnt,
> +				     pdev, dmaru->segment)) {
> +			found = dmaru->iommu;
> +			break;
>  		}
>  
> -		if (drhd->include_all)
> -			return drhd->iommu;
>  	}
>  
> -	return NULL;
> +	pci_dev_put(pdev);
> +
> +	return found;
>  }
>  
>  static void domain_flush_cache(struct dmar_domain *domain,
> @@ -2250,7 +2252,7 @@ int __init init_dmars(void)
>  	struct dmar_rmrr_unit *rmrr;
>  	struct pci_dev *pdev;
>  	struct intel_iommu *iommu;
> -	int i, ret;
> +	int ret;
>  
>  	/*
>  	 * for each drhd
> @@ -2397,18 +2399,22 @@ int __init init_dmars(void)
>  	 */
>  	printk(KERN_INFO "IOMMU: Setting RMRR:\n");
>  	for_each_rmrr_units(rmrr) {
> -		for (i = 0; i < rmrr->devices_cnt; i++) {
> -			pdev = rmrr->devices[i];
> -			/*
> -			 * some BIOS lists non-exist devices in DMAR
> -			 * table.
> -			 */
> +		struct acpi_dmar_reserved_memory *rmrrh;
> +		int i;
> +
> +		rmrrh = container_of(rmrr->hdr,
> +				     struct acpi_dmar_reserved_memory, header);
> +
> +		for (i = 0; i < rmrr->scopes_cnt; i++) {
> +			pdev = dmar_get_scope_dev(rmrr->scopes[i],
> +						  rmrrh->segment);
>  			if (!pdev)
>  				continue;
> -			ret = iommu_prepare_rmrr_dev(rmrr, pdev);
> -			if (ret)
> +
> +			if (iommu_prepare_rmrr_dev(rmrr, pdev))
>  				printk(KERN_ERR
>  				       "IOMMU: mapping reserved region failed\n");
> +			pci_dev_put(pdev);
>  		}
>  	}
>  
> @@ -3078,15 +3084,21 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quir
>  static void __init init_no_remapping_devices(void)
>  {
>  	struct dmar_drhd_unit *drhd;
> +	struct pci_dev *pdev;
>  
>  	for_each_drhd_unit(drhd) {
>  		if (!drhd->include_all) {
>  			int i;
> -			for (i = 0; i < drhd->devices_cnt; i++)
> -				if (drhd->devices[i] != NULL)
> +			for (i = 0; i < drhd->scopes_cnt; i++) {
> +				pdev = dmar_get_scope_dev(drhd->scopes[i],
> +							  drhd->segment);
> +				if (pdev) {
> +					pci_dev_put(pdev);
>  					break;
> +				}
> +			}
>  			/* ignore DMAR unit if no pci devices exist */
> -			if (i == drhd->devices_cnt)
> +			if (i == drhd->scopes_cnt)
>  				drhd->ignored = 1;
>  		}
>  	}
> @@ -3099,20 +3111,28 @@ static void __init init_no_remapping_devices(void)
>  		if (drhd->ignored || drhd->include_all)
>  			continue;
>  
> -		for (i = 0; i < drhd->devices_cnt; i++)
> -			if (drhd->devices[i] &&
> -				!IS_GFX_DEVICE(drhd->devices[i]))
> +		for (i = 0; i < drhd->scopes_cnt; i++) {
> +			pdev = dmar_get_scope_dev(drhd->scopes[i],
> +						  drhd->segment);
> +			if (pdev && !IS_GFX_DEVICE(pdev)) {
> +				pci_dev_put(pdev);
>  				break;
> +			}
> +			pci_dev_put(pdev);
> +		}
>  
> -		if (i < drhd->devices_cnt)
> +		if (i < drhd->scopes_cnt)
>  			continue;
>  
>  		/* bypass IOMMU if it is just for gfx devices */
>  		drhd->ignored = 1;
> -		for (i = 0; i < drhd->devices_cnt; i++) {
> -			if (!drhd->devices[i])
> +		for (i = 0; i < drhd->scopes_cnt; i++) {
> +			pdev = dmar_get_scope_dev(drhd->scopes[i],
> +						  drhd->segment);
> +			if (!pdev)
>  				continue;
> -			drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
> +			pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
> +			pci_dev_put(pdev);
>  		}
>  	}
>  }
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index 69a6fba..70b7e3c 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -32,8 +32,8 @@ struct dmar_drhd_unit {
>  	struct list_head list;		/* list of drhd units	*/
>  	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
>  	u64	reg_base_addr;		/* register base address*/
> -	struct	pci_dev **devices; 	/* target device array	*/
> -	int	devices_cnt;		/* target device count	*/
> +	struct	acpi_dmar_device_scope **scopes; /* target scope array	*/
> +	int	scopes_cnt;		/* target scope count	*/
>  	u16	segment;		/* PCI domain		*/
>  	u8	ignored:1; 		/* ignore drhd		*/
>  	u8	include_all:1;
> @@ -55,6 +55,9 @@ extern struct list_head dmar_drhd_units;
>  
>  extern int dmar_table_init(void);
>  extern int dmar_dev_scope_init(void);
> +extern int dmar_match_scope(struct acpi_dmar_device_scope **, int,
> +			    struct pci_dev *, u16);
> +extern struct pci_dev *dmar_get_scope_dev(struct acpi_dmar_device_scope *, u16);
>  
>  /* Intel IOMMU detection */
>  extern void detect_intel_iommu(void);
> @@ -72,6 +75,20 @@ static inline int dmar_table_init(void)
>  {
>  	return -ENODEV;
>  }
> +
> +static inline int dmar_match_scope(struct acpi_dmar_device_scope **scopes,
> +				   int cnt, struct pci_dev *dev, u16 segment)
> +{
> +	return 0;
> +}
> +
> +static inline struct pci_dev *dmar_get_scope_dev(
> +					struct acpi_dmar_device_scope *scope,
> +					u16 segment)
> +{
> +	return NULL;
> +}
> +
>  static inline int enable_drhd_fault_handling(void)
>  {
>  	return -1;
> @@ -203,8 +220,8 @@ struct dmar_rmrr_unit {
>  	struct acpi_dmar_header *hdr;	/* ACPI header		*/
>  	u64	base_address;		/* reserved base address*/
>  	u64	end_address;		/* reserved end address */
> -	struct pci_dev **devices;	/* target devices */
> -	int	devices_cnt;		/* target device count */
> +	struct	acpi_dmar_device_scope **scopes; /* target scope array */
> +	int	scopes_cnt;		/* target scope count */
>  };
>  
>  #define for_each_rmrr_units(rmrr) \
> @@ -213,8 +230,8 @@ struct dmar_rmrr_unit {
>  struct dmar_atsr_unit {
>  	struct list_head list;		/* list of ATSR units */
>  	struct acpi_dmar_header *hdr;	/* ACPI header */
> -	struct pci_dev **devices;	/* target devices */
> -	int devices_cnt;		/* target device count */
> +	struct acpi_dmar_device_scope **scopes;	/* target scope array */
> +	int scopes_cnt;		/* target scope count */
>  	u8 include_all:1;		/* include all ports */
>  };
>  
> 

