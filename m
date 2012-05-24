Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2EXJP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:15:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59063 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2EXJPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:15:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6720"; a="191891322"
Message-ID: <4FBDFC4A.1060602@codeaurora.org>
Date: Thu, 24 May 2012 02:15:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] remoteproc: block premature rproc booting
References: <1337687472-23009-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1337687472-23009-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2012 4:51 AM, Ohad Ben-Cohen wrote:
> When an rproc instance is registered, remoteproc asynchronously
> loads its firmware in order to tell which vdevs it supports.
>
> Later on those vdevs are registered, and when probed, their drivers
> usually trigger powering on of the remote processor.
>
> OTOH, non-standard scenarios might involve early invocation of
> rproc_boot even before the asynchronous fw loading has completed.
>
> We're not sure we really want to support those scenarios, but right
> now we do (e.g. via rproc_get_by_name), so let's simply fix this race
> by blocking those premature rproc_boot() flows until the async fw
> loading is completed.
>
> Reported-and-tested-by: Sjur Brandeland <sjur.brandeland@stericsson.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/remoteproc/remoteproc_core.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index 40e2b2d..464ea4f 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -1141,6 +1141,18 @@ int rproc_boot(struct rproc *rproc)
>  
>  	dev = rproc->dev;
>  
> +	/*
> +	 * if asynchronoush fw loading is underway, wait up to 65 secs
> +	 * (just a bit more than the firmware request's timeout)
> +	 */
> +	ret = wait_for_completion_interruptible_timeout(
> +					&rproc->firmware_loading_complete,
> +					msecs_to_jiffies(65000));

The request_firmware timeout is defaulted to 60 seconds but not
necessarily 60 if the user has changed the timeout in sysfs.

Why does this need to be a timeout at all? Presumably
request_firmware_nowait() in rproc_register() will timeout and complete
the firmware_loading_complete completion variable. Would it suffice to
have some new rproc->state like RPROC_UNKNOWN that we set in
rproc_register() before adding it to the list of rprocs? If we find the
firmware then we set it to RPROC_READY or RPROC_REGISTERED? Then we
wait_for_completion() and check the state, failing if it's still in the
unknown state.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

