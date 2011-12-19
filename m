Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1LSTeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:34:06 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:40521 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751606Ab1LSTeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:34:05 -0500
Message-ID: <4EEF9FCA.4040401@xenotime.net>
Date: Mon, 19 Dec 2011 12:34:18 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/2] leds-tca6507: allow driver to compile when GPIOLIB
 is not available.
References: <20111219001806.23170.14518.stgit@notabene.brown> <20111219002022.23170.36881.stgit@notabene.brown>
In-Reply-To: <20111219002022.23170.36881.stgit@notabene.brown>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2011 04:20 PM, NeilBrown wrote:
> This driver can configure the outputs as GPIO line instead of LEDs.  But
> that only works if GPIOLIB is available.  So make that code conditional
> on the library's availability.
> 
> Also remove the 'teardown' callback as it is never called and should
> never be needed.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>,
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>,
> Signed-off-by: NeilBrown <neilb@suse.de>

Hi Neil,

with linux-next 20111219 and this patch applied, I now get:

drivers/leds/leds-tca6507.c: In function 'tca6507_remove':
drivers/leds/leds-tca6507.c:677:9: error: 'struct tca6507_chip' has no member named 'gpio'
drivers/leds/leds-tca6507.c:678:3: error: implicit declaration of function 'gpiochip_remove'
drivers/leds/leds-tca6507.c:678:33: error: 'struct tca6507_chip' has no member named 'gpio'

when GPIOLIB is not enabled.


> ---
> 
>  drivers/leds/leds-tca6507.c  |   75 +++++++++++++++++++++++++++++-------------
>  include/linux/leds-tca6507.h |    3 +-
>  2 files changed, 53 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
> index a7ea4cf..c9cc3f7 100644
> --- a/drivers/leds/leds-tca6507.c
> +++ b/drivers/leds/leds-tca6507.c
> @@ -149,9 +149,11 @@ struct tca6507_chip {
>  		int			bank;	/* Bank used, or -1 */
>  		int			blink;	/* 1 if we are hardware-blinking */
>  	} leds[NUM_LEDS];
> +#ifdef CONFIG_GPIOLIB
>  	struct gpio_chip		gpio;
>  	const char			*gpio_name[NUM_LEDS];
>  	int				gpio_map[NUM_LEDS];
> +#endif
>  };
>  
>  static const struct i2c_device_id tca6507_id[] = {
> @@ -520,6 +522,7 @@ static int tca6507_blink_set(struct led_classdev *led_cdev,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_GPIOLIB
>  static void tca6507_gpio_set_value(struct gpio_chip *gc,
>  				   unsigned offset, int val)
>  {
> @@ -542,6 +545,51 @@ static int tca6507_gpio_direction_output(struct gpio_chip *gc,
>  	tca6507_gpio_set_value(gc, offset, val);
>  	return 0;
>  }
> +static int tca6507_probe_gpios(struct i2c_client *client,
> +			       struct tca6507_chip *tca,
> +			       struct tca6507_platform_data *pdata)
> +{
> +	int err;
> +	int i = 0;
> +	int gpios = 0;
> +
> +	for (i = 0; i < NUM_LEDS; i++)
> +		if (pdata->leds.leds[i].name && pdata->leds.leds[i].flags) {
> +			/* Configure as a gpio */
> +			tca->gpio_name[gpios] = pdata->leds.leds[i].name;
> +			tca->gpio_map[gpios] = i;
> +			gpios++;
> +		}
> +
> +	if (!gpios)
> +		return 0;
> +
> +	tca->gpio.label = "gpio-tca6507";
> +	tca->gpio.names = tca->gpio_name;
> +	tca->gpio.ngpio = gpios;
> +	tca->gpio.base = pdata->gpio_base;
> +	tca->gpio.owner = THIS_MODULE;
> +	tca->gpio.direction_output = tca6507_gpio_direction_output;
> +	tca->gpio.set = tca6507_gpio_set_value;
> +	tca->gpio.dev = &client->dev;
> +	err = gpiochip_add(&tca->gpio);
> +	if (err) {
> +		tca->gpio.ngpio = 0;
> +		return err;
> +	}
> +	if (pdata->setup)
> +		pdata->setup(tca->gpio.base, tca->gpio.ngpio);
> +	return 0;
> +}
> +
> +#else /* CONFIG_GPIOLIB */
> +static int tca6507_probe_gpios(struct i2c_client *client,
> +			       struct tca6507_chip *tca,
> +			       struct tca6507_platform_data *pdata)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_GPIOLIB */
>  
>  static int __devinit tca6507_probe(struct i2c_client *client,
>  				   const struct i2c_device_id *id)
> @@ -551,7 +599,6 @@ static int __devinit tca6507_probe(struct i2c_client *client,
>  	struct tca6507_platform_data *pdata;
>  	int err;
>  	int i = 0;
> -	int gpios = 0;
>  
>  	adapter = to_i2c_adapter(client->dev.parent);
>  	pdata = client->dev.platform_data;
> @@ -590,30 +637,10 @@ static int __devinit tca6507_probe(struct i2c_client *client,
>  			if (err < 0)
>  				goto exit;
>  		}
> -		if (pdata->leds.leds[i].name && pdata->leds.leds[i].flags) {
> -			/* Configure as a gpio */
> -			tca->gpio_name[gpios] = pdata->leds.leds[i].name;
> -			tca->gpio_map[gpios] = i;
> -			gpios++;
> -		}
> -	}
> -	if (gpios) {
> -		tca->gpio.label = "gpio-tca6507";
> -		tca->gpio.names = tca->gpio_name;
> -		tca->gpio.ngpio = gpios;
> -		tca->gpio.base = pdata->gpio_base;
> -		tca->gpio.owner = THIS_MODULE;
> -		tca->gpio.direction_output = tca6507_gpio_direction_output;
> -		tca->gpio.set = tca6507_gpio_set_value;
> -		tca->gpio.dev = &client->dev;
> -		err = gpiochip_add(&tca->gpio);
> -		if (err) {
> -			tca->gpio.ngpio = 0;
> -			goto exit;
> -		}
> -		if (pdata->setup)
> -			pdata->setup(tca->gpio.base, tca->gpio.ngpio);
>  	}
> +	err = tca6507_probe_gpios(client, tca, pdata);
> +	if (err)
> +		goto exit;
>  	i2c_set_clientdata(client, tca);
>  	/* set all registers to known state - zero */
>  	tca->reg_set = 0x7f;
> diff --git a/include/linux/leds-tca6507.h b/include/linux/leds-tca6507.h
> index 3b8ac62..dcabf4f 100644
> --- a/include/linux/leds-tca6507.h
> +++ b/include/linux/leds-tca6507.h
> @@ -24,9 +24,10 @@
>  
>  struct tca6507_platform_data {
>  	struct led_platform_data leds;
> +#ifdef CONFIG_GPIOLIB
>  	int gpio_base;
>  	void (*setup)(unsigned gpio_base, unsigned ngpio);
> -	void (*teardown)(unsigned gpio_base, unsigned ngpio);
> +#endif
>  };
>  
>  #define	TCA6507_MAKE_GPIO 1
> 
> 
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
