Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2KAGe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:34:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39374 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2KAGe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <1992450.Ke1VSjeX8X@vostro.rjw.lan>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
	<1992450.Ke1VSjeX8X@vostro.rjw.lan>
Date: Wed, 31 Oct 2012 23:34:24 -0700
X-Google-Sender-Auth: NCVjveHu08ZgcpguQMBGYfoPlOg
Message-ID: <CAE9FiQURGWOUzHc5j4pHCfcXE9y4a3WaPCEg=RewUpA=u8pSAQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] ACPI: Add support for platform bus type
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 list <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Content-Type: multipart/mixed; boundary=000e0cd1d124d1a23804cd69351d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd1d124d1a23804cd69351d
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Oct 31, 2012 at 2:36 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> With ACPI 5 it is now possible to enumerate traditional SoC
> peripherals, like serial bus controllers and slave devices behind
> them.  These devices are typically based on IP-blocks used in many
> existing SoC platforms and platform drivers for them may already
> be present in the kernel tree.
>
> To make driver "porting" more straightforward, add ACPI support to
> the platform bus type.  Instead of writing ACPI "glue" drivers for
> the existing platform drivers, register the platform bus type with
> ACPI to create platform device objects for the drivers and bind the
> corresponding ACPI handles to those platform devices.
>
> This should allow us to reuse the existing platform drivers for the
> devices in question with the minimum amount of modifications.
>
> This changeset is based on Mika Westerberg's and Mathias Nyman's
> work.
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/Makefile        |    1
>  drivers/acpi/acpi_platform.c |  285 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/internal.h      |    7 +
>  drivers/acpi/scan.c          |   16 ++
>  drivers/base/platform.c      |    5
>  5 files changed, 313 insertions(+), 1 deletion(-)

this patch is too big, and should be split to at least two or more.

