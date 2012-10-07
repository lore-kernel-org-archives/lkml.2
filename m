Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab2JGQeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:34:07 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:35555 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab2JGQd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:33:59 -0400
Message-ID: <5071AEF3.6080108@bfs.de>
Date: Sun, 07 Oct 2012 18:33:55 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Antti Palosaari <crope@iki.fi>, kernel-janitors@vger.kernel.org,
        rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for i2c_msg
 initialization
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 07.10.2012 17:38, schrieb Julia Lawall:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
> 
> In the second i2c_msg structure, a length expressed as an explicit constant
> is also re-expressed as the size of the buffer, reg.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression a,b,c;
> identifier x;
> @@
> 
> struct i2c_msg x =
> - {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
> + I2C_MSG_READ(a,b,c)
>  ;
> 
> @@
> expression a,b,c;
> identifier x;
> @@
> 
> struct i2c_msg x =
> - {.addr = a, .buf = b, .len = c, .flags = 0}
> + I2C_MSG_WRITE(a,b,c)
>  ;
> 
> @@
> expression a,b,c,d;
> identifier x;
> @@
> 
> struct i2c_msg x = 
> - {.addr = a, .buf = b, .len = c, .flags = d}
> + I2C_MSG_OP(a,b,c,d)
>  ;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/media/tuners/e4000.c |   20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> index 1b33ed3..8f182fc 100644
> --- a/drivers/media/tuners/e4000.c
> +++ b/drivers/media/tuners/e4000.c
> @@ -26,12 +26,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
>  	int ret;
>  	u8 buf[1 + len];
>  	struct i2c_msg msg[1] = {
> -		{
> -			.addr = priv->cfg->i2c_addr,
> -			.flags = 0,
> -			.len = sizeof(buf),
> -			.buf = buf,
> -		}
> +		I2C_MSG_WRITE(priv->cfg->i2c_addr, buf, sizeof(buf))
>  	};
>  

Any reason why struct i2c_msg is an array ?

re,
 wh

>  	buf[0] = reg;
> @@ -54,17 +49,8 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
>  	int ret;
>  	u8 buf[len];
>  	struct i2c_msg msg[2] = {
> -		{
> -			.addr = priv->cfg->i2c_addr,
> -			.flags = 0,
> -			.len = 1,
> -			.buf = &reg,
> -		}, {
> -			.addr = priv->cfg->i2c_addr,
> -			.flags = I2C_M_RD,
> -			.len = sizeof(buf),
> -			.buf = buf,
> -		}
> +		I2C_MSG_WRITE(priv->cfg->i2c_addr, &reg, sizeof(reg)),
> +		I2C_MSG_READ(priv->cfg->i2c_addr, buf, sizeof(buf))
>  	};
>  
>  	ret = i2c_transfer(priv->i2c, msg, 2);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
