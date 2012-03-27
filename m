Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2C0JLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:11:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37315 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab2C0JLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:11:19 -0400
MIME-Version: 1.0
In-Reply-To: <1332421699-5315-1-git-send-email-corentincj@iksaif.net>
References: <20120320163002.GB6811@srcf.ucam.org>
	<1332421699-5315-1-git-send-email-corentincj@iksaif.net>
Date: Tue, 27 Mar 2012 11:11:18 +0200
Message-ID: <CAHR064hc4AdFUeoO8Szg0FG6CwLK+xauGn9VMJntWV1Gik=ACQ@mail.gmail.com>
Subject: Re: [PATCH] samsung-laptop: unregister ACPI video module for some
 well known laptops
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 2:08 PM, Corentin Chary <corentincj@iksaif.net> wrote:
> On these laptops, the ACPI video is not functional, and very unlikely
> to be fixed by the vendor. Note that intel_backlight works for some
> of these laptops, and the backlight from samsung-laptop always work.
>
> The good news is that newer laptops have functional ACPI video device
> and won't end up growing this list.
>
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> ---
>  drivers/platform/x86/samsung-laptop.c |   80 +++++++++++++++++++++++++++++++--
>  1 files changed, 76 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> index 4787afd..e2a34b4 100644
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -26,6 +26,9 @@
>  #include <linux/seq_file.h>
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
> +#if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> +#include <acpi/video.h>
> +#endif
>
>  /*
>  * This driver is needed because a number of Samsung laptops do not hook
> @@ -336,6 +339,7 @@ struct samsung_laptop {
>        struct work_struct kbd_led_work;
>
>        struct samsung_laptop_debug debug;
> +       struct samsung_quirks *quirks;
>
>        bool handle_backlight;
>        bool has_stepping_quirk;
> @@ -343,7 +347,15 @@ struct samsung_laptop {
>        char sdiag[64];
>  };
>
> +struct samsung_quirks {
> +       bool broken_acpi_video;
> +};
> +
> +static struct samsung_quirks samsung_unknown = {};
>
> +static struct samsung_quirks samsung_broken_acpi_video = {
> +       .broken_acpi_video = true,
> +};
>
>  static bool force;
>  module_param(force, bool, 0);
> @@ -1416,6 +1428,14 @@ static int __init samsung_platform_init(struct samsung_laptop *samsung)
>        return 0;
>  }
>
> +static struct samsung_quirks *quirks;
> +
> +static int __init samsung_dmi_matched(const struct dmi_system_id *d)
> +{
> +       quirks = d->driver_data;
> +       return 0;
> +}
> +
>  static struct dmi_system_id __initdata samsung_dmi_table[] = {
>        {
>                .matches = {
> @@ -1445,6 +1465,47 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
>                        DMI_MATCH(DMI_CHASSIS_TYPE, "14"), /* Sub-Notebook */
>                },
>        },
> +       /* Specific DMI ids for laptop with quirks */
> +       {
> +        .callback = samsung_dmi_matched,
> +        .ident = "N150P",
> +        .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
> +               DMI_MATCH(DMI_BOARD_NAME, "N150P"),
> +               },
> +        .driver_data = &samsung_broken_acpi_video,
> +       },
> +       {
> +        .callback = samsung_dmi_matched,
> +        .ident = "N145P/N250P/N260P",
> +        .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
> +               DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
> +               },
> +        .driver_data = &samsung_broken_acpi_video,
> +       },
> +       {
> +        .callback = samsung_dmi_matched,
> +        .ident = "N150/N210/N220",
> +        .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
> +               DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
> +               },
> +        .driver_data = &samsung_broken_acpi_video,
> +       },
> +       {
> +        .callback = samsung_dmi_matched,
> +        .ident = "NF110/NF210/NF310",
> +        .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
> +               DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
> +               },
> +        .driver_data = &samsung_broken_acpi_video,
> +       },
>        { },
>  };
>  MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
> @@ -1456,6 +1517,7 @@ static int __init samsung_init(void)
>        struct samsung_laptop *samsung;
>        int ret;
>
> +       quirks = &samsung_unknown;
>        if (!force && !dmi_check_system(samsung_dmi_table))
>                return -ENODEV;
>
> @@ -1465,12 +1527,21 @@ static int __init samsung_init(void)
>
>        mutex_init(&samsung->sabi_mutex);
>        samsung->handle_backlight = true;
> +       samsung->quirks = quirks;
>
> -#ifdef CONFIG_ACPI
> +
> +#if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
>        /* Don't handle backlight here if the acpi video already handle it */
> -       if (acpi_video_backlight_support())
> -               samsung->handle_backlight = false;
> +       if (acpi_video_backlight_support()) {
> +               if (samsung->quirks->broken_acpi_video) {
> +                       pr_info("Disabling ACPI video driver\n");
> +                       acpi_video_unregister();
> +               } else {
> +                       samsung->handle_backlight = false;
> +               }
> +       }
>  #endif
> +
>        ret = samsung_platform_init(samsung);
>        if (ret)
>                goto error_platform;
> @@ -1481,7 +1552,8 @@ static int __init samsung_init(void)
>
>  #ifdef CONFIG_ACPI
>        /* Only log that if we are really on a sabi platform */
> -       if (acpi_video_backlight_support())
> +       if (acpi_video_backlight_support() &&
> +           !samsung->quirks->broken_acpi_video)
>                pr_info("Backlight controlled by ACPI video driver\n");
>  #endif
>
> --
> 1.7.3.4
>

Matthew, is this one ok ? I really hope this patch can go in 3.4 so we
don't introduce a regression for old laptops.
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