>  create mode 100644 drivers/acpi/acpi_platform.c
>
> Index: linux/drivers/acpi/Makefile
> ===================================================================
> --- linux.orig/drivers/acpi/Makefile
> +++ linux/drivers/acpi/Makefile
> @@ -37,6 +37,7 @@ acpi-y                                += processor_core.o
>  acpi-y                         += ec.o
>  acpi-$(CONFIG_ACPI_DOCK)       += dock.o
>  acpi-y                         += pci_root.o pci_link.o pci_irq.o pci_bind.o
> +acpi-y                         += acpi_platform.o
>  acpi-y                         += power.o
>  acpi-y                         += event.o
>  acpi-y                         += sysfs.o
> Index: linux/drivers/acpi/acpi_platform.c
> ===================================================================
> --- /dev/null
> +++ linux/drivers/acpi/acpi_platform.c
> @@ -0,0 +1,285 @@
> +/*
> + * ACPI support for platform bus type.
> + *
> + * Copyright (C) 2012, Intel Corporation
> + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> + *          Mathias Nyman <mathias.nyman@linux.intel.com>
> + *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +ACPI_MODULE_NAME("platform");
> +
> +struct resource_info {
> +       struct device *dev;
> +       struct resource *res;
> +       size_t n, cur;
> +};
> +
> +static acpi_status acpi_platform_count_resources(struct acpi_resource *res,
> +                                                void *data)
> +{
> +       struct acpi_resource_extended_irq *acpi_xirq;
> +       struct resource_info *ri = data;
> +
> +       switch (res->type) {
> +       case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> +       case ACPI_RESOURCE_TYPE_IRQ:
> +               ri->n++;
> +               break;
> +       case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> +               acpi_xirq = &res->data.extended_irq;
> +               ri->n += acpi_xirq->interrupt_count;
> +               break;
> +       case ACPI_RESOURCE_TYPE_ADDRESS32:
> +               if (res->data.address32.resource_type == ACPI_IO_RANGE)
> +                       ri->n++;
> +               break;
> +       }
> +
> +       return AE_OK;
> +}
> +
> +static acpi_status acpi_platform_add_resources(struct acpi_resource *res,
> +                                              void *data)
> +{
> +       struct acpi_resource_fixed_memory32 *acpi_mem;
> +       struct acpi_resource_address32 *acpi_add32;
> +       struct acpi_resource_extended_irq *acpi_xirq;
> +       struct acpi_resource_irq *acpi_irq;
> +       struct resource_info *ri = data;
> +       struct resource *r;
> +       int irq, i;
> +
> +       switch (res->type) {
> +       case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> +               acpi_mem = &res->data.fixed_memory32;
> +               r = &ri->res[ri->cur++];
> +
> +               r->start = acpi_mem->address;
> +               r->end = r->start + acpi_mem->address_length - 1;
> +               r->flags = IORESOURCE_MEM;
> +
> +               dev_dbg(ri->dev, "Memory32Fixed %pR\n", r);
> +               break;
> +
> +       case ACPI_RESOURCE_TYPE_ADDRESS32:
> +               acpi_add32 = &res->data.address32;
> +
> +               if (acpi_add32->resource_type == ACPI_IO_RANGE) {
> +                       r = &ri->res[ri->cur++];
> +                       r->start = acpi_add32->minimum;
> +                       r->end = r->start + acpi_add32->address_length - 1;
> +                       r->flags = IORESOURCE_IO;
> +                       dev_dbg(ri->dev, "Address32 %pR\n", r);
> +               }
> +               break;
> +
> +       case ACPI_RESOURCE_TYPE_IRQ:
> +               acpi_irq = &res->data.irq;
> +               r = &ri->res[ri->cur++];
> +
> +               irq = acpi_register_gsi(ri->dev,
> +                                       acpi_irq->interrupts[0],
> +                                       acpi_irq->triggering,
> +                                       acpi_irq->polarity);
> +
> +               r->start = r->end = irq;
> +               r->flags = IORESOURCE_IRQ;
> +
> +               dev_dbg(ri->dev, "IRQ %pR\n", r);
> +               break;
> +
> +       case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> +               acpi_xirq = &res->data.extended_irq;
> +
> +               for (i = 0; i < acpi_xirq->interrupt_count; i++, ri->cur++) {
> +                       r = &ri->res[ri->cur];
> +                       irq = acpi_register_gsi(ri->dev,
> +                                               acpi_xirq->interrupts[i],
> +                                               acpi_xirq->triggering,
> +                                               acpi_xirq->polarity);
> +
> +                       r->start = r->end = irq;
> +                       r->flags = IORESOURCE_IRQ;
> +
> +                       dev_dbg(ri->dev, "Interrupt %pR\n", r);
> +               }
> +               break;
> +       }
> +
> +       return AE_OK;
> +}
> +

could be shared with pci root or pnp devices?

> +static acpi_status acpi_platform_get_device_uid(struct acpi_device *adev,
> +                                               int *uid)
> +{
> +       struct acpi_device_info *info;
> +       acpi_status status;
> +
> +       status = acpi_get_object_info(adev->handle, &info);
> +       if (ACPI_FAILURE(status))
> +               return status;
> +
> +       status = AE_NOT_EXIST;
> +       if ((info->valid & ACPI_VALID_UID) &&
> +            !kstrtoint(info->unique_id.string, 0, uid))
> +               status = AE_OK;
> +
> +       kfree(info);
> +       return status;
> +}
> +
> +/**
> + * acpi_create_platform_device - Create platform device for ACPI device node
> + * @adev: ACPI device node to create a platform device for.
> + *
> + * Check if the given @adev can be represented as a platform device and, if
> + * that's the case, create and register a platform device, populate its common
> + * resources and returns a pointer to it.  Otherwise, return %NULL.
> + *
> + * The platform device's name will be taken from the @adev's _HID and _UID.
> + */
> +struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
> +{
> +       struct platform_device *pdev = NULL;
> +       struct acpi_device *acpi_parent;
> +       struct device *parent = NULL;
> +       struct resource_info ri;
> +       acpi_status status;
> +       int devid;
> +
> +       /* If the ACPI node already has a physical device attached, skip it. */
> +       if (adev->physical_node_count)
> +               return NULL;
> +
> +       /* Use the UID of the device as the new platform device id if found. */
> +       status = acpi_platform_get_device_uid(adev, &devid);
> +       if (ACPI_FAILURE(status))
> +               devid = -1;
> +
> +       memset(&ri, 0, sizeof(ri));
> +
> +       /* First, count the resources. */
> +       status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
> +                                    acpi_platform_count_resources, &ri);
> +       if (ACPI_FAILURE(status) || !ri.n)
> +               return NULL;
> +
> +       /* Next, allocate memory for all the resources and populate it. */
> +       ri.dev = &adev->dev;
> +       ri.res = kzalloc(ri.n * sizeof(struct resource), GFP_KERNEL);
> +       if (!ri.res) {
> +               dev_err(&adev->dev,
> +                       "failed to allocate memory for resources\n");
> +               return NULL;
> +       }
> +
> +       status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
> +                                    acpi_platform_add_resources, &ri);
> +       if (ACPI_FAILURE(status)) {
> +               dev_err(&adev->dev, "failed to walk resources\n");
> +               goto out;
> +       }
> +
> +       if (WARN_ON(ri.n != ri.cur))
> +               goto out;
> +
> +       /*
> +        * If the ACPI node has a parent and that parent has a physical device
> +        * attached to it, that physical device should be the parent of the
> +        * platform device we are about to create.
> +        */
> +       acpi_parent = adev->parent;
> +       if (acpi_parent) {
> +               struct acpi_device_physical_node *entry;
> +               struct list_head *list;
> +
> +               mutex_lock(&acpi_parent->physical_node_lock);
> +               list = &acpi_parent->physical_node_list;
> +               if (!list_empty(list)) {
> +                       entry = list_first_entry(list,
> +                                       struct acpi_device_physical_node,
> +                                       node);
> +                       parent = entry->dev;
> +               }
> +               mutex_unlock(&acpi_parent->physical_node_lock);
> +       }
> +       pdev = platform_device_register_resndata(parent, acpi_device_hid(adev),
> +                                                devid, ri.res, ri.n, NULL, 0);
> +       if (IS_ERR(pdev)) {
> +               dev_err(&adev->dev, "platform device creation failed: %ld\n",
> +                       PTR_ERR(pdev));
> +               pdev = NULL;
> +       } else {
> +               dev_dbg(&adev->dev, "created platform device %s\n",
> +                       dev_name(&pdev->dev));
> +       }
> +
> + out:
> +       kfree(ri.res);
> +       return pdev;
> +}
> +
> +static acpi_status acpi_platform_match(acpi_handle handle, u32 depth,
> +                                      void *data, void **return_value)
> +{
> +       struct platform_device *pdev = data;
> +       struct acpi_device *adev;
> +       acpi_status status;
> +
> +       status = acpi_bus_get_device(handle, &adev);
> +       if (ACPI_FAILURE(status))
> +               return status;
> +
> +       /* Skip ACPI devices that have physical device attached */
> +       if (adev->physical_node_count)
> +               return AE_OK;
> +
> +       if (!strcmp(pdev->name, acpi_device_hid(adev))) {
> +               int devid;
> +
> +               /* Check that both name and UID match if it exists */
> +               status = acpi_platform_get_device_uid(adev, &devid);
> +               if (ACPI_FAILURE(status))
> +                       devid = -1;
> +
> +               if (pdev->id != devid)
> +                       return AE_OK;
> +
> +               *(acpi_handle *)return_value = handle;
> +               return AE_CTRL_TERMINATE;
> +       }
> +
> +       return AE_OK;
> +}
> +
> +static int acpi_platform_find_device(struct device *dev, acpi_handle *handle)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +
> +       *handle = NULL;
> +       acpi_get_devices(pdev->name, acpi_platform_match, pdev, handle);
> +
> +       return *handle ? 0 : -ENODEV;
> +}
> +
> +static struct acpi_bus_type acpi_platform_bus = {
> +       .bus = &platform_bus_type,
> +       .find_device = acpi_platform_find_device,
> +};
> +
> +static int __init acpi_platform_init(void)
> +{
> +       return register_acpi_bus_type(&acpi_platform_bus);
> +}
> +arch_initcall(acpi_platform_init);
> Index: linux/drivers/acpi/internal.h
> ===================================================================
> --- linux.orig/drivers/acpi/internal.h
> +++ linux/drivers/acpi/internal.h
> @@ -93,4 +93,11 @@ static inline int suspend_nvs_save(void)
>  static inline void suspend_nvs_restore(void) {}
>  #endif
>
> +/*--------------------------------------------------------------------------
> +                               Platform bus support
> +  -------------------------------------------------------------------------- */
> +struct platform_device;
> +
> +struct platform_device *acpi_create_platform_device(struct acpi_device *adev);
> +
>  #endif /* _ACPI_INTERNAL_H_ */
> Index: linux/drivers/acpi/scan.c
> ===================================================================
> --- linux.orig/drivers/acpi/scan.c
> +++ linux/drivers/acpi/scan.c
> @@ -29,6 +29,15 @@ extern struct acpi_device *acpi_root;
>
>  static const char *dummy_hid = "device";
>
> +/*
> + * The following ACPI IDs are known to be suitable for representing as
> + * platform devices.
> + */
> +static const struct acpi_device_id acpi_platform_device_ids[] = {
> +

?

> +       { }
> +};
> +
>  static LIST_HEAD(acpi_device_list);
>  static LIST_HEAD(acpi_bus_id_list);
>  DEFINE_MUTEX(acpi_device_lock);
> @@ -1544,8 +1553,13 @@ static acpi_status acpi_bus_check_add(ac
>          */
>         device = NULL;
>         acpi_bus_get_device(handle, &device);
> -       if (ops->acpi_op_add && !device)
> +       if (ops->acpi_op_add && !device) {
>                 acpi_add_single_object(&device, handle, type, sta, ops);
> +               /* Is the device a known good platform device? */
> +               if (device
> +                   && !acpi_match_device_ids(device, acpi_platform_device_ids))
> +                       acpi_create_platform_device(device);
> +       }

That is ugly! any reason for not using acpi_driver for them.

there is not reason to treat those platform_device different from pci
root device and other pnp device.

something like attached patch. .add of acpi_driver ops could call
acpi_create_platform_device.

Yinghai

--000e0cd1d124d1a23804cd69351d
Content-Type: application/octet-stream; name="acpi_platform_driver.patch"
Content-Disposition: attachment; filename="acpi_platform_driver.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8zht1cz0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9hY3BpX3BsYXRmb3JtLmMgYi9kcml2ZXJzL2FjcGkv
YWNwaV9wbGF0Zm9ybS5jCmluZGV4IGE1YTIzNDYuLjRlZDk3YTcgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvYWNwaS9hY3BpX3BsYXRmb3JtLmMKKysrIGIvZHJpdmVycy9hY3BpL2FjcGlfcGxhdGZvcm0u
YwpAQCAtMjMwLDYgKzIzMCw0NCBAQCBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICphY3BpX2NyZWF0
ZV9wbGF0Zm9ybV9kZXZpY2Uoc3RydWN0IGFjcGlfZGV2aWNlICphZGV2KQogCXJldHVybiBwZGV2
OwogfQogCisvKgorICogVGhlIGZvbGxvd2luZyBBQ1BJIElEcyBhcmUga25vd24gdG8gYmUgc3Vp
dGFibGUgZm9yIHJlcHJlc2VudGluZyBhcworICogcGxhdGZvcm0gZGV2aWNlcy4KKyAqLworc3Rh
dGljIGNvbnN0IHN0cnVjdCBhY3BpX2RldmljZV9pZCBhY3BpX3BsYXRmb3JtX2RldmljZV9pZHNb
XSA9IHsKKworCXsgfQorfTsKKworI2RlZmluZSBBQ1BJX1BMQVRGT1JNX0NMQVNTCQkiYWNwaV9w
bGF0Zm9ybSIKK3N0YXRpYyBpbnQgX19kZXZpbml0IGFjcGlfcGxhdGZvcm1fZGV2aWNlX2FkZChz
dHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKK3sKKwlhY3BpX2NyZWF0ZV9wbGF0Zm9ybV9kZXZp
Y2UoZGV2aWNlKTsKK30KK3N0YXRpYyBpbnQgYWNwaV9wbGF0Zm9ybV9kZXZpY2VfcmVtb3ZlKHN0
cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLCBpbnQgdHlwZSkKK3sKKwkvKiBUT0RPOiByZW1vdmUg
dGhhdCBwbGF0ZnJvbV9kZXZpY2UgYW5kIHJlc291cmNlICovCit9CisKK3N0YXRpYyBzdHJ1Y3Qg
YWNwaV9kcml2ZXIgYWNwaV9wbGF0Zm9ybV9kcml2ZXIgPSB7CisJLm5hbWUgPSAiYWNwaV9wbGF0
Zm9ybSIsCisJLmNsYXNzID0gQUNQSV9QTEFURk9STV9DTEFTUywKKwkuaWRzID0gYWNwaV9wbGF0
Zm9ybV9kZXZpY2VfaWRzLAorCS5vcHMgPSB7CisJCS5hZGQgPSBhY3BpX3BsYXRmb3JtX2Rldmlj
ZV9hZGQsCisJCS5yZW1vdmUgPSBhY3BpX3BsYXRmb3JtX2RldmljZV9yZW1vdmUsCisJCX0sCit9
OworCitzdGF0aWMgaW50IF9faW5pdCBhY3BpX3BsYXRmb3JtX2luaXQodm9pZCkKK3sKKwlpZiAo
YWNwaV9idXNfcmVnaXN0ZXJfZHJpdmVyKCZhY3BpX3BsYXRmb3JtX2RyaXZlcikgPCAwKQorCQly
ZXR1cm4gLUVOT0RFVjsKKworCXJldHVybiAwOworfQorc3Vic3lzX2luaXRjYWxsKGFjcGlfcGxh
dGZvcm1faW5pdCk7CisKIHN0YXRpYyBhY3BpX3N0YXR1cyBhY3BpX3BsYXRmb3JtX21hdGNoKGFj
cGlfaGFuZGxlIGhhbmRsZSwgdTMyIGRlcHRoLAogCQkJCSAgICAgICB2b2lkICpkYXRhLCB2b2lk
ICoqcmV0dXJuX3ZhbHVlKQogewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL3NjYW4uYyBiL2Ry
aXZlcnMvYWNwaS9zY2FuLmMKaW5kZXggZTdhZmJhMS4uNzNiZmEzZCAxMDA2NDQKLS0tIGEvZHJp
dmVycy9hY3BpL3NjYW4uYworKysgYi9kcml2ZXJzL2FjcGkvc2Nhbi5jCkBAIC0yOSwxNSArMjks
NiBAQCBleHRlcm4gc3RydWN0IGFjcGlfZGV2aWNlICphY3BpX3Jvb3Q7CiAKIHN0YXRpYyBjb25z
dCBjaGFyICpkdW1teV9oaWQgPSAiZGV2aWNlIjsKIAotLyoKLSAqIFRoZSBmb2xsb3dpbmcgQUNQ
SSBJRHMgYXJlIGtub3duIHRvIGJlIHN1aXRhYmxlIGZvciByZXByZXNlbnRpbmcgYXMKLSAqIHBs
YXRmb3JtIGRldmljZXMuCi0gKi8KLXN0YXRpYyBjb25zdCBzdHJ1Y3QgYWNwaV9kZXZpY2VfaWQg
YWNwaV9wbGF0Zm9ybV9kZXZpY2VfaWRzW10gPSB7Ci0KLQl7IH0KLX07Ci0KIHN0YXRpYyBMSVNU
X0hFQUQoYWNwaV9kZXZpY2VfbGlzdCk7CiBzdGF0aWMgTElTVF9IRUFEKGFjcGlfYnVzX2lkX2xp
c3QpOwogREVGSU5FX01VVEVYKGFjcGlfZGV2aWNlX2xvY2spOwpAQCAtMTU1MywxMyArMTU0NCw4
IEBAIHN0YXRpYyBhY3BpX3N0YXR1cyBhY3BpX2J1c19jaGVja19hZGQoYWNwaV9oYW5kbGUgaGFu
ZGxlLCB1MzIgbHZsLAogCSAqLwogCWRldmljZSA9IE5VTEw7CiAJYWNwaV9idXNfZ2V0X2Rldmlj
ZShoYW5kbGUsICZkZXZpY2UpOwotCWlmIChvcHMtPmFjcGlfb3BfYWRkICYmICFkZXZpY2UpIHsK
KwlpZiAob3BzLT5hY3BpX29wX2FkZCAmJiAhZGV2aWNlKQogCQlhY3BpX2FkZF9zaW5nbGVfb2Jq
ZWN0KCZkZXZpY2UsIGhhbmRsZSwgdHlwZSwgc3RhLCBvcHMpOwotCQkvKiBJcyB0aGUgZGV2aWNl
IGEga25vd24gZ29vZCBwbGF0Zm9ybSBkZXZpY2U/ICovCi0JCWlmIChkZXZpY2UKLQkJICAgICYm
ICFhY3BpX21hdGNoX2RldmljZV9pZHMoZGV2aWNlLCBhY3BpX3BsYXRmb3JtX2RldmljZV9pZHMp
KQotCQkJYWNwaV9jcmVhdGVfcGxhdGZvcm1fZGV2aWNlKGRldmljZSk7Ci0JfQogCiAJaWYgKCFk
ZXZpY2UpCiAJCXJldHVybiBBRV9DVFJMX0RFUFRIOwo=
--000e0cd1d124d1a23804cd69351d--
