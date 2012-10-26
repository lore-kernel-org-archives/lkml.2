Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2JZJKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:10:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35319 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab2JZJKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <1350593430-24470-4-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org> <1350593430-24470-4-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Oct 2012 03:10:21 -0600
Message-ID: <CAErSpo5s9sz+i+Qkuu1=HpfrSh271axkLDRgJSaKED5q3DNfPg@mail.gmail.com>
Subject: Re: [PATCH 2/3] PCI: correctly detect ACPI PCI host bridge objects
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 2:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
>
> The code in pci_root_hp.c depends on function acpi_is_root_bridge()
> to check whether an ACPI object is a PCI host bridge or not.
> If an ACPI device hasn't been created for the ACPI object yet,
> function acpi_is_root_bridge() will return false even if the object
> is a PCI host bridge object. That behavior will cause two issues:
> 1) No ACPI notification handler installed for PCI host bridges absent
>    at startup, so hotplug events for those bridges won't be handled.
> 2) rescan_root_bridge() can't reenumerate offlined PCI host bridges
>    because the ACPI devices have been already destroyed.
>
> So use acpi_match_object_info_ids() to correctly detect PCI host bridges.
>
> -v2: update to use acpi_match_object_info_ids() from Tang Chen  - Yinghai
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/pci_root_hp.c |   25 ++++++++++++++++++++++++-
>  1 files changed, 24 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
> index 2aebf78..3edec7f 100644
> --- a/drivers/acpi/pci_root_hp.c
> +++ b/drivers/acpi/pci_root_hp.c
> @@ -19,6 +19,12 @@ struct acpi_root_bridge {
>         u32 flags;
>  };
>
> +static const struct acpi_device_id root_device_ids[] = {
> +       {"PNP0A03", 0},
> +       {"PNP0A08", 0},

Why do we need PNP0A08 here?

Per the PCI Firmware Spec, sec 4.1.5, PNP0A08 identifies a PCI Express
or a PCI-X Mode 2 host bridge, and such a device is required to
include PNP0A03 in _CID.  Therefore, it should be sufficient to look
only for PNP0A03.

That raises the question of why the spec defined PNP0A08 in the first
place.  It looks like PNP0A08 is intended specifically to indicate
support for extended config space (offsets 256-4095), per sec 4.1.5
(Note 1) and sec 4.3.1.

I don't think Linux currently does anything differently with PNP0A08,
so if the spec authors thought it was important to add PNP0A08, maybe
Linux is missing something.  For example, maybe we should be limiting
config space size to 256 unless we're below a PNP0A08 device.  I don't
know what that could *fix*, unless it would allow us to get rid of
some quirks or something, but usually spec authors don't add things
unless they think there's a reason it's needed.

> +       {"", 0},
> +};
> +
>  /* bridge flags */
>  #define ROOT_BRIDGE_HAS_EJ0    (0x00000002)
>  #define ROOT_BRIDGE_HAS_PS3    (0x00000080)
> @@ -256,6 +262,23 @@ static void handle_hotplug_event_root(acpi_handle handle, u32 type,
>                                 _handle_hotplug_event_root);
>  }
>
> +static bool acpi_is_root_bridge_object(acpi_handle handle)
> +{
> +       struct acpi_device_info *info = NULL;
> +       acpi_status status;
> +       bool ret;
> +
> +       status = acpi_get_object_info(handle, &info);
> +       if (ACPI_FAILURE(status))
> +               return false;
> +
> +       ret = !acpi_match_object_info_ids(info, root_device_ids);
> +
> +       kfree(info);
> +
> +       return ret;
> +}
> +
>  static acpi_status __init
>  find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>  {
> @@ -264,7 +287,7 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>                                       .pointer = objname };
>         int *count = (int *)context;
>
> -       if (!acpi_is_root_bridge(handle))
> +       if (!acpi_is_root_bridge_object(handle))
>                 return AE_OK;
>
>         (*count)++;
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
