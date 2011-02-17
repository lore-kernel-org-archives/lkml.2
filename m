Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1BQUqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:46:04 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39429 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab1BQUqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:46:02 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [Patch] Zarlink zl10036 DVB-S: Fix mem leak in zl10036_attach
Date: Thu, 17 Feb 2011 21:45:51 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <alpine.LNX.2.00.1102062128391.13593@swampdragon.chaosbits.net> <201102172054.12773.zzam@gentoo.org> <alpine.LNX.2.00.1102172130360.17697@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102172130360.17697@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102172145.55258.zzam@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011, Jesper Juhl wrote:
> On Thu, 17 Feb 2011, Matthias Schwarzott wrote:
> > On Sunday 06 February 2011, Jesper Juhl wrote:
> > > If the memory allocation to 'state' succeeds but we jump to the 'error'
> > > label before 'state' is assigned to fe->tuner_priv, then the call to
> > > 'zl10036_release(fe)' at the 'error:' label will not free 'state', but
> > > only what was previously assigned to 'tuner_priv', thus leaking the
> > > memory allocated to 'state'.
> > > There are may ways to fix this, including assigning the allocated
> > > memory directly to 'fe->tuner_priv', but I did not go for that since
> > > the additional pointer derefs are more expensive than the local
> > > variable, so I just added a 'kfree(state)' call. I guess the call to
> > > 'zl10036_release' might not even be needed in this case, but I wasn't
> > > sure, so I left it in.
> > 
> > Yeah, that call to zl10036_release can be completely eleminated.
> > Another thing is: jumping to the error label only makes sense when memory
> > was already allocated. So the jump in line 471 can be replaced by
> > "return NULL",
> > 
> > as the other error handling before allocation:
> >         if (NULL == config) {
> >         
> >                 printk(KERN_ERR "%s: no config specified", __func__);
> >                 goto error;
> >         
> >         }
> > 
> > I suggest to improve the patch to clean the code up when changing that.
> > 
> > But I am fine with commiting this patch also if you do not want to change
> > it.
> 
> Thank you for your feedback. It makes a lot of sense.
> Changing it is not a problem :)
> How about the updated patch below?
> 
Looks good.

@Mauro: Please apply.

> 
> If the memory allocation to 'state' succeeds but we jump to the 'error'
> label before 'state' is assigned to fe->tuner_priv, then the call to
> 'zl10036_release(fe)' at the 'error:' label will not free 'state', but
> only what was previously assigned to 'tuner_priv', thus leaking the memory
> allocated to 'state'.
> This patch fixes the leak and also does not jump to 'error:' before mem
> has been allocated but instead just returns. Also some small style
> cleanups.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>


Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>  zl10036.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/zl10036.c
> b/drivers/media/dvb/frontends/zl10036.c index 4627f49..81aa984 100644
> --- a/drivers/media/dvb/frontends/zl10036.c
> +++ b/drivers/media/dvb/frontends/zl10036.c
> @@ -463,16 +463,16 @@ struct dvb_frontend *zl10036_attach(struct
> dvb_frontend *fe, const struct zl10036_config *config,
>  				    struct i2c_adapter *i2c)
>  {
> -	struct zl10036_state *state = NULL;
> +	struct zl10036_state *state;
>  	int ret;
> 
> -	if (NULL == config) {
> +	if (!config) {
>  		printk(KERN_ERR "%s: no config specified", __func__);
> -		goto error;
> +		return NULL;
>  	}
> 
>  	state = kzalloc(sizeof(struct zl10036_state), GFP_KERNEL);
> -	if (NULL == state)
> +	if (!state)
>  		return NULL;
> 
>  	state->config = config;
> @@ -507,7 +507,7 @@ struct dvb_frontend *zl10036_attach(struct dvb_frontend
> *fe, return fe;
> 
>  error:
> -	zl10036_release(fe);
> +	kfree(state);
>  	return NULL;
>  }
>  EXPORT_SYMBOL(zl10036_attach);

