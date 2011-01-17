Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab1AQVGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:06:49 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34658 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1AQVGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:06:47 -0500
Subject: Re: [PATCH 3/3] trusted-keys: avoid scattring va_end()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: safford@watson.ibm.com, David Safford <safford@us.ibm.com>,
        jj@chaosbits.net, dhowells@redhat.com, jmorris@namei.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201101170044.p0H0iLQW087457@www262.sakura.ne.jp>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
	 <1295011682.7804.2.camel@localhost.localdomain>
	 <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp>
	 <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
	 <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net>
	 <201101170039.p0H0d1f5085735@www262.sakura.ne.jp>
	 <201101170041.p0H0ffFE086481@www262.sakura.ne.jp>
	 <201101170044.p0H0iLQW087457@www262.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 16:06:40 -0500
Message-ID: <1295298400.2642.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 09:44 +0900, Tetsuo Handa wrote:
> From 65b41710a476deae2e0899a4df40c02d199a4ee3 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 17 Jan 2011 09:27:27 +0900
> Subject: [PATCH 3/3] trusted-keys: avoid scattring va_end()
> 
> We can avoid scattering va_end() within the
> 
>   va_start();
>   for (;;) {
> 
>   }
>   va_end();
> 
> loop, assuming that crypto_shash_init()/crypto_shash_update() return 0 on
> success and negative value otherwise.
> 
> Make TSS_authhmac()/TSS_checkhmac1()/TSS_checkhmac2() similar to TSS_rawhmac()
> by removing "va_end()/goto" from the loop.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

The patch looks good.  Would you mind making the one change below?

Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  security/keys/trusted_defined.c |   30 +++++++++++++-----------------
>  1 files changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
> index f7d0677..2836c6d 100644
> --- a/security/keys/trusted_defined.c
> +++ b/security/keys/trusted_defined.c
> @@ -150,17 +150,15 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
>  		data = va_arg(argp, unsigned char *);
>  		if (!data) {
>  			ret = -EINVAL;
> -			va_end(argp);
> -			goto out;
> +			break;
>  		}
>  		ret = crypto_shash_update(&sdesc->shash, data, dlen);
> -		if (ret < 0) {
> -			va_end(argp);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			break;
>  	}
>  	va_end(argp);
> -	ret = crypto_shash_final(&sdesc->shash, paramdigest);
> +	if (!ret)
> +		ret = crypto_shash_final(&sdesc->shash, paramdigest);
>  	if (!ret)

Change the existing '(!ret)' to '(ret < 0)', like the rest of the code?
It's not wrong, but ....

>  		ret = TSS_rawhmac(digest, key, keylen, SHA1_DIGEST_SIZE,
>  				  paramdigest, TPM_NONCE_SIZE, h1,
> @@ -229,13 +227,12 @@ static int TSS_checkhmac1(unsigned char *buffer,
>  			break;
>  		dpos = va_arg(argp, unsigned int);
>  		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
> -		if (ret < 0) {
> -			va_end(argp);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			break;
>  	}
>  	va_end(argp);
> -	ret = crypto_shash_final(&sdesc->shash, paramdigest);
> +	if (!ret)
> +		ret = crypto_shash_final(&sdesc->shash, paramdigest);
>  	if (ret < 0)
>  		goto out;
> 
> @@ -323,13 +320,12 @@ static int TSS_checkhmac2(unsigned char *buffer,
>  			break;
>  		dpos = va_arg(argp, unsigned int);
>  		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
> -		if (ret < 0) {
> -			va_end(argp);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			break;
>  	}
>  	va_end(argp);
> -	ret = crypto_shash_final(&sdesc->shash, paramdigest);
> +	if (!ret)
> +		ret = crypto_shash_final(&sdesc->shash, paramdigest);
>  	if (ret < 0)
>  		goto out;
> 


