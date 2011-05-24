Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab1EXVqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:46:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48553 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1EXVp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:45:57 -0400
Message-ID: <4DDC26FE.6070207@kernel.org>
Date: Tue, 24 May 2011 14:45:34 -0700
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
References: <4DC6E569.1060808@kernel.org> <1305843308.3100.10.camel@x201>	 <1306234696.7218.14.camel@i7.infradead.org> <1306258959.3100.79.camel@x201>	  <4DDC0858.3090406@kernel.org> <1306267639.3100.102.camel@x201>
In-Reply-To: <1306267639.3100.102.camel@x201>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DDC2703.0171,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 01:07 PM, Alex Williamson wrote:
> On Tue, 2011-05-24 at 12:34 -0700, Yinghai Lu wrote:
>> On 05/24/2011 10:42 AM, Alex Williamson wrote:
>>> On Tue, 2011-05-24 at 11:58 +0100, David Woodhouse wrote:
>>>> On Thu, 2011-05-19 at 16:15 -0600, Alex Williamson wrote:
>>>>> I think I'd vote for saving some kind of representation of the bus
>>>>> hierarchy, we probably don't need to list every possible individual
>>>>> device.  Leaving a broken pointer around to be matched up and restored
>>>>> later just seems like a continuation of an idea that was bad to begin
>>>>> with.  Thanks, 
>>>>
>>>> I agree. We should just process the original ATSR information in
>>>> dmar_find_matched_drhd_unit(), rather than comparing with a list of
>>>> possibly stale pointers.
>>>>
>>>> I don't quite understand why the list of PCI devices was *ever* done
>>>> like that.
>>>
>>> Yinghai,
>>>
>>> I thought I might be running into something similar so spent some time
>>> taking a different slant coding up the bug you found.  Turns out I
>>> should have tested your patch first because I wasn't hitting that bug at
>>> all.  The patch below is a work-in-progress that I think fixes the bug
>>> by providing a quick means of re-parsing the scope as needed to match
>>> current struct pci_devs.  It needs testing and cleanup, but feel free to
>>> run with it (or ignore).  Just figured its better to post than waste the
>>> code if you end up doing something similar.  Thanks,
>>>
>>> Alex
>>>
>>
>> it does not apply to current linus tree cleanly.
> 
> Sorry, for some reason I started hacking on this against a rhel kernel.
> Here's the compile tested-only forward port to 2.6.39 (plus the
> domain_exit flush patch).  Thanks,
> 
> Alex
> 
> 
> Not for commit
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/pci/dmar.c        |  162 ++++++++++++++++++++++++---------------------
>  drivers/pci/intel-iommu.c |   94 ++++++++++++++++----------
>  include/linux/dmar.h      |   29 ++++++--
>  3 files changed, 166 insertions(+), 119 deletions(-)
> 
> 
> diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> index 12e02bf..47e4f09 100644
> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -61,8 +61,8 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
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
> @@ -74,7 +74,7 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
>  	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
>  		/ sizeof(struct acpi_dmar_pci_path);
>  
> -	while (count) {
> +	for (; count; path++, count--, bus = pdev->subordinate) {
>  		if (pdev)
>  			pci_dev_put(pdev);
>  		/*
> @@ -82,53 +82,77 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
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
> +		return 0;
> +
> +	pdev = dmar_get_scope_dev(scope, segment);
> +	if (!pdev)
>  		return 0;
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
> @@ -138,27 +162,23 @@ static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
>  		}
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
> @@ -207,9 +227,8 @@ static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
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
> @@ -253,10 +272,10 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
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
> @@ -293,10 +312,9 @@ static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
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
> @@ -310,6 +328,7 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
>  	struct pci_bus *bus;
>  	struct acpi_dmar_atsr *atsr;
>  	struct dmar_atsr_unit *atsru;
> +	struct pci_dev *pdev;
>  
>  	dev = pci_physfn(dev);
>  
> @@ -330,10 +349,18 @@ found:
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
> @@ -513,23 +540,6 @@ parse_dmar_table(void)
>  	return ret;
>  }
>  
> -static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
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
> @@ -544,11 +554,11 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
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
> index b04f84e..d1d542a 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -563,32 +563,34 @@ static void domain_update_iommu_cap(struct dmar_domain *domain)
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
> @@ -2227,7 +2229,7 @@ static int __init init_dmars(int force_on)
>  	struct dmar_rmrr_unit *rmrr;
>  	struct pci_dev *pdev;
>  	struct intel_iommu *iommu;
> -	int i, ret;
> +	int ret;
>  
>  	/*
>  	 * for each drhd
> @@ -2376,18 +2378,22 @@ static int __init init_dmars(int force_on)
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
> @@ -3072,15 +3078,21 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quir
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
> @@ -3093,20 +3105,28 @@ static void __init init_no_remapping_devices(void)
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
> index 7b776d7..cf071f9 100644
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
>  extern int detect_intel_iommu(void);
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
> @@ -212,8 +229,8 @@ struct dmar_rmrr_unit {
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
> @@ -222,8 +239,8 @@ struct dmar_rmrr_unit {
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


No, it does not work.

[  592.792864] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[  592.793279] IP: [<ffffffff8136271a>] dmar_match_scope+0x27/0xb6
[  592.804488] PGD 0 
[  592.804629] Oops: 0000 [#1] SMP 
[  592.804849] CPU 1 
[  592.804947] Modules linked in:
[  592.824426] 
[  592.824521] Pid: 14498, comm: kworker/u:7 Tainted: G        W   2.6.39-tip-yh-06738-g5d55a15-dirty #1043 Oracle Corporation  Sun Fire X4800 M2 /     
[  592.844637] RIP: 0010:[<ffffffff8136271a>]  [<ffffffff8136271a>] dmar_match_scope+0x27/0xb6
[  592.864410] RSP: 0018:ffff881ffce45a70  EFLAGS: 00010293
[  592.864673] RAX: 0000000000000000 RBX: 0000000000000008 RCX: 0000000000000000
[  592.884403] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88fffeef6000
[  592.904205] RBP: ffff881ffce45ab0 R08: 0000000000000000 R09: 0000000000000000
[  592.904535] R10: 0000000000000000 R11: ffff88dffedda320 R12: 0000000000000000
[  592.924419] R13: 0000000000000000 R14: ffff88fffeef6000 R15: 0000000000000000
[  592.924748] FS:  0000000000000000(0000) GS:ffff88207d800000(0000) knlGS:0000000000000000
[  592.944447] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  592.964196] CR2: 0000000000000010 CR3: 00000000023cb000 CR4: 00000000000006e0
[  592.964541] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  592.984308] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  593.004091] Process kworker/u:7 (pid: 14498, threadinfo ffff881ffce44000, task ffff881ffce3c560)
[  593.004492] Stack:
[  593.024051]  ffff881ffce45a80 ffffffff8134bf6a ffff881ffce45ab0 ffff88407d002640
[  593.024479]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  593.044272]  ffff881ffce45ae0 ffffffff81363e4a ffff881ffce45b00 ffff88dffe1c1d00
[  593.064027] Call Trace:
[  593.064156]  [<ffffffff8134bf6a>] ? pci_get_device+0x16/0x18
[  593.064441]  [<ffffffff81363e4a>] device_to_iommu+0x4c/0x77
[  593.084054]  [<ffffffff81364163>] domain_remove_one_dev_info+0x39/0x1fc
[  593.084361]  [<ffffffff8136637f>] device_notifier+0x52/0x78
[  593.104093]  [<ffffffff81c24cc3>] notifier_call_chain+0x68/0x9f
[  593.123814]  [<ffffffff81193710>] ? sysfs_schedule_callback+0x1df/0x1df
[  593.124125]  [<ffffffff8109f209>] __blocking_notifier_call_chain+0x4c/0x61
[  593.143899]  [<ffffffff8109f232>] blocking_notifier_call_chain+0x14/0x16
[  593.144207]  [<ffffffff81414909>] __device_release_driver+0xcd/0xd2
[  593.163934]  [<ffffffff81414933>] device_release_driver+0x25/0x32
[  593.164222]  [<ffffffff814144bd>] bus_remove_device+0x8e/0x9f
[  593.183934]  [<ffffffff8141255e>] device_del+0x130/0x17f
[  593.184186]  [<ffffffff814125c3>] device_unregister+0x16/0x23
[  593.203888]  [<ffffffff813473e5>] pci_stop_bus_device+0x61/0x83
[  593.223661]  [<ffffffff8134c88a>] ? remove_callback+0x1f/0x3c
[  593.223932]  [<ffffffff813473b4>] pci_stop_bus_device+0x30/0x83
[  593.243652]  [<ffffffff81347470>] pci_remove_bus_device+0x1a/0xba
[  593.243955]  [<ffffffff8134c896>] remove_callback+0x2b/0x3c
[  593.263631]  [<ffffffff8119372c>] sysfs_schedule_callback_work+0x1c/0x5f
[  593.263962]  [<ffffffff8109433b>] process_one_work+0x231/0x3e6
[  593.283667]  [<ffffffff810942ac>] ? process_one_work+0x1a2/0x3e6
[  593.283958]  [<ffffffff81094829>] worker_thread+0x17c/0x240
[  593.303651]  [<ffffffff810add32>] ? trace_hardirqs_on+0xd/0xf
[  593.303927]  [<ffffffff810946ad>] ? manage_workers+0xab/0xab
[  593.323617]  [<ffffffff81099ea5>] kthread+0xa0/0xa8
[  593.323845]  [<ffffffff810adbcc>] ? trace_hardirqs_on_caller+0x1f/0x178
[  593.343620]  [<ffffffff81c29614>] kernel_thread_helper+0x4/0x10
[  593.343888]  [<ffffffff81c218c4>] ? _raw_spin_unlock_irq+0x30/0x36
[  593.363642]  [<ffffffff810add32>] ? trace_hardirqs_on+0xd/0xf
[  593.383357]  [<ffffffff81c21bc0>] ? retint_restore_args+0xe/0xe
[  593.383624]  [<ffffffff81099e05>] ? __init_kthread_worker+0x5b/0x5b
[  593.403441]  [<ffffffff81c29610>] ? gs_change+0xb/0xb
[  593.403667] Code: 41 5f c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 66 66 66 66 90 45 31 ed 89 f3 49 89 d4 49 89 fe 44 0f b7 f9 eb 72 
[  593.424146]  8b 44 24 10 49 8b 16 48 8b 80 88 00 00 00 44 3b 38 75 57 48 
[  593.443684] RIP  [<ffffffff8136271a>] dmar_match_scope+0x27/0xb6
[  593.443968]  RSP <ffff881ffce45a70>
[  593.463319] CR2: 0000000000000010
[  593.463510] ---[ end trace 75ddbb3d94414ea9 ]---
[  593.465841] BUG: unable to handle kernel 

