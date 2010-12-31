Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0LaBTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 20:19:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52387 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0LaBTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 20:19:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XunSnGHjVkdxJ2vxGLM3FC/mvnMaR4WtyKQZqdJQexmGL5n2TqhKymjiRyMIbTbLsN
         8ourp0OaGYWHt7wVJbdG1QJ0IMD6x1nGrzOZxTPYwlKJIv01IbbRwTbZvlQYt6ltt7Gj
         A6PnKXbg/BP4b9lC8F/0FMnEFQ8aYf86hm0zU=
Subject: Re: [PATVH] media, dvb, IX2505V: Remember to free allocated memory
 in failure path (ix2505v_attach()).
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <alpine.LNX.2.00.1012310008070.32595@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012310008070.32595@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 01:19:34 +0000
Message-ID: <1293758374.10326.7.camel@tvboxspy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-31 at 00:11 +0100, Jesper Juhl wrote:
> Hi,
> 
> We may leak the storage allocated to 'state' in 
> drivers/media/dvb/frontends/ix2505v.c::ix2505v_attach() on error.
> This patch makes sure we free the allocated memory in the failure case.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  ix2505v.c |    1 +
>  1 file changed, 1 insertion(+)
> 
>   Compile tested only.
> 
> diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb/frontends/ix2505v.c
> index 55f2eba..fcb173d 100644
> --- a/drivers/media/dvb/frontends/ix2505v.c
> +++ b/drivers/media/dvb/frontends/ix2505v.c
> @@ -293,6 +293,7 @@ struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
>  		ret = ix2505v_read_status_reg(state);
>  
>  		if (ret & 0x80) {
> +			kfree(state);
>  			deb_i2c("%s: No IX2505V found\n", __func__);
>  			goto error;
>  		}
> 
Memory is freed in... 

error:
	ix2505v_release(fe);
	return NULL;

via...

static int ix2505v_release(struct dvb_frontend *fe)
{
	struct ix2505v_state *state = fe->tuner_priv;

	fe->tuner_priv = NULL;
	kfree(state);

	return 0;
}


Regards


Malcolm

