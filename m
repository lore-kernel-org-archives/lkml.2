Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031562Ab2CSRsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:48:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab2CSRsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:48:22 -0400
Message-ID: <4F67714A.3070205@redhat.com>
Date: Mon, 19 Mar 2012 14:47:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Olivier Grenie <olivier.grenie@dibcom.fr>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] [media] dib0700: unlock mutexes on error paths
References: <1331148118-22593-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1331148118-22593-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-03-2012 16:21, Alexey Khoroshilov escreveu:
> dib0700_i2c_xfer [_new and _legacy] leave i2c_mutex locked on error paths.
> The patch adds appropriate unlocks.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/media/dvb/dvb-usb/dib0700_core.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
> index 070e82a..8ec22c4 100644
> --- a/drivers/media/dvb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
> @@ -228,7 +228,7 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
>  			/* Write request */
>  			if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>  				err("could not acquire lock");
> -				return 0;
> +				break;

A break here doesn't sound the right thing to do.

>  			}
>  			st->buf[0] = REQUEST_NEW_I2C_WRITE;
>  			st->buf[1] = msg[i].addr << 1;
> @@ -270,11 +270,14 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
>  	struct dib0700_state *st = d->priv;
>  	int i,len;
>  
> -	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> +	if (mutex_lock_interruptible(&d->i2c_mutex) < 0) {
> +		err("could not acquire lock");
>  		return -EAGAIN;
> +	}
>  	if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
> +		mutex_unlock(&d->i2c_mutex);
>  		err("could not acquire lock");
> -		return 0;
> +		return -EAGAIN;
>  	}
>  
>  	for (i = 0; i < num; i++) {

