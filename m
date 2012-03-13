Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2CMOeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:34:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39589 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2CMOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:34:35 -0400
Message-ID: <4F5F5ABF.5030103@openwrt.org>
Date: Tue, 13 Mar 2012 15:33:35 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        timur@freescale.com, rdunlap@xenotime.net, kernel@pengutronix.de
Subject: Re: [PATCH 1/1] net: phylib: add error checking if no phy found
References: <1331636302-18256-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1331636302-18256-1-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 03/13/12 11:58, Dong Aisheng a écrit :
> From: Dong Aisheng<dong.aisheng@linaro.org>
>
> Signed-off-by: Dong Aisheng<dong.aisheng@linaro.org>
> ---
>   drivers/net/phy/mdio_bus.c |   11 ++++++++++-
>   1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 88cc5db..d8e044d 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -101,6 +101,7 @@ static struct class mdio_bus_class = {
>   int mdiobus_register(struct mii_bus *bus)
>   {
>   	int i, err;
> +	u32 phynum = 0;
>
>   	if (NULL == bus || NULL == bus->name ||
>   			NULL == bus->read ||
> @@ -134,12 +135,20 @@ int mdiobus_register(struct mii_bus *bus)
>   			if (IS_ERR(phydev)) {
>   				err = PTR_ERR(phydev);
>   				goto error;
> +			} else if (phydev != NULL) {
> +				phynum++;
>   			}
>   		}
>   	}
>
> +	if (!phynum) {
> +		err = -ENODEV;
> +		printk(KERN_ERR "%s: no phys found\n", bus->name);
> +		goto error;
> +	}

I am not sure if this is a good idea to change it, especially if:
- the MII bus probing is also done later (quite some drivers do this)
- if we want to attach a fixed PHY because we could not probe one at 
registration time

> +
>   	bus->state = MDIOBUS_REGISTERED;
> -	pr_info("%s: probed\n", bus->name);
> +	pr_info("%s: %d phys probed\n", bus->name, phynum);
>   	return 0;
>
>   error:
