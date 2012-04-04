Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2DDGSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 02:18:21 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:51765 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab2DDGSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 02:18:20 -0400
Message-ID: <4F7BE7A4.1060202@permonline.ru>
Date: Wed, 04 Apr 2012 12:18:12 +0600
From: Mike Sinkovsky <msink@permonline.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] Ethernet driver for the WIZnet W5300 chip
References: <1332752876-1650-1-git-send-email-msink@permonline.ru> <1333450726-24455-2-git-send-email-msink@permonline.ru> <20120403133619.GA3960@sirena.org.uk>
In-Reply-To: <20120403133619.GA3960@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.04.2012 19:36, Mark Brown написал:
> On Tue, Apr 03, 2012 at 04:58:45PM +0600, Mike Sinkovsky wrote:
>
>> +static irqreturn_t w5300_detect_link(int irq, void *ndev_instance)
>> +{
>> +	struct net_device *ndev = ndev_instance;
>> +	struct w5300_priv *priv = netdev_priv(ndev);
>> +
>> +	if (netif_running(ndev)) {
>> +		if (gpio_get_value(priv->link_gpio) != 0) {
>> +			netif_info(priv, link, ndev, "link is up\n");
>> +			netif_carrier_on(ndev);
>> +		} else {
>> +			netif_info(priv, link, ndev, "link is down\n");
>> +			netif_carrier_off(ndev);
>> +		}
>> +	}
>> +
>> +	return IRQ_HANDLED;
>> +}
>
> This relies on ndev being valid and on the gpio being requested but...
>
>> +	priv->link_gpio = data->link_gpio;
>> +	if (gpio_is_valid(priv->link_gpio)) {
>> +		char *link_name = devm_kzalloc(&pdev->dev, 16, GFP_KERNEL);
>> +		if (!link_name)
>> +			return -ENOMEM;
>> +		snprintf(link_name, 16, "%s-link", name);
>> +		priv->link_irq = gpio_to_irq(priv->link_gpio);
>> +		if (devm_request_threaded_irq(&pdev->dev,
>> +				priv->link_irq, NULL, w5300_detect_link,
>> +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>> +				link_name, priv->ndev)<  0)
>> +			priv->link_gpio = -EINVAL;
>> +	}
>
> ...you use devm_request_threaded_irq() here and rely on it for cleanup.
> Are you sure there's no possibility of the interrupt firing after you
> start to tear down the device?
>
> By using a specifically threaded IRQ you're also adding a performance
> overhead for no good reason if you can call netdev_carrier_*() from IRQ
> context and the GPIO is capable of generating a hard IRQ.  If you use
> request_any_context_irq() instead then the driver will get a hard IRQ if
> that's supported.

There isn't devm* variant of request_any_context_irq(), and using plain 
version looks inconsistent with other resources handling.
Anyway, this is not performance critical procedure, and latency around 
100 millisecond is acceptable. Some our boards even don't have this gpio 
at all, and nothing bad happens, just userspace doesn't know is carrier 
on or off.

Some gpio cannot generate irq at all, and if goal is to support any - I 
can easily convert this to background polling from delayed_work 
procedure. If it is required for generalized mainstream driver.


-- 
Mike

