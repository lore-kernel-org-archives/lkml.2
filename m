Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066Ab2JLS0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:26:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42600 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2JLS02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:26:28 -0400
MIME-Version: 1.0
In-Reply-To: <1350045261-7344-2-git-send-email-tangchen@cn.fujitsu.com>
References: <1350045261-7344-1-git-send-email-tangchen@cn.fujitsu.com>
	<1350045261-7344-2-git-send-email-tangchen@cn.fujitsu.com>
Date: Fri, 12 Oct 2012 11:26:26 -0700
X-Google-Sender-Auth: znkcq4EKyEOUP3VqKHy-VulajMo
Message-ID: <CAE9FiQWVm-BxyGx5C89v0txn_Wdaf=Wk6oRjSjW8jTQ+3mXoMg@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] Introduce a new acpi to determine HID match.
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
> This introduce a new api to determine if a HID matches a list of IDs.
> Different from acpi_match_device_ids(), the new api gets HID from
> acpi_device_info struct.
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  drivers/acpi/scan.c     |   24 ++++++++++++++++++++++++
>  include/acpi/acpi_bus.h |    2 ++
>  2 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 03c12e6..41fd4c9 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -312,6 +312,30 @@ int acpi_match_device_ids(struct acpi_device *device,
>  }
>  EXPORT_SYMBOL(acpi_match_device_ids);
>
> +int acpi_match_object_info_ids(struct acpi_device_info *info,
> +                              const struct acpi_device_id *ids)
> +{
> +       char *hardware_id;
> +       int i, j;
> +
> +       for (i = 0; ids[i].id[0]; i++) {
> +               hardware_id = info->hardware_id.string;
> +               if (hardware_id &&
> +                   !strcmp((char *)ids[i].id, hardware_id))
> +                               return 0;
> +
> +               for (j = 0; j < info->compatible_id_list.count; j++) {
> +                       hardware_id = info->compatible_id_list.ids[j].string;
> +                       if (hardware_id &&
> +                           !strcmp((char *)ids[i].id, hardware_id))
> +                               return 0;
> +               }
> +       }
> +
> +       return 1;

-ENOENT instead of 1?

> +}
> +EXPORT_SYMBOL(acpi_match_object_info_ids);
> +
>  static void acpi_free_ids(struct acpi_device *device)
>  {
>         struct acpi_hardware_id *id, *tmp;
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index f0b9681..f83d581 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -379,6 +379,8 @@ int acpi_bus_start(struct acpi_device *device);
>  acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
>  int acpi_match_device_ids(struct acpi_device *device,
>                           const struct acpi_device_id *ids);
> +int acpi_match_object_info_ids(struct acpi_device_info *info,
> +                              const struct acpi_device_id *ids);
>  int acpi_create_dir(struct acpi_device *);
>  void acpi_remove_dir(struct acpi_device *);
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
