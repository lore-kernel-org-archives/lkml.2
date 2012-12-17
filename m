Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2LQVz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:55:27 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43225 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab2LQVzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:55:25 -0500
Message-ID: <50CF94C9.2050907@wwwdotorg.org>
Date: Mon, 17 Dec 2012 14:55:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: alan@linux.intel.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] serial: tegra: add serial driver
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 05:10 AM, Laxman Dewangan wrote:
> Nvidia's Tegra has multiple uart controller which supports:
> - APB dma based controller fifo read/write.
> - End Of Data interrupt in incoming data to know whether end
>   of frame achieve or not.
> - Hw controlled RTS and CTS flow control to reduce SW overhead.
> 
> Add serial driver to use all above feature.

> diff --git a/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt b/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt

> +Required properties:
> +- compatible : should be "nvidia,tegra20-hsuart", "nvidia,tegra30-hsuart".

I think you want ", or" not just "," there. If both are specified,
"tegra30" should come before "tegra20", so you might want to re-order
that. That said, other bindings say something like
"nvidia,tegra<chip>-hsuart" so avoid having to spell out all the
supported Tegra versions.

> diff --git a/drivers/tty/serial/serial_tegra.c b/drivers/tty/serial/serial_tegra.c

> +struct tegra_uart_chip_data tegra20_uart_chip_data = {
> +	.tx_fifo_full_status		= false,
> +	.allow_txfifo_reset_fifo_mode	= true,
> +	.support_clk_src_div		= false,
> +};
> +
> +struct tegra_uart_chip_data tegra30_uart_chip_data = {
> +	.tx_fifo_full_status		= true,
> +	.allow_txfifo_reset_fifo_mode	= false,
> +	.support_clk_src_div		= true,
> +};

Nit: Perhaps it'd be nice to move those right before
tegra_uart_of_match[] - i.e. right where they're used.

> +static struct tegra_uart_platform_data *tegra_uart_parse_dt(

> +	if (of_get_property(np, "nvidia,enable-modem-interrupt", NULL))
> +		pdata->enable_modem_interrupt = 1;

That should use of_property_read_bool().

> +static int __devinit tegra_uart_probe(struct platform_device *pdev)

> +	if (pdev->dev.of_node) {

That will always be true these days.

I didn't review the body of the UART implementation since I'm not
familiar with drivers/tty/serial nor too much about our UART HW beyond
basic 8250 usage.
