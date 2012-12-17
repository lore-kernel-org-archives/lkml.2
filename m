Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2LQG4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:56:36 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45798 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2LQG4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:56:35 -0500
Date: Sun, 16 Dec 2012 22:53:06 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] charger-manager: Fix bug when check dropped
 voltage after fullbatt event
Message-ID: <20121217064902.GA9027@lizard.gateway.2wire.net>
References: <1353570831-19439-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353570831-19439-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 04:53:51PM +0900, Chanwoo Choi wrote:
> This patch check difference value between current voltage of battery
> and desc->fullbatt_uV whether positve or negative number. If difference
> value is negative number when current voltage of battery is larger than
> desc->fullbatt_uV, charger-manager return immediately because battery
> is fully charged.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/power/charger-manager.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index ee039b9..17130c7 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -468,7 +468,9 @@ static void fullbatt_vchk(struct work_struct *work)
>  	struct charger_manager *cm = container_of(dwork,
>  			struct charger_manager, fullbatt_vchk_work);
>  	struct charger_desc *desc = cm->desc;
> -	int batt_uV, err, diff;
> +	int batt_uV;
> +	int err;
> +	int diff;

I applied the patch, but dropped this part. This is an unrelated style
fix, and, if anything, it desires a separate patch (possibly 'fixing' the
whole file/driver).

Thanks!

>  	/* remove the appointment for fullbatt_vchk */
>  	cm->fullbatt_vchk_jiffies_at = 0;
> @@ -482,8 +484,9 @@ static void fullbatt_vchk(struct work_struct *work)
>  		return;
>  	}
>  
> -	diff = desc->fullbatt_uV;
> -	diff -= batt_uV;
> +	diff = desc->fullbatt_uV - batt_uV;
> +	if (diff < 0)
> +		return;
>  
>  	dev_info(cm->dev, "VBATT dropped %duV after full-batt.\n", diff);
>  
> -- 
> 1.7.0.4
