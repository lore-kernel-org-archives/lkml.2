Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2DADh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 23:37:29 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:34354 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2DADh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 23:37:27 -0400
Message-ID: <1333251443.5466.3.camel@lorien2>
Subject: Re: [PATCH 1/1] leds: Add LED driver for lm3556 chip
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, Geon Si Jeong <gshark.jeong@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 31 Mar 2012 21:37:23 -0600
In-Reply-To: <20120330114122.be769e8a.akpm@linux-foundation.org>
References: <1333089508-8501-1-git-send-email-gshark.jeong@gmail.com>
	 <1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
	 <20120330114122.be769e8a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 11:41 -0700, Andrew Morton wrote:
> On Fri, 30 Mar 2012 15:38:28 +0900
> Geon Si Jeong <gshark.jeong@gmail.com> wrote:
> 
> > It is a simple driver for LM3556 Chip(Texas Instruments)
> > LM3556 :
> > The LM3556 is a 4 MHz fixed-frequency synchronous boost
> > converter plus 1.5A constant current driver for a high-current white LED.
> > Datasheet: www.national.com/ds/LM/LM3556.pdf
> 
> It needs this to build on x86_64:
> 
> --- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-fix-2
> +++ a/drivers/leds/leds-lm3556.c
> @@ -11,6 +11,7 @@
>  #include <linux/delay.h>
>  #include <linux/i2c.h>
>  #include <linux/leds.h>
> +#include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>
>  #include <linux/types.h>
> 
> 
> And here are some fixes for problems which were detected by checkpatch.
> Please use checkpatch.  Please review and test this change:
> 
> --- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
> +++ a/drivers/leds/leds-lm3556.c
> @@ -141,7 +141,7 @@ static struct indicator indicator_patter
>  };
>  
>  /* i2c access*/
> -int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)
> +int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 *val)
>  {
>  	int ret;
>  	struct lm3556_chip_data *chip = i2c_get_clientdata(client);
> @@ -317,12 +317,15 @@ static ssize_t lm3556_indicator_pattern_
>  					      const char *buf, size_t size)
>  {
>  	char *after;
> -	ssize_t ret = -EINVAL;
> +	ssize_t ret;
>  	struct i2c_client *client = container_of(dev->parent,
>  						 struct i2c_client, dev);
> -	unsigned long state = simple_strtoul(buf, &after, 10);
> +	unsigned long state;
>  	size_t count = after - buf;
>  
> +	ret = kstrtoul(buf, 10, &state);
> +	if (ret)
> +		goto out;
>  	if (isspace(*after))
>  		count++;

after is used without initialization. Please note that simple_strtoul()
initializes after. Don't think this will work.

-- Shuah
>  
> @@ -336,6 +339,7 @@ static ssize_t lm3556_indicator_pattern_
>  		lm3556_write_reg(client, REG_INDIC_PERIOD,
>  				 indicator_pattern[state].period_cnt);
>  	}
> +out:
>  	return ret;
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


