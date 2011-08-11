Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1HKUxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:53:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5669 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1HKUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:53:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 11 Aug 2011 13:53:31 -0700
Subject: Re: [PATCH] i2c: tegra: fix possible race condition after tx
From: Rhyland Klein <rklein@nvidia.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Stephen Warren <swarren@nvidia.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Jean Delvare <khali@linux-fr.org>, Rakesh Iyer <riyer@nvidia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1313093946-24559-1-git-send-email-dianders@chromium.org>
References: <1313093946-24559-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 13:52:45 -0700
Message-ID: <1313095965.8365.1.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 13:19 -0700, Doug Anderson wrote:
> In tegra_i2c_fill_tx_fifo, once we have finished pushing all the bytes
> to the I2C hardware controller, the interrupt might happen before we
> have updated i2c_dev->msg_buf_remaining at the end of the function.
> Then, in tegra_i2c_isr, we will call again tegra_i2c_fill_tx_fifo
> triggering weird behaviour. This has been shown to happen under real
> conditions.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/i2c/busses/i2c-tegra.c |   46 +++++++++++++++++++++++++++------------
>  1 files changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 2440b74..9c5fb75 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -270,14 +270,30 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
>  
>  	/* Rounds down to not include partial word at the end of buf */
>  	words_to_transfer = buf_remaining / BYTES_PER_FIFO_WORD;
> -	if (words_to_transfer > tx_fifo_avail)
> -		words_to_transfer = tx_fifo_avail;
>  
> -	i2c_writesl(i2c_dev, buf, I2C_TX_FIFO, words_to_transfer);
> -
> -	buf += words_to_transfer * BYTES_PER_FIFO_WORD;
> -	buf_remaining -= words_to_transfer * BYTES_PER_FIFO_WORD;
> -	tx_fifo_avail -= words_to_transfer;
> +	/* It's very common to have < 4 bytes, so optimize that case. */
> +	if (words_to_transfer) {
> +		if (words_to_transfer > tx_fifo_avail)
> +			words_to_transfer = tx_fifo_avail;
> +
> +		/*
> +		 * Update state before writing to FIFO.  If this casues us
> +		 * to finish writing all bytes (AKA buf_remaining goes to 0) we
> +		 * have a potential for an interrupt (PACKET_XFER_COMPLETE is
> +		 * not maskable).  We need to make sure that the isr sees
> +		 * buf_remaining as 0 and doesn't call us back re-entrantly.
> +		 */
> +		buf_remaining -= words_to_transfer * BYTES_PER_FIFO_WORD;
> +		tx_fifo_avail -= words_to_transfer;
> +		i2c_dev->msg_buf_remaining = buf_remaining;
> +		i2c_dev->msg_buf = buf +
> +			words_to_transfer * BYTES_PER_FIFO_WORD;
> +		barrier();
> +
> +		i2c_writesl(i2c_dev, buf, I2C_TX_FIFO, words_to_transfer);
> +
> +		buf += words_to_transfer * BYTES_PER_FIFO_WORD;
> +	}
>  
>  	/*
>  	 * If there is a partial word at the end of buf, handle it manually to
> @@ -287,14 +303,15 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
>  	if (tx_fifo_avail > 0 && buf_remaining > 0) {
>  		BUG_ON(buf_remaining > 3);
>  		memcpy(&val, buf, buf_remaining);
> +
> +		/* Again update before writing to FIFO to make sure isr sees. */
> +		i2c_dev->msg_buf_remaining = 0;
> +		i2c_dev->msg_buf = NULL;
> +		barrier();
> +
>  		i2c_writel(i2c_dev, val, I2C_TX_FIFO);
> -		buf_remaining = 0;
> -		tx_fifo_avail--;
>  	}
>  
> -	BUG_ON(tx_fifo_avail > 0 && buf_remaining > 0);
> -	i2c_dev->msg_buf_remaining = buf_remaining;
> -	i2c_dev->msg_buf = buf;
>  	return 0;
>  }
>  
> @@ -411,9 +428,10 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
>  			tegra_i2c_mask_irq(i2c_dev, I2C_INT_TX_FIFO_DATA_REQ);
>  	}
>  
> -	if ((status & I2C_INT_PACKET_XFER_COMPLETE) &&
> -			!i2c_dev->msg_buf_remaining)
> +	if (status & I2C_INT_PACKET_XFER_COMPLETE) {
> +		BUG_ON(i2c_dev->msg_buf_remaining);
>  		complete(&i2c_dev->msg_complete);
> +	}
>  
>  	i2c_writel(i2c_dev, status, I2C_INT_STATUS);
>  	if (i2c_dev->is_dvc)

Looks good to me 

Acked-by: Rhyland Klein <rklein@nvidia.com>

