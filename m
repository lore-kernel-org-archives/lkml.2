Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab3AIOt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:49:28 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:52028 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab3AIOt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:49:27 -0500
X-Greylist: delayed 60806 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 09:49:26 EST
MIME-Version: 1.0
In-Reply-To: <1357742588-11366-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357742588-11366-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 9 Jan 2013 15:49:25 +0100
Message-ID: <CAN+gG=GrrEdgrCLXvO=xJ6SNeKgHFRobq6RSAfLMfesKkJcijA@mail.gmail.com>
Subject: Re: [PATCH v2] HID: i2c-hid: add ACPI support
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Wed, Jan 9, 2013 at 3:43 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> The HID over I2C protocol specification states that when the device is
> enumerated from ACPI the HID descriptor address can be obtained by
> executing "_DSM" for the device with function 1. Enable this.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I'm eager to test it (hopefully next week).

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Thanks,
Benjamin

> ---
> Changes to previous version:
>
>         * platform data is embedded into struct i2c_hid
>         * i2c_hid_acpi_pdata() returns error codes or 0 on success
>         * i2c_hid_acpi_pdata() prints out errors if _DSM execution fails or
>           returns something we don't understand
>         * constify i2c_hid_acpi_match
>         * set the hid device ACPI handle
>
> We still don't handle the GpioInt in case client->irq is not set but I
> didn't want to implement it now as I'm unable to test it. So this only
> works if the ACPI device has an Interrupt or IRQ resource set.
>
>  drivers/hid/i2c-hid/i2c-hid.c |   87 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 81 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 9ef22244..9e46e42 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -34,6 +34,7 @@
>  #include <linux/kernel.h>
>  #include <linux/hid.h>
>  #include <linux/mutex.h>
> +#include <linux/acpi.h>
>
>  #include <linux/i2c/i2c-hid.h>
>
> @@ -139,6 +140,8 @@ struct i2c_hid {
>         unsigned long           flags;          /* device flags */
>
>         wait_queue_head_t       wait;           /* For waiting the interrupt */
> +
> +       struct i2c_hid_platform_data pdata;
>  };
>
>  static int __i2c_hid_command(struct i2c_client *client,
> @@ -810,6 +813,70 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
>         return 0;
>  }
>
> +#ifdef CONFIG_ACPI
> +static int i2c_hid_acpi_pdata(struct i2c_client *client,
> +               struct i2c_hid_platform_data *pdata)
> +{
> +       static u8 i2c_hid_guid[] = {
> +               0xF7, 0xF6, 0xDF, 0x3C, 0x67, 0x42, 0x55, 0x45,
> +               0xAD, 0x05, 0xB3, 0x0A, 0x3D, 0x89, 0x38, 0xDE,
> +       };
> +       struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
> +       union acpi_object params[4], *obj;
> +       struct acpi_object_list input;
> +       struct acpi_device *adev;
> +       acpi_handle handle;
> +
> +       handle = ACPI_HANDLE(&client->dev);
> +       if (!handle || acpi_bus_get_device(handle, &adev))
> +               return -ENODEV;
> +
> +       input.count = ARRAY_SIZE(params);
> +       input.pointer = params;
> +
> +       params[0].type = ACPI_TYPE_BUFFER;
> +       params[0].buffer.length = sizeof(i2c_hid_guid);
> +       params[0].buffer.pointer = i2c_hid_guid;
> +       params[1].type = ACPI_TYPE_INTEGER;
> +       params[1].integer.value = 1;
> +       params[2].type = ACPI_TYPE_INTEGER;
> +       params[2].integer.value = 1; /* HID function */
> +       params[3].type = ACPI_TYPE_INTEGER;
> +       params[3].integer.value = 0;
> +
> +       if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf))) {
> +               dev_err(&client->dev, "device _DSM execution failed\n");
> +               return -ENODEV;
> +       }
> +
> +       obj = (union acpi_object *)buf.pointer;
> +       if (obj->type != ACPI_TYPE_INTEGER) {
> +               dev_err(&client->dev, "device _DSM returned invalid type: %d\n",
> +                       obj->type);
> +               kfree(buf.pointer);
> +               return -EINVAL;
> +       }
> +
> +       pdata->hid_descriptor_address = obj->integer.value;
> +
> +       kfree(buf.pointer);
> +       return 0;
> +}
> +
> +static const struct acpi_device_id i2c_hid_acpi_match[] = {
> +       {"ACPI0C50", 0 },
> +       {"PNP0C50", 0 },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(acpi, i2c_hid_acpi_match);
> +#else
> +static inline int i2c_hid_acpi_pdata(struct i2c_client *client,
> +               struct i2c_hid_platform_data *pdata)
> +{
> +       return -ENODEV;
> +}
> +#endif
> +
>  static int __devinit i2c_hid_probe(struct i2c_client *client,
>                 const struct i2c_device_id *dev_id)
>  {
> @@ -821,11 +888,6 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
>
>         dbg_hid("HID probe called for i2c 0x%02x\n", client->addr);
>
> -       if (!platform_data) {
> -               dev_err(&client->dev, "HID register address not provided\n");
> -               return -EINVAL;
> -       }
> -
>         if (!client->irq) {
>                 dev_err(&client->dev,
>                         "HID over i2c has not been provided an Int IRQ\n");
> @@ -836,11 +898,22 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
>         if (!ihid)
>                 return -ENOMEM;
>
> +       if (!platform_data) {
> +               ret = i2c_hid_acpi_pdata(client, &ihid->pdata);
> +               if (ret) {
> +                       dev_err(&client->dev,
> +                               "HID register address not provided\n");
> +                       goto err;
> +               }
> +       } else {
> +               ihid->pdata = *platform_data;
> +       }
> +
>         i2c_set_clientdata(client, ihid);
>
>         ihid->client = client;
>
> -       hidRegister = platform_data->hid_descriptor_address;
> +       hidRegister = ihid->pdata.hid_descriptor_address;
>         ihid->wHIDDescRegister = cpu_to_le16(hidRegister);
>
>         init_waitqueue_head(&ihid->wait);
> @@ -873,6 +946,7 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
>         hid->hid_get_raw_report = i2c_hid_get_raw_report;
>         hid->hid_output_raw_report = i2c_hid_output_raw_report;
>         hid->dev.parent = &client->dev;
> +       ACPI_HANDLE_SET(&hid->dev, ACPI_HANDLE(&client->dev));
>         hid->bus = BUS_I2C;
>         hid->version = le16_to_cpu(ihid->hdesc.bcdVersion);
>         hid->vendor = le16_to_cpu(ihid->hdesc.wVendorID);
> @@ -964,6 +1038,7 @@ static struct i2c_driver i2c_hid_driver = {
>                 .name   = "i2c_hid",
>                 .owner  = THIS_MODULE,
>                 .pm     = &i2c_hid_pm,
> +               .acpi_match_table = ACPI_PTR(i2c_hid_acpi_match),
>         },
>
>         .probe          = i2c_hid_probe,
> --
> 1.7.10.4
>
