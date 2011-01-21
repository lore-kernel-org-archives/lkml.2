Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1AUWO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:14:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274Ab1AUWO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:14:56 -0500
Date: Fri, 21 Jan 2011 14:14:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] leds: Fix warnings when PM is disabled for BD2802
Message-Id: <20110121141402.30aac149.akpm@linux-foundation.org>
In-Reply-To: <1295631217-19591-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1295631217-19591-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 17:33:37 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> The suspend and resume functions will only be referenced when PM is
> enabled so they generate warnings due to being unreferenced and
> unexported.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This is the more usual idiom for fixing this than the patch you added.
> 
>  drivers/leds/leds-bd2802.c |   30 ++++++++++++++++--------------
>  1 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
> index 22152a2..ef0b868 100644
> --- a/drivers/leds/leds-bd2802.c
> +++ b/drivers/leds/leds-bd2802.c
> @@ -319,20 +319,6 @@ static void bd2802_turn_off(struct bd2802_led *led, enum led_ids id,
>  	bd2802_update_state(led, id, color, BD2802_OFF);
>  }
>  
> -static void bd2802_restore_state(struct bd2802_led *led)
> -{
> -	int i;
> -
> -	for (i = 0; i < LED_NUM; i++) {
> -		if (led->led[i].r)
> -			bd2802_turn_on(led, i, RED, led->led[i].r);
> -		if (led->led[i].g)
> -			bd2802_turn_on(led, i, GREEN, led->led[i].g);
> -		if (led->led[i].b)
> -			bd2802_turn_on(led, i, BLUE, led->led[i].b);
> -	}
> -}
> -
>  #define BD2802_SET_REGISTER(reg_addr, reg_name)				\
>  static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
>  	struct device_attribute *attr, const char *buf, size_t count)	\
> @@ -761,6 +747,7 @@ static int __exit bd2802_remove(struct i2c_client *client)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int bd2802_suspend(struct device *dev)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> @@ -771,6 +758,20 @@ static int bd2802_suspend(struct device *dev)
>  	return 0;
>  }
>  
> +static void bd2802_restore_state(struct bd2802_led *led)
> +{
> +	int i;
> +
> +	for (i = 0; i < LED_NUM; i++) {
> +		if (led->led[i].r)
> +			bd2802_turn_on(led, i, RED, led->led[i].r);
> +		if (led->led[i].g)
> +			bd2802_turn_on(led, i, GREEN, led->led[i].g);
> +		if (led->led[i].b)
> +			bd2802_turn_on(led, i, BLUE, led->led[i].b);
> +	}
> +}
> +
>  static int bd2802_resume(struct device *dev)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> @@ -783,6 +784,7 @@ static int bd2802_resume(struct device *dev)
>  
>  	return 0;
>  }
> +#endif
>  

That rather sucks.  It leaves an all-zeroes instance of dev_pm_ops
uselessly bloating the driver.  And it leaves
bd2802_i2c_driver.driver.pm pointing at that all-zeroes instance of
dev_pm_ops, which is rather dangerous.

If CONFIG_PM_SLEEP=n, the .driver.pm field shouldn't exist at all.

<looks at Rafael>
