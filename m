Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab2GaUQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:16:54 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:34041 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756088Ab2GaUQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:16:51 -0400
Message-ID: <50183CEC.1050105@xenotime.net>
Date: Tue, 31 Jul 2012 13:15:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: linux-next: Tree for July 31 (media/radio-tea5777)
References: <20120731152614.de6ebe9e0d4b8fc6645b793a@canb.auug.org.au> <50181451.5040202@xenotime.net> <50183865.9090700@redhat.com>
In-Reply-To: <50183865.9090700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 12:56 PM, Mauro Carvalho Chehab wrote:

> Em 31-07-2012 14:22, Randy Dunlap escreveu:
>> drivers/built-in.o: In function `radio_tea5777_set_freq':
>> radio-tea5777.c:(.text+0x4d8704): undefined reference to `__udivdi3'
>>
> The patch below should fix it.
> 
> Thanks for reporting it!
> 
> Regards,
> Mauro
> 
> [media] radio-tea5777: use library for 64bits div
> 
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> drivers/built-in.o: In function `radio_tea5777_set_freq':
> radio-tea5777.c:(.text+0x4d8704): undefined reference to `__udivdi3'
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> 
> diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
> index 3e12179..5bc9fa6 100644
> --- a/drivers/media/radio/radio-tea5777.c
> +++ b/drivers/media/radio/radio-tea5777.c
> @@ -33,6 +33,7 @@
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-event.h>
> +#include <asm/div64.h>
>  #include "radio-tea5777.h"
>  
>  MODULE_AUTHOR("Hans de Goede <perex@perex.cz>");
> @@ -158,10 +159,11 @@ static int radio_tea5777_set_freq(struct radio_tea5777 *tea)
>  	int res;
>  
>  	freq = clamp_t(u32, tea->freq,
> -		       TEA5777_FM_RANGELOW, TEA5777_FM_RANGEHIGH);
> -	freq = (freq + 8) / 16; /* to kHz */
> +		       TEA5777_FM_RANGELOW, TEA5777_FM_RANGEHIGH) + 8;
> +	do_div(freq, 16); /* to kHz */
>  
> -	freq = (freq - TEA5777_FM_IF) / TEA5777_FM_FREQ_STEP;
> +	freq -= TEA5777_FM_IF;
> +	do_div(freq, TEA5777_FM_FREQ_STEP);
>  
>  	tea->write_reg &= ~(TEA5777_W_FM_PLL_MASK | TEA5777_W_FM_FREF_MASK);
>  	tea->write_reg |= freq << TEA5777_W_FM_PLL_SHIFT;
> 
> --


-- 
~Randy
