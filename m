Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0G2KJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:09:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52354 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab0G2KJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=loGkeMX84wdwmF2tJSMYrGksBHXd48Th8Dl6JbVw2dmwmItswEtWQleaJ+Qlp+bZLp
         tTvP9nScLdLfDOO7S3zmAM+SW3OHT3AFPCaa3V/oR8hxgUiajxNdod5717oSbWoYU8NW
         2X2F11pDgg4gNVxOs7+DalSwbDlZj56dZP2Qw=
MIME-Version: 1.0
In-Reply-To: <1280397419-6799-1-git-send-email-pinaraf@pinaraf.info>
References: <1280397419-6799-1-git-send-email-pinaraf@pinaraf.info>
Date: Thu, 29 Jul 2010 12:09:49 +0200
Message-ID: <AANLkTikzpUaWCqGLseOZixFmoQOPd9L-pecLNzm_aDSw@mail.gmail.com>
Subject: Re: [PATCH] Add support for Toshiba Illumination. This is a set of 
	LEDs installed on some Toshiba laptops. It is controlled through ACPI, the 
	commands has been found through reverse engineering. It has been tested on a 
	Toshiba Qosmio G50-122.
From: Corentin Chary <corentin.chary@gmail.com>
To: Pierre Ducroquet <pinaraf@pinaraf.info>
Cc: platform-driver-x86@vger.kernel.org, mjg@redhat.com,
        akpm@linux-foundation.org, len.brown@intel.com, nm127@freemail.hu,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hum it seems that there was an issue with the changelog, you should
add some \n :p

On Thu, Jul 29, 2010 at 11:56 AM, Pierre Ducroquet <pinaraf@pinaraf.info> wrote:
> Signed-off-by: Pierre Ducroquet <pinaraf@pinaraf.info>
> ---
>  drivers/platform/x86/toshiba_acpi.c |  117 +++++++++++++++++++++++++++++++++++
>  1 files changed, 117 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 37aa147..81b76a8 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -4,6 +4,7 @@
>  *
>  *  Copyright (C) 2002-2004 John Belmonte
>  *  Copyright (C) 2008 Philip Langdale
> + *  Copyright (C) 2010 Pierre Ducroquet
>  *
>  *  This program is free software; you can redistribute it and/or modify
>  *  it under the terms of the GNU General Public License as published by
> @@ -47,6 +48,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/rfkill.h>
>  #include <linux/input.h>
> +#include <linux/leds.h>
>  #include <linux/slab.h>
>
>  #include <asm/uaccess.h>
> @@ -285,6 +287,7 @@ struct toshiba_acpi_dev {
>        struct platform_device *p_dev;
>        struct rfkill *bt_rfk;
>        struct input_dev *hotkey_dev;
> +       int illumination_installed;

I don't know if this is really  needed, you can use the led_classdev
for that (if NULL, then not installed).

>        acpi_handle handle;
>
>        const char *bt_name;
> @@ -292,6 +295,110 @@ struct toshiba_acpi_dev {
>        struct mutex mutex;
>  };
>
> +/* Illumination support */
> +static int toshiba_illumination_available(void)
> +{
> +       u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
> +       u32 out[HCI_WORDS];
> +       acpi_status status;
> +
> +       in[0] = 0xf100;
> +       status = hci_raw(in, out);
> +       if (ACPI_FAILURE(status)) {
> +               printk(MY_INFO "Illumination device not available\n");
> +               return 0;
> +       }
> +       in[0] = 0xf400;
> +       status = hci_raw(in, out);
> +       return 1;
> +}
> +
> +static void toshiba_illumination_set(struct led_classdev *cdev,
> +                                    enum led_brightness brightness)
> +{
> +       u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
> +       u32 out[HCI_WORDS];
> +       acpi_status status;
> +
> +       /* First request : initialize communication. */
> +       in[0] = 0xf100;
> +       status = hci_raw(in, out);
> +       if (ACPI_FAILURE(status)) {
> +               printk(MY_INFO "Illumination device not available\n");
> +               return;
> +       }
> +
> +       if (brightness) {
> +               /* Switch the illumination on */
> +               in[0] = 0xf400;
> +               in[1] = 0x14e;
> +               in[2] = 1;
> +               status = hci_raw(in, out);
> +               if (ACPI_FAILURE(status)) {
> +                       printk(MY_INFO "ACPI call for illumination failed.\n");
> +                       return;
> +               }
> +       } else {
> +               /* Switch the illumination off */
> +               in[0] = 0xf400;
> +               in[1] = 0x14e;
> +               in[2] = 0;
> +               status = hci_raw(in, out);
> +               if (ACPI_FAILURE(status)) {
> +                       printk(MY_INFO "ACPI call for illumination failed.\n");
> +                       return;
> +               }
> +       }
> +
> +       /* Last request : close communication. */
> +       in[0] = 0xf200;
> +       in[1] = 0;
> +       in[2] = 0;
> +       hci_raw(in, out);
> +}
> +
> +static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
> +{
> +       u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
> +       u32 out[HCI_WORDS];
> +       acpi_status status;
> +       enum led_brightness result;
> +
> +       /* First request : initialize communication. */
> +       in[0] = 0xf100;
> +       status = hci_raw(in, out);
> +       if (ACPI_FAILURE(status)) {
> +               printk(MY_INFO "Illumination device not available\n");
> +               return LED_OFF;
> +       }
> +
> +       /* Check the illumination */
> +       in[0] = 0xf300;
> +       in[1] = 0x14e;
> +       status = hci_raw(in, out);
> +       if (ACPI_FAILURE(status)) {
> +               printk(MY_INFO "ACPI call for illumination failed.\n");
> +               return LED_OFF;
> +       }
> +
> +       result = out[2] ? LED_FULL : LED_OFF;
> +
> +       /* Last request : close communication. */
> +       in[0] = 0xf200;
> +       in[1] = 0;
> +       in[2] = 0;
> +       hci_raw(in, out);
> +
> +       return result;
> +}
> +
> +static struct led_classdev toshiba_led = {
> +       .name           = "toshiba::illumination",
> +       .max_brightness = 1,
> +       .brightness_set = toshiba_illumination_set,
> +       .brightness_get = toshiba_illumination_get,
> +};

Please put the led_classed in t toshiba_acpi_dev, even if the hci_raw
calls (and the whole driver) is not really reentrant.
See eeepc-laptop or asus-laptop.

>  static struct toshiba_acpi_dev toshiba_acpi = {
>        .bt_name = "Toshiba Bluetooth",
>  };
> @@ -914,6 +1021,9 @@ static void toshiba_acpi_exit(void)
>        acpi_remove_notify_handler(toshiba_acpi.handle, ACPI_DEVICE_NOTIFY,
>                                   toshiba_acpi_notify);
>
> +       if (toshiba_acpi.illumination_installed)
> +               led_classdev_unregister(&toshiba_led);
> +
>        platform_device_unregister(toshiba_acpi.p_dev);
>
>        return;
> @@ -1013,6 +1123,13 @@ static int __init toshiba_acpi_init(void)
>                }
>        }
>
> +       toshiba_acpi.illumination_installed = 0;
> +       if (toshiba_illumination_available()) {
> +               if (!led_classdev_register(&(toshiba_acpi.p_dev->dev),
> +                                          &toshiba_led))
> +                       toshiba_acpi.illumination_installed = 1;
> +       }
> +
>        return 0;
>  }
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Corentin Chary
http://xf.iksaif.net
