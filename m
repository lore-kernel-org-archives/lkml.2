Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2LCN31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:29:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33460 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2LCN30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:29:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAHuqX+EQ0pZnm27yAVqC=NRX8huQ5EvbC8PGn2G3xYw4D71gQA@mail.gmail.com>
References: <1354354961-28833-1-git-send-email-giridhar.maruthy@linaro.org>
	<CAHuqX+EQ0pZnm27yAVqC=NRX8huQ5EvbC8PGn2G3xYw4D71gQA@mail.gmail.com>
Date: Mon, 3 Dec 2012 22:28:21 +0900
X-Google-Sender-Auth: rVQz-WxPrKFYffC5GAZWmI60hjk
Message-ID: <CAH9JG2VU7gLU-tdhUcGYtkn3aE5+CePKZD7U0OhpDMgJjARWyw@mail.gmail.com>
Subject: Re: [PATCH] I2C: EXYNOS: Add slave support to i2c
From: Kyungmin Park <kmpark@infradead.org>
To: Giridhar Maruthy <giridhar.maruthy@linaro.org>
Cc: ben-linux@fluff.org, kgene.kim@samsung.com, khali@linux-fr.org,
        w.sang@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 3, 2012 at 9:16 PM, Giridhar Maruthy
<giridhar.maruthy@linaro.org> wrote:
> This patch adds slave support to i2c. The dt entry i2c-mode
> decides at probe time if the controller needs to work in
> slave mode and the controller is accordingly programmed.
>
> Signed-off-by: Giridhar Maruthy <giridhar.maruthy@linaro.org>
> ---
>  drivers/i2c/busses/i2c-s3c2410.c |  100
> ++++++++++++++++++++++++++------------
>  1 file changed, 68 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c
> b/drivers/i2c/busses/i2c-s3c2410.c
> index e93e7d6..d83a6d7 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -53,6 +53,9 @@
>  /* Max time to wait for bus to become idle after a xfer (in us) */
>  #define S3C2410_IDLE_TIMEOUT   5000
>
> +/* To find the master/slave mode of current controller */
> +#define is_master(i2c) (!i2c->i2c_mode)
> +
>  /* i2c controller state */
>  enum s3c24xx_i2c_state {
>         STATE_IDLE,
> @@ -89,6 +92,8 @@ struct s3c24xx_i2c {
>  #ifdef CONFIG_CPU_FREQ
>         struct notifier_block   freq_transition;
>  #endif
> +       /* i2c_mode: 0 is for master; and 1 is for slave */
> +       unsigned int            i2c_mode;
If it's used for master or not, doesn't better to use 'is_master' or
'is_slave'? what's the meaning of 'i2c_mode'?
and
#define is_master(i2c) (i2c->is_master)

Thank you,
Kyungmin Park
>  };
>
>  static struct platform_device_id s3c24xx_driver_ids[] = {
> @@ -202,11 +207,21 @@ static void s3c24xx_i2c_message_start(struct
> s3c24xx_i2c *i2c,
>         stat = 0;
>         stat |=  S3C2410_IICSTAT_TXRXEN;
>
> -       if (msg->flags & I2C_M_RD) {
> -               stat |= S3C2410_IICSTAT_MASTER_RX;
> -               addr |= 1;
> -       } else
> -               stat |= S3C2410_IICSTAT_MASTER_TX;
> +       if (is_master(i2c)) {
> +               /* Master mode */
> +               if (msg->flags & I2C_M_RD) {
> +                       stat |= S3C2410_IICSTAT_MASTER_RX;
> +                       addr |= 1;
> +               } else
> +                       stat |= S3C2410_IICSTAT_MASTER_TX;
> +       } else {
> +               /* Slave mode */
> +               if (msg->flags & I2C_M_RD) {
> +                       stat |= S3C2410_IICSTAT_SLAVE_RX;
> +                       addr |= 1;
> +               } else
> +                       stat |= S3C2410_IICSTAT_SLAVE_TX;
> +       }
>
>         if (msg->flags & I2C_M_REV_DIR_ADDR)
>                 addr ^= 1;
> @@ -228,8 +243,10 @@ static void s3c24xx_i2c_message_start(struct
> s3c24xx_i2c *i2c,
>         dev_dbg(i2c->dev, "iiccon, %08lx\n", iiccon);
>         writel(iiccon, i2c->regs + S3C2410_IICCON);
>
> -       stat |= S3C2410_IICSTAT_START;
> -       writel(stat, i2c->regs + S3C2410_IICSTAT);
> +       if (is_master(i2c)) {
> +               stat |= S3C2410_IICSTAT_START;
> +               writel(stat, i2c->regs + S3C2410_IICSTAT);
> +       }
>  }
>
>  static inline void s3c24xx_i2c_stop(struct s3c24xx_i2c *i2c, int ret)
> @@ -272,14 +289,19 @@ static inline void s3c24xx_i2c_stop(struct s3c24xx_i2c
> *i2c, int ret)
>          * devices, the host as Master and the HDMIPHY device as the slave.
>          * Skipping the STOP condition has been tested on this bus and
> works.
>          */
> -       if (i2c->quirks & QUIRK_HDMIPHY) {
> -               /* Stop driving the I2C pins */
> -               iicstat &= ~S3C2410_IICSTAT_TXRXEN;
> -       } else {
> -               /* stop the transfer */
> -               iicstat &= ~S3C2410_IICSTAT_START;
> +       if (is_master(i2c)) {
> +               if (i2c->quirks & QUIRK_HDMIPHY) {
> +                       /* Stop driving the I2C pins */
> +                       iicstat &= ~S3C2410_IICSTAT_TXRXEN;
> +               } else {
> +                       /* stop the transfer */
> +                       if (is_master(i2c)) {
> +                               /* Start/Stop required only for master */
> +                               iicstat &= ~S3C2410_IICSTAT_START;
> +                       }
> +               }
> +               writel(iicstat, i2c->regs + S3C2410_IICSTAT);
>         }
> -       writel(iicstat, i2c->regs + S3C2410_IICSTAT);
>
>         i2c->state = STATE_STOP;
>
> @@ -348,7 +370,8 @@ static int i2c_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c,
> unsigned long iicstat)
>                  */
>
>                 if (iicstat & S3C2410_IICSTAT_LASTBIT &&
> -                   !(i2c->msg->flags & I2C_M_IGNORE_NAK)) {
> +                   !(i2c->msg->flags & I2C_M_IGNORE_NAK) &&
> +                   is_master(i2c)) {
>                         /* ack was not received... */
>
>                         dev_dbg(i2c->dev, "ack was not received\n");
> @@ -380,7 +403,7 @@ static int i2c_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c,
> unsigned long iicstat)
>                  * end of the message, and if so, work out what to do
>                  */
>
> -               if (!(i2c->msg->flags & I2C_M_IGNORE_NAK)) {
> +               if (!(i2c->msg->flags & I2C_M_IGNORE_NAK) && is_master(i2c))
> {
>                         if (iicstat & S3C2410_IICSTAT_LASTBIT) {
>                                 dev_dbg(i2c->dev, "WRITE: No Ack\n");
>
> @@ -432,7 +455,6 @@ static int i2c_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c,
> unsigned long iicstat)
>
>                 } else {
>                         /* send stop */
> -
>                         s3c24xx_i2c_stop(i2c, 0);
>                 }
>                 break;
> @@ -447,7 +469,7 @@ static int i2c_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c,
> unsigned long iicstat)
>                 i2c->msg->buf[i2c->msg_ptr++] = byte;
>
>   prepare_read:
> -               if (is_msglast(i2c)) {
> +               if (is_msglast(i2c) && is_master(i2c)) {
>                         /* last byte of buffer */
>
>                         if (is_lastmsg(i2c))
> @@ -612,11 +634,13 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
>         if (i2c->suspended)
>                 return -EIO;
>
> -       ret = s3c24xx_i2c_set_master(i2c);
> -       if (ret != 0) {
> -               dev_err(i2c->dev, "cannot get bus (error %d)\n", ret);
> -               ret = -EAGAIN;
> -               goto out;
> +       if (is_master(i2c)) {
> +               ret = s3c24xx_i2c_set_master(i2c);
> +               if (ret != 0) {
> +                       dev_err(i2c->dev, "cannot get bus (error %d)\n",
> ret);
> +                       ret = -EAGAIN;
> +                       goto out;
> +               }
>         }
>
>         i2c->msg     = msgs;
> @@ -628,23 +652,29 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
>         s3c24xx_i2c_enable_irq(i2c);
>         s3c24xx_i2c_message_start(i2c, msgs);
>
> -       timeout = wait_event_timeout(i2c->wait, i2c->msg_num == 0, HZ * 5);
> +       if (is_master(i2c))
> +               timeout = wait_event_timeout(i2c->wait,\
> +                               i2c->msg_num == 0, HZ * 5);
> +       else
> +               wait_event_interruptible(i2c->wait, i2c->msg_num == 0);
>
>         ret = i2c->msg_idx;
>
>         /* having these next two as dev_err() makes life very
>          * noisy when doing an i2cdetect */
>
> -       if (timeout == 0)
> -               dev_dbg(i2c->dev, "timeout\n");
> -       else if (ret != num)
> -               dev_dbg(i2c->dev, "incomplete xfer (%d)\n", ret);
> +       if (is_master(i2c)) {
> +               if (timeout == 0)
> +                       dev_dbg(i2c->dev, "timeout\n");
> +               else if (ret != num)
> +                       dev_dbg(i2c->dev, "incomplete xfer (%d)\n", ret);
>
> -       /* For QUIRK_HDMIPHY, bus is already disabled */
> -       if (i2c->quirks & QUIRK_HDMIPHY)
> -               goto out;
> +               /* For QUIRK_HDMIPHY, bus is already disabled */
> +               if (i2c->quirks & QUIRK_HDMIPHY)
> +                       goto out;
>
> -       s3c24xx_i2c_wait_idle(i2c);
> +               s3c24xx_i2c_wait_idle(i2c);
> +       }
>
>   out:
>         return ret;
> @@ -963,6 +993,7 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct
> s3c24xx_i2c *i2c)
>         of_property_read_u32(np, "samsung,i2c-slave-addr",
> &pdata->slave_addr);
>         of_property_read_u32(np, "samsung,i2c-max-bus-freq",
>                                 (u32 *)&pdata->frequency);
> +       of_property_read_u32(np, "samsung,i2c-mode", &i2c->i2c_mode);
>  }
>  #else
>  static void
> @@ -1004,6 +1035,10 @@ static int s3c24xx_i2c_probe(struct platform_device
> *pdev)
>                 goto err_noclk;
>         }
>
> +       /* By default, i2c works in master mode */
> +       /* This currently will be updated using DT */
> +       i2c->i2c_mode   = 0;
> +
>         i2c->quirks = s3c24xx_get_device_quirks(pdev);
>         if (pdata)
>                 memcpy(i2c->pdata, pdata, sizeof(*pdata));
> @@ -1017,6 +1052,7 @@ static int s3c24xx_i2c_probe(struct platform_device
> *pdev)
>         i2c->adap.class   = I2C_CLASS_HWMON | I2C_CLASS_SPD;
>         i2c->tx_setup     = 50;
>
> +
>         init_waitqueue_head(&i2c->wait);
>
>         /* find the clock and enable it */
> --
> 1.7.9.5
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
