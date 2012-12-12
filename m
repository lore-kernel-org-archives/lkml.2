Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2LLAp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:45:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39505 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab2LLAp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:45:56 -0500
Message-ID: <50C7D3AB.6060508@zytor.com>
Date: Tue, 11 Dec 2012 16:45:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4] 8042: Enable A20 using KBC to fix S3 resume on some
 MSI laptops
References: <201212112218.06551.linux@rainbow-software.org>
In-Reply-To: <201212112218.06551.linux@rainbow-software.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.  Alan/Rafael/Dmitry, OK for me to commit this?

	-hpa

On 12/11/2012 01:18 PM, Ondrej Zary wrote:
> Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable A20
> line but resume code assumes that KBC was used.
> The laptop will not resume from S3 otherwise but powers off after a while
> and then powers on again stuck with a blank screen.
> 
> Fix it by enabling A20 using KBC in i8042_platform_init for x86.
> 
> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/input/serio/i8042-x86ia64io.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index d6cc77a..5f306f7 100644
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
> @@ -960,6 +961,14 @@ static int __init i8042_platform_init(void)
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
> +	i8042_command(NULL, 0x00ff);	/* Null command for SMM firmware */
>  #endif /* CONFIG_X86 */
>  
>  	return retval;
> 

