Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0EILeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 07:34:25 -0400
Received: from trinity.fluff.org ([89.16.178.74]:37887 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab0EILeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 07:34:23 -0400
Date: Sun, 9 May 2010 12:34:20 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] i2c-bfin-twi: handle faulty slave devices better
Message-ID: <20100509113420.GB2589@trinity.fluff.org>
References: <1273403087-3326-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273403087-3326-1-git-send-email-vapier@gentoo.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 07:04:47AM -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Faulty slave devices might drive SDA low after a transfer finishes.  So,
> when this scenario is detected, have the master generate up to 8 extra
> clocks until the SDA is properly released.
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> Note: this requires the existing Blackfin TWI patches already sent out

hmm, it is late in the -rc series for anything other than critical
bugfixes, will update series tomorrow.
 
>  drivers/i2c/busses/i2c-bfin-twi.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index fb26e5c..f9c05e1 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -20,6 +20,7 @@
>  #include <linux/completion.h>
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
> +#include <linux/delay.h>
>  
>  #include <asm/blackfin.h>
>  #include <asm/portmux.h>
> @@ -159,6 +160,27 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>  		if (mast_stat & BUFWRERR)
>  			dev_dbg(&iface->adap.dev, "Buffer Write Error\n");
>  
> +		/* Faulty salve devices, may drive SDA low after a transfer
spello: slave

> +		 * finishes. To release the bus this code generates up to 8
> +		 * extra clocks until SDA is released.
> +		 */
> +
> +		if (read_MASTER_STAT(iface) & SDASEN) {
> +			int cnt = 8;
> +			do {
> +				write_MASTER_CTL(iface, SCLOVR);
> +				udelay(6);
> +				write_MASTER_CTL(iface, 0);
> +				udelay(6);
> +			} while ((read_MASTER_STAT(iface) & SDASEN) && cnt--);
> +
> +			write_MASTER_CTL(iface, SDAOVR | SCLOVR);
> +			udelay(6);
> +			write_MASTER_CTL(iface, SDAOVR);
> +			udelay(6);
> +			write_MASTER_CTL(iface, 0);
> +		}
> +
>  		/* If it is a quick transfer, only address without data,
>  		 * not an err, return 1.
>  		 */
> -- 
> 1.7.1
> 

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

