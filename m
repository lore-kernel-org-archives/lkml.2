Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab0KIKxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:53:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:55068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab0KIKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:53:06 -0500
Message-ID: <4CD9280C.40204@infradead.org>
Date: Tue, 09 Nov 2010 08:53:00 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Maciej Szmigiero <mhej@o2.pl>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [V4L][SAA7134] fix tda9887 detection on cold and eeprom read
 corruption on warm Medion 7134
References: <4CC5C568.4090809@o2.pl>
In-Reply-To: <4CC5C568.4090809@o2.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-10-2010 15:59, Maciej Szmigiero escreveu:
> [V4L][SAA7134] fix tda9887 detection on cold and eeprom read corruption on warm Medion 7134
> 
> When Medion 7134 analog+DVB-T card is cold (after powerup) the tda9887 analog demodulator
> won't show on i2c bus.
> This results in no signal on analog TV. After loading driver for second time
> eeprom (required for tuner autodetection) read is corrupted, but tda9987 is detected
> properly and analog TV works when tuner model is forced.
> 
> Fix tda9887 problem by moving its detect code after tuner setup which unhides it.
> The eeprom read issue is fixed by opening i2c gate in DVB-T demodulator.
> 
> Tested on Medion 7134 and also tested for reference on Typhoon Cardbus Hybrid
> (which also uses saa7134 driver).
> 
> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
> 
> --- a/drivers/media/video/saa7134/saa7134-cards.c	2010-08-02 00:11:14.000000000 +0200
> +++ b/drivers/media/video/saa7134/saa7134-cards.c	2010-10-25 19:19:08.000000000 +0200
> @@ -7249,12 +7249,37 @@
>  		break;
>  	case SAA7134_BOARD_MD7134:
>  	{
> -		u8 subaddr;
> +		u8 subaddr, dmdregval;
>  		u8 data[3];
>  		int ret, tuner_t;
> +		struct i2c_msg i2cgatemsg_r[] = { {.addr = 0x08, .flags = 0,
> +						.buf = &subaddr, .len = 1},
> +						{.addr = 0x08,
> +							.flags = I2C_M_RD,
> +						.buf = &dmdregval, .len = 1} };
> +		struct i2c_msg i2cgatemsg_w[] = { {.addr = 0x08, .flags = 0,
> +						.buf = data, .len = 2} };
>  		struct i2c_msg msg[] = {{.addr=0x50, .flags=0, .buf=&subaddr, .len = 1},
>  					{.addr=0x50, .flags=I2C_M_RD, .buf=data, .len = 3}};
>  
> +		/* open i2c gate in DVB-T demod */
> +		/* so eeprom read won't be corrupted */
> +		subaddr = 0x7;
> +		ret = i2c_transfer(&dev->i2c_adap, i2cgatemsg_r, 2);
> +		if ((ret == 2) && (dmdregval & 0x2)) {
> +			printk(KERN_NOTICE "%s DVB-T demod i2c gate was left"
> +						    " closed\n", dev->name);
> +			printk(KERN_NOTICE "%s previous informational"
> +					    " EEPROM read might have been"
> +					    " corrupted\n", dev->name);

hmm... I don't think we need those debug messages on normal cases. Also, we want the log
shown as:
	saa7134: <foo>
and not as:
	saa7134 <foo>

> +
> +			data[0] = 0x7;
> +			data[1] = (dmdregval & ~0x2);
> +			if (i2c_transfer(&dev->i2c_adap, i2cgatemsg_w, 1) != 1)
> +				printk(KERN_ERR "early i2c gate"
> +						" open failure\n");

Gah. A message like that should really specify the dev->name, and the board.

> +		}
> +
>  		subaddr= 0x14;
>  		tuner_t = 0;
>  
> @@ -7522,10 +7547,6 @@
>  			v4l2_i2c_new_subdev(&dev->v4l2_dev,
>  				&dev->i2c_adap, "tuner", "tuner",
>  				dev->radio_addr, NULL);
> -		if (has_demod)
> -			v4l2_i2c_new_subdev(&dev->v4l2_dev,
> -				&dev->i2c_adap, "tuner", "tuner",
> -				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
>  		if (dev->tuner_addr == ADDR_UNSET) {
>  			enum v4l2_i2c_tuner_type type =
>  				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
> @@ -7542,6 +7563,15 @@
>  
>  	saa7134_tuner_setup(dev);
>  
> +	/* some cards (Medion 7134 for example) needs tuner to be setup */
> +	/* before tda9887 shows itself on i2c bus */
> +	if ((TUNER_ABSENT != dev->tuner_type)
> +			&& (dev->tda9887_conf & TDA9887_PRESENT)) {
> +		v4l2_i2c_new_subdev(&dev->v4l2_dev,
> +			&dev->i2c_adap, "tuner", "tuner",
> +			0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
> +	}
> +
>  	switch (dev->board) {
>  	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
>  	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:

The order change for the demod probe will likely break support for other boards.
If the problem is specific to Medion 7134, what you should do, instead, is to
change the order just for MD7134 (so, inside the switch(dev->board)).

Cheers,
Mauro.
