Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2LAPvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 10:51:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54681 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab2LAPve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 10:51:34 -0500
Date: Sat, 1 Dec 2012 16:51:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] aerdrv: Enhanced AER logging
Message-ID: <20121201155130.GA12274@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
 <20121130213337.7649.6709.stgit@grignak.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121130213337.7649.6709.stgit@grignak.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 02:33:37PM -0700, Lance Ortiz wrote:
> This patch will provide a more reliable and easy way for user-space
> applications to have access to AER logs rather than reading them from the
> message buffer. It also provides a way to notify user-space when an AER
> event occurs.
> 
> The aer driver is updated to generate a trace event of function 'aer_event'
> when an AER occurs.

... when a PCIe error is reported over the AER interface.

> The trace event was added to both the interrupt
> based aer path and the firmware first path
> 
> v1-v2 fix compile errors in ifdefs.
> v2-v3 Update to new location of trace header. Update print to remove
> warning.
> 
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  drivers/acpi/apei/cper.c               |   17 +++++++++++++++--
>  drivers/pci/pcie/aer/aerdrv_errprint.c |   10 +++++++++-
>  include/linux/aer.h                    |    2 +-
>  3 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index e6defd8..e9d6062 100644
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
> @@ -281,9 +286,17 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>  #ifdef CONFIG_ACPI_APEI_PCIEAER
> -	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) {
> +	dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
> +			pcie->device_id.bus, pcie->device_id.function);
> +	if (!dev)
> +		pr_info("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
> +			pcie->device_id.segment, pcie->device_id.bus,
> +			pcie->device_id.slot, pcie->device_id.function);
> +
> +	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO && dev) {

You don't need to test dev here because you've tested for !dev in the
line above...

>  		struct aer_capability_regs *aer_regs = (void *)pcie->aer_info;
> -		cper_print_aer(pfx, gdata->error_severity, aer_regs);
> +		cper_print_aer(dev, gdata->error_severity, aer_regs);
> +		pci_dev_put(dev);

... and thus this pci_dev_put() has to be unconditional, i.e. after the
if test.

which means that you can simplify the last 4 lines like this:

	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO)
		cper_print_aer(dev, gdata->error_severity,
			       (struct aer_capability_regs *)pcie->aer_info);

	pci_dev_put(dev);

...

Thanks.

-- 
Regards/Gruss,
    Boris.
