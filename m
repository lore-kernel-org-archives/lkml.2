Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab0JGDz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:55:27 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57376 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab0JGDz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NPC7/AUK2hgE92AfWCZo3+Sv8MMKsGik2XYrZ3/DLx/8zuiffKlt6EQZtd9voGt+Ie
         EGTsbubVnHFkhKBG0oHNXN9ZjtSrQWUXIS/vblvDLg0cQ/flpW2aeP8nk7tUlLXYxw5G
         ILH9TTzPszQ6iAjcFwYniIVYTWaI3BfsDdKMQ=
MIME-Version: 1.0
In-Reply-To: <1286423526-2777-1-git-send-email-rahul.ruikar@gmail.com>
References: <1286423526-2777-1-git-send-email-rahul.ruikar@gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Thu, 7 Oct 2010 09:24:17 +0530
Message-ID: <AANLkTin3eFrPwN+CT7XR1dsCV82QgyT+UryNj0M9FhW7@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Kindly apply this patch.


- Rahul Ruikar





On 7 October 2010 09:22, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> Fix for following cases
> - Call device_unregister() only when device_register() succeeds.
> - Call put_device() when device_register() fails.
> - Call device_remove_file() only when device_create_file() succeeds.
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/gadget/langwell_udc.c |   14 +++++++++++---
>  drivers/usb/gadget/langwell_udc.h |    4 +++-
>  2 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
> index c2d2a20..56e216e 100644
> --- a/drivers/usb/gadget/langwell_udc.c
> +++ b/drivers/usb/gadget/langwell_udc.c
> @@ -2952,8 +2952,11 @@ static void langwell_udc_remove(struct pci_dev *pdev)
>        INFO(dev, "unbind\n");
>        DBG(dev, "<--- %s()\n", __func__);
>
> -       device_unregister(&dev->gadget.dev);
> -       device_remove_file(&pdev->dev, &dev_attr_langwell_udc);
> +       if (dev->reg_status)
> +               device_unregister(&dev->gadget.dev);
> +
> +       if (dev->file_created)
> +               device_remove_file(&pdev->dev, &dev_attr_langwell_udc);
>
>  #ifndef        OTG_TRANSCEIVER
>        pci_set_drvdata(pdev, NULL);
> @@ -3190,13 +3193,18 @@ static int langwell_udc_probe(struct pci_dev *pdev,
>        the_controller = dev;
>
>        retval = device_register(&dev->gadget.dev);
> -       if (retval)
> +       if (retval) {
> +               put_device(&dev->gadget.dev);
>                goto error;
> +       }
> +       dev->reg_status = 1;
>
>        retval = device_create_file(&pdev->dev, &dev_attr_langwell_udc);
>        if (retval)
>                goto error;
>
> +       dev->file_created = 1;
> +
>        VDBG(dev, "<--- %s()\n", __func__);
>        return 0;
>
> diff --git a/drivers/usb/gadget/langwell_udc.h b/drivers/usb/gadget/langwell_udc.h
> index 9719934..da40671 100644
> --- a/drivers/usb/gadget/langwell_udc.h
> +++ b/drivers/usb/gadget/langwell_udc.h
> @@ -199,7 +199,9 @@ struct langwell_udc {
>                                vbus_active:1,
>                                suspended:1,
>                                stopped:1,
> -                               lpm:1;  /* LPM capability */
> +                               lpm:1,  /* LPM capability */
> +                               reg_status:1,
> +                               file_created:1;
>
>        /* pci state used to access those endpoints */
>        struct pci_dev          *pdev;
> --
> 1.7.2.3
>
>
