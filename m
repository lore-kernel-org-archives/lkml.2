Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2JOFl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:41:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45541 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2JOFlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:41:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Mon, 15 Oct 2012 14:41:27 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: bhelgaas@google.com, lenb@kernel.org, yinghai@kernel.org,
        jiang.liu@huawei.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] Do not use acpi_device to find pci root bridge
 in _init code.
Message-Id: <20121015144127.731e8cf0.izumi.taku@jp.fujitsu.com>
In-Reply-To: <1350045261-7344-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1350045261-7344-1-git-send-email-tangchen@cn.fujitsu.com>
	<1350045261-7344-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 20:34:20 +0800
Tang Chen <tangchen@cn.fujitsu.com> wrote:

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

  How about squashing patch #2 into patch #1 ?
  The caller and callee should be the same place in my mind.

  Best regards,
  Taku Izumi

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
> -	int ret;
> -	struct acpi_device *device;
> +	struct acpi_device_info *info;
> +	acpi_status status;
>  
> -	ret = acpi_bus_get_device(handle, &device);
> -	if (ret)
> +	status = acpi_get_object_info(handle, &info);
> +	if (ACPI_FAILURE(status)) {
> +		printk(KERN_ERR PREFIX "%s: Error reading"
> +				       "device info\n", __func__);
>  		return 0;
> +	}
>  
> -	ret = acpi_match_device_ids(device, root_device_ids);
> -	if (ret)
> +	if (acpi_match_object_info_ids(info, root_device_ids))
>  		return 0;
>  	else
>  		return 1;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Taku Izumi <izumi.taku@jp.fujitsu.com>

