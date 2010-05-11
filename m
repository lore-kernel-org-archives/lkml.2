Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0EKXJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:09:31 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:18923 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317Ab0EKXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:09:30 -0400
Date: Wed, 12 May 2010 00:09:01 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH v2] i2c-bfin-twi: handle faulty slave devices better
Message-ID: <20100511230901.GA31325@fluff.org.uk>
References: <1273403087-3326-1-git-send-email-vapier@gentoo.org>
 <1273505624-30920-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273505624-30920-1-git-send-email-vapier@gentoo.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 11:33:44AM -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Faulty slave devices might drive SDA low after a transfer finishes.  So,
> when this scenario is detected, have the master generate up to 9 extra
> clocks until the SDA is properly released.

This doesn't apply to my for-2635/i2c-bfin tree, can't find the BUFWERR
patch. will check to see if theres's something i've missed..
 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> v2
> 	- fix typo in comment pointed out by Ben
> 	- use 9 clocks rather than 8 to cover a possible NACK pointed out by Michael
> 
>  drivers/i2c/busses/i2c-bfin-twi.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index fb26e5c..1ee9d5a 100644
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
> +		/* Faulty slave devices, may drive SDA low after a transfer
> +		 * finishes. To release the bus this code generates up to 9
> +		 * extra clocks until SDA is released.
> +		 */
> +
> +		if (read_MASTER_STAT(iface) & SDASEN) {
> +			int cnt = 9;
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
