Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab2AMVlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:41:20 -0500
Received: from smtp.nokia.com ([147.243.1.48]:37616 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab2AMVlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:41:17 -0500
Date: Fri, 13 Jan 2012 23:38:26 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@kernel.research.nokia.com
To: Dmitry Antipov <dmitry.antipov@linaro.org>
cc: Chris Ball <cjb@laptop.org>, patches@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: change mmc_delay() to use usleep_range()
In-Reply-To: <1326467370-21026-1-git-send-email-dmitry.antipov@linaro.org>
Message-ID: <alpine.DEB.2.00.1201132308530.24003@kernel.research.nokia.com>
References: <1326467370-21026-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 13 Jan 2012, Dmitry Antipov wrote:
> Use the usleep_range() to simplify mmc_delay() and give some more
> accuracy to it - but with an exception of mmc_card_sleepawake():
> since sleep/awake timeout varies in a wide range, different
> delay methods should be used.
>
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>

[...]

> +	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY)) {
> +		/* JEDEC MMCA 4.41 specifies the timeout value is in 200ns..838.86ms
> +		   range. Round it up to 1us and use an appropriate delay method. */
> +		unsigned long us = DIV_ROUND_UP(card->ext_csd.sa_timeout, 10);
> +		if (us < 10)
> +			udelay(us);
> +		else
> +			usleep_range(us, us + 100);
> +	}

I think this part of the patch is over-engineered. What difference
does it make in practice if you round it up to a bigger value so that
usleep_range() makes always sense? The S/A timeout defines the max time
the transition can take, it's not wrong to wait a bit longer. Also note
that udelay() is not accurate so you need to add some margin anyway.

A.
