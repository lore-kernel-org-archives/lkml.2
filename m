Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0JNCYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 22:24:54 -0400
Received: from void.printf.net ([89.145.121.20]:52602 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab0JNCYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 22:24:52 -0400
Date: Thu, 14 Oct 2010 03:24:40 +0100
From: Chris Ball <cjb@laptop.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-mmc@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>,
        Nicolas Pitre <nico@fluxnic.net>, libertas-dev@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Mack <daniel@caiaq.de>,
        Colin Cross <ccross@android.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxim Levitsky <maximlevitsky@gmail.com>, stable@kernel.org
Subject: Re: [PATCH] sdio: fix suspend/resume regression
Message-ID: <20101014022440.GD3553@void.printf.net>
References: <1286788315.3101.11.camel@sven> <1286955116-22793-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286955116-22793-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Wed, Oct 13, 2010 at 09:31:56AM +0200, Ohad Ben-Cohen wrote:
> Fix SDIO suspend/resume regression introduced by
> 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e "mmc: fix all hangs related to
> mmc/sd card insert/removal during suspend/resume":
> 
> [ 5647.295953] PM: Syncing filesystems ... done.
> [ 5647.318792] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 5647.337048] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [ 5647.356915] Suspending console(s) (use no_console_suspend to debug)
> [ 5647.366651] pm_op(): platform_pm_suspend+0x0/0x5c returns -38
> [ 5647.366671] PM: Device pxa2xx-mci.0 failed to suspend: error -38
> [ 5647.367082] PM: Some devices failed to suspend
> 
> 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e moved the card removal/insertion
> mechanism out of MMC's suspend/resume path and into pm notifiers
> (mmc_pm_notify), and that broke SDIO's expectation that mmc_suspend_host()
> will remove the card, and squash the error, in case -ENOSYS is returned
> from the bus suspend handler (mmc_sdio_suspend() in this case).
> 
> mmc_sdio_suspend() is using this whenever at least one of the card's SDIO
> function drivers does not have suspend/resume handlers - in that case
> it is agreed to force removal of the entire card.
> 
> This patch fixes this regression by trivially bringing back that part of
> mmc_suspend_host(), which was removed by 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e.
> 
> Reported-and-tested-by: Sven Neumann <s.neumann@raumfeld.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: <stable@kernel.org>
> --
> 
> It may still be desired to further clean this area up by using the card
> removal mechanism in mmc_pm_notify() for SDIO as well.
> 
> To use mmc_pm_notify's card-removal code also for SDIO, we need it
> to check if all the SDIO functions have suspend handlers. That
> would probably make us add a new bus_ops handler (something like
> host->bus_ops->remove_card_on_suspend ?).
> 
> It's starting to get a bit complicated though, and I'm not sure it
> would make the code a lot more readable.
> 
> In addition, this would still not work for drivers like libertas sdio,
> which do have a suspend handler, but sometimes let it return -ENOSYS,
> expecting mmc_suspend_host() to remove the card and squash the error.
> For those cases, we still need the old card-removal logic in mmc_suspend_host().
> 
> This brings up a question whether libertas_sdio really needs this
> functionality; When MMC_PM_KEEP_POWER is not needed, can't it just return 0
> (and as a result the card will be powered down, but not removed) ?
> 
> Until we have an agreement on this, I suggest we at least fix the
> regression with this patch.
> 
> Thanks Sven Neumann for reporting and testing the issue and this patch.
> 
>  drivers/mmc/core/core.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index c94565d..515ff39 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1682,6 +1682,19 @@ int mmc_suspend_host(struct mmc_host *host)
>  	if (host->bus_ops && !host->bus_dead) {
>  		if (host->bus_ops->suspend)
>  			err = host->bus_ops->suspend(host);
> +		if (err == -ENOSYS || !host->bus_ops->resume) {
> +			/*
> +			 * We simply "remove" the card in this case.
> +			 * It will be redetected on resume.
> +			 */
> +			if (host->bus_ops->remove)
> +				host->bus_ops->remove(host);
> +			mmc_claim_host(host);
> +			mmc_detach_bus(host);
> +			mmc_release_host(host);
> +			host->pm_flags = 0;
> +			err = 0;
> +		}
>  	}
>  	mmc_bus_put(host);
>  
> -- 

Thanks very much, I've applied this to mmc-next with Nicolas' ACK.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
