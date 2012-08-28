Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2H1DR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 23:17:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45514 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2H1DRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 23:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <1345904049-26568-1-git-send-email-anish198519851985@gmail.com>
References: <1345904049-26568-1-git-send-email-anish198519851985@gmail.com>
Date: Tue, 28 Aug 2012 08:47:22 +0530
Message-ID: <CAK7N6vrmz_JPkzam68A6O77vR4FsDyu_H_6+ZAvoJLkiz0MOLQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC]Extcon: Change to add standard cable names in
 individual drivers.
From: anish singh <anish198519851985@gmail.com>
To: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Cc: linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the requirement:
driver has to give the core the list of standard cable names(exported by
the core) and can also specify the custom cable names.

Something as this :
char *cable_names_supported = {
        [0] = EXTCON_USB,   /*defined in extcon core */
        [1] = EXTCON_HEADSET,/*defined in extcon core */
        [2] = CUSTOM_CABLE /*Not defined in extcon core */
 }
As of now this is not possible because of some limitations in the extcon core.

So, I proposed this attached patch(with limitations) and below is the gist:
In the core( .C file):
char *cable_name[] = { "USB",
                                   "Cable1",
                                   "Cable2",
                                   ......
                                }
In the core ( .h file):
enum cable_name{
             USB = 0,
             CABLE1,
             CABLE2,
}

enum cable_name_support{
             USB_SUPPORT = 1<<USB,
             CABLE1 = 1 << CABLE1,
             CABLE2 = 1 << CABLE2,
 }

and driver can use it this way:
list_of_cable = EXTCON_MIC_IN_SUPPORT |
                     EXTCON_HEADPHONE_OUT_SUPPORT |
                     EXTCON_MECHANICAL_SUPPORT;

Limitations of this patch:
1. We can't specify the custom cable names and
2. It can't grow beyond 32.

One more approach that comes to mind is using the #defines
for all the cable names but that looks ugly.

Is there any better approach to make it work?

-a-n-i-s-h-

