Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1CLPeP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 10:34:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:42907 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752147Ab1CLPeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 10:34:11 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18alBwKxK0aMIBOt6H3s4brX7QJAKwRV+0BGfV8pC
	vEqYogDuV7VNHU
Message-ID: <4D7B926F.60400@gmx.de>
Date: Sat, 12 Mar 2011 16:34:07 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video via: fix iomem access
References: <20110303095901.2a283be0@nehalam>
In-Reply-To: <20110303095901.2a283be0@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger schrieb:
> This driver is not respecting the iomem memory space restrictions
> and does direct access. This works on x86 but is non-portable and
> should not be done.  Converted memcpy() of 2 to readw.
> Last post increment of romptr was unnecessary since pointer never
> used after that.
> 
> Found by sparse, compile tested only.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied (although it does not make a difference as viafb is x86 only). Thanks,


Florian Tobias Schandinat

> 
> ---
>  drivers/video/via/lcd.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/video/via/lcd.c	2011-03-03 09:09:10.552604209 -0800
> +++ b/drivers/video/via/lcd.c	2011-03-03 09:56:12.144398571 -0800
> @@ -1064,34 +1064,33 @@ static struct display_timing lcd_centeri
>  
>  bool viafb_lcd_get_mobile_state(bool *mobile)
>  {
> -	unsigned char *romptr, *tableptr;
> +	unsigned char __iomem *romptr, *tableptr, *biosptr;
>  	u8 core_base;
> -	unsigned char *biosptr;
>  	/* Rom address */
> -	u32 romaddr = 0x000C0000;
> -	u16 start_pattern = 0;
> +	const u32 romaddr = 0x000C0000;
> +	u16 start_pattern;
>  
>  	biosptr = ioremap(romaddr, 0x10000);
> +	start_pattern = readw(biosptr);
>  
> -	memcpy(&start_pattern, biosptr, 2);
>  	/* Compare pattern */
>  	if (start_pattern == 0xAA55) {
>  		/* Get the start of Table */
>  		/* 0x1B means BIOS offset position */
>  		romptr = biosptr + 0x1B;
> -		tableptr = biosptr + *((u16 *) romptr);
> +		tableptr = biosptr + readw(romptr);
>  
>  		/* Get the start of biosver structure */
>  		/* 18 means BIOS version position. */
>  		romptr = tableptr + 18;
> -		romptr = biosptr + *((u16 *) romptr);
> +		romptr = biosptr + readw(romptr);
>  
>  		/* The offset should be 44, but the
>  		   actual image is less three char. */
>  		/* pRom += 44; */
>  		romptr += 41;
>  
> -		core_base = *romptr++;
> +		core_base = readb(romptr);
>  
>  		if (core_base & 0x8)
>  			*mobile = false;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

