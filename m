Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab1BQTyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:54:25 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:60992 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab1BQTyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:54:22 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [Patch] Zarlink zl10036 DVB-S: Fix mem leak in zl10036_attach
Date: Thu, 17 Feb 2011 20:54:06 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <alpine.LNX.2.00.1102062128391.13593@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102062128391.13593@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102172054.12773.zzam@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 February 2011, Jesper Juhl wrote:
> If the memory allocation to 'state' succeeds but we jump to the 'error'
> label before 'state' is assigned to fe->tuner_priv, then the call to
> 'zl10036_release(fe)' at the 'error:' label will not free 'state', but
> only what was previously assigned to 'tuner_priv', thus leaking the memory
> allocated to 'state'.
> There are may ways to fix this, including assigning the allocated memory
> directly to 'fe->tuner_priv', but I did not go for that since the
> additional pointer derefs are more expensive than the local variable, so I
> just added a 'kfree(state)' call. I guess the call to 'zl10036_release'
> might not even be needed in this case, but I wasn't sure, so I left it in.
> 
Yeah, that call to zl10036_release can be completely eleminated.
Another thing is: jumping to the error label only makes sense when memory was 
already allocated. So the jump in line 471 can be replaced by "return NULL", 
as the other error handling before allocation:
        if (NULL == config) {
                printk(KERN_ERR "%s: no config specified", __func__);
                goto error;
        }

I suggest to improve the patch to clean the code up when changing that.

But I am fine with commiting this patch also if you do not want to change it.

Regards
Matthias

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  zl10036.c |    1 +
>  1 file changed, 1 insertion(+)
> 
>  compile tested only.
> 
> diff --git a/drivers/media/dvb/frontends/zl10036.c
> b/drivers/media/dvb/frontends/zl10036.c index 4627f49..b4fb8e8 100644
> --- a/drivers/media/dvb/frontends/zl10036.c
> +++ b/drivers/media/dvb/frontends/zl10036.c
> @@ -508,6 +508,7 @@ struct dvb_frontend *zl10036_attach(struct dvb_frontend
> *fe,
> 
>  error:
>  	zl10036_release(fe);
> +	kfree(state);
>  	return NULL;
>  }
>  EXPORT_SYMBOL(zl10036_attach);

