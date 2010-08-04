Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0HDEXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:23:33 -0400
Received: from tuxonice.net ([74.207.252.127]:38676 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab0HDEXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:23:31 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C58EB41.1020808@tuxonice.net>
Date: Wed, 04 Aug 2010 14:23:29 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
References: <1280465201.2600.10.camel@shrek.rexursive.com>	 <1280486667.2608.1.camel@shrek.rexursive.com>	 <4C534C9D.8000600@tuxonice.net>	 <1280532174.2583.1.camel@shrek.rexursive.com>	 <4C5362E7.3000706@tuxonice.net>	 <1280538184.2583.11.camel@shrek.rexursive.com>	 <4C537A01.5040808@tuxonice.net>	 <1280540035.2658.5.camel@shrek.rexursive.com>	 <1280551286.3097.6.camel@shrek.rexursive.com>	 <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>	 <1280710453.2727.8.camel@shrek.rexursive.com>	 <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>	 <1280712068.2671.0.camel@shrek.rexursive.com>	 <20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>	 <1280713381.2673.2.camel@shrek.rexursive.com>	 <1280800750.3305.4.camel@shrek.rexursive.com>	 <1280802642.2627.2.camel@shrek.rexursive.com> <4C58D3B0.10602@tuxonice.net>	 <1280890070.2741.11.camel@shrek.rexursive.com> <1280894658.2591.1.camel@shrek.rexursive.com>
In-Reply-To: <1280894658.2591.1.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 04/08/10 14:04, Bojan Smojver wrote:
> On Wed, 2010-08-04 at 12:47 +1000, Bojan Smojver wrote:
>> Points taken for all the other comments. Thank you.
>
> Style wise, does this look better?
>
> PS. Don't worry about contents yet - still working out the kinks.

Okay.

> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index ca6066a..cb57eb9 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -137,6 +137,8 @@ config SUSPEND_FREEZER
>   config HIBERNATION
>   	bool "Hibernation (aka 'suspend to disk')"
>   	depends on PM&&  SWAP&&  ARCH_HIBERNATION_POSSIBLE
> +	select LZO_COMPRESS
> +	select LZO_DECOMPRESS

But, having said 'okay' above, I should point out that you might want to 
select CRYPTO too, since LZO depends on it. (And perhaps I should ask 
whether you should be using cryptoapi rather than LZO directly?)

>   	select SUSPEND_NVS if HAS_IOMEM
>   	---help---
>   	  Enable the suspend to disk (STD) functionality, which is usually
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index b0bb217..1515e2c 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -24,6 +24,7 @@
>   #include<linux/swapops.h>
>   #include<linux/pm.h>
>   #include<linux/slab.h>
> +#include<linux/lzo.h>
>
>   #include "power.h"
>
> @@ -357,6 +358,30 @@ static int swap_writer_finish(struct swap_map_handle *handle,
>   	return error;
>   }
>
> +/* We need to remember how much compressed data we need to read. */
> +#define LZO_HEADER	sizeof(size_t)
> +
> +/* Number of pages/bytes we'll compress at a time. */
> +#define LZO_UNC_PAGES	64
> +#define LZO_UNC_SIZE	(LZO_UNC_PAGES * PAGE_SIZE)
> +
> +/* Number of pages/bytes we need for compressed data (worst case). */
> +#define LZO_CMP_PAGES	DIV_ROUND_UP(lzo1x_worst_compress(LZO_UNC_SIZE) + \
> +			             LZO_HEADER, PAGE_SIZE)
> +#define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
> +
> +/* As per examples/overlap.c in lzo distribution, we need to add more space
> + * to the end of the buffer in order to perform overlapping compression. We
> + * also add LZO_HEADER, because our compressed data starts at that offset.
> + * Then we round it off on PAGE_SIZE boundary, so that we can copy full pages
> + * safely. We call this overhead. Magic numbers and formula below.
> + */

Yeah, that's much better; thanks.

Nigel
