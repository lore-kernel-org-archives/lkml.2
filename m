Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0CXIZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:25:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0CXIZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:25:50 -0400
Message-ID: <4BA9CCAE.1040607@redhat.com>
Date: Wed, 24 Mar 2010 09:26:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] hwmon: f71882fg: prepare for addition of watchdog
 support
References: <20100323141718.GA23172@salidar.me.mortis.eu> <1269385936-3440-1-git-send-email-me@mortis.eu> <1269385936-3440-2-git-send-email-me@mortis.eu>
In-Reply-To: <1269385936-3440-2-git-send-email-me@mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack.

Acked-by: Hans de Goede <hdegoede@redhat.com>

On 03/24/2010 12:12 AM, Giel van Schijndel wrote:
> Rename the `address' variable that's used in some places to hwmon_addr
> to indicate it refers to the hardware monitor (HWMON in datasheet)
> "logical device" of the chip.
>
> Signed-off-by: Giel van Schijndel<me@mortis.eu>
> ---
>   drivers/hwmon/f71882fg.c |   24 ++++++++++++------------
>   1 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
> index b290b87..7b31e14 100644
> --- a/drivers/hwmon/f71882fg.c
> +++ b/drivers/hwmon/f71882fg.c
> @@ -2233,7 +2233,7 @@ static int f71882fg_remove(struct platform_device *pdev)
>   	return 0;
>   }
>
> -static int __init f71882fg_find(int sioaddr, unsigned short *address,
> +static int __init f71882fg_find(int sioaddr, unsigned short *hwmon_addr,
>   	struct f71882fg_sio_data *sio_data)
>   {
>   	int err = -ENODEV;
> @@ -2290,16 +2290,16 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
>   		goto exit;
>   	}
>
> -	*address = superio_inw(sioaddr, SIO_REG_ADDR);
> -	if (*address == 0) {
> +	*hwmon_addr = superio_inw(sioaddr, SIO_REG_ADDR);
> +	if (*hwmon_addr == 0) {
>   		printk(KERN_WARNING DRVNAME ": Base address not set\n");
>   		goto exit;
>   	}
> -	*address&= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
> +	*hwmon_addr&= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
>
>   	err = 0;
>   	printk(KERN_INFO DRVNAME ": Found %s chip at %#x, revision %d\n",
> -		f71882fg_names[sio_data->type],	(unsigned int)*address,
> +		f71882fg_names[sio_data->type],	(unsigned int)*hwmon_addr,
>   		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
>   exit:
>   	superio_exit(sioaddr);
> @@ -2307,17 +2307,17 @@ exit:
>   	return err;
>   }
>
> -static int __init f71882fg_device_add(unsigned short address,
> +static int __init f71882fg_device_add(unsigned short hwmon_addr,
>   	const struct f71882fg_sio_data *sio_data)
>   {
>   	struct resource res = {
> -		.start	= address,
> -		.end	= address + REGION_LENGTH - 1,
> +		.start	= hwmon_addr,
> +		.end	= hwmon_addr + REGION_LENGTH - 1,
>   		.flags	= IORESOURCE_IO,
>   	};
>   	int err;
>
> -	f71882fg_pdev = platform_device_alloc(DRVNAME, address);
> +	f71882fg_pdev = platform_device_alloc(DRVNAME, hwmon_addr);
>   	if (!f71882fg_pdev)
>   		return -ENOMEM;
>
> @@ -2357,14 +2357,14 @@ static int __init f71882fg_init(void)
>   {
>   	static const unsigned short addrs[] = { 0x2e, 0x4e };
>   	int err = -ENODEV;
> -	unsigned short address = /* shut up compiler */ 0;
> +	unsigned short hwmon_addr = /* shut up compiler */ 0;
>   	struct f71882fg_sio_data sio_data;
>   	int i;
>
>   	memset(&sio_data, 0, sizeof(sio_data));
>
>   	for (i = 0; i<  ARRAY_SIZE(addrs); i++) {
> -		err = f71882fg_find(addrs[i],&address,&sio_data);
> +		err = f71882fg_find(addrs[i],&hwmon_addr,&sio_data);
>   		if (err == 0)
>   			break;
>   	}
> @@ -2375,7 +2375,7 @@ static int __init f71882fg_init(void)
>   	if (err)
>   		goto exit;
>
> -	err = f71882fg_device_add(address,&sio_data);
> +	err = f71882fg_device_add(hwmon_addr,&sio_data);
>   	if (err)
>   		goto exit_driver;
>
