Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0FTWeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:34:17 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:25860 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756893Ab0FTWdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:33:42 -0400
Date: Sun, 20 Jun 2010 23:33:21 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Sascha Hauer <sha@pengutronix.de>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c-imx: do not allow interruptions when waiting
 for I2C to complete (resend)
Message-ID: <20100620223321.GA12387@fluff.org.uk>
References: <4C1753F6.3080106@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1753F6.3080106@pengutronix.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 12:20:38PM +0200, Marc Kleine-Budde wrote:
> The i2c_imx_trx_complete() function is using
> wait_event_interruptible_timeout() to wait for the I2C controller to
> signal that it has completed an I2C bus operation. If the process that
> causes the I2C operation receives a signal, the wait will be
> interrupted, returning an error. It is better to let the I2C operation
> finished before handling the signal (i.e. returning into userspace).
> 
> It is safe to use wait_event_timeout() instead, because the timeout
> will allow the process to exit if the I2C bus hangs. It's also better
> to allow the I2C operation to finish, because unacknowledged I2C
> operations can cause the I2C bus to hang.

Hmm, if it times out, do you need to at-least try sending a stop
on the bus? or does the caller do that for you?
 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
> 
> V2: Remove check for "result < 0" as commented by Wolfram Sang.
> 
>  drivers/i2c/busses/i2c-imx.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index d1ff940..58df809 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -161,13 +161,10 @@ static int i2c_imx_trx_complete(struct
> imx_i2c_struct *i2c_imx)
>  {
>  	int result;
> 
> -	result = wait_event_interruptible_timeout(i2c_imx->queue,
> +	result = wait_event_timeout(i2c_imx->queue,
>  		i2c_imx->i2csr & I2SR_IIF, HZ / 10);
> 
> -	if (unlikely(result < 0)) {
> -		dev_dbg(&i2c_imx->adapter.dev, "<%s> result < 0\n", __func__);
> -		return result;
> -	} else if (unlikely(!(i2c_imx->i2csr & I2SR_IIF))) {
> +	if (unlikely(!(i2c_imx->i2csr & I2SR_IIF))) {
>  		dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n", __func__);
>  		return -ETIMEDOUT;
>  	}
> @@ -295,7 +292,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
>  		i2c_imx->i2csr = temp;
>  		temp &= ~I2SR_IIF;
>  		writeb(temp, i2c_imx->base + IMX_I2C_I2SR);
> -		wake_up_interruptible(&i2c_imx->queue);
> +		wake_up(&i2c_imx->queue);
>  		return IRQ_HANDLED;
>  	}
> 
> -- 
> 1.7.1
> 



-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
