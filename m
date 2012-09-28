Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2I1BKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:10:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65165 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2I1BKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:10:44 -0400
Date: Thu, 27 Sep 2012 18:08:00 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 45/57] power: ab8500: defer btemp filtering while init
Message-ID: <20120928010759.GD5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-46-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-46-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:42AM -0600, mathieu.poirier@linaro.org wrote:
> From: Rupesh Kumar <rupesh.kumar@stericsson.com>
> 
> Due to btemp filtering enabled during init, temp values
> reported to charge algorithm driver started from 0.
> As a result,charge algorithm was going into wrong
> state and charging was stopped.
> This patch defers btemp filtering till init is done.
> 
> Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
> Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
> Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
> ---
>  drivers/power/ab8500_btemp.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
> index b24835f..1f33122 100644
> --- a/drivers/power/ab8500_btemp.c
> +++ b/drivers/power/ab8500_btemp.c
> @@ -613,7 +613,6 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
>  		struct ab8500_btemp, btemp_periodic_work.work);
>  
>  	if (!di->initialized) {
> -		di->initialized = true;
>  		/* Identify the battery */
>  		if (ab8500_btemp_id(di) < 0)
>  			dev_warn(di->dev, "failed to identify the battery\n");
> @@ -626,8 +625,9 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
>  	 * same temperature. Else only allow 1 degree change from previous
>  	 * reported value in the direction of the new measurement.
>  	 */
> -	if (bat_temp == di->prev_bat_temp || !di->initialized) {
> -		if (di->bat_temp != di->prev_bat_temp || !di->initialized) {
> +	if ((bat_temp == di->prev_bat_temp) || !di->initialized) {
> +		if ((di->bat_temp != di->prev_bat_temp) || !di->initialized) {

This change is stray, and adds completely unneeded parenthesis.

> +			di->initialized = true;
>  			di->bat_temp = bat_temp;
>  			power_supply_changed(&di->btemp_psy);
>  		}
> -- 
> 1.7.5.4
