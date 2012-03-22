Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2CVG6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 02:58:25 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:59949 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2CVG6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 02:58:23 -0400
Message-ID: <4F6ACD82.2030505@permonline.ru>
Date: Thu, 22 Mar 2012 12:58:10 +0600
From: Mike Sinkovsky <msink@permonline.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, msink@permonline.ru
Subject: Re: [PATCH v2] ethernet driver for the WIZnet W5300 chip
References: <1332149037-12025-1-git-send-email-msink@permonline.ru> <4F69EA7E.4030606@openwrt.org>
In-Reply-To: <4F69EA7E.4030606@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21.03.2012 20:49, Florian Fainelli wrote:
>> +#if defined(CONFIG_WIZNET_BUS_DIRECT)
>> +#define detect_bus_mode(priv, mem_size) do {} while(0)
>> +#define read_reg_u16    read_u16_direct
>> +#define write_reg_u16    write_u16_direct
>> +
>> +#elif defined(CONFIG_WIZNET_BUS_INDIRECT)
>> +#define detect_bus_mode(priv, mem_size) do {} while(0)
>> +#define read_reg_u16    read_u16_indirect
>> +#define write_reg_u16    write_u16_indirect
> Looks like you don't have to make such decisions at compile-time. 
> Since it is a platform driver, better supply this through 
> platform_data instead.
Interface bus mode can be selected in .config (make menuconfig etc.)
If don't selected explicitly in .config, platform_device.resource[] is 
used in runtime to setup callbacks.
This hack was done for performance reasons, but may be not necessary, 
I'm not sure.


> Please implement phylib to properly report the link state to the 
> networking stack and ethtool.
This chip don't allow any access to phy interface, it completely hidden 
for host processor.
The only way I found - to wire pin LINK from W5300 to some GPIO, then 
ise RIGING/FALLING interrupt for tthat GPIO:
> +static irqreturn_t w5300_detect_link(int irq, void *ndev_instance)
> +{
> +        struct net_device *ndev = ndev_instance;
> +        struct w5300_private *priv = netdev_priv(ndev);
> +
> +        if (netif_running(ndev)) {
> +                if (gpio_get_value(priv->link) == 0)
> +                        netif_carrier_off(ndev);
> +                else
> +                        netif_carrier_on(ndev);
> +        }
> +
> +        return IRQ_HANDLED;
> +}
Isn't it enough for networking stack?


> Allow platform_data to pass a valid MAC address to this driver instead 
> of defaulting to random unconditionnaly.
>
Do you mean - create .h file in /include/linux/platform_data/ ?
Ok, will do in next version.

Thanks.

---
Mike


