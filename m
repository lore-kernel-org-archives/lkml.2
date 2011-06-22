Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1FVJUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:20:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60321 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1FVJUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T9Rmuw2VecPXEvaLHJ55URjj6uXiYlu9dUuHBLSEnmefLh3wmY6cNQ5+2CKoEAeRRP
         Wwisvs70+Gm5WYEE2AeYoM+LRyhgDd2i6IdW/ryAkPdjN7Q4vWzoqIrMrudJVSBGFrgA
         TDzybtjkAs1gxMYSitS1TQhKQKWOpUxqzkXAk=
MIME-Version: 1.0
In-Reply-To: <1308730058-2703-1-git-send-email-ike.pan@canonical.com>
References: <1308729781-2590-1-git-send-email-ike.pan@canonical.com>
	<1308730058-2703-1-git-send-email-ike.pan@canonical.com>
Date: Wed, 22 Jun 2011 11:20:16 +0200
Message-ID: <BANLkTi=fh1UTsUFQvo+66B_QaOx-mqF3kg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ideapad: add backlight driver
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:07 AM, Ike Panhc <ike.pan@canonical.com> wrote:
> When acpi_backlight=vendor in cmdline or no backlight support in acpi video
> device, ideapad-laptop will register backlight device and control brightness
> and backlight power via the command in VPC2004.
>
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> ---
>  drivers/platform/x86/ideapad-laptop.c |  129 ++++++++++++++++++++++++++++++---
>  1 files changed, 119 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index 678bbf7..018c457 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -32,6 +32,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/input.h>
>  #include <linux/input/sparse-keymap.h>
> +#include <linux/backlight.h>
> +#include <linux/fb.h>
>
>  #define IDEAPAD_RFKILL_DEV_NUM (3)
>
> @@ -44,6 +46,7 @@ struct ideapad_private {
>        struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
>        struct platform_device *platform_device;
>        struct input_dev *inputdev;
> +       struct backlight_device *blightdev;
>        unsigned long cfg;
>  };
>
> @@ -257,9 +260,8 @@ static struct rfkill_ops ideapad_rfk_ops = {
>        .set_block = ideapad_rfk_set,
>  };
>
> -static void ideapad_sync_rfk_state(struct acpi_device *adevice)
> +static void ideapad_sync_rfk_state(struct ideapad_private *priv)
>  {
> -       struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
>        unsigned long hw_blocked;
>        int i;
>
> @@ -309,8 +311,7 @@ static int __devinit ideapad_register_rfkill(struct acpi_device *adevice,
>        return 0;
>  }
>
> -static void __devexit ideapad_unregister_rfkill(struct acpi_device *adevice,
> -                                               int dev)
> +static void ideapad_unregister_rfkill(struct acpi_device *adevice, int dev)
>  {
>        struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
>
> @@ -418,6 +419,97 @@ static void ideapad_input_report(struct ideapad_private *priv,
>  }
>
>  /*
> + * backlight
> + */
> +static int ideapad_backlight_get_brightness(struct backlight_device *blightdev)
> +{
> +       unsigned long now;
> +
> +       if (read_ec_data(ideapad_handle, 0x12, &now))
> +               return -EAGAIN;
> +       return now;
> +}
> +
> +static int ideapad_backlight_update_status(struct backlight_device *blightdev)
> +{
> +       if (write_ec_cmd(ideapad_handle, 0x13, blightdev->props.brightness))
> +               return -EAGAIN;
> +       if (write_ec_cmd(ideapad_handle, 0x33,
> +                        blightdev->props.power == FB_BLANK_POWERDOWN ? 0 : 1))
> +               return -EAGAIN;
> +
> +       return 0;
> +}

I don't think -EAGAIN is a good idea here ... Why not -EIO ?

> +static const struct backlight_ops ideapad_backlight_ops = {
> +       .get_brightness = ideapad_backlight_get_brightness,
> +       .update_status = ideapad_backlight_update_status,
> +};
> +
> +static int ideapad_backlight_init(struct ideapad_private *priv)
> +{
> +       struct backlight_device *blightdev;
> +       struct backlight_properties props;
> +       unsigned long max, now, power;
> +
> +       if (read_ec_data(ideapad_handle, 0x11, &max))
> +               return -EAGAIN;
> +       if (read_ec_data(ideapad_handle, 0x12, &now))
> +               return -EAGAIN;
> +       if (read_ec_data(ideapad_handle, 0x18, &power))
> +               return -EAGAIN;

Same

> +       memset(&props, 0, sizeof(struct backlight_properties));
> +       props.max_brightness = max;

You forgot to set backlight type, "props.type = BACKLIGHT_PLATFORM;"

> +       blightdev = backlight_device_register("ideapad",
> +                                             &priv->platform_device->dev,
> +                                             priv,
> +                                             &ideapad_backlight_ops,
> +                                             &props);
> +       if (IS_ERR(blightdev)) {
> +               pr_err("Could not register backlight device\n");
> +               return PTR_ERR(blightdev);
> +       }
> +
> +       priv->blightdev = blightdev;
> +       blightdev->props.brightness = now;
> +       blightdev->props.power = power ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
> +       backlight_update_status(blightdev);
> +
> +       return 0;
> +}
> +
> +static void ideapad_backlight_exit(struct ideapad_private *priv)
> +{
> +       if (priv->blightdev)
> +               backlight_device_unregister(priv->blightdev);
> +       priv->blightdev = NULL;
> +}
> +
> +static void ideapad_backlight_notify_power(struct ideapad_private *priv)
> +{
> +       unsigned long power;
> +       struct backlight_device *blightdev = priv->blightdev;
> +
> +       if (read_ec_data(ideapad_handle, 0x18, &power))
> +               return;
> +       blightdev->props.power = power ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
> +}
> +
> +static void ideapad_backlight_notify_brightness(struct ideapad_private *priv)
> +{
> +       unsigned long now;
> +
> +       /* if we control brightness via acpi video driver */
> +       if (priv->blightdev == NULL) {
> +               read_ec_data(ideapad_handle, 0x12, &now);
> +               return;
> +       }
> +
> +       backlight_force_update(priv->blightdev, BACKLIGHT_UPDATE_HOTKEY);
> +}
> +
> +/*
>  * module init/exit
>  */
>  static const struct acpi_device_id ideapad_device_ids[] = {
> @@ -456,10 +548,19 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
>                else
>                        priv->rfk[i] = NULL;
>        }
> -       ideapad_sync_rfk_state(adevice);
> +       ideapad_sync_rfk_state(priv);
> +
> +       if (!acpi_video_backlight_support()) {
> +               ret = ideapad_backlight_init(priv);
> +               if (ret && ret != -ENODEV)
> +                       goto backlight_failed;
> +       }
>
>        return 0;
>
> +backlight_failed:
> +       for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
> +               ideapad_unregister_rfkill(adevice, i);
>  input_failed:
>        ideapad_platform_exit(priv);
>  platform_failed:
> @@ -472,6 +573,7 @@ static int __devexit ideapad_acpi_remove(struct acpi_device *adevice, int type)
>        struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
>        int i;
>
> +       ideapad_backlight_exit(priv);
>        for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
>                ideapad_unregister_rfkill(adevice, i);
>        ideapad_input_exit(priv);
> @@ -496,12 +598,19 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
>        vpc1 = (vpc2 << 8) | vpc1;
>        for (vpc_bit = 0; vpc_bit < 16; vpc_bit++) {
>                if (test_bit(vpc_bit, &vpc1)) {
> -                       if (vpc_bit == 9)
> -                               ideapad_sync_rfk_state(adevice);
> -                       else if (vpc_bit == 4)
> -                               read_ec_data(handle, 0x12, &vpc2);
> -                       else
> +                       switch (vpc_bit) {
> +                       case 9:
> +                               ideapad_sync_rfk_state(priv);
> +                               break;
> +                       case 4:
> +                               ideapad_backlight_notify_brightness(priv);
> +                               break;
> +                       case 2:
> +                               ideapad_backlight_notify_power(priv);
> +                               break;
> +                       default:
>                                ideapad_input_report(priv, vpc_bit);
> +                       }
>                }
>        }
>  }
> --
> 1.7.4.1
>
>

Otherwise, looks ok

-- 
Corentin Chary
http://xf.iksaif.net
