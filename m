Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab1KGBnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 20:43:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39516 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1KGBna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 20:43:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EB737A8.3000208@jp.fujitsu.com>
Date: Mon, 07 Nov 2011 10:43:04 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI / ACPI: Make acpiphp ignore root bridges using SHPC
 native hotplug
References: <201110220043.38635.rjw@sisk.pl> <201110261342.51843.rjw@sisk.pl> <4EAA1762.1060207@jp.fujitsu.com> <201111062311.28913.rjw@sisk.pl>
In-Reply-To: <201111062311.28913.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for doing this.
Looks good to me.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Regards,
Kenji Kaneshige


(2011/11/07 7:11), Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rjw@sisk.pl>
>
> If the kernel has requested control of the SHPC native hotplug
> feature for a given root bridge, the acpiphp driver should not try
> to handle that root bridge and it should leave it to shpchp.
> Failing to do so causes problems to happen if shpchp is loaded
> and unloaded before loading acpiphp (ACPI-based hotplug won't work
> in that case anyway).
>
> To address this issue make find_root_bridges() ignore PCI root
> bridges with SHPC native hotplug enabled and make add_bridge()
> return error code if SHPC native hotplug is enabled for the given
> root bridge.  This causes acpiphp to refuse to load if SHPC native
> hotplug is enabled for all root bridges and to refuse binding to
> the root bridges with SHPC native hotplug enabled.
>
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> ---
>
> Jesse,
>
> This should apply to your linux-next branch.
>
> Thanks,
> Rafael
>
> ---
>   drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
>   include/linux/acpi.h               |    4 ++++
>   2 files changed, 6 insertions(+), 2 deletions(-)
>
> Index: linux/include/linux/acpi.h
> ===================================================================
> --- linux.orig/include/linux/acpi.h
> +++ linux/include/linux/acpi.h
> @@ -302,6 +302,10 @@ extern bool osc_sb_apei_support_acked;
>   				OSC_PCI_EXPRESS_PME_CONTROL |		\
>   				OSC_PCI_EXPRESS_AER_CONTROL |		\
>   				OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL)
> +
> +#define OSC_PCI_NATIVE_HOTPLUG	(OSC_PCI_EXPRESS_NATIVE_HP_CONTROL |	\
> +				OSC_SHPC_NATIVE_HP_CONTROL)
> +
>   extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
>   					     u32 *mask, u32 req);
>   extern void acpi_early_init(void);
> Index: linux/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux/drivers/pci/hotplug/acpiphp_glue.c
> @@ -467,7 +467,7 @@ static int add_bridge(acpi_handle handle
>   	 * granted by the BIOS for it.
>   	 */
>   	root = acpi_pci_find_root(handle);
> -	if (root&&  (root->osc_control_set&  OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
> +	if (root&&  (root->osc_control_set&  OSC_PCI_NATIVE_HOTPLUG))
>   		return -ENODEV;
>
>   	/* if the bridge doesn't have _STA, we assume it is always there */
> @@ -1395,7 +1395,7 @@ find_root_bridges(acpi_handle handle, u3
>   	if (!root)
>   		return AE_OK;
>
> -	if (root->osc_control_set&  OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
> +	if (root->osc_control_set&  OSC_PCI_NATIVE_HOTPLUG)
>   		return AE_OK;
>
>   	(*count)++;
>

