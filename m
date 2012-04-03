Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2DCIpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:45:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39535 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2DCIpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:45:04 -0400
MIME-Version: 1.0
In-Reply-To: <1333436730-13008-5-git-send-email-rydberg@euromail.se>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
	<1333436730-13008-5-git-send-email-rydberg@euromail.se>
Date: Tue, 3 Apr 2012 10:45:04 +0200
Message-ID: <CAN+gG=F0v1NnBd5G_Z77m3Qf8FuSs5Nj2-W97k=GhFdWmZDiKg@mail.gmail.com>
Subject: Re: [RFC 4/5] hid: Add idtags to modalias
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 09:05, Henrik Rydberg <rydberg@euromail.se> wrote:
> HID devices are only partially presented to userland.  Hotplugged
> devices emit events containing a modalias based on the basic bus,
> vendor and product entities. However, in practise a hid device can
> depend on details such as a single usb interface or a particular item
> in a report descriptor.
>
> This patch adds a special interface tag to the hid device id, and
> broadcasts it using both uevent and modalias. Matching ids are
> introduced for the hid-multitouch driver. As a consequence, generic
> hid will no longer match multitouch devices, and udev will
> automatically load hid-multitouch instead.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-core.c          |   28 +++++++++++++++++++++++++---
>  drivers/hid/hid-multitouch.c    |    7 ++++++-
>  include/linux/hid.h             |    7 +++++++
>  include/linux/mod_devicetable.h |    2 +-
>  scripts/mod/file2alias.c        |    2 ++
>  5 files changed, 41 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 8a7b59e..1cf6cb5 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -205,6 +205,10 @@ static int hid_add_usage(struct hid_parser *parser, unsigned usage)
>                parser->collection_stack_ptr ?
>                parser->collection_stack[parser->collection_stack_ptr - 1] : 0;
>        parser->local.usage_index++;
> +
> +       if (usage == HID_DG_CONTACTID)
> +               parser->device->idtags |= HID_IDTAG_MULTITOUCH;
> +
>        return 0;
>  }
>
> @@ -1154,7 +1158,7 @@ EXPORT_SYMBOL_GPL(hid_input_report);
>  static bool hid_match_one_id(struct hid_device *hdev,
>                const struct hid_device_id *id)
>  {
> -       return id->bus == hdev->bus &&
> +       return id->bus == hdev->bus && id->idtags == hdev->idtags &&
>                (id->vendor == HID_ANY_ID || id->vendor == hdev->vendor) &&
>                (id->product == HID_ANY_ID || id->product == hdev->product);
>  }
> @@ -1723,6 +1727,23 @@ static int hid_device_remove(struct device *dev)
>        return 0;
>  }
>
> +static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
> +                            char *buf)
> +{
> +       struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +       int len;
> +
> +       len = snprintf(buf, PAGE_SIZE, "hid:b%04Xi%04Xv%08Xp%08X\n",
> +                      hdev->bus, hdev->idtags, hdev->vendor, hdev->product);
> +
> +       return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
> +}
> +
> +static struct device_attribute hid_dev_attrs[] = {
> +       __ATTR_RO(modalias),
> +       __ATTR_NULL,
> +};
> +
>  static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>        struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> @@ -1740,8 +1761,8 @@ static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
>        if (add_uevent_var(env, "HID_UNIQ=%s", hdev->uniq))
>                return -ENOMEM;
>
> -       if (add_uevent_var(env, "MODALIAS=hid:b%04Xv%08Xp%08X",
> -                       hdev->bus, hdev->vendor, hdev->product))
> +       if (add_uevent_var(env, "MODALIAS=hid:b%04Xi%04Xv%08Xp%08X",
> +                          hdev->bus, hdev->idtags, hdev->vendor, hdev->product))
>                return -ENOMEM;
>
>        return 0;
> @@ -1749,6 +1770,7 @@ static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
>
>  static struct bus_type hid_bus_type = {
>        .name           = "hid",
> +       .dev_attrs      = hid_dev_attrs,
>        .match          = hid_bus_match,
>        .probe          = hid_device_probe,
>        .remove         = hid_device_remove,
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 421b16c..80ceab5 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -104,7 +104,7 @@ struct mt_device {
>  #define MT_DEFAULT_MAXCONTACT  10
>
>  #define HID_USB_MT_DEVICE(v, p)                                                \
> -       HID_USB_DEVICE(v, p)
> +       .idtags = HID_IDTAG_MULTITOUCH, HID_USB_DEVICE(v, p)
>
>  /*
>  * these device-dependent functions determine what slot corresponds
> @@ -886,6 +886,11 @@ static const struct hid_device_id mt_devices[] = {
>                HID_USB_MT_DEVICE(USB_VENDOR_ID_XIROKU,
>                        USB_DEVICE_ID_XIROKU_CSR2) },
>
> +       /* Generic MT device */
> +       { .driver_data = MT_CLS_DEFAULT,
> +               HID_USB_MT_DEVICE(HID_ANY_ID,
> +                       HID_ANY_ID) },

This breaks the mechanism used to detect serial protocol.
A better solution would be to keep .driver_data = 0 -> this would tell
us that the device is unknown and that we can override the given
settings.

Thanks,
Benjamin

> +
>        { }
>  };
>  MODULE_DEVICE_TABLE(hid, mt_devices);
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 5b3be43..1e68543 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -62,6 +62,12 @@
>
>  #define HID_MAX_DESCRIPTOR_SIZE                4096
>
> +/*
> + * HID identifying tags extracted from reports
> + */
> +#define HID_IDTAG_MULTITOUCH           0x0001
> +
> +
>  #ifdef __KERNEL__
>
>  #include <linux/types.h>
> @@ -473,6 +479,7 @@ struct hid_device {                                                 /* device report descriptor */
>        unsigned maxcollection;                                         /* Number of parsed collections */
>        unsigned maxapplication;                                        /* Number of applications */
>        __u16 bus;                                                      /* BUS ID */
> +       __u16 idtags;                                                   /* Identifying tags extracted from reports */
>        __u32 vendor;                                                   /* Vendor ID */
>        __u32 product;                                                  /* Product ID */
>        __u32 version;                                                  /* HID version */
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 83ac071..25446f0 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -135,7 +135,7 @@ struct usb_device_id {
>
>  struct hid_device_id {
>        __u16 bus;
> -       __u16 pad1;
> +       __u16 idtags;
>        __u32 vendor;
>        __u32 product;
>        kernel_ulong_t driver_data
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index b89efe6..d0c3a2b 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -336,10 +336,12 @@ static int do_hid_entry(const char *filename,
>                             struct hid_device_id *id, char *alias)
>  {
>        id->bus = TO_NATIVE(id->bus);
> +       id->idtags = TO_NATIVE(id->idtags);
>        id->vendor = TO_NATIVE(id->vendor);
>        id->product = TO_NATIVE(id->product);
>
>        sprintf(alias, "hid:b%04X", id->bus);
> +       ADD(alias, "i", true, id->idtags);
>        ADD(alias, "v", id->vendor != HID_ANY_ID, id->vendor);
>        ADD(alias, "p", id->product != HID_ANY_ID, id->product);
>
> --
> 1.7.9.5
>
