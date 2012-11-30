Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2K3BMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:12:38 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47471 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752859Ab2K3BMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:12:37 -0500
Message-ID: <1354237958.4275.4.camel@joe-AO722>
Subject: Re: [PATCH v2 2/3] aerdrv: Enhanced AER logging
From: Joe Perches <joe@perches.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 17:12:38 -0800
In-Reply-To: <20121129225800.8405.83305.stgit@grignak.americas.hpqcorp.net>
References: <20121129225800.8405.83305.stgit@grignak.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 15:58 -0700, Lance Ortiz wrote:
> This patch will provide a more reliable and easy way for user-space
> applications to have access to AER logs rather than reading them from the
> message buffer. It also provides a way to notify user-space when an AER
> event occurs.
[]
>  0 files changed, 0 insertions(+), 0 deletions(-)

Those are odd patch statistics

> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
[]
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
> +		printk("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
> +			pcie->device_id.segment, pcie->device_id.bus,
> +			pcie->device_id.slot, pcie->device_id.function);
> +
> +	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO && dev) {
>  		struct aer_capability_regs *aer_regs = (void *)pcie->aer_info;
> -		cper_print_aer(pfx, gdata->error_severity, aer_regs);
> +		cper_print_aer(dev, gdata->error_severity, aer_regs);
> +		pci_dev_put(dev);
>  	}

This could be written something like:
	dev = etc..
	if (!dev) {
		pr_err(etc...)
	} else if {pcie->validation_bits & ...) {
		etc...


