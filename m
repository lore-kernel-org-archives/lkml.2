Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0CXINw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:13:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab0CXINu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:13:50 -0400
Message-ID: <4BA9C9D6.4020903@redhat.com>
Date: Wed, 24 Mar 2010 09:14:14 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: properly acquire I/O regions while probing
References: <1269353535-23134-1-git-send-email-me@mortis.eu>
In-Reply-To: <1269353535-23134-1-git-send-email-me@mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't have any objections against the proposed changes, but there
are 3 unrelated changes in this patch, please break them up in separate
patches:

1) code cleanup: properly using, previously defined, functions rather
    than duplicating their code.
2) properly acquire I/O regions while probing
3) Make the addresses to probe an array

And IMHO you might just as well drop number 3, it does not really make
the code any better readable, and the old way is how all superio hwmon
drivers do things.

Regards,

Hans


On 03/23/2010 03:12 PM, Giel van Schijndel wrote:
> Acquire the I/O region for the Super I/O chip while we're working on it.
>
> Further alter the way multiple Super I/O addresses are probed for chips
> such that errors in the probing process are passed on from the module
> initialisation function.
>
> Some code cleanup: properly using, previously defined, functions rather
> than duplicating their code.
> ---
>   drivers/hwmon/f71882fg.c |   38 +++++++++++++++++++++++---------------
>   1 files changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
> index 4230729..25e1cad 100644
> --- a/drivers/hwmon/f71882fg.c
> +++ b/drivers/hwmon/f71882fg.c
> @@ -856,10 +856,8 @@ static inline int superio_inb(int base, int reg)
>   static int superio_inw(int base, int reg)
>   {
>   	int val;
> -	outb(reg++, base);
> -	val = inb(base + 1)<<  8;
> -	outb(reg, base);
> -	val |= inb(base + 1);
> +	val  = superio_inb(base, reg)<<  8;
> +	val |= superio_inb(base, reg + 1);
>   	return val;
>   }
>
> @@ -905,10 +903,8 @@ static u16 f71882fg_read16(struct f71882fg_data *data, u8 reg)
>   {
>   	u16 val;
>
> -	outb(reg++, data->addr + ADDR_REG_OFFSET);
> -	val = inb(data->addr + DATA_REG_OFFSET)<<  8;
> -	outb(reg, data->addr + ADDR_REG_OFFSET);
> -	val |= inb(data->addr + DATA_REG_OFFSET);
> +	val  = f71882fg_read8(data, reg)<<  8;
> +	val |= f71882fg_read8(data, reg + 1);
>
>   	return val;
>   }
> @@ -921,10 +917,8 @@ static void f71882fg_write8(struct f71882fg_data *data, u8 reg, u8 val)
>
>   static void f71882fg_write16(struct f71882fg_data *data, u8 reg, u16 val)
>   {
> -	outb(reg++, data->addr + ADDR_REG_OFFSET);
> -	outb(val>>  8, data->addr + DATA_REG_OFFSET);
> -	outb(reg, data->addr + ADDR_REG_OFFSET);
> -	outb(val&  255, data->addr + DATA_REG_OFFSET);
> +	f71882fg_write8(data, reg,     val>>  8);
> +	f71882fg_write8(data, reg + 1, val&  0xff);
>   }
>
>   static u16 f71882fg_read_temp(struct f71882fg_data *data, int nr)
> @@ -2184,6 +2178,13 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
>   	int err = -ENODEV;
>   	u16 devid;
>
> +	/* Don't step on other driver's I/O space by accident */
> +	if (!request_region(sioaddr, 2, DRVNAME)) {
> +		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
> +				(int)sioaddr);
> +		return -EIO;
> +	}
> +
>   	superio_enter(sioaddr);
>
>   	devid = superio_inw(sioaddr, SIO_REG_MANID);
> @@ -2238,6 +2239,7 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
>   		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
>   exit:
>   	superio_exit(sioaddr);
> +	release_region(sioaddr, 2);
>   	return err;
>   }
>
> @@ -2289,14 +2291,20 @@ exit_device_put:
>
>   static int __init f71882fg_init(void)
>   {
> +	static const unsigned short addrs[] = { 0x2e, 0x4e };
>   	int err = -ENODEV;
> -	unsigned short address;
> +	unsigned short address = /* shut up compiler */ 0;
>   	struct f71882fg_sio_data sio_data;
> +	int i;
>
>   	memset(&sio_data, 0, sizeof(sio_data));
>
> -	if (f71882fg_find(0x2e,&address,&sio_data)&&
> -	    f71882fg_find(0x4e,&address,&sio_data))
> +	for (i = 0; i<  ARRAY_SIZE(addrs); i++) {
> +		err = f71882fg_find(addrs[i],&address,&sio_data);
> +		if (err == 0)
> +			break;
> +	}
> +	if (i == ARRAY_SIZE(addrs))
>   		goto exit;
>
>   	err = platform_driver_register(&f71882fg_driver);
