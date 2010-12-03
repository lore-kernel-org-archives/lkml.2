Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab0LCFGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 00:06:09 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57970 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LCFGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 00:06:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6185"; a="65093458"
Message-ID: <1c6eadd860e1a9085336bf75a2a96eb3.squirrel@www.codeaurora.org>
In-Reply-To: <20101202223812.GA2685@rere.qmqm.pl>
References: <4C80187D.9000304@yahoo.es>
    <1291288582.15187.91.camel@stummala-linux.in.qualcomm.com>
    <4CF80DC6.1020801@yahoo.es> <20101202223812.GA2685@rere.qmqm.pl>
Date: Thu, 2 Dec 2010 21:05:54 -0800 (PST)
Subject: Re: [PATCH v4] mmc: Make ID freq configurable
From: stummala@codeaurora.org
To: "Michal Miroslaw" <mirq-linux@rere.qmqm.pl>
Cc: "Hein_Tibosch" <hein_tibosch@yahoo.es>,
        "Sahitya Tummala" <stummala@codeaurora.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Pierre Ossman" <pierre@ossman.eu>, "Chris Ball" <cjb@laptop.org>,
        "Ben Nizette" <bn@niasdigital.com>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Adrian Hunter" <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Matt Fleming" <matt@console-pimps.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> On Fri, Dec 03, 2010 at 05:21:10AM +0800, Hein_Tibosch wrote:
>> Hi Sahitya,
>> On 2-12-2010 19:16, Sahitya Tummala wrote:
>> > Hi Hein Tibosch,
>> >
>> > On Fri, 2010-09-03 at 05:34 +0800, Hein_Tibosch wrote:
>> >> In the latest releases of the mmc driver, the freq during
>> initialization
>> >> is set to a fixed 400 Khz. This was reportedly too fast for several
>> >> users. As there doesn't seem to be an ideal frequency
>> which-works-for-all,
>> >> Pierre suggested to let the driver try several frequencies.
>> >> <cut>
>> >> +		/*
>> >> +		 * First we search for SDIO...
>> >> +		 */
>> >> +		err = mmc_send_io_op_cond(host, 0, &ocr);
>> >> +		if (!err) {
>> >> +			if (mmc_attach_sdio(host, ocr)) {
>> >> +				mmc_claim_host(host);
>> >> +				/* try SDMEM (but not MMC) even if SDIO is broken */
>> >> +				if (mmc_send_app_op_cond(host, 0, &ocr))
>> > In case of SDIO error, mmc_power_off() is getting called as part of
>> > mmc_detach_bus().  Shouldn't we power up the host before checking for
>> > SDMEM? Any comments?
>> I think you should ask Michal Miroslaw, as he wrote the patch for the
>> SD-combo (IO + mem)*
>>
>> But yes, in case of a failure, mmc_attach_sdio() will call
>> mmc_detach_bus()
>> which in turn will call mmc_power_off()
>>
>> And so it should be mmc_power_up() again before trying to detect SD
>> memory.
>
> Yes, you are right!  This explains some things...
>
> Please try attached patch. (Not tested, but obvious enough.)

I was looking at the code and figured out this issue. I don't have any
SD-combo card to verify your patch.

Thanks
Sahitya.
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.

> Best Regards,
> Micha³ Miros³aw
>
> ---
>
> mmc: fix detection of memory part of SD-combo card with broken SDIO
>
> In case of failure, mmc_attach_sdio() will power off the SD bus.
> Power it up and reinitialize before trying SD memory detection.
>
> Reported-by: Sahitya Tummala <stummala@codeaurora.org>
> Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/mmc/core/core.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 6286898..32a4798 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1564,6 +1564,11 @@ void mmc_rescan(struct work_struct *work)
>  				 * Try SDMEM (but not MMC) even if SDIO
>  				 * is broken.
>  				 */
> +				mmc_power_up(host);
> +				sdio_reset(host);
> +				mmc_go_idle(host);
> +				mmc_send_if_cond(host, host->ocr_avail);
> +
>  				if (mmc_send_app_op_cond(host, 0, &ocr))
>  					goto out_fail;
>
> --
> 1.7.2.3
>
>


