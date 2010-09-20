Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0ITGSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 02:18:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:39372 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0ITGSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 02:18:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,391,1280732400"; 
   d="scan'208";a="659002442"
Message-ID: <4C96FCA3.2060704@linux.intel.com>
Date: Mon, 20 Sep 2010 14:18:11 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH]  PCI / PCIe / AER: Disable native AER service if BIOS
 has precedence
References: <201009200002.15609.rjw@sisk.pl>
In-Reply-To: <201009200002.15609.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 9/20/2010 6:02 AM, Rafael J. Wysocki 写道:
> From: Rafael J. Wysocki<rjw@sisk.pl>
>
> There is a design issue related to PCIe AER and _OSC that the BIOS
> may be asked to grant control of the AER service even if some
> Hardware Error Source Table (HEST) entries contain information
> meaning that the BIOS really should control it.  Namely,
> pcie_port_acpi_setup() calls pcie_aer_get_firmware_first() that
> determines whether or not the AER service should be controlled by
> the BIOS on the basis of the HEST information for the given PCIe
> port.  The BIOS is asked to grant control of the AER service for
> a PCIe Root Complex if pcie_aer_get_firmware_first() returns 'false'
> for at least one root port in that complex, even if all of the other
> root ports' HEST entries have the FIRMWARE_FIRST flag set (and none
> of them has the GLOBAL flag set).  However, if the AER service is
> controlled by the kernel, that may interfere with the BIOS' handling
> of the error sources having the FIRMWARE_FIRST flag.  Moreover,
> there may be PCIe endpoints that have the FIRMWARE_FIRST flag set in
> HEST and are attached to the root ports in question, in which case it
> also may be unsafe to ask the BIOS for control of the AER service.
>
> For this reason, introduce a function checking if there's at least
> one PCIe-related HEST entry with the FIRMWARE_FIRST flag set and
> disable the native AER service altogether if this function returns
> 'true'.
>
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> ---
>   drivers/pci/pcie/aer/aerdrv.c      |    2 +-
>   drivers/pci/pcie/aer/aerdrv.h      |    3 +++
>   drivers/pci/pcie/aer/aerdrv_acpi.c |   31 +++++++++++++++++++++++++++++++
>   drivers/pci/pcie/portdrv_acpi.c    |    2 +-
>   4 files changed, 36 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/drivers/pci/pcie/aer/aerdrv_acpi.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ linux-2.6/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -93,4 +93,35 @@ int pcie_aer_get_firmware_first(struct p
>   		aer_set_firmware_first(dev);
>   	return dev->__aer_firmware_first;
>   }
> +
> +static bool aer_firmware_first;
> +
> +static int aer_hest_parse_aff(struct acpi_hest_header *hest_hdr, void *data)
> +{
> +	if (aer_firmware_first)
> +		return 0;
> +
> +	switch (hest_hdr->type) {
> +	case ACPI_HEST_TYPE_AER_ROOT_PORT:
> +	case ACPI_HEST_TYPE_AER_ENDPOINT:
> +	case ACPI_HEST_TYPE_AER_BRIDGE:
> +		aer_firmware_first = !!(p->flags&  ACPI_HEST_FIRMWARE_FIRST);

Where "p" comes from ? Maybe it points to "struct acpi_hest_aer_common *p;"

> +	default:
> +		return 0;
> +	}
> +}
> +
> +/**
> + * aer_acpi_firmware_first - Check if APEI should control AER.
> + */
> +bool aer_acpi_firmware_first(void)
> +{
> +	static bool parsed = false;
> +
> +	if (!parsed) {
> +		apei_hest_parse(aer_hest_parse_aff, NULL);
> +		parsed = true;
> +	}
> +	return aer_firmware_first;
> +}
>   #endif
> Index: linux-2.6/drivers/pci/pcie/aer/aerdrv.h
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv.h
> +++ linux-2.6/drivers/pci/pcie/aer/aerdrv.h
> @@ -132,6 +132,7 @@ static inline int aer_osc_setup(struct p
>
>   #ifdef CONFIG_ACPI_APEI
>   extern int pcie_aer_get_firmware_first(struct pci_dev *pci_dev);
> +extern bool aer_acpi_firmware_first(void);
>   #else
>   static inline int pcie_aer_get_firmware_first(struct pci_dev *pci_dev)
>   {
> @@ -139,6 +140,8 @@ static inline int pcie_aer_get_firmware_
>   		return pci_dev->__aer_firmware_first;
>   	return 0;
>   }
> +
> +static inline bool aer_acpi_firmware_first(void) { return false; }
>   #endif
>
>   static inline void pcie_aer_force_firmware_first(struct pci_dev *pci_dev,
> Index: linux-2.6/drivers/pci/pcie/aer/aerdrv.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv.c
> +++ linux-2.6/drivers/pci/pcie/aer/aerdrv.c
> @@ -416,7 +416,7 @@ static void aer_error_resume(struct pci_
>    */
>   static int __init aer_service_init(void)
>   {
> -	if (!pci_aer_available())
> +	if (!pci_aer_available() || aer_acpi_firmware_first())
>   		return -ENXIO;
>   	return pcie_port_service_register(&aerdriver);
>   }
> Index: linux-2.6/drivers/pci/pcie/portdrv_acpi.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/portdrv_acpi.c
> +++ linux-2.6/drivers/pci/pcie/portdrv_acpi.c
> @@ -49,7 +49,7 @@ int pcie_port_acpi_setup(struct pci_dev
>   		| OSC_PCI_EXPRESS_PME_CONTROL;
>
>   	if (pci_aer_available()) {
> -		if (pcie_aer_get_firmware_first(port))
> +		if (aer_acpi_firmware_first())
>   			dev_dbg(&port->dev, "PCIe errors handled by BIOS.\n");
>   		else
>   			flags |= OSC_PCI_EXPRESS_AER_CONTROL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

