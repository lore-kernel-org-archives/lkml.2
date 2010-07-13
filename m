Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab0GMQZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:25:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64687 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab0GMQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FSRX7AmwEj7QG0amgRibkfJFZBYV4251Wx5cGblU6xDnx4Do2bPu0J91r8BmrUEDdQ
         rFcVGTg1AE2esXKvMjeM+yVI6kQeXKhm6O8oK1mpk8lWFcoiQ/Bn9NLeaHoBhUZXTvG9
         xoZVwRiB1Sas+MomZ8XzQaCpKmfMMYga680No=
Date: Tue, 13 Jul 2010 09:25:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH] atlas_btns: fix mixing acpi_status and int for return
 value
Message-ID: <20100713162508.GA26529@core.coreip.homeip.net>
References: <1279013475.28550.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279013475.28550.5.camel@mola>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 05:31:15PM +0800, Axel Lin wrote:
> To improve readability, this patch fixes mixing acpi_status
> and int for return value.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/input/misc/atlas_btns.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
> index 7d53608..ea14800 100644
> --- a/drivers/input/misc/atlas_btns.c
> +++ b/drivers/input/misc/atlas_btns.c
> @@ -60,12 +60,12 @@ static acpi_status acpi_atlas_button_handler(u32 function,
>  		input_report_key(input_dev, atlas_keymap[code], key_down);
>  		input_sync(input_dev);
>  
> -		status = 0;
> +		status = AE_OK;
>  	} else {
>  		printk(KERN_WARNING "atlas: shrugged on unexpected function"
>  			":function=%x,address=%lx,value=%x\n",
>  			function, (unsigned long)address, (u32)*value);
> -		status = -EINVAL;
> +		status = AE_BAD_PARAMETER;
>  	}
>  
>  	return status;
> @@ -114,26 +114,27 @@ static int atlas_acpi_button_add(struct acpi_device *device)
>  	if (ACPI_FAILURE(status)) {
>  		printk(KERN_ERR "Atlas: Error installing addr spc handler\n");
>  		input_unregister_device(input_dev);
> -		status = -EINVAL;
> +		err = -EINVAL;
>  	}
>  
> -	return status;
> +	return err;
>  }
>  
>  static int atlas_acpi_button_remove(struct acpi_device *device, int type)
>  {
>  	acpi_status status;
> +	int err = 0;
>  
>  	status = acpi_remove_address_space_handler(device->handle,
>  				0x81, &acpi_atlas_button_handler);
>  	if (ACPI_FAILURE(status)) {
>  		printk(KERN_ERR "Atlas: Error removing addr spc handler\n");
> -		status = -EINVAL;
> +		err = -EINVAL;
>  	}
>  
>  	input_unregister_device(input_dev);
>  
> -	return status;
> +	return err;

We should not report any errors since operation is irreversible, just
log them. I believe typing remove methods as returning int instead of
void was a mistake.

I'll fix it up and apply both patches, thanks Axel.

-- 
Dmitry
