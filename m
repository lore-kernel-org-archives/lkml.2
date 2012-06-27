Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2F0S4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:56:20 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:38860 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2F0S4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:56:18 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AttTAAVW609V5qg+PGdsb2JhbABFihWsGBkBAQEBHhkNJ4IYAQEEATocIwULCAMOOBQlChoTiAYJuDoUkE1gA5UxhWaDQYk+
X-IronPort-AV: E=Sophos;i="4.77,486,1336341600"; 
   d="scan'208";a="70063986"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 27 Jun 2012 20:59:40 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/21 v5] Input: atmel_mxt_ts - add variable length
 __mxt_write_reg
Message-ID: <20120627185940.GA14026@polaris.bitmath.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
 <1340693829-18665-12-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340693829-18665-12-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> The i2c bus requires 4 bytes to do a 1-byte write
> (1 byte i2c address + 2 byte offset + 1 byte data).
> 
> By taking a length with writes, the driver can amortize transaction
> overhead by performing larger transactions where appropriate.
> 
> This patch just sets up the new API.  Later patches refactor writes
> to take advantage of the larger transactions.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   22 +++++++++++++++++-----
>  1 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 3672553..d9e7e68 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -431,17 +431,24 @@ static int mxt_read_reg(struct i2c_client *client, u16 reg, u8 *val)
>  	return __mxt_read_reg(client, reg, 1, val);
>  }
>  
> -static int mxt_write_reg(struct i2c_client *client, u16 reg, u8 val)
> +static int __mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
> +			   const void *val)
>  {
> -	u8 buf[3];
> +	u8 *buf;
> +	size_t count;
>  	int ret;
>  
> +	count = len + 2;
> +	buf = kmalloc(count, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
>  	buf[0] = reg & 0xff;
>  	buf[1] = (reg >> 8) & 0xff;
> -	buf[2] = val;
> +	memcpy(&buf[2], val, len);
>  
> -	ret = i2c_master_send(client, buf, 3);
> -	if (ret == 3) {
> +	ret = i2c_master_send(client, buf, count);
> +	if (ret == count) {
>  		ret = 0;
>  	} else {
>  		if (ret >= 0)
> @@ -453,6 +460,11 @@ static int mxt_write_reg(struct i2c_client *client, u16 reg, u8 val)

kfree(buf);

>  	return ret;
>  }
>  
> +static int mxt_write_reg(struct i2c_client *client, u16 reg, u8 val)
> +{
> +	return __mxt_write_reg(client, reg, 1, &val);
> +}
> +
>  static int mxt_read_object_table(struct i2c_client *client,
>  				      u16 reg, u8 *object_buf)
>  {
> -- 
> 1.7.7.3
> 

Thanks,
Henrik
