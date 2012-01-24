Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2AXJPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:15:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:2763 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab2AXJPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:15:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99063738"
Subject: Re: [PATCH] sound: Fix memory leak on error in
 snd_compr_set_params()
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <alpine.LNX.2.00.1201232059540.8772@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201232059540.8772@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Jan 2012 14:46:14 +0530
Message-ID: <1327396574.517.33.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 21:02 +0100, Jesper Juhl wrote:
> If copy_from_user() does not return 0 we'll leak the memory we
> allocated for 'params' when that variable goes out of scope.
> 
> Also a small CodingStyle cleanup: Use braces on both branches of
> if/else when one branch needs it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Thanks for the fix
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
> ---
>  sound/core/compress_offload.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
> index dac3633..a68aed7 100644
> --- a/sound/core/compress_offload.c
> +++ b/sound/core/compress_offload.c
> @@ -441,19 +441,22 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
>  		params = kmalloc(sizeof(*params), GFP_KERNEL);
>  		if (!params)
>  			return -ENOMEM;
> -		if (copy_from_user(params, (void __user *)arg, sizeof(*params)))
> -			return -EFAULT;
> +		if (copy_from_user(params, (void __user *)arg, sizeof(*params))) {
> +			retval = -EFAULT;
> +			goto out;
> +		}
>  		retval = snd_compr_allocate_buffer(stream, params);
>  		if (retval) {
> -			kfree(params);
> -			return -ENOMEM;
> +			retval = -ENOMEM;
> +			goto out;
>  		}
>  		retval = stream->ops->set_params(stream, params);
>  		if (retval)
>  			goto out;
>  		stream->runtime->state = SNDRV_PCM_STATE_SETUP;
> -	} else
> +	} else {
>  		return -EPERM;
> +	}
>  out:
>  	kfree(params);
>  	return retval;
> -- 
> 1.7.8.4
> 
> 


-- 
~Vinod

