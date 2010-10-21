Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0JUXrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:47:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41569 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0JUXrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:47:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H6x+4ReNU9hkpndKvMdlcAEqFRFPwL0enacRdNbhsuzgRNe7FwKZXQderUwdvTUIvS
         1tTacd90+iWgnvgInFxi49qjC0/2/QV5DsCbhYwX1GvGqoO7CCvINvOw8npeVAHPxvaQ
         M+JXwyJSd/tVrorCfwt26oeGOC/vEgJsE1waU=
Subject: Re: [PATCH] sdio: fix suspend/resume regression
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-mmc@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>,
        Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
        libertas-dev@lists.infradead.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Mack <daniel@caiaq.de>, Colin Cross <ccross@android.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@kernel.org
In-Reply-To: <1286955116-22793-1-git-send-email-ohad@wizery.com>
References: <1286788315.3101.11.camel@sven>
	 <1286955116-22793-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 01:47:35 +0200
Message-ID: <1287704855.12734.14.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 09:31 +0200, Ohad Ben-Cohen wrote:
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
This reintroduces the bug I fixed.

if the CONFIG_MMC_UNSAFE_RESUME isn't set (and that is default
unfortunately), the host->bus_ops->resume will be NULL (see core/mmc.c
mmc_ops), and therefore card will be removed, that will trigger a block
device removal, sync, and deadlock).

I actually thought about the sdio case. Sorry for breaking yet.

My idea was to move the effective suspend/resume to a pm notifier,
and the mmc_pm_notify is supposed to do the job.

Could you test why it fails?

The relevant code in mmc_pm_notify:

		if (!host->bus_ops || host->bus_ops->suspend)
			break;

		mmc_claim_host(host);

		if (host->bus_ops->remove)
			host->bus_ops->remove(host);

		mmc_detach_bus(host);
		mmc_release_host(host);
		host->pm_flags = 0;
		break;


So NULL host->bus_ops->suspend should trigger a card remove by that
function and it did here on my system without CONFIG_MMC_UNSAFE_RESUME.

I suspect that in your case, the .suspend isn't NULL, but .resume is.
Then, we just need an one liner change to mmc_pm_notify to account that
case.

Note that I don't call the  host->bus_ops->suspend(host); in
mmc_pm_notify on purpose as it is too early.

So what happens if you set .suspend to NULL? instead of -ENOSYS return?



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

Best regards,
	Maxim Levitsky

