Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab2JDNDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:03:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43426 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2JDNDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:03:52 -0400
MIME-Version: 1.0
In-Reply-To: <1349305214-3241-2-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
	<1349305214-3241-1-git-send-email-yinghai@kernel.org>
	<1349305214-3241-2-git-send-email-yinghai@kernel.org>
Date: Thu, 4 Oct 2012 09:03:51 -0400
X-Google-Sender-Auth: CUv1VY5MhfbRPseljwXVFhWVU6g
Message-ID: <CACJDEmoeD+XwjGnA2WwkeJ5TrsaXfgw+mZHPDcX0+7QZ9_80SA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ACPI: add drivers_autoprobe in struct acpi_device
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 7:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> To use to control the delay attach driver for acpi_device.

<blinks>
I am not sure what this says. Can you please explain how it controls
the delaying of
attaching drivers?
>
> Will use bus notifier to toggle this bits when needed.

Will use ..? In a subsequent patch? Which patch? And when is this
needed? Is there a patch that needs this?
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/acpi/scan.c     |    8 +++++++-
>  include/acpi/acpi_bus.h |    1 +
>  2 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index d1ecca2..cbb3ed1 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -333,7 +333,12 @@ static void acpi_device_release(struct device *dev)
>  static int acpi_bus_match(struct device *dev, struct device_driver *drv)
>  {
>         struct acpi_device *acpi_dev = to_acpi_device(dev);
> -       struct acpi_driver *acpi_drv = to_acpi_driver(drv);
> +       struct acpi_driver *acpi_drv;
> +
> +       if (!acpi_dev->drivers_autoprobe)
> +               return 0;
> +
> +       acpi_drv = to_acpi_driver(drv);
>
>         return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
>  }
> @@ -1268,6 +1273,7 @@ static int acpi_add_single_object(struct acpi_device **child,
>         device->parent = acpi_bus_get_parent(handle);
>         device->bus_ops = *ops; /* workround for not call .start */
>         STRUCT_TO_INT(device->status) = sta;
> +       device->drivers_autoprobe = true;
>
>         acpi_device_get_busid(device);
>
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index bde976e..969544e 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -304,6 +304,7 @@ struct acpi_device {
>         struct device dev;
>         struct acpi_bus_ops bus_ops;    /* workaround for different code path for hotplug */
>         enum acpi_bus_removal_type removal_type;        /* indicate for different removal type */
> +       bool drivers_autoprobe;
>  };
>
>  static inline void *acpi_driver_data(struct acpi_device *d)
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
