Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2CHJ3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:29:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51069 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab2CHJ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 04:28:52 -0500
Message-ID: <4F587B9E.4000708@openwrt.org>
Date: Thu, 08 Mar 2012 10:27:58 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        alexander.h.duyck@intel.com, eilong@broadcom.com,
        ian.campbell@citrix.com, netdev@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de, baruch@tkos.co.il,
        joe@perches.com, bhutchings@solarflare.com
Subject: Re: [PATCH v6] lpc32xx: Added ethernet driver
References: <1331151693-21726-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1331151693-21726-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

Le 03/07/12 21:21, Roland Stigge a écrit :
> This patch adds an ethernet driver for the LPC32xx ARM SoC.
>
> Signed-off-by: Roland Stigge<stigge@antcom.de>

I have a couple of phylib-related comments addressed inline.

>
> ---
>
> Applies to v3.3-rc6
>
> Changes since v5:
>   * Indentation and whitespace fixes
>   * Use __le32 for descriptors
>   * Use bool for boolean function parameters
>   * Removed unnecessary (u32) cast
>   * Added comment regarding future device tree introduction
>
>   Thanks to David Miller, Arnd Bergmann and Joe Perches for
>   reviewing the last version!
>
>   drivers/net/ethernet/Kconfig       |    1
>   drivers/net/ethernet/Makefile      |    1
>   drivers/net/ethernet/nxp/Kconfig   |    8
>   drivers/net/ethernet/nxp/Makefile  |    1
>   drivers/net/ethernet/nxp/lpc_eth.c | 1616 +++++++++++++++++++++++++++++++++++++
>   5 files changed, 1627 insertions(+)
>
> --- linux-2.6.orig/drivers/net/ethernet/Kconfig
> +++ linux-2.6/drivers/net/ethernet/Kconfig

