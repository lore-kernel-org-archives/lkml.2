Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1CRBKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 21:10:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50346 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1CRBKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 21:10:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D82B0FC.1060303@jp.fujitsu.com>
Date: Fri, 18 Mar 2011 10:10:20 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI/ACPI: Report ASPM support to BIOS if not disabled
 from command line
References: <201103051321.51856.rjw@sisk.pl>
In-Reply-To: <201103051321.51856.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,

This patch fixes the problem that PCIe hotplug no longer work in 2.6.38
on my platform (ASPM is disabled　through ACPI FADT in my platform).
I think this need to be applied soon.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Regards,
Kenji Kaneshige


(2011/03/05 21:21), Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rjw@sisk.pl>
>
> We need to distinguish the situation in which ASPM support is
> disabled from the command line or through .config from the situation
> in which it is disabled, because the hardware or BIOS can't handle
> it.  In the former case we should not report ASPM support to the BIOS
> through ACPI _OSC, but in the latter case we should do that.
>
> Introduce pcie_aspm_support_enabled() that can be used by
> acpi_pci_root_add() to determine whether or not it should report ASPM
> support to the BIOS through _OSC.
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=29722
> References: https://bugzilla.kernel.org/show_bug.cgi?id=20232
> Reported-and-tested-by: Ortwin Glück<odi@odi.ch>
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> ---
>   drivers/acpi/pci_root.c |    2 +-
>   drivers/pci/pcie/aspm.c |    7 +++++++
>   include/linux/pci.h     |    7 +++----
>   3 files changed, 11 insertions(+), 5 deletions(-)
>
> Index: linux-2.6/drivers/pci/pcie/aspm.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/aspm.c
> +++ linux-2.6/drivers/pci/pcie/aspm.c
> @@ -69,6 +69,7 @@ struct pcie_link_state {
>   };
>
>   static int aspm_disabled, aspm_force, aspm_clear_state;
> +static bool aspm_support_enabled = true;
>   static DEFINE_MUTEX(aspm_lock);
>   static LIST_HEAD(link_list);
>
> @@ -896,6 +897,7 @@ static int __init pcie_aspm_disable(char
>   {
>   	if (!strcmp(str, "off")) {
>   		aspm_disabled = 1;
> +		aspm_support_enabled = false;
>   		printk(KERN_INFO "PCIe ASPM is disabled\n");
>   	} else if (!strcmp(str, "force")) {
>   		aspm_force = 1;
> @@ -930,3 +932,8 @@ int pcie_aspm_enabled(void)
>   }
>   EXPORT_SYMBOL(pcie_aspm_enabled);
>
> +bool pcie_aspm_support_enabled(void)
> +{
> +	return aspm_support_enabled;
> +}
> +EXPORT_SYMBOL(pcie_aspm_support_enabled);
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -564,7 +564,7 @@ static int __devinit acpi_pci_root_add(s
>   	/* Indicate support for various _OSC capabilities. */
>   	if (pci_ext_cfg_avail(root->bus->self))
>   		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
> -	if (pcie_aspm_enabled())
> +	if (pcie_aspm_support_enabled())
>   		flags |= OSC_ACTIVE_STATE_PWR_SUPPORT |
>   			OSC_CLOCK_PWR_CAPABILITY_SUPPORT;
>   	if (pci_msi_enabled())
> Index: linux-2.6/include/linux/pci.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci.h
> +++ linux-2.6/include/linux/pci.h
> @@ -1002,12 +1002,11 @@ extern bool pcie_ports_auto;
>   #endif
>
>   #ifndef CONFIG_PCIEASPM
> -static inline int pcie_aspm_enabled(void)
> -{
> -	return 0;
> -}
> +static inline int pcie_aspm_enabled(void) { return 0; }
> +static inline bool pcie_aspm_support_enabled(void) { return false; }
>   #else
>   extern int pcie_aspm_enabled(void);
> +extern bool pcie_aspm_support_enabled(void);
>   #endif
>
>   #ifdef CONFIG_PCIEAER
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


