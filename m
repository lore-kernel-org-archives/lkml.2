Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab1JZLk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 07:40:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772Ab1JZLkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 07:40:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH] PCI / ACPI: Make acpiphp ignore root bridges using PCIe native hotplug
Date: Wed, 26 Oct 2011 13:42:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201110220043.38635.rjw@sisk.pl> <201110251525.27446.rjw@sisk.pl> <4EA7543E.7050009@jp.fujitsu.com>
In-Reply-To: <4EA7543E.7050009@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201110261342.51843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 26, 2011, Kenji Kaneshige wrote:
> (2011/10/25 22:25), Rafael J. Wysocki wrote:
> > On Tuesday, October 25, 2011, Kenji Kaneshige wrote:
> >> Looks good.
> >> This is also needed for SHPC native hotplug.
> > 
> > I don't think so, we still leave the SHPC _OSC for the driver to take care
> > of (which may not be the right thing, but I don't feel confident enough to
> > decide :-)).
> 
> I think of the case that acpiphp driver is loaded after shpchp driver is unloaded.
> Once native hotplug control is granted to OS, there is no way to return the control
> to firmware. So once shpchp gets the native hotplug control on a given root bridge,
> acpiphp should not try to handle the hotplug slots under it.

Good point, but that would be a separate patch I think?

Rafael


> >> (2011/10/22 7:43), Rafael J. Wysocki wrote:
> >>> From: Rafael J. Wysocki<rjw@sisk.pl>
> >>>
> >>> If the kernel has requested control of the PCIe native hotplug
> >>> feature for a given root complex, the acpiphp driver should not try
> >>> to handle that root complex and it should leave it to pciehp.
> >>> Failing to do so causes problems to happen if acpiphp is loaded
> >>> before pciehp on such systems.
> >>>
> >>> To address this issue make find_root_bridges() ignore PCIe root
> >>> complexes with PCIe native hotplug enabled and make add_bridge()
> >>> return error code if PCIe native hotplug is enabled for the given
> >>> root port.  This causes acpiphp to refuse to load if PCIe native
> >>> hotplug is enabled for all complexes and to refuse binding to
> >>> the root complexes with PCIe native hotplug is enabled.
> >>>
> >>> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> >>> ---
> >>>    drivers/pci/hotplug/acpiphp_glue.c |   29 ++++++++++++++++++++++++-----
> >>>    1 file changed, 24 insertions(+), 5 deletions(-)
> >>>
> >>> Index: linux/drivers/pci/hotplug/acpiphp_glue.c
> >>> ===================================================================
> >>> --- linux.orig/drivers/pci/hotplug/acpiphp_glue.c
> >>> +++ linux/drivers/pci/hotplug/acpiphp_glue.c
> >>> @@ -458,8 +458,17 @@ static int add_bridge(acpi_handle handle
> >>>    {
> >>>    	acpi_status status;
> >>>    	unsigned long long tmp;
> >>> +	struct acpi_pci_root *root;
> >>>    	acpi_handle dummy_handle;
> >>>
> >>> +	/*
> >>> +	 * We shouldn't use this bridge if PCIe native hotplug control has been
> >>> +	 * granted by the BIOS for it.
> >>> +	 */
> >>> +	root = acpi_pci_find_root(handle);
> >>> +	if (root&&   (root->osc_control_set&   OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
> >>> +		return -ENODEV;
> >>> +
> >>>    	/* if the bridge doesn't have _STA, we assume it is always there */
> >>>    	status = acpi_get_handle(handle, "_STA",&dummy_handle);
> >>>    	if (ACPI_SUCCESS(status)) {
> >>> @@ -1297,13 +1306,23 @@ static void handle_hotplug_event_func(ac
> >>>    static acpi_status
> >>>    find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> >>>    {
> >>> +	struct acpi_pci_root *root;
> >>>    	int *count = (int *)context;
> >>>
> >>> -	if (acpi_is_root_bridge(handle)) {
> >>> -		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> >>> -				handle_hotplug_event_bridge, NULL);
> >>> -			(*count)++;
> >>> -	}
> >>> +	if (!acpi_is_root_bridge(handle))
> >>> +		return AE_OK;
> >>> +
> >>> +	root = acpi_pci_find_root(handle);
> >>> +	if (!root)
> >>> +		return AE_OK;
> >>> +
> >>> +	if (root->osc_control_set&   OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
> >>> +		return AE_OK;
> >>> +
> >>> +	(*count)++;
> >>> +	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> >>> +				    handle_hotplug_event_bridge, NULL);
> >>> +
> >>>    	return AE_OK ;
> >>>    }
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> >>
> >>
> > 
> > 
> 
> 
> 

