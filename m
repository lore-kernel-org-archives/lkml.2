Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab0EUTVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:21:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758213Ab0EUTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:21:54 -0400
Date: Fri, 21 May 2010 12:21:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH] drivers/gpio/it8761e_gpio: check return value of
 gpiochip_remove()
Message-Id: <20100521122141.3d9d5fdf.akpm@linux-foundation.org>
In-Reply-To: <1274282913-21696-1-git-send-email-daniel@caiaq.de>
References: <1274282913-21696-1-git-send-email-daniel@caiaq.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 17:28:33 +0200
Daniel Mack <daniel@caiaq.de> wrote:

> This eliminates the following build warning:
> 
> drivers/gpio/it8761e_gpio.c: In function ___it8761e_gpio_exit___:
> drivers/gpio/it8761e_gpio.c:220: warning: ignoring return value of ___gpiochip_remove___, declared with attribute warn_unused_result
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Denis Turischev <denis@compulab.co.il>
> ---
>  drivers/gpio/it8761e_gpio.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/it8761e_gpio.c b/drivers/gpio/it8761e_gpio.c
> index 753219c..a524bd8 100644
> --- a/drivers/gpio/it8761e_gpio.c
> +++ b/drivers/gpio/it8761e_gpio.c
> @@ -217,7 +217,10 @@ gpiochip_add_err:
>  static void __exit it8761e_gpio_exit(void)
>  {
>  	if (gpio_ba) {
> -		gpiochip_remove(&it8761e_gpio_chip);
> +		int ret = gpiochip_remove(&it8761e_gpio_chip);
> +
> +		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
> +				__func__, ret);
>  
>  		release_region(gpio_ba, GPIO_IOSIZE);
>  		gpio_ba = 0;

So I just looked through ten-odd gpio drivers to see how they handle
gpiochip_remove() failures.  Big mess.

All of them do some form of printk, with no consistency.

Some of them bale out on error, leaking resources.  Others just proceed
to release the possibly-in-use resources.

I'd suggest that gpiochip_remove() itself emit the warning, so we can
remove zillions of inconsistent warnings from drivers.

I'd also suggest that someone get down and work out what a suitable
recovery strategy is.  Probably, just leaking the possibly-still-used
resources is the safest approach.  Once the strategy is decided, lots
of drivers need work.

