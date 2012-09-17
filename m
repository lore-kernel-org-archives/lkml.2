Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2IQSvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:51:42 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:32841 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757189Ab2IQSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <1347517863-30017-1-git-send-email-gururaja.hebbar@ti.com>
References: <1347517863-30017-1-git-send-email-gururaja.hebbar@ti.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Tue, 18 Sep 2012 00:21:02 +0530
Message-ID: <CANfBPZ9hrKZgAbyUWfT7cLyRVDEEAVC7x=eBwFqBn49m-rmqkw@mail.gmail.com>
Subject: Re: [PATCH V2] mmc: omap_hsmmc: Pass on the suspend failure to the PM core
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, cjb@laptop.org, nsekhar@ti.com,
        sudhakar.raj@ti.com, Vaibhav Bedia <vaibhav.bedia@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 12:01 PM, Hebbar, Gururaja
<gururaja.hebbar@ti.com> wrote:
> From: Vaibhav Bedia <vaibhav.bedia@ti.com>
>
> In some cases mmc_suspend_host() is not able to claim the
> host and proceed with the suspend process. The core returns
> -EBUSY to the host controller driver. Unfortunately, the
> host controller driver does not pass on this information
> to the PM core and hence the system suspend process continues.
>
>         ret = mmc_suspend_host(host->mmc);
>         if (ret) {
>                 host->suspended = 0;
>                 if (host->pdata->resume) {
>                         ret = host->pdata->resume(dev, host->slot_id);
>
> The return status from mmc_suspend_host() is overwritten by return
> status from host->pdata->resume. So the original return status is lost.
>
> In these cases the MMC core gets to an unexpected state
> during resume and multiple issues related to MMC crop up.
> 1. Host controller driver starts accessing the device registers
> before the clocks are enabled which leads to a prefetch abort.
> 2. A file copy thread which was launched before suspend gets
> stuck due to the host not being reclaimed during resume.
>
> To avoid such problems pass on the -EBUSY status to the PM core
> from the host controller driver. With this change, MMC core
> suspend might still fail but it does not end up making the
> system unusable. Suspend gets aborted and the user can try
> suspending the system again.
>
> Signed-off-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
> Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
This version is good.

Acked-by: Venkatraman S <svenkatr@ti.com>

> ---
> Changes from V1:
>         - Instead of forcibly returning -EBUSY on err, retain old
>         status and pass on the same to the caller.
>         - add more detail to commit message (explanation with code
>         snippet)
>
> :100644 100644 9afdd20... d9af5f1... M  drivers/mmc/host/omap_hsmmc.c
>  drivers/mmc/host/omap_hsmmc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 9afdd20..d9af5f1 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -2050,8 +2050,7 @@ static int omap_hsmmc_suspend(struct device *dev)
>         if (ret) {
>                 host->suspended = 0;
>                 if (host->pdata->resume) {
> -                       ret = host->pdata->resume(dev, host->slot_id);
> -                       if (ret)
> +                       if (host->pdata->resume(dev, host->slot_id))
>                                 dev_dbg(dev, "Unmask interrupt failed\n");
>                 }
>                 goto err;
> --
> 1.7.0.4
>
