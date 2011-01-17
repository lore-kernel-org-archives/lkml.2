Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1AQVBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:01:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:39233 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1AQVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:01:41 -0500
Subject: Re: [PATCH 1/3] trusted-keys: another free memory bugfix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: safford@watson.ibm.com, David Safford <safford@us.ibm.com>,
        jj@chaosbits.net, dhowells@redhat.com, jmorris@namei.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201101170039.p0H0d1f5085735@www262.sakura.ne.jp>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
	 <1295011682.7804.2.camel@localhost.localdomain>
	 <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp>
	 <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
	 <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net>
	 <201101170039.p0H0d1f5085735@www262.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 16:01:32 -0500
Message-ID: <1295298092.2642.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 09:39 +0900, Tetsuo Handa wrote:
> Resending in separated mails in case somebody missed that
> there was 3 patches in one mail.
> ----------------------------------------
> From 94e965700f1e401408836d4aa782105483196842 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 17 Jan 2011 09:22:47 +0900
> Subject: [PATCH 1/3] trusted-keys: another free memory bugfix
> 
> TSS_rawhmac() forgot to call va_end()/kfree() when data == NULL and
> forgot to call va_end() when crypto_shash_update() < 0.
> Fix these bugs by escaping from the loop using "break"
> (rather than "return"/"goto") in order to make sure that
> va_end()/kfree() are always called.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  security/keys/trusted_defined.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
> index 932f868..7b21795 100644
> --- a/security/keys/trusted_defined.c
> +++ b/security/keys/trusted_defined.c
> @@ -101,11 +101,13 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
>  		if (dlen == 0)
>  			break;
>  		data = va_arg(argp, unsigned char *);
> -		if (data == NULL)
> -			return -EINVAL;
> +		if (data == NULL) {
> +			ret = -EINVAL;
> +			break;
> +		}
>  		ret = crypto_shash_update(&sdesc->shash, data, dlen);
>  		if (ret < 0)
> -			goto out;
> +			break;
>  	}
>  	va_end(argp);
>  	if (!ret)


