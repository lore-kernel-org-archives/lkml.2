Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0JOOYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:24:53 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:21839 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab0JOOYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:24:52 -0400
Message-ID: <4CB86431.5000305@bfs.de>
Date: Fri, 15 Oct 2010 16:24:49 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/staging: Return -ENOMEM on memory allocation
 failure
References: <1287147610-8041-2-git-send-email-julia@diku.dk>
In-Reply-To: <1287147610-8041-2-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a case for kasprintf().

re
 wh

Julia Lawall schrieb:
> From: Julia Lawall <julia@diku.dk>
> 
> Each of these functions defines a variable err and a variable retval.  err
> is always 0 and is returned in the error case.  At one point near the end
> of the function, retval is initialized to an error code.  For each
> function, the patch drops err, stores -ENOMEM in retval in two cases where
> memory allocation fails, and changes the return value in the error case
> from err to retval.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression ret;
> expression x,e1,e2,e3;
> @@
> 
> ret = 0
> ... when != ret = e1
> *x = \(kmalloc\|kcalloc\|kzalloc\)(...)
> ... when != ret = e2
> if (x == NULL) { ... when != ret = e3
>   return ret;
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/staging/cx25821/cx25821-audio-upstream.c     |   11 +++++++----
>  drivers/staging/cx25821/cx25821-video-upstream-ch2.c |   11 +++++++----
>  drivers/staging/cx25821/cx25821-video-upstream.c     |   11 +++++++----
>  3 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff -u -p a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
> --- a/drivers/staging/cx25821/cx25821-audio-upstream.c
> +++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
> @@ -723,7 +723,6 @@ int cx25821_audio_upstream_init(struct c
>  {
>  	struct sram_channel *sram_ch;
>  	int retval = 0;
> -	int err = 0;
>  	int str_length = 0;
>  
>  	if (dev->_audio_is_running) {
> @@ -756,8 +755,10 @@ int cx25821_audio_upstream_init(struct c
>  		str_length = strlen(dev->input_audiofilename);
>  		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
>  
> -		if (!dev->_audiofilename)
> +		if (!dev->_audiofilename) {
> +			retval = -ENOMEM;
>  			goto error;
> +		}
>  
>  		memcpy(dev->_audiofilename, dev->input_audiofilename,
>  		       str_length + 1);
> @@ -770,8 +771,10 @@ int cx25821_audio_upstream_init(struct c
>  		str_length = strlen(_defaultAudioName);
>  		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
>  
> -		if (!dev->_audiofilename)
> +		if (!dev->_audiofilename) {
> +			retval = -ENOMEM;
>  			goto error;
> +		}
>  
>  		memcpy(dev->_audiofilename, _defaultAudioName, str_length + 1);
>  	}
> @@ -802,5 +805,5 @@ int cx25821_audio_upstream_init(struct c
>  error:
>  	cx25821_dev_unregister(dev);
>  
> -	return err;
> +	return retval;
>  }
> diff -u -p a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> --- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> +++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> @@ -747,7 +747,6 @@ int cx25821_vidupstream_init_ch2(struct 
>  	struct sram_channel *sram_ch;
>  	u32 tmp;
>  	int retval = 0;
> -	int err = 0;
>  	int data_frame_size = 0;
>  	int risc_buffer_size = 0;
>  	int str_length = 0;
> @@ -792,8 +791,10 @@ int cx25821_vidupstream_init_ch2(struct 
>  		str_length = strlen(dev->input_filename_ch2);
>  		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
>  
> -		if (!dev->_filename_ch2)
> +		if (!dev->_filename_ch2) {
> +			retval = -ENOMEM;
>  			goto error;
> +		}
>  
>  		memcpy(dev->_filename_ch2, dev->input_filename_ch2,
>  		       str_length + 1);
> @@ -801,8 +802,10 @@ int cx25821_vidupstream_init_ch2(struct 
>  		str_length = strlen(dev->_defaultname_ch2);
>  		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
>  
> -		if (!dev->_filename_ch2)
> +		if (!dev->_filename_ch2) {
> +			retval = -ENOMEM;
>  			goto error;
> +		}
>  
>  		memcpy(dev->_filename_ch2, dev->_defaultname_ch2,
>  		       str_length + 1);
> @@ -851,5 +854,5 @@ int cx25821_vidupstream_init_ch2(struct 
>        error:
>  	cx25821_dev_unregister(dev);
>  
> -	return err;
> +	return retval;
>  }
> diff -u -p a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
> --- a/drivers/staging/cx25821/cx25821-video-upstream.c
> +++ b/drivers/staging/cx25821/cx25821-video-upstream.c
> @@ -800,7 +800,6 @@ int cx25821_vidupstream_init_ch1(struct 
>  	struct sram_channel *sram_ch;
>  	u32 tmp;
>  	int retval = 0;
> -	int err = 0;
>  	int data_frame_size = 0;
>  	int risc_buffer_size = 0;
>  	int str_length = 0;
> @@ -844,16 +843,20 @@ int cx25821_vidupstream_init_ch1(struct 
>  		str_length = strlen(dev->input_filename);
>  		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
>  
> -		if (!dev->_filename)
> +		if (!dev->_filename) {
> +			retval = -ENOMEM;
>  			goto error;
> +		}
>  
>  		memcpy(dev->_filename, dev->input_filename, str_length + 1);
>  	} else {
>  		str_length = strlen(dev->_defaultname);
>  		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
>  
> -		if (!dev->_filename)
> +		if (!dev->_filename) {
> +			retval = -ENOMEM;
>  			goto error;
> +		}
>  
>  		memcpy(dev->_filename, dev->_defaultname, str_length + 1);
>  	}
> @@ -908,5 +911,5 @@ int cx25821_vidupstream_init_ch1(struct 
>  error:
>  	cx25821_dev_unregister(dev);
>  
> -	return err;
> +	return retval;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
