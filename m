Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2EHGvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 02:51:39 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:35103 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142Ab2EHGvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 02:51:38 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds-pca955x: Fix race condition while setting brightness on several LEDs
Date: Tue, 08 May 2012 08:51:35 +0200
Message-ID: <2641969.OTteIvR3hZ@ws-stein>
User-Agent: KMail/4.8.0 (Linux/3.2.12-gentoo; KDE/4.8.1; x86_64; ; )
In-Reply-To: <4164556.rD0tn1gQO8@ws-stein>
References: <1328705048-21073-1-git-send-email-alexander.stein@systec-electronic.com> <4164556.rD0tn1gQO8@ws-stein>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any news/feedback on this?

Regards,
Alexander

On Tuesday 20 March 2012 14:03:11, Alexander Stein wrote:
> Any news/feedback on this?
> 
> Regards,
> Alexander
> 
> Am Mittwoch, 8. Februar 2012, 13:44:08 schrieb Alexander Stein:
> > When issuing the following command:
> > for I in 0 1 2 3 4 5 6 7; do
> > 
> >   echo 0 > /sys/class/leds/pca955x\:${I}/brightness;
> > 
> > done
> > It is possible that all the pca955x_read_ls calls are done sequentially
> > before any pca955x_write_ls call is done. This updates the LS only to the
> > last LED update in its set.
> > Fix this by using a global lock for the pca995x device during
> > pca955x_led_work. Also used a struct for shared data bewteen all LEDs.
> > 
> > Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> > ---
> > 
> >  drivers/leds/leds-pca955x.c |  105
> > 
> > ++++++++++++++++++++++++++----------------- 1 files changed, 64
> > insertions(+), 41 deletions(-)
> > 
> > diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
> > index dcc3bc3..2980d8e 100644
> > --- a/drivers/leds/leds-pca955x.c
> > +++ b/drivers/leds/leds-pca955x.c
> > @@ -101,11 +101,16 @@ static const struct i2c_device_id pca955x_id[] = {
> > 
> >  };
> >  MODULE_DEVICE_TABLE(i2c, pca955x_id);
> > 
> > -struct pca955x_led {
> > +struct pca955x {
> > +	struct mutex lock;
> > +	struct pca955x_led *leds;
> > 
> >  	struct pca955x_chipdef	*chipdef;
> >  	struct i2c_client	*client;
> > 
> > +};
> > +
> > +struct pca955x_led {
> > +	struct pca955x	*pca955x;
> > 
> >  	struct work_struct	work;
> > 
> > -	spinlock_t		lock;
> > 
> >  	enum led_brightness	brightness;
> >  	struct led_classdev	led_cdev;
> >  	int			led_num;	/* 0 .. 15 potentially */
> > 
> > @@ -128,7 +133,7 @@ static inline int pca95xx_num_led_regs(int bits)
> > 
> >   * Return an LED selector register value based on an existing one, with
> >   * the appropriate 2-bit state value set for the given LED number (0-3).
> >   */
> > 
> > -static inline u8 pca955x_ledsel(u8 oldval, int led_num, int state)
> > +static inline u8 pca955x_ledel(u8 oldval, int led_num, int state)
> > 
> >  {
> >  
> >  	return (oldval & (~(0x3 << (led_num << 1)))) |
> >  	
> >  		((state & 0x3) << (led_num << 1));
> > 
> > @@ -140,7 +145,7 @@ static inline u8 pca955x_ledsel(u8 oldval, int
> > led_num,
> > int state) */
> > 
> >  static void pca955x_write_psc(struct i2c_client *client, int n, u8 val)
> >  {
> > 
> > -	struct pca955x_led *pca955x = i2c_get_clientdata(client);
> > +	struct pca955x *pca955x = i2c_get_clientdata(client);
> > 
> >  	i2c_smbus_write_byte_data(client,
> >  	
> >  		pca95xx_num_input_regs(pca955x->chipdef->bits) + 2*n,
> > 
> > @@ -156,7 +161,7 @@ static void pca955x_write_psc(struct i2c_client
> > *client, int n, u8 val) */
> > 
> >  static void pca955x_write_pwm(struct i2c_client *client, int n, u8 val)
> >  {
> > 
> > -	struct pca955x_led *pca955x = i2c_get_clientdata(client);
> > +	struct pca955x *pca955x = i2c_get_clientdata(client);
> > 
> >  	i2c_smbus_write_byte_data(client,
> >  	
> >  		pca95xx_num_input_regs(pca955x->chipdef->bits) + 1 + 2*n,
> > 
> > @@ -169,7 +174,7 @@ static void pca955x_write_pwm(struct i2c_client
> > *client, int n, u8 val) */
> > 
> >  static void pca955x_write_ls(struct i2c_client *client, int n, u8 val)
> >  {
> > 
> > -	struct pca955x_led *pca955x = i2c_get_clientdata(client);
> > +	struct pca955x *pca955x = i2c_get_clientdata(client);
> > 
> >  	i2c_smbus_write_byte_data(client,
> >  	
> >  		pca95xx_num_input_regs(pca955x->chipdef->bits) + 4 + n,
> > 
> > @@ -182,7 +187,7 @@ static void pca955x_write_ls(struct i2c_client
> > *client,
> > int n, u8 val) */
> > 
> >  static u8 pca955x_read_ls(struct i2c_client *client, int n)
> >  {
> > 
> > -	struct pca955x_led *pca955x = i2c_get_clientdata(client);
> > +	struct pca955x *pca955x = i2c_get_clientdata(client);
> > 
> >  	return (u8) i2c_smbus_read_byte_data(client,
> >  	
> >  		pca95xx_num_input_regs(pca955x->chipdef->bits) + 4 + n);
> > 
> > @@ -190,26 +195,31 @@ static u8 pca955x_read_ls(struct i2c_client *client,
> > int n)
> > 
> >  static void pca955x_led_work(struct work_struct *work)
> >  {
> > 
> > -	struct pca955x_led *pca955x;
> > +	struct pca955x_led *pca955x_led;
> > +	struct pca955x *pca955x;
> > 
> >  	u8 ls;
> >  	int chip_ls;	/* which LSx to use (0-3 potentially) */
> >  	int ls_led;	/* which set of bits within LSx to use (0-3) */
> > 
> > -	pca955x = container_of(work, struct pca955x_led, work);
> > -	chip_ls = pca955x->led_num / 4;
> > -	ls_led = pca955x->led_num % 4;
> > +	pca955x_led = container_of(work, struct pca955x_led, work);
> > +	pca955x = pca955x_led->pca955x;
> > +
> > +	chip_ls = pca955x_led->led_num / 4;
> > +	ls_led = pca955x_led->led_num % 4;
> > +
> > +	mutex_lock(&pca955x->lock);
> > 
> >  	ls = pca955x_read_ls(pca955x->client, chip_ls);
> > 
> > -	switch (pca955x->brightness) {
> > +	switch (pca955x_led->brightness) {
> > 
> >  	case LED_FULL:
> > -		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_ON);
> > +		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_LED_ON);
> > 
> >  		break;
> >  	
> >  	case LED_OFF:
> > -		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_OFF);
> > +		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_LED_OFF);
> > 
> >  		break;
> >  	
> >  	case LED_HALF:
> > -		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK0);
> > +		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_BLINK0);
> > 
> >  		break;
> >  	
> >  	default:
> >  		/*
> > 
> > @@ -219,12 +229,15 @@ static void pca955x_led_work(struct work_struct
> > *work) * OFF, HALF, or FULL.  But, this is probably better than
> > 
> >  		 * just turning off for all other values.
> >  		 */
> > 
> > -		pca955x_write_pwm(pca955x->client, 1, 255-pca955x->brightness);
> > -		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK1);
> > +		pca955x_write_pwm(pca955x->client, 1,
> > +				255 - pca955x_led->brightness);
> > +		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_BLINK1);
> > 
> >  		break;
> >  	
> >  	}
> >  	
> >  	pca955x_write_ls(pca955x->client, chip_ls, ls);
> > 
> > +
> > +	mutex_unlock(&pca955x->lock);
> > 
> >  }
> >  
> >  static void pca955x_led_set(struct led_classdev *led_cdev, enum
> > 
> > led_brightness value) @@ -233,7 +246,6 @@ static void
> > pca955x_led_set(struct led_classdev *led_cdev, enum led_brightness v
> > 
> >  	pca955x = container_of(led_cdev, struct pca955x_led, led_cdev);
> > 
> > -	spin_lock(&pca955x->lock);
> > 
> >  	pca955x->brightness = value;
> >  	
> >  	/*
> > 
> > @@ -241,14 +253,13 @@ static void pca955x_led_set(struct led_classdev
> > *led_cdev, enum led_brightness v * can sleep.
> > 
> >  	 */
> >  	
> >  	schedule_work(&pca955x->work);
> > 
> > -
> > -	spin_unlock(&pca955x->lock);
> > 
> >  }
> >  
> >  static int __devinit pca955x_probe(struct i2c_client *client,
> >  
> >  					const struct i2c_device_id *id)
> >  
> >  {
> > 
> > -	struct pca955x_led *pca955x;
> > +	struct pca955x *pca955x;
> > +	struct pca955x_led *pca955x_led;
> > 
> >  	struct pca955x_chipdef *chip;
> >  	struct i2c_adapter *adapter;
> >  	struct led_platform_data *pdata;
> > 
> > @@ -282,39 +293,48 @@ static int __devinit pca955x_probe(struct i2c_client
> > *client, }
> > 
> >  	}
> > 
> > -	pca955x = kzalloc(sizeof(*pca955x) * chip->bits, GFP_KERNEL);
> > +	pca955x = kzalloc(sizeof(*pca955x), GFP_KERNEL);
> > 
> >  	if (!pca955x)
> >  	
> >  		return -ENOMEM;
> > 
> > +	pca955x->leds = kzalloc(sizeof(*pca955x_led) * chip->bits, 
GFP_KERNEL);
> > +	if (!pca955x->leds) {
> > +		err = -ENOMEM;
> > +		goto exit_nomem;
> > +	}
> > +
> > 
> >  	i2c_set_clientdata(client, pca955x);
> > 
> > +	mutex_init(&pca955x->lock);
> > +	pca955x->client = client;
> > +	pca955x->chipdef = chip;
> > +
> > 
> >  	for (i = 0; i < chip->bits; i++) {
> > 
> > -		pca955x[i].chipdef = chip;
> > -		pca955x[i].client = client;
> > -		pca955x[i].led_num = i;
> > +		pca955x_led = &pca955x->leds[i];
> > +		pca955x_led->led_num = i;
> > +		pca955x_led->pca955x = pca955x;
> > 
> >  		/* Platform data can specify LED names and default triggers */
> >  		if (pdata) {
> >  		
> >  			if (pdata->leds[i].name)
> > 
> > -				snprintf(pca955x[i].name,
> > -					 sizeof(pca955x[i].name), "pca955x:%s",
> > -					 pdata->leds[i].name);
> > +				snprintf(pca955x_led->name,
> > +					sizeof(pca955x_led->name), "pca955x:%s",
> > +					pdata->leds[i].name);
> > 
> >  			if (pdata->leds[i].default_trigger)
> > 
> > -				pca955x[i].led_cdev.default_trigger =
> > +				pca955x_led->led_cdev.default_trigger =
> > 
> >  					pdata->leds[i].default_trigger;
> >  		
> >  		} else {
> > 
> > -			snprintf(pca955x[i].name, sizeof(pca955x[i].name),
> > +			snprintf(pca955x_led->name, sizeof(pca955x_led->name),
> > 
> >  				 "pca955x:%d", i);
> >  		
> >  		}
> > 
> > -		spin_lock_init(&pca955x[i].lock);
> > -
> > -		pca955x[i].led_cdev.name = pca955x[i].name;
> > -		pca955x[i].led_cdev.brightness_set = pca955x_led_set;
> > +		pca955x_led->led_cdev.name = pca955x_led->name;
> > +		pca955x_led->led_cdev.brightness_set = pca955x_led_set;
> > 
> > -		INIT_WORK(&pca955x[i].work, pca955x_led_work);
> > +		INIT_WORK(&pca955x_led->work, pca955x_led_work);
> > 
> > -		err = led_classdev_register(&client->dev, &pca955x[i].led_cdev);
> > +		err = led_classdev_register(&client->dev,
> > +					&pca955x_led->led_cdev);
> > 
> >  		if (err < 0)
> >  		
> >  			goto exit;
> >  	
> >  	}
> > 
> > @@ -337,10 +357,12 @@ static int __devinit pca955x_probe(struct i2c_client
> > *client,
> > 
> >  exit:
> >  	while (i--) {
> > 
> > -		led_classdev_unregister(&pca955x[i].led_cdev);
> > -		cancel_work_sync(&pca955x[i].work);
> > +		led_classdev_unregister(&pca955x->leds[i].led_cdev);
> > +		cancel_work_sync(&pca955x->leds[i].work);
> > 
> >  	}
> > 
> > +	kfree(pca955x->leds);
> > 
> > +exit_nomem:
> >  	kfree(pca955x);
> >  	
> >  	return err;
> > 
> > @@ -348,14 +370,15 @@ exit:
> >  static int __devexit pca955x_remove(struct i2c_client *client)
> >  {
> > 
> > -	struct pca955x_led *pca955x = i2c_get_clientdata(client);
> > +	struct pca955x *pca955x = i2c_get_clientdata(client);
> > 
> >  	int i;
> >  	
> >  	for (i = 0; i < pca955x->chipdef->bits; i++) {
> > 
> > -		led_classdev_unregister(&pca955x[i].led_cdev);
> > -		cancel_work_sync(&pca955x[i].work);
> > +		led_classdev_unregister(&pca955x->leds[i].led_cdev);
> > +		cancel_work_sync(&pca955x->leds[i].work);
> > 
> >  	}
> > 
> > +	kfree(pca955x->leds);
> > 
> >  	kfree(pca955x);
> >  	
> >  	return 0;
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Tel: +49-3661-6279-0, Fax: +49-3661-6279-99
eMail:    Alexander.Stein@systec-electronic.com
Internet: http://www.systec-electronic.com

Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Jena, HRB 205563
