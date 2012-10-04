Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2JDM6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:58:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44050 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2JDM55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:57:57 -0400
MIME-Version: 1.0
In-Reply-To: <1349305214-3241-5-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
	<1349305214-3241-1-git-send-email-yinghai@kernel.org>
	<1349305214-3241-5-git-send-email-yinghai@kernel.org>
Date: Thu, 4 Oct 2012 08:57:56 -0400
X-Google-Sender-Auth: uzU65JFmW8xaAer9J3ukBQ2tFAo
Message-ID: <CACJDEmq8hp8P4=KdFGqAE67fkEMdkQwTJhh3k-59U6CF2U-9GA@mail.gmail.com>
Subject: Re: [PATCH 4/4] ACPI: remove acpi_op_start workaround
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
> No .start on any acpi_driver ops anymore.

Could you include the git commit number (of the one that removed it)
and a little description of why it was removed please?


>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/acpi/scan.c     |   95 ++++++++--------------------------------------
>  include/acpi/acpi_bus.h |    8 ----
>  2 files changed, 17 insertions(+), 86 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 1bafa2d..5e6d2ad 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -416,7 +416,6 @@ static void acpi_device_remove_notify_handler(struct acpi_device *device)
>  }
>
>  static int acpi_bus_driver_init(struct acpi_device *, struct acpi_driver *);
> -static int acpi_start_single_object(struct acpi_device *);
>  static int acpi_device_probe(struct device * dev)
>  {
>         struct acpi_device *acpi_dev = to_acpi_device(dev);
> @@ -425,9 +424,6 @@ static int acpi_device_probe(struct device * dev)
>
>         ret = acpi_bus_driver_init(acpi_dev, acpi_drv);
>         if (!ret) {
> -               if (acpi_dev->bus_ops.acpi_op_start)
> -                       acpi_start_single_object(acpi_dev);
> -
>                 if (acpi_drv->ops.notify) {
>                         ret = acpi_device_install_notify_handler(acpi_dev);
>                         if (ret) {
> @@ -604,24 +600,6 @@ acpi_bus_driver_init(struct acpi_device *device, struct acpi_driver *driver)
>         return 0;
>  }
>
> -static int acpi_start_single_object(struct acpi_device *device)
> -{
> -       int result = 0;
> -       struct acpi_driver *driver;
> -
> -
> -       if (!(driver = device->driver))
> -               return 0;
> -
> -       if (driver->ops.start) {
> -               result = driver->ops.start(device);
> -               if (result && driver->ops.remove)
> -                       driver->ops.remove(device, ACPI_BUS_REMOVAL_NORMAL);
> -       }
> -
> -       return result;
> -}
> -
>  /**
>   * acpi_bus_register_driver - register a driver with the ACPI bus
>   * @driver: driver being registered
> @@ -1254,8 +1232,7 @@ static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>
>  static int acpi_add_single_object(struct acpi_device **child,
>                                   acpi_handle handle, int type,
> -                                 unsigned long long sta,
> -                                 struct acpi_bus_ops *ops)
> +                                 unsigned long long sta)
>  {
>         int result;
>         struct acpi_device *device;
> @@ -1271,7 +1248,6 @@ static int acpi_add_single_object(struct acpi_device **child,
>         device->device_type = type;
>         device->handle = handle;
>         device->parent = acpi_bus_get_parent(handle);
> -       device->bus_ops = *ops; /* workround for not call .start */
>         STRUCT_TO_INT(device->status) = sta;
>         device->drivers_autoprobe = true;
>
> @@ -1354,16 +1330,12 @@ end:
>
>  static void acpi_bus_add_power_resource(acpi_handle handle)
>  {
> -       struct acpi_bus_ops ops = {
> -               .acpi_op_add = 1,
> -               .acpi_op_start = 1,
> -       };
>         struct acpi_device *device = NULL;
>
>         acpi_bus_get_device(handle, &device);
>         if (!device)
>                 acpi_add_single_object(&device, handle, ACPI_BUS_TYPE_POWER,
> -                                       ACPI_STA_DEFAULT, &ops);
> +                                       ACPI_STA_DEFAULT);
>  }
>
>  static int acpi_bus_type_and_status(acpi_handle handle, int *type,
> @@ -1408,7 +1380,6 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
>  static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl,
>                                       void *context, void **return_value)
>  {
> -       struct acpi_bus_ops *ops = context;
>         int type;
>         unsigned long long sta;
>         struct acpi_device *device;
> @@ -1433,37 +1404,30 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl,
>
>         /*
>          * We may already have an acpi_device from a previous enumeration.  If
> -        * so, we needn't add it again, but we may still have to start it.
> +        * so, we needn't add it again.
>          */
>         device = NULL;
>         acpi_bus_get_device(handle, &device);
> -       if (ops->acpi_op_add && !device)
> -               acpi_add_single_object(&device, handle, type, sta, ops);
> +       if (!device)
> +               acpi_add_single_object(&device, handle, type, sta);
>
>         if (!device)
>                 return AE_CTRL_DEPTH;
>
> -       if (ops->acpi_op_start && !(ops->acpi_op_add)) {
> -               status = acpi_start_single_object(device);
> -               if (ACPI_FAILURE(status))
> -                       return AE_CTRL_DEPTH;
> -       }
> -
>         if (!*return_value)
>                 *return_value = device;
>         return AE_OK;
>  }
>
> -static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
> -                        struct acpi_device **child)
> +static int acpi_bus_scan(acpi_handle handle, struct acpi_device **child)
>  {
>         acpi_status status;
>         void *device = NULL;
>
> -       status = acpi_bus_check_add(handle, 0, ops, &device);
> +       status = acpi_bus_check_add(handle, 0, NULL, &device);
>         if (ACPI_SUCCESS(status))
>                 acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> -                                   acpi_bus_check_add, NULL, ops, &device);
> +                                   acpi_bus_check_add, NULL, NULL, &device);
>
>         if (child)
>                 *child = device;
> @@ -1488,28 +1452,24 @@ static void acpi_bus_attach(struct acpi_device *dev)
>  }
>
>  /*
> - * acpi_bus_add and acpi_bus_start
> + * acpi_bus_add
>   *
>   * scan a given ACPI tree and (probably recently hot-plugged)
> - * create and add or starts found devices.
> + * create and add found devices.
>   *
>   * If no devices were found -ENODEV is returned which does not
>   * mean that this is a real error, there just have been no suitable
>   * ACPI objects in the table trunk from which the kernel could create
> - * a device and add/start an appropriate driver.
> + * a device and add an appropriate driver.
>   */
>
>  int
>  acpi_bus_add(struct acpi_device **child,
>              struct acpi_device *parent, acpi_handle handle, int type)
>  {
> -       struct acpi_bus_ops ops;
>         int result;
>
> -       memset(&ops, 0, sizeof(ops));
> -       ops.acpi_op_add = 1;
> -
> -       result = acpi_bus_scan(handle, &ops, child);
> +       result = acpi_bus_scan(handle, child);
>
>         if (*child)
>                 acpi_bus_attach(*child);
> @@ -1520,20 +1480,12 @@ EXPORT_SYMBOL(acpi_bus_add);
>
>  int acpi_bus_start(struct acpi_device *device)
>  {
> -       struct acpi_bus_ops ops;
> -       int result;
> -
>         if (!device)
>                 return -EINVAL;
>
> -       memset(&ops, 0, sizeof(ops));
> -       ops.acpi_op_start = 1;
> -
> -       result = acpi_bus_scan(device->handle, &ops, NULL);
> -
>         acpi_update_all_gpes();
>
> -       return result;
> +       return 0;
>  }
>  EXPORT_SYMBOL(acpi_bus_start);
>
> @@ -1596,11 +1548,6 @@ static int acpi_bus_scan_fixed(void)
>  {
>         int result = 0;
>         struct acpi_device *device = NULL;
> -       struct acpi_bus_ops ops;
> -
> -       memset(&ops, 0, sizeof(ops));
> -       ops.acpi_op_add = 1;
> -       ops.acpi_op_start = 1;
>
>         /*
>          * Enumerate all fixed-feature devices.
> @@ -1608,17 +1555,14 @@ static int acpi_bus_scan_fixed(void)
>         if ((acpi_gbl_FADT.flags & ACPI_FADT_POWER_BUTTON) == 0) {
>                 result = acpi_add_single_object(&device, NULL,
>                                                 ACPI_BUS_TYPE_POWER_BUTTON,
> -                                               ACPI_STA_DEFAULT,
> -                                               &ops);
> +                                               ACPI_STA_DEFAULT);
>                 device_init_wakeup(&device->dev, true);
>         }
>
> -       if ((acpi_gbl_FADT.flags & ACPI_FADT_SLEEP_BUTTON) == 0) {
> +       if ((acpi_gbl_FADT.flags & ACPI_FADT_SLEEP_BUTTON) == 0)
>                 result = acpi_add_single_object(&device, NULL,
>                                                 ACPI_BUS_TYPE_SLEEP_BUTTON,
> -                                               ACPI_STA_DEFAULT,
> -                                               &ops);
> -       }
> +                                               ACPI_STA_DEFAULT);
>
>         return result;
>  }
> @@ -1626,11 +1570,6 @@ static int acpi_bus_scan_fixed(void)
>  int __init acpi_scan_init(void)
>  {
>         int result;
> -       struct acpi_bus_ops ops;
> -
> -       memset(&ops, 0, sizeof(ops));
> -       ops.acpi_op_add = 1;
> -       ops.acpi_op_start = 1;
>
>         result = bus_register(&acpi_bus_type);
>         if (result) {
> @@ -1643,7 +1582,7 @@ int __init acpi_scan_init(void)
>         /*
>          * Enumerate devices in the ACPI namespace.
>          */
> -       result = acpi_bus_scan(ACPI_ROOT_OBJECT, &ops, &acpi_root);
> +       result = acpi_bus_scan(ACPI_ROOT_OBJECT, &acpi_root);
>
>         if (!result)
>                 result = acpi_bus_scan_fixed();
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 969544e..cc9363b 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -119,20 +119,13 @@ struct acpi_device;
>
>  typedef int (*acpi_op_add) (struct acpi_device * device);
>  typedef int (*acpi_op_remove) (struct acpi_device * device, int type);
> -typedef int (*acpi_op_start) (struct acpi_device * device);
>  typedef int (*acpi_op_bind) (struct acpi_device * device);
>  typedef int (*acpi_op_unbind) (struct acpi_device * device);
>  typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
>
> -struct acpi_bus_ops {
> -       u32 acpi_op_add:1;
> -       u32 acpi_op_start:1;
> -};
> -
>  struct acpi_device_ops {
>         acpi_op_add add;
>         acpi_op_remove remove;
> -       acpi_op_start start;
>         acpi_op_bind bind;
>         acpi_op_unbind unbind;
>         acpi_op_notify notify;
> @@ -302,7 +295,6 @@ struct acpi_device {
>         struct acpi_driver *driver;
>         void *driver_data;
>         struct device dev;
> -       struct acpi_bus_ops bus_ops;    /* workaround for different code path for hotplug */
>         enum acpi_bus_removal_type removal_type;        /* indicate for different removal type */
>         bool drivers_autoprobe;
>  };
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
