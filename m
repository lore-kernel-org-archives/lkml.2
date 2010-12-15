Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0LOIKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:10:55 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46901 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0LOIKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W/Bry5KyIaL7y9y/cafyXMey+T5MHa2nldqhGUNvHx+n+N0Q3tQ9j2E2AgVlCFcknM
         niy25rYSAvOesgyeh4KhIafCXFkAtTyUsyKdoP8JYIQFpDCkXUcNG0lqxQ74VxNrGZNl
         B3sYLCo1/6if3cm04KGACEXu8Ty78meJqlzUQ=
Date: Wed, 15 Dec 2010 00:10:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] toshiba_acpi: FULL TOS1900 device support
Message-ID: <20101215081046.GB11920@core.coreip.homeip.net>
References: <AANLkTimW5ro7EQBgoqMLSxnEsVrinL2S+USu207-Nbh=@mail.gmail.com>
 <20101210213551.GE1630@core.coreip.homeip.net>
 <AANLkTimhgLyx=Di2yBimFWm=Hg5-2CGOxHfuB+Gb-9_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimhgLyx=Di2yBimFWm=Hg5-2CGOxHfuB+Gb-9_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Azael,

On Fri, Dec 10, 2010 at 05:06:09PM -0700, Azael Avalos wrote:
> 
> - err_remove_notify:
> -	acpi_remove_notify_handler(toshiba_acpi.handle,
> -				   ACPI_DEVICE_NOTIFY, toshiba_acpi_notify);
> - err_free_keymap:
> +err_free_keymap:
>  	sparse_keymap_free(toshiba_acpi.hotkey_dev);
> - err_free_dev:
> +	if (toshiba_acpi.hci_type == 2)
> +		i8042_remove_filter(toshiba_i8042_filter);

You need to remove filter before you free the keymap. Also
cancel_work_sync() is needed.

> +err_free_dev:
>  	input_free_device(toshiba_acpi.hotkey_dev);
>  	toshiba_acpi.hotkey_dev = NULL;
>  	return error;
>  }
> 

...

> +static int toshiba_acpi_remove(struct acpi_device *device, int type)
> +{
> +	if (toshiba_acpi.hci_type == 2)
> +		i8042_remove_filter(toshiba_i8042_filter);

You also need to call cancel_work_sync() here to make sure the work is
not running while you are tearing down the device.

> +
> +	toshiba_acpi_cleanup();
> +
> +	return 0;
> +}
> +

Thanks.

-- 
Dmitry
