Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2JWQAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:00:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46168 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2JWQAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:00:46 -0400
MIME-Version: 1.0
In-Reply-To: <1350045098-7232-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1350045098-7232-1-git-send-email-tangchen@cn.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 23 Oct 2012 10:00:25 -0600
Message-ID: <CAErSpo5QESO0J8LfzvvzCm4pTG=+9dOb0eYfsphoE7+mb2-MeA@mail.gmail.com>
Subject: Re: [PATCH v2] Fix a hard coding style when determining if a device
 is a container.
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: lenb@kernel.org, yinghai@kernel.org, jiang.liu@huawei.com,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 6:31 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> "ACPI0004","PNP0A05" and "PNP0A06" are all defined in array
> container_device_ids[], so use it, but not the hard coding style.
>
> Also, introduce a new api is_container_device() to determine if a
> device is a container device.
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Looks good to me, but is_container_device() should be of type "bool",
not type "int".

With that change,

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/acpi/container.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index 1f9f7d7..ffd76ee 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -92,6 +92,19 @@ static int is_device_present(acpi_handle handle)
>         return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
>  }
>
> +static int is_container_device(const char *hid)
> +{
> +       const struct acpi_device_id *container_id;
> +
> +       for (container_id = container_device_ids;
> +            container_id->id[0]; container_id++) {
> +               if (!strcmp((char *)container_id->id, hid))
> +                       return 1;
> +       }
> +
> +       return 0;
> +}
> +
>  /*******************************************************************/
>  static int acpi_container_add(struct acpi_device *device)
>  {
> @@ -232,10 +245,8 @@ container_walk_namespace_cb(acpi_handle handle,
>                 goto end;
>         }
>
> -       if (strcmp(hid, "ACPI0004") && strcmp(hid, "PNP0A05") &&
> -           strcmp(hid, "PNP0A06")) {
> +       if (!is_container_device(hid))
>                 goto end;
> -       }
>
>         switch (*action) {
>         case INSTALL_NOTIFY_HANDLER:
> --
> 1.7.1
>