On Sat, Aug 25, 2012 at 7:44 PM, anish kumar
<anish198519851985@gmail.com> wrote:
> From: anish kumar <anish198519851985@gmail.com>
>
> Right now we are forced to define our own cable names instead of what
> is exported by extcon framework.We should use the standard cable
> names.With this change, individual drivers can define cable names
> as below:
>
> edev.list_of_cable = EXTCON_MIC_IN_SUPPORT |
>                      EXTCON_HEADPHONE_OUT_SUPPORT |
>                      EXTCON_MECHANICAL_SUPPORT;
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  drivers/extcon/extcon-arizona.c |   11 +++--------
>  drivers/extcon/extcon-class.c   |   35 +++++++++++++++++++++++++----------
>  include/linux/extcon.h          |   29 ++++++++++++++++++++++++++++-
>  3 files changed, 56 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index fa2114f..7a690f2 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -74,13 +74,6 @@ static struct {
>  #define ARIZONA_CABLE_MICROPHONE 1
>  #define ARIZONA_CABLE_HEADPHONE  2
>
> -static const char *arizona_cable[] = {
> -       "Mechanical",
> -       "Microphone",
> -       "Headphone",
> -       NULL,
> -};
> -
>  static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
>  {
>         struct arizona *arizona = info->arizona;
> @@ -381,7 +374,9 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
>         }
>
>         info->edev.name = "Headset Jack";
> -       info->edev.supported_cable = arizona_cable;
> +       info->edev.list_of_cable = EXTCON_MIC_IN_SUPPORT |
> +                                       EXTCON_HEADPHONE_OUT_SUPPORT |
> +                                               EXTCON_MECHANICAL_SUPPORT;
>
>         ret = extcon_dev_register(&info->edev, arizona->dev);
>         if (ret < 0) {
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 481cfa0..22aa4b8 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -95,7 +95,7 @@ static int check_mutually_exclusive(struct extcon_dev *edev, u32 new_state)
>                 u32 correspondants = new_state & edev->mutually_exclusive[i];
>                 u32 exp = 1;
>
> -               for (j = 0; j < 32; j++) {
> +               for (j = 0; j < SUPPORTED_CABLE_MAX; j++) {
>                         if (exp & correspondants)
>                                 count++;
>                         if (count > 1)
> @@ -580,6 +580,7 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
>                 put_device(edev->dev);
>         }
>
> +       kfree(edev->supported_cable);
>         kfree(edev->dev);
>  }
>
> @@ -607,7 +608,7 @@ static void dummy_sysfs_dev_release(struct device *dev)
>   */
>  int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
>  {
> -       int ret, index = 0;
> +       int ret, index = 0, i = 0;
>
>         if (!extcon_class) {
>                 ret = create_extcon_class();
> @@ -615,23 +616,36 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
>                         return ret;
>         }
>
> -       if (edev->supported_cable) {
> -               /* Get size of array */
> -               for (index = 0; edev->supported_cable[index]; index++)
> -                       ;
> -               edev->max_supported = index;
> -       } else {
> -               edev->max_supported = 0;
> +       edev->max_supported = 0;
> +
> +       /* get the total number of cables */
> +       for_each_set_bit(i, &edev->list_of_cable, BITS_PER_LONG) {
> +               index++;
>         }
> +       edev->max_supported = index;
>
>         if (index > SUPPORTED_CABLE_MAX) {
>                 dev_err(edev->dev, "extcon: maximum number of supported cables exceeded.\n");
>                 return -EINVAL;
>         }
>
> +       edev->supported_cable = kzalloc(sizeof(char *) * index, GFP_KERNEL);
> +       if (!edev->supported_cable) {
> +               pr_err("extcon supported cable allocation failed\n");
> +               return -ENOMEM;
> +       }
> +
> +       index = 0;
> +       for_each_set_bit(i, &edev->list_of_cable, BITS_PER_LONG) {
> +               edev->supported_cable[index++] = extcon_cable_name[i];
> +       }
> +
>         edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
> -       if (!edev->dev)
> +       if (!edev->dev) {
> +               pr_err("extcon device allocation failed\n");
>                 return -ENOMEM;
> +       }
> +
>         edev->dev->parent = dev;
>         edev->dev->class = extcon_class;
>         edev->dev->release = extcon_dev_release;
> @@ -799,6 +813,7 @@ err_alloc_cables:
>         if (edev->max_supported)
>                 kfree(edev->cables);
>  err_sysfs_alloc:
> +       kfree(edev->supported_cable);
>         kfree(edev->dev);
>         return ret;
>  }
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index cdd4014..65cc23a 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -70,6 +70,32 @@ enum extcon_cable_name {
>  };
>  extern const char *extcon_cable_name[];
>
> +/* Please use this enum's to add support for cables in your drivers
> + * Please add any other "standard" cables used with extcon dev.
> + */
> +enum extcon_cable_name_support {
> +       EXTCON_USB_SUPPORT              = 1 << EXTCON_USB,
> +       EXTCON_USB_HOST_SUPPORT         = 1 << EXTCON_USB_HOST,
> +       EXTCON_TA_SUPPORT               = 1 << EXTCON_TA,
> +       EXTCON_FAST_CHARGER_SUPPORT     = 1 << EXTCON_FAST_CHARGER,
> +       EXTCON_SLOW_CHARGER_SUPPORT     = 1 << EXTCON_SLOW_CHARGER,
> +       EXTCON_CHARGE_DOWNSTREAM_SUPPORT = 1 << EXTCON_CHARGE_DOWNSTREAM,
> +       EXTCON_HDMI_SUPPORT             = 1 << EXTCON_HDMI,
> +       EXTCON_MHL_SUPPORT              = 1 << EXTCON_MHL,
> +       EXTCON_DVI_SUPPORT              = 1 << EXTCON_DVI,
> +       EXTCON_VGA_SUPPORT              = 1 << EXTCON_VGA,
> +       EXTCON_DOCK_SUPPORT             = 1 << EXTCON_DOCK,
> +       EXTCON_LINE_IN_SUPPORT          = 1 << EXTCON_LINE_IN,
> +       EXTCON_LINE_OUT_SUPPORT         = 1 << EXTCON_LINE_OUT,
> +       EXTCON_MIC_IN_SUPPORT           = 1 << EXTCON_MIC_IN,
> +       EXTCON_HEADPHONE_OUT_SUPPORT    = 1 << EXTCON_HEADPHONE_OUT,
> +       EXTCON_SPDIF_IN_SUPPORT         = 1 << EXTCON_SPDIF_IN,
> +       EXTCON_SPDIF_OUT_SUPPORT        = 1 << EXTCON_SPDIF_OUT,
> +       EXTCON_VIDEO_IN_SUPPORT         = 1 << EXTCON_VIDEO_IN,
> +       EXTCON_VIDEO_OUT_SUPPORT        = 1 << EXTCON_VIDEO_OUT,
> +       EXTCON_MECHANICAL_SUPPORT       = 1 << EXTCON_MECHANICAL,
> +};
> +
>  struct extcon_cable;
>
>  /**
> @@ -111,7 +137,7 @@ struct extcon_cable;
>  struct extcon_dev {
>         /* --- Optional user initializing data --- */
>         const char      *name;
> -       const char **supported_cable;
> +       unsigned long   list_of_cable;
>         const u32       *mutually_exclusive;
>
>         /* --- Optional callbacks to override class functions --- */
> @@ -120,6 +146,7 @@ struct extcon_dev {
>
>         /* --- Internal data. Please do not set. --- */
>         struct device   *dev;
> +       const char **supported_cable;
>         u32             state;
>         struct raw_notifier_head nh;
>         struct list_head entry;
> --
> 1.7.1
>
