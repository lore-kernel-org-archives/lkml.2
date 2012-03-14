Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2CNPhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:37:12 -0400
Received: from sym2.noone.org ([178.63.92.236]:48074 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab2CNPhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:37:07 -0400
Date: Wed, 14 Mar 2012 16:37:05 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Mike Sinkovsky <msink@permonline.ru>
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ethernet driver for the WIZnet W5300 chip
Message-ID: <20120314153705.GN21503@distanz.ch>
References: <1331730035-11183-1-git-send-email-msink@permonline.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331730035-11183-1-git-send-email-msink@permonline.ru>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-14 at 14:00:35 +0100, Mike Sinkovsky <msink@permonline.ru> wrote:

[snip]

> +static int w5300_set_macaddr(struct net_device *ndev, void *addr)
> +{
> +	struct dev_private *priv = netdev_priv(ndev);
> +	struct sockaddr *sock_addr = addr;
> +
> +	if (is_multicast_ether_addr(sock_addr->sa_data))
> +		return -EADDRNOTAVAIL;

This should probably be

	if (!is_valid_ether_addr(sock_addr->sa_data))
		return -EADDRNOTAVAIL;

> +	memcpy(ndev->dev_addr, sock_addr->sa_data, ETH_ALEN);
> +	write_macaddr(priv);

You'll also want to reset NET_ADDR_RANDOM in ndev->addr_assign_type
since you seem to generate a random address in w5300_probe().

> +
> +	return 0;
> +}
> +

[snip]

> +static int __devinit w5300_probe(struct platform_device *pdev)
> +{
> +	struct net_device *ndev;
> +	struct dev_private *priv;
> +	struct resource *mem;
> +	void __iomem *mem_base;
> +	int mem_size;
> +	int irq;
> +	int err;
> +
> +	ndev = alloc_etherdev(sizeof(*priv));
> +	if (!ndev) {
> +		err = -ENOMEM;
> +		goto err_do_devfree;
> +	}
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	irq = platform_get_irq(pdev, 0);
> +	if (!mem || irq < 0) {
> +		err = -ENXIO;
> +		goto err_do_devfree;
> +	}
> +	mem_size = resource_size(mem);
> +
> +	if (!request_mem_region(mem->start, mem_size, KBUILD_MODNAME)) {
> +		err = -EBUSY;
> +		goto err_do_devfree;
> +	}
> +	mem_base = ioremap(mem->start, mem_size);
> +	if (!mem_base) {
> +		err = -ENOMEM;
> +		goto err_do_memrelease;
> +	}
> +
> +	SET_NETDEV_DEV(ndev, &pdev->dev);
> +	platform_set_drvdata(pdev, ndev);
> +	priv = netdev_priv(ndev);
> +	priv->ndev = ndev;
> +	priv->base = mem_base;
> +	priv->promisc_mode = false;
> +	spin_lock_init(&priv->reg_lock);
> +
> +	ndev->mem_start = mem->start;
> +	ndev->mem_end = mem->start + mem_size - 1;
> +	ndev->irq = irq;
> +	ndev->netdev_ops = &netdev_ops;
> +	ndev->watchdog_timeo = 2 * HZ;
> +	ether_setup(ndev);
> +	dev_hw_addr_random(ndev, ndev->dev_addr);

This is eth_hw_addr_random(ndev) in net-next now.

> +	reset_chip(priv);
> +	if (read_IDR(priv) != 0x5300) {
> +		err = -ENODEV;
> +		goto err_do_iounmap;
> +	}
> +
> +	err = request_irq(ndev->irq, w5300_start_rx,
> +			  IRQ_TYPE_LEVEL_LOW, ndev->name, ndev);
> +	if (err)
> +		goto err_do_iounmap;
> +
> +	netif_napi_add(ndev, &priv->napi, w5300_napi_poll, 16);
> +	err = register_netdev(ndev);
> +	if (err)
> +		goto err_do_irqfree;
> +
> +	netdev_info(ndev, "at 0x%lX irq %d\n", ndev->mem_start, ndev->irq);
> +	return 0;
> +
> +err_do_irqfree:
> +	free_irq(ndev->irq, ndev);
> +err_do_iounmap:
> +	iounmap(mem_base);
> +err_do_memrelease:
> +	release_mem_region(mem->start, resource_size(mem));
> +err_do_devfree:
> +	free_netdev(ndev);
> +	platform_set_drvdata(pdev, NULL);
> +	return err;
> +}
