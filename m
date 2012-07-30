Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2G3FU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 01:20:59 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:59659 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079Ab2G3FUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 01:20:42 -0400
Message-ID: <501619A4.50906@ti.com>
Date: Mon, 30 Jul 2012 10:50:36 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC/omap_hsmmc: handle failure of regulator_get better.
References: <20120730101245.7dbe72b0@notabene.brown>
In-Reply-To: <20120730101245.7dbe72b0@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2012 05:42 AM, NeilBrown wrote:
>
> 1/ if regulator_get fails, return an error.  This is important
>     if it failed with EPROBE_DEFER, as the probe needs to be
>     deferred.
>
> 2/ Don't set .set_power until the regulator has been found, or
>     the deferred probe will not bother calling omap_hsmmc_reg_get().

I am not very sure, but aren't the data structures re-allocated on a
re-probe (after it was deferred) causing .set_power to be lost anyway?

>
> Signed-off-by: NeilBrown<neilb@suse.de>
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 389a3ee..f052c29 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -299,12 +299,12 @@ static int omap_hsmmc_reg_get(struct omap_hsmmc_host *host)
>   	struct regulator *reg;
>   	int ocr_value = 0;
>
> -	mmc_slot(host).set_power = omap_hsmmc_set_power;
> -
>   	reg = regulator_get(host->dev, "vmmc");
>   	if (IS_ERR(reg)) {
>   		dev_dbg(host->dev, "vmmc regulator missing\n");
> +		return PTR_ERR(reg);
>   	} else {
> +		mmc_slot(host).set_power = omap_hsmmc_set_power;
>   		host->vcc = reg;
>   		ocr_value = mmc_regulator_get_ocrmask(reg);
>   		if (!mmc_slot(host).ocr_mask) {

