Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2FMPzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:55:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43983 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2FMPzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:55:44 -0400
Message-ID: <4FD8B7FC.3060708@wwwdotorg.org>
Date: Wed, 13 Jun 2012 09:55:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: khali@linux-fr.org, w.sang@pengutronix.de, ben-linux@fluff.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3 1/4] i2c: tegra: make sure register writes completes
References: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com> <1339582359-7911-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1339582359-7911-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 04:12 AM, Laxman Dewangan wrote:
> The Tegra PPSB (an peripheral bus) queues writes transactions.
> In order to guarantee that writes have completed before a
> certain time, a read transaction to a register on the same
> bus must be executed.
> This is necessary in situations such as when clearing an
> interrupt status or enable, so that when returning from an
> interrupt handler, the HW has already de-asserted its
> interrupt status output, which will avoid spurious interrupts.

> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c

> @@ -165,6 +165,10 @@ static void i2c_writel(struct tegra_i2c_dev *i2c_dev, u32 val,
>  	unsigned long reg)
>  {
>  	writel(val, i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));
> +
> +	/* Read back register to make sure that register writes completed */
> +	if (reg != I2C_TX_FIFO)
> +		readl(i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg));

I guess that's fine, but it sure does seem rather heavy-weight. Don't
you only need to do the readback if you just wrote to the IRQ status or
mask registers, rather than if you wrote to /any/ register other than
the FIFO?
