Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935369Ab0KQV34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:29:56 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50348 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab0KQV3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:29:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oeCcdT/SAx6GzbwMS3kjRqNHtMnseTV5SR00JSX7IrNu7Aq6yebkwro14xPKAKkS/u
         WDnk2ljFb5uFUwsV/4CbDQ8eLUfsnD7dp1RX5gARySyD9xuCCiUM27dxYICYxziODhhg
         NDfUv0D3eNSXyX1CtvlyfnevFKM93miSifm0s=
Date: Wed, 17 Nov 2010 13:29:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/3] ideapad: add hotkey support
Message-ID: <20101117212943.GA6661@core.coreip.homeip.net>
References: <1289977165-14802-1-git-send-email-ike.pan@canonical.com>
 <1289977238-15113-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289977238-15113-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:00:38PM +0800, Ike Panhc wrote:
> Hotkey enabled by this patch:
>   Fn+F3: Video mode switch
>   Fn+F5: software rfkill for wifi
> 
> For some ideapad when push Fn+F3, hardware generates Super-P keys, those key
> will not be enabled by this patch.
> 
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> ---
>  drivers/platform/x86/ideapad-laptop.c |   74 +++++++++++++++++++++++++++++++++
>  1 files changed, 74 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index d75c21f..d397034 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -28,6 +28,8 @@
>  #include <acpi/acpi_drivers.h>
>  #include <linux/rfkill.h>
>  #include <linux/platform_device.h>
> +#include <linux/input.h>
> +#include <linux/input/sparse-keymap.h>
>  
>  #define IDEAPAD_DEV_CAMERA	0
>  #define IDEAPAD_DEV_WLAN	1
> @@ -39,6 +41,7 @@ struct ideapad_private {
>  	acpi_handle handle;
>  	struct rfkill *rfk[5];
>  	struct platform_device *platform_device;
> +	struct input_dev *inputdev;
>  } *ideapad_priv;
>  
>  static struct {
> @@ -325,6 +328,68 @@ static void ideapad_platform_exit(void)
>  }
>  /* the above is platform device */
>  
> +/*
> + * input device
> + */
> +static const struct key_entry ideapad_keymap[] = {
> +	{ KE_KEY, 0x06, { KEY_SWITCHVIDEOMODE } },
> +	{ KE_KEY, 0x0D, { KEY_WLAN } },
> +	{ KE_END, 0 },
> +};
> +
> +static int ideapad_input_init(void)

__devinit?

> +{
> +	struct input_dev *inputdev;
> +	int error;
> +
> +	inputdev = input_allocate_device();
> +	if (!inputdev) {
> +		pr_info("Unable to allocate input device\n");
> +		return -ENOMEM;
> +	}
> +
> +	inputdev->name = "Ideapad extra buttons";
> +	inputdev->phys = "ideapad/input0";
> +	inputdev->id.bustype = BUS_HOST;
> +	inputdev->dev.parent = &ideapad_priv->platform_device->dev;
> +
> +	error = sparse_keymap_setup(inputdev, ideapad_keymap, NULL);
> +	if (error) {
> +		pr_err("Unable to setup input device keymap\n");
> +		goto err_free_dev;
> +	}
> +
> +	error = input_register_device(inputdev);
> +	if (error) {
> +		pr_err("Unable to register input device\n");
> +		goto err_free_keymap;
> +	}
> +
> +	ideapad_priv->inputdev = inputdev;

Why don't you pass ideapad_priv in as an argument instead of relying on
global. I know that there can only be one, but then why do you have a
structure?

> +	return 0;
> +
> +err_free_keymap:
> +	sparse_keymap_free(inputdev);
> +err_free_dev:
> +	input_free_device(inputdev);
> +	return error;
> +}
> +
> +static void ideapad_input_exit(void)

__devexit? The rest of the driver might user these markups as well.

> +{
> +	if (ideapad_priv->inputdev) {
> +		sparse_keymap_free(ideapad_priv->inputdev);
> +		input_unregister_device(ideapad_priv->inputdev);
> +	}
> +	ideapad_priv->inputdev = NULL;

You fail driver initialization when ideapad_input_init() fails so there
is no point in checking whether ideapad_priv->inputdev is null or not.

Otherwise looks good from input POV.

Thanks.

-- 
Dmitry