> +
> +static int lpc_mii_probe(struct net_device *ndev)
> +{
> +	struct netdata_local *pldat = netdev_priv(ndev);
> +	struct phy_device *phydev = NULL;
> +	int phy_addr;
> +
> +	/* find the first phy */
> +	for (phy_addr = 0; phy_addr<  PHY_MAX_ADDR; phy_addr++) {
> +		if (pldat->mii_bus->phy_map[phy_addr]) {
> +			phydev = pldat->mii_bus->phy_map[phy_addr];
> +			break;
> +		}
> +	}

Please use phy_find_first() instead of open-coding this.

> +
> +	if (!phydev) {
> +		netdev_err(ndev, "no PHY found\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Attach to the PHY */
> +	if (lpc_phy_interface_mode() == PHY_INTERFACE_MODE_MII)
> +		netdev_info(ndev, "using MII interface\n");
> +	else
> +		netdev_info(ndev, "using RMII interface\n");
> +	phydev = phy_connect(ndev, dev_name(&phydev->dev),
> +		&lpc_handle_link_change, 0, lpc_phy_interface_mode());
> +
> +	if (IS_ERR(phydev)) {
> +		netdev_err(ndev, "Could not attach to PHY\n");
> +		return PTR_ERR(phydev);
> +	}
> +
> +	/* mask with MAC supported features */
> +	phydev->supported&= PHY_BASIC_FEATURES;
> +
> +	phydev->advertising = phydev->supported;
> +
> +	pldat->link = 0;
> +	pldat->speed = 0;
> +	pldat->duplex = -1;
> +	pldat->phy_dev = phydev;
> +
> +	return 0;
> +}
> +
> +static int lpc_mii_init(struct netdata_local *pldat)
> +{
> +	int err = -ENXIO, i;
> +
> +	pldat->mii_bus = mdiobus_alloc();
> +	if (!pldat->mii_bus) {
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	/* Setup MII mode */
> +	if (lpc_phy_interface_mode() == PHY_INTERFACE_MODE_MII)
> +		writel(LPC_COMMAND_PASSRUNTFRAME,
> +		       LPC_ENET_COMMAND(pldat->net_base));
> +	else {
> +		writel((LPC_COMMAND_PASSRUNTFRAME | LPC_COMMAND_RMII),
> +		       LPC_ENET_COMMAND(pldat->net_base));
> +		writel(LPC_SUPP_RESET_RMII, LPC_ENET_SUPP(pldat->net_base));
> +	}
> +
> +	pldat->mii_bus->name = "lpc_mii_bus";
> +	pldat->mii_bus->read =&lpc_mdio_read;
> +	pldat->mii_bus->write =&lpc_mdio_write;
> +	pldat->mii_bus->reset =&lpc_mdio_reset;
> +	snprintf(pldat->mii_bus->id, MII_BUS_ID_SIZE, "%x", pldat->pdev->id);

No, makes this bus name unique in the system:
snprnitf(pldat->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
	pldat->pdev->name, pldat->pdev->id);

> +	pldat->mii_bus->priv = pldat;
> +	pldat->mii_bus->parent =&pldat->pdev->dev;
> +	pldat->mii_bus->phy_mask = 0xFFFFFFF0;

I would rather not hardcode the phy_mask here, just leave it to 0, and 
let phy_find_first() find the PHY devices for you, or make this platform 
configurable.

> +
> +	pldat->mii_bus->irq = kmalloc(sizeof(int) * PHY_MAX_ADDR, GFP_KERNEL);
> +	if (!pldat->mii_bus->irq) {
> +		err = -ENOMEM;
> +		goto err_out_1;
> +	}
> +
> +	for (i = 0; i<  PHY_MAX_ADDR; i++)
> +		pldat->mii_bus->irq[i] = PHY_POLL;
> +
> +	platform_set_drvdata(pldat->pdev, pldat->mii_bus);
> +
> +	if (mdiobus_register(pldat->mii_bus))
> +		goto err_out_free_mdio_irq;
> +
> +	if (lpc_mii_probe(pldat->ndev) != 0)
> +		goto err_out_unregister_bus;
> +
> +	return 0;
> +
> +err_out_unregister_bus:
> +	mdiobus_unregister(pldat->mii_bus);
> +err_out_free_mdio_irq:
> +	kfree(pldat->mii_bus->irq);
> +err_out_1:
> +	mdiobus_free(pldat->mii_bus);
> +err_out:
> +	return err;
> +}
> +

[snip]

> +
> +static int lpc_eth_open(struct net_device *ndev)
> +{
> +	struct netdata_local *pldat = netdev_priv(ndev);
> +
> +	/* if the phy is not yet registered, retry later*/
> +	if (!pldat->phy_dev)
> +		return -EAGAIN;

You have already probed the mii bus in the driver's probe function, how 
can you end up here without a phy being attached here?

[snip]

> +	if (lpc_mii_init(pldat) != 0)
> +		goto err_out_unregister_netdev;
> +
> +	netdev_info(ndev, "LPC mac at 0x%08x irq %d\n",
> +	       res->start, ndev->irq);
> +
> +	phydev = pldat->phy_dev;
> +	netdev_info(ndev,
> +		"attached PHY driver [%s] (mii_bus:phy_addr=%s, irq=%d)\n",
> +		phydev->drv->name, dev_name(&phydev->dev), phydev->irq);

Most drivers put this informational message in their mii probing 
function, please move it here as well.

> +
> +	device_init_wakeup(&pdev->dev, 1);
> +	device_set_wakeup_enable(&pdev->dev, 0);
> +
> +	return 0;
> +
> +err_out_unregister_netdev:
> +	platform_set_drvdata(pdev, NULL);
> +	unregister_netdev(ndev);
> +err_out_dma_unmap:
> +	if (!use_iram_for_net() ||
> +	    pldat->dma_buff_size>  lpc32xx_return_iram_size())
> +		dma_free_coherent(&pldat->pdev->dev, pldat->dma_buff_size,
> +				  pldat->dma_buff_base_v,
> +				  pldat->dma_buff_base_p);
> +err_out_free_irq:
> +	free_irq(ndev->irq, ndev);
> +err_out_iounmap:
> +	iounmap(pldat->net_base);
> +err_out_disable_clocks:
> +	clk_disable(pldat->clk);
> +	clk_put(pldat->clk);
> +err_out_free_dev:
> +	free_netdev(ndev);
> +err_exit:
> +	pr_err("%s: not found (%d).\n", MODNAME, ret);
> +	return ret;
> +}
> +
> +static int lpc_eth_drv_remove(struct platform_device *pdev)
> +{
> +	struct net_device *ndev = platform_get_drvdata(pdev);
> +	struct netdata_local *pldat = netdev_priv(ndev);
> +
> +	unregister_netdev(ndev);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	if (!use_iram_for_net() ||
> +	    pldat->dma_buff_size>  lpc32xx_return_iram_size())
> +		dma_free_coherent(&pldat->pdev->dev, pldat->dma_buff_size,
> +				  pldat->dma_buff_base_v,
> +				  pldat->dma_buff_base_p);
> +	free_irq(ndev->irq, ndev);
> +	iounmap(pldat->net_base);
> +	clk_disable(pldat->clk);
> +	clk_put(pldat->clk);
> +	free_netdev(ndev);

You are not freeing the mii bus in the driver's remove path.
--
Florian
