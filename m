Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2IEOLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:11:05 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:5389 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab2IEOLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:11:04 -0400
Message-ID: <50475D75.2040908@bfs.de>
Date: Wed, 05 Sep 2012 16:11:01 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] da9052-battery: don't free IRQ that wasn't requested
References: <20120905123440.GF6128@elgon.mountain>
In-Reply-To: <20120905123440.GF6128@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 05.09.2012 14:34, schrieb Dan Carpenter:
> We should decrement "i" before doing the free_irq().  If we call this
> because request_threaded_irq() failed then we don't want to free the
> thing which failed.  Or in the case where we get here because
> power_supply_register() failed then the original codes does a read past
> the end of the array.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
> index 20b86ed..d9d034d 100644
> --- a/drivers/power/da9052-battery.c
> +++ b/drivers/power/da9052-battery.c
> @@ -623,7 +623,7 @@ static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err:
> -	for (; i >= 0; i--) {
> +	while (--i >= 0) {
>  		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
>  		free_irq(bat->da9052->irq_base + irq, bat);
>  	}

hi da,
(my usual nitpicking ...)
since a lot of people do make mistakes on count-down-loops, is there any chance to
make this a common count-up-for()-loop ?
like:
   for (j=0; j <= i ;j++ ) {
	irq = platform_get_irq_byname(pdev, da9052_bat_irqs[j]);
	free_irq(bat->da9052->irq_base + irq, bat);
	}

re,
 wh
