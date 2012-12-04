Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab2LDSm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:42:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab2LDSm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:42:27 -0500
Date: Tue, 4 Dec 2012 16:41:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] aerdrv: Enhanced AER logging
Message-ID: <20121204164151.66b9bb37@redhat.com>
In-Reply-To: <20121204170436.31397.40857.stgit@grignak.americas.hpqcorp.net>
References: <20121204170429.31397.50068.stgit@grignak.americas.hpqcorp.net>
	<20121204170436.31397.40857.stgit@grignak.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 04 Dec 2012 10:04:36 -0700
Lance Ortiz <lance.ortiz@hp.com> escreveu:

> This patch will provide a more reliable and easy way for user-space
> applications to have access to AER logs rather than reading them from the
> message buffer. It also provides a way to notify user-space when an AER
> event occurs.
> 
> The aer driver is updated to generate a trace event of function 'aer_event'
> when a PCIe error is reported over the AER interface.  The trace event was
> added to both the interrupt based aer path and the firmware first path.
> 
> v1-v2 fix compile errors in ifdefs.
> v2-v3 Update to new location of trace header. Update print to remove
> warning.
> v3-v4 Reworked logic when getting ready to call cper_print_aer
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  0 files changed, 0 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index e6defd8..4a3e945 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -29,6 +29,7 @@
>  #include <linux/time.h>
>  #include <linux/cper.h>
>  #include <linux/acpi.h>
> +#include <linux/pci.h>
>  #include <linux/aer.h>
>  
>  /*
> @@ -249,6 +250,10 @@ static const char *cper_pcie_port_type_strs[] = {
>  static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  			    const struct acpi_hest_generic_data *gdata)
>  {
> +#ifdef CONFIG_ACPI_APEI_PCIEAER
> +	struct pci_dev *dev;
> +#endif
> +
>  	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
>  		printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
>  		       pcie->port_type < ARRAY_SIZE(cper_pcie_port_type_strs) ?
> @@ -281,10 +286,18 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>  #ifdef CONFIG_ACPI_APEI_PCIEAER
> -	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) {
> -		struct aer_capability_regs *aer_regs = (void *)pcie->aer_info;
> -		cper_print_aer(pfx, gdata->error_severity, aer_regs);
> +	dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
> +			pcie->device_id.bus, pcie->device_id.function);
> +	if (!dev) {
> +		pr_info("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
> +			pcie->device_id.segment, pcie->device_id.bus,
> +			pcie->device_id.slot, pcie->device_id.function);

Hmm... please correct if I'm wrong, but an error happened at PCI, and also a 
kernel bug that prevented it to get the proper PCI device... 

IMHO, the message here should be stronger, and likely printed via pr_err().

> +		return;
>  	}
> +	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO)
> +		cper_print_aer(dev, gdata->error_severity,
> +				(struct aer_capability_regs *) pcie->aer_info);
> +	pci_dev_put(dev);
>  #endif
>  }
>  
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index 3ea5173..34d96e4 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -23,6 +23,9 @@
>  
>  #include "aerdrv.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/ras.h>
> +
>  #define AER_AGENT_RECEIVER		0
>  #define AER_AGENT_REQUESTER		1
>  #define AER_AGENT_COMPLETER		2
> @@ -194,6 +197,8 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
>  	if (info->id && info->error_dev_num > 1 && info->id == id)
>  		printk("%s""  Error of this Agent(%04x) is reported first\n",
>  			prefix, id);
> +	trace_aer_event(dev_name(&dev->dev), (info->status & ~info->mask),
> +			info->severity);
>  }
>  
>  void aer_print_port_info(struct pci_dev *dev, struct aer_err_info *info)
> @@ -217,12 +222,13 @@ int cper_severity_to_aer(int cper_severity)
>  }
>  EXPORT_SYMBOL_GPL(cper_severity_to_aer);
>  
> -void cper_print_aer(const char *prefix, int cper_severity,
> +void cper_print_aer(struct pci_dev *dev, int cper_severity,
>  		    struct aer_capability_regs *aer)
>  {
>  	int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
>  	u32 status, mask;
>  	const char **status_strs;
> +	char *prefix = NULL;
>  
>  	aer_severity = cper_severity_to_aer(cper_severity);
>  	if (aer_severity == AER_CORRECTABLE) {
> @@ -259,5 +265,7 @@ void cper_print_aer(const char *prefix, int cper_severity,
>  			*(tlp + 8), *(tlp + 15), *(tlp + 14),
>  			*(tlp + 13), *(tlp + 12));
>  	}
> +	trace_aer_event(dev_name(&dev->dev), (status & ~mask),
> +			aer_severity);
>  }
>  #endif
> diff --git a/include/linux/aer.h b/include/linux/aer.h
> index 544abdb..7b86dc6 100644
> --- a/include/linux/aer.h
> +++ b/include/linux/aer.h
> @@ -49,7 +49,7 @@ static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
>  }
>  #endif
>  
> -extern void cper_print_aer(const char *prefix, int cper_severity,
> +extern void cper_print_aer(struct pci_dev *dev, int cper_severity,
>  			   struct aer_capability_regs *aer);
>  extern int cper_severity_to_aer(int cper_severity);
>  extern void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
> 

After addressing the above:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>


-- 

Cheers,
Mauro
