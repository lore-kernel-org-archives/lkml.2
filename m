Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2I1DDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:03:43 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54156 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab2I1DDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:03:42 -0400
Date: Thu, 27 Sep 2012 20:00:57 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 56/57] power: abx500_chargalg: Fix quick re-attach
 charger issue.
Message-ID: <20120928030057.GO5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-57-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-57-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:53AM -0600, mathieu.poirier@linaro.org wrote:
> From: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> 
> The patch for 426250 added a change to check for the quick

What is 426250? I guess it's some internal bug#... but since we don't have
access to that info, it's better to describe which upstream commit caused
this.

> re-attachment of the charger connection as an error in the
> AB8500 HW meant that a quick detach/attach wouldn't be
> detected.
> This patch isolates the original change so that newer AB's
> are not affected.
> 
> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
> Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> ---
>  drivers/power/abx500_chargalg.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
> index c8849af..7a81e4e 100644
> --- a/drivers/power/abx500_chargalg.c
> +++ b/drivers/power/abx500_chargalg.c
> @@ -1299,11 +1299,12 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
>  	abx500_chargalg_check_charger_voltage(di);
>  	charger_status = abx500_chargalg_check_charger_connection(di);
>  
> -	ret = abx500_chargalg_check_charger_enable(di);
> -	if (ret < 0)
> -		dev_err(di->dev, "Checking charger if enabled error: %d line: %d\n",
> -				ret, __LINE__);
> -
> +	if (is_ab8500(di->parent)) {
> +		ret = abx500_chargalg_check_charger_enable(di);
> +		if (ret < 0)
> +			dev_err(di->dev, "Checking charger is enabled error");
> +			dev_err(di->dev, ": Returned Value %d\n", ret);

Ouch. Missing braces. No need for two dev_err().

> +	}
>  	/*
>  	 * First check if we have a charger connected.
>  	 * Also we don't allow charging of unknown batteries if configured
> -- 
> 1.7.5.4
