Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2DCNgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:36:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47043 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2DCNgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:36:20 -0400
Date: Tue, 3 Apr 2012 14:36:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Sinkovsky <msink@permonline.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] Ethernet driver for the WIZnet W5300 chip
Message-ID: <20120403133619.GA3960@sirena.org.uk>
References: <1332752876-1650-1-git-send-email-msink@permonline.ru>
 <1333450726-24455-2-git-send-email-msink@permonline.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333450726-24455-2-git-send-email-msink@permonline.ru>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 04:58:45PM +0600, Mike Sinkovsky wrote:

> +static irqreturn_t w5300_detect_link(int irq, void *ndev_instance)
> +{
> +	struct net_device *ndev = ndev_instance;
> +	struct w5300_priv *priv = netdev_priv(ndev);
> +
> +	if (netif_running(ndev)) {
> +		if (gpio_get_value(priv->link_gpio) != 0) {
> +			netif_info(priv, link, ndev, "link is up\n");
> +			netif_carrier_on(ndev);
> +		} else {
> +			netif_info(priv, link, ndev, "link is down\n");
> +			netif_carrier_off(ndev);
> +		}
> +	}
> +
> +	return IRQ_HANDLED;
> +}

This relies on ndev being valid and on the gpio being requested but...

> +	priv->link_gpio = data->link_gpio;
> +	if (gpio_is_valid(priv->link_gpio)) {
> +		char *link_name = devm_kzalloc(&pdev->dev, 16, GFP_KERNEL);
> +		if (!link_name)
> +			return -ENOMEM;
> +		snprintf(link_name, 16, "%s-link", name);
> +		priv->link_irq = gpio_to_irq(priv->link_gpio);
> +		if (devm_request_threaded_irq(&pdev->dev,
> +				priv->link_irq, NULL, w5300_detect_link,
> +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +				link_name, priv->ndev) < 0)
> +			priv->link_gpio = -EINVAL;
> +	}

...you use devm_request_threaded_irq() here and rely on it for cleanup.
Are you sure there's no possibility of the interrupt firing after you
start to tear down the device?

By using a specifically threaded IRQ you're also adding a performance
overhead for no good reason if you can call netdev_carrier_*() from IRQ
context and the GPIO is capable of generating a hard IRQ.  If you use
request_any_context_irq() instead then the driver will get a hard IRQ if
that's supported.
