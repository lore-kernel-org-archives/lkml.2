Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2LKUhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:37:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34889 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2LKUhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:37:11 -0500
Message-ID: <50C7995E.7060301@zytor.com>
Date: Tue, 11 Dec 2012 12:36:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Enable A20 using KBC for some MSI laptops to fix S3
 resume
References: <201210261056.44225.zary@gsystems.sk> <201212111959.15808.linux@rainbow-software.org> <50C78486.9070700@zytor.com> <201212112129.13248.linux@rainbow-software.org>
In-Reply-To: <201212112129.13248.linux@rainbow-software.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 12:29 PM, Ondrej Zary wrote:
> 
> Something like this? (It works.)
> 

Something like that.  We need to make sure we send the proper sequence,
though, or it might break some SMM firmware...

> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index d6cc77a..0807ac7 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -921,6 +921,7 @@ static int __init i8042_platform_init(void)
>  	int retval;
>  
>  #ifdef CONFIG_X86
> +	u8 a20_on = 0xdf;
>  	/* Just return if pre-detection shows no i8042 controller exist */
>  	if (!x86_platform.i8042_detect())
>  		return -ENODEV;
> @@ -960,6 +961,13 @@ static int __init i8042_platform_init(void)
>  
>  	if (dmi_check_system(i8042_dmi_dritek_table))
>  		i8042_dritek = true;
> +
> +	/*
> +	 * A20 was already enabled during early kernel init. But some buggy
> +	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
> +	 * resume from S3. So we do it here and hope that nothing breaks.
> +	 */
> +	i8042_command(&a20_on, 0x10d1);
>  #endif /* CONFIG_X86 */
>  
>  	return retval;
> 

