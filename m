Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab2JLScN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:32:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41687 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab2JLScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:32:12 -0400
MIME-Version: 1.0
In-Reply-To: <1350045261-7344-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1350045261-7344-1-git-send-email-tangchen@cn.fujitsu.com>
	<1350045261-7344-3-git-send-email-tangchen@cn.fujitsu.com>
Date: Fri, 12 Oct 2012 11:32:10 -0700
X-Google-Sender-Auth: PMaPF4nWVe0LpVSBYpQ1dXnV7fU
Message-ID: <CAE9FiQX-P-X43B52-JondDDN406NYv2dwk8hk4YULrrySW4suQ@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] Do not use acpi_device to find pci root bridge in
 _init code.
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: bhelgaas@google.com, lenb@kernel.org, jiang.liu@huawei.com,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 5:34 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> When the kernel is being initialized, and some hardwares are not added
> to system, there won't be acpi_device structs for these devices. But
> acpi_is_root_bridge() depends on acpi_device struct. As a result, all
> the not-added root bridge will not be judged as a root bridge in
> find_root_bridges(). And further more, no handle_hotplug_event_root()
> notifier will be installed for them.
>
> This patch introduces a new api to find all root bridges in system by
> getting HID directly from ACPI namespace, not depending on acpi_device
> struct.
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Liu Jiang <jiang.liu@huawei.com>
> ---
>  drivers/acpi/pci_root.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 6151d83..582eb11 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -129,20 +129,23 @@ EXPORT_SYMBOL_GPL(acpi_get_pci_rootbridge_handle);
>   * acpi_is_root_bridge - determine whether an ACPI CA node is a PCI root bridge
>   * @handle - the ACPI CA node in question.
>   *
> - * Note: we could make this API take a struct acpi_device * instead, but
> - * for now, it's more convenient to operate on an acpi_handle.
> + * Note: If a device is not added to the system yet, there won't be an
> + * acpi_device struct for it. So do not get HID and CID from acpi_device,
> + * get them from ACPI namespace directly.
>   */
>  int acpi_is_root_bridge(acpi_handle handle)
>  {
> -       int ret;
> -       struct acpi_device *device;
> +       struct acpi_device_info *info;
> +       acpi_status status;
>
> -       ret = acpi_bus_get_device(handle, &device);
> -       if (ret)
> +       status = acpi_get_object_info(handle, &info);
> +       if (ACPI_FAILURE(status)) {
> +               printk(KERN_ERR PREFIX "%s: Error reading"
> +                                      "device info\n", __func__);
>                 return 0;
> +       }
>
> -       ret = acpi_match_device_ids(device, root_device_ids);
> -       if (ret)
> +       if (acpi_match_object_info_ids(info, root_device_ids))
>                 return 0;
>         else
>                 return 1;

there are some other users for acpi_is_root_bridge.

drivers/acpi/pci_root.c:        while (!acpi_is_root_bridge(phandle)) {
drivers/pci/hotplug/acpi_pcihp.c:               if (acpi_is_root_bridge(handle))
drivers/pci/hotplug/acpi_pcihp.c:               if (acpi_is_root_bridge(handle))

and they are ok to have acpi_device ready.

so we could have another separated static version for those not added ones?

Thanks

Yinghai
