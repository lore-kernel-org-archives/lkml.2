Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2LEOcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:32:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42889 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab2LEOcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:32:05 -0500
Date: Wed, 5 Dec 2012 15:32:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/3] aerdrv: Enhanced AER logging
Message-ID: <20121205143202.GD2364@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121204210305.4515.91100.stgit@grignak.americas.hpqcorp.net>
 <20121204210312.4515.13415.stgit@grignak.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121204210312.4515.13415.stgit@grignak.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 02:03:12PM -0700, Lance Ortiz wrote:
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
> v6-v7 Change print from pr_info to pr_err if !dev
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  drivers/acpi/apei/cper.c               |   19 ++++++++++++++++---
>  drivers/pci/pcie/aer/aerdrv_errprint.c |   10 +++++++++-
>  include/linux/aer.h                    |    2 +-
>  3 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index e6defd8..b2f695b 100644
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
> +		pr_err("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
> +			pcie->device_id.segment, pcie->device_id.bus,
> +			pcie->device_id.slot, pcie->device_id.function);
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

What are you doing here? You dropped the 'prefix' argument being passed
down in this function and are defining a local variable of the same name
which is used in the function later:

        printk("%s""aer_status: 0x%08x, aer_mask: 0x%08x\n",
               prefix, status, mask);

WTF?

Also, this function cper_print_aer() is too crammed and could use a
little spacing out between lines belonging logically together.

Finally, please wait a couple of days before resending the patchset
so that you can collect *all* feedback and can save yourself needless
iterations.

Thanks.

-- 
Regards/Gruss,
    Boris.
