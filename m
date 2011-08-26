Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1HZOtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:49:00 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34634 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1HZOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:48:58 -0400
Date: Fri, 26 Aug 2011 16:48:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 26 (i7core_edac)
Message-ID: <20110826144855.GA11820@aftab>
References: <20110826150000.302334d0b86c17cd9b89b590@canb.auug.org.au>
 <205ae102ed038641e32cf38c48334f9e.squirrel@xenotime.net>
 <CA+icZUX1zaw7xxka8yP4B0tFt7XgXe=8faw8vBnNWm+6teJVaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUX1zaw7xxka8yP4B0tFt7XgXe=8faw8vBnNWm+6teJVaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 10:16:11AM -0400, Sedat Dilek wrote:
> ( UNTESTED, just followed patches like "[PATCH] p54: Use do_div for
> 64-bit division to fix 32-bit kernels" or "[PATCH v1] carl9170: Use
> do_div for 64-bit division to fix 32-bit kernels" )
> 
> Regards,
> - Sedat -

> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> index 7cb68de..4d4f3a5 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -37,6 +37,7 @@
>  #include <linux/smp.h>
>  #include <asm/mce.h>
>  #include <asm/processor.h>
> +#include <asm/div64.h>
>  
>  #include "edac_core.h"
>  
> @@ -2102,7 +2103,8 @@ static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 new_bw)
>  		 * program the corresponding register value.
>  		 */
>  		scrub_interval = (unsigned long long)freq_dclk_mhz *
> -			cache_line_size * 1000000 / new_bw;
> +			cache_line_size * 1000000);
> +		do_div(scrub_interval, new_bw);

This has been an issue pretty often lately on lkml. Instead of doing
64-bit division on 32-bit (which is really slow), you could try to use
the commutative property of integer multiplication and thus reorder the
operations so that the division is 32-bit only. Maybe

((freq_dclk_mhz * cache_line_size) / new_bw) * 1000000

for example. You have to make sure though that new_bw as divisor can
never be bigger than the dividend because otherwise you get the 0. One
question would be what is the interval of freq_dclk_mhz and can (new_bw >> 6)
be ever bigger than it.

And while at it, the cache_line_size is pretty solidly staying 64 Byte
in the short-term future so no need for a local variable. Also, shifting
left by 6 should be a faster equivalent than multiplying by 64.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
