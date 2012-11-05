Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2KEXUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:20:11 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:43486 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2KEXUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:20:07 -0500
Message-ID: <5098498A.9070707@iki.fi>
Date: Tue, 06 Nov 2012 01:19:38 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] tda18212: tda18218: use 'val' if initialized
References: <1351803609.1597.16.camel@x61.thuisdomein>
In-Reply-To: <1351803609.1597.16.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 82.128.190.158
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 11:00 PM, Paul Bolle wrote:
> Commits e666a44fa313cb9329c0381ad02fc6ee1e21cb31 ("[media] tda18212:
> silence compiler warning") and e0e52d4e9f5bce7ea887027c127473eb654a5a04
> ("[media] tda18218: silence compiler warning") silenced warnings
> equivalent to these:
>      drivers/media/tuners/tda18212.c: In function ‘tda18212_attach’:
>      drivers/media/tuners/tda18212.c:299:2: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>      drivers/media/tuners/tda18218.c: In function ‘tda18218_attach’:
>      drivers/media/tuners/tda18218.c:305:2: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>
> But in both cases 'val' will still be used uninitialized if the calls
> of tda18212_rd_reg() or tda18218_rd_reg() fail. Fix this by only
> printing the "chip id" if the calls of those functions were successful.
> This allows to drop the uninitialized_var() stopgap measure.
>
> Also stop printing the return values of tda18212_rd_reg() or
> tda18218_rd_reg(), as these are not interesting.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

That patch does not make much sense, but I don't still see any reason to 
reject it.

> ---
> 0) Compile tested only.
>
>   drivers/media/tuners/tda18212.c | 6 +++---
>   drivers/media/tuners/tda18218.c | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
> index 5d9f028..e4a84ee 100644
> --- a/drivers/media/tuners/tda18212.c
> +++ b/drivers/media/tuners/tda18212.c
> @@ -277,7 +277,7 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
>   {
>   	struct tda18212_priv *priv = NULL;
>   	int ret;
> -	u8 uninitialized_var(val);
> +	u8 val;
>
>   	priv = kzalloc(sizeof(struct tda18212_priv), GFP_KERNEL);
>   	if (priv == NULL)
> @@ -296,8 +296,8 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
>   	if (fe->ops.i2c_gate_ctrl)
>   		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
>
> -	dev_dbg(&priv->i2c->dev, "%s: ret=%d chip id=%02x\n", __func__, ret,
> -			val);
> +	if (!ret)
> +		dev_dbg(&priv->i2c->dev, "%s: chip id=%02x\n", __func__, val);
>   	if (ret || val != 0xc7) {
>   		kfree(priv);
>   		return NULL;
> diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
> index 1819853..2d31aeb 100644
> --- a/drivers/media/tuners/tda18218.c
> +++ b/drivers/media/tuners/tda18218.c
> @@ -277,7 +277,7 @@ struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
>   	struct i2c_adapter *i2c, struct tda18218_config *cfg)
>   {
>   	struct tda18218_priv *priv = NULL;
> -	u8 uninitialized_var(val);
> +	u8 val;
>   	int ret;
>   	/* chip default registers values */
>   	static u8 def_regs[] = {
> @@ -302,8 +302,8 @@ struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
>
>   	/* check if the tuner is there */
>   	ret = tda18218_rd_reg(priv, R00_ID, &val);
> -	dev_dbg(&priv->i2c->dev, "%s: ret=%d chip id=%02x\n", __func__, ret,
> -			val);
> +	if (!ret)
> +		dev_dbg(&priv->i2c->dev, "%s: chip id=%02x\n", __func__, val);
>   	if (ret || val != def_regs[R00_ID]) {
>   		kfree(priv);
>   		return NULL;
>


-- 
http://palosaari.fi/
