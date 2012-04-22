Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2DVUfP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 16:35:15 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60586 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2DVUfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 16:35:14 -0400
From: Marek Vasut <marex@denx.de>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] ISP1704 USB Charger: Fix use-after-free error in isp1704_charger_probe()
Date: Sun, 22 Apr 2012 22:34:59 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
References: <alpine.LNX.2.00.1204222210290.27455@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204222210290.27455@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204222234.59624.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jesper Juhl,

> In isp1704_charger_probe() at the 'fail0:' label we kfree(isp) and
> then subsequently call isp1704_charger_set_power(isp, 0). That's a
> problem since isp1704_charger_set_power() dereferences the pointer it
> is passed as its first argument, which is 'isp', which we already
> freed.
> 
> Fixed by simply swapping the order of the two calls so that we only
> kfree() *after* the call to isp1704_charger_set_power().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/power/isp1704_charger.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/power/isp1704_charger.c
> b/drivers/power/isp1704_charger.c index 39eb50f..8a610da 100644
> --- a/drivers/power/isp1704_charger.c
> +++ b/drivers/power/isp1704_charger.c
> @@ -476,11 +476,9 @@ fail2:
>  fail1:
>  	usb_put_transceiver(isp->phy);
>  fail0:
> -	kfree(isp);
> -
>  	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
> -
>  	isp1704_charger_set_power(isp, 0);
> +	kfree(isp);

Use devm_kzalloc() and be done with all this goo?

>  	return ret;
>  }

Best regards,
Marek Vasut
