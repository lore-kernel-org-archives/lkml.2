Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2DXI6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:58:33 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:33300 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2DXI6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:58:30 -0400
Date: Tue, 24 Apr 2012 10:58:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, swarren@wwwdotorg.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] i2c: tegra: fix 10bit address configuration
Message-ID: <20120424105815.1d9e7d95@endymion.delvare>
In-Reply-To: <1335251976-31925-2-git-send-email-ldewangan@nvidia.com>
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>
	<1335251976-31925-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012 12:49:35 +0530, Laxman Dewangan wrote:
> The slave address of device to be configured in packet
> header as follows:
>     7 bit address: PacketHeader3[7:1]
>     10 bit address: PacketHeader3[9:0]
> 
> Fixing the code to make packet header3 properly.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/i2c/busses/i2c-tegra.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 55e5ea6..18067b3 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -476,12 +476,15 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
>  	packet_header = msg->len - 1;
>  	i2c_writel(i2c_dev, packet_header, I2C_TX_FIFO);
>  
> -	packet_header = msg->addr << I2C_HEADER_SLAVE_ADDR_SHIFT;
> -	packet_header |= I2C_HEADER_IE_ENABLE;
> +	packet_header = I2C_HEADER_IE_ENABLE;
>  	if (!stop)
>  		packet_header |= I2C_HEADER_REPEAT_START;
> -	if (msg->flags & I2C_M_TEN)
> +	if (msg->flags & I2C_M_TEN) {
> +		packet_header |= msg->addr;
>  		packet_header |= I2C_HEADER_10BIT_ADDR;
> +	} else {
> +		packet_header |= msg->addr << I2C_HEADER_SLAVE_ADDR_SHIFT;
> +	}
>  	if (msg->flags & I2C_M_IGNORE_NAK)
>  		packet_header |= I2C_HEADER_CONT_ON_NAK;
>  	if (msg->flags & I2C_M_RD)
> @@ -557,7 +560,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
>  
>  static u32 tegra_i2c_func(struct i2c_adapter *adap)
>  {
> -	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR;
>  }
>  
>  static const struct i2c_algorithm tegra_i2c_algo = {

Looks good.

Acked-by: Jean Delvare <khali@linux-fr.org>

Not that 10-bit address devices are immensely popular though...

-- 
Jean Delvare
