Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1DRXCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:02:19 -0400
Received: from expn.cat.pdx.edu ([131.252.208.110]:55495 "EHLO
	expn.cat.pdx.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1DRXCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:02:17 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 19:02:17 EDT
Message-ID: <4DACC1B1.8090808@freedesktop.org>
Date: Mon, 18 Apr 2011 15:56:49 -0700
From: Ian Romanick <idr@freedesktop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm: Create and use drm_err
References: <cover.1303097621.git.joe@perches.com> <d70d2c8ad548f99e8d028a2fbd4c5b35609f8917.1303097621.git.joe@perches.com>
In-Reply-To: <d70d2c8ad548f99e8d028a2fbd4c5b35609f8917.1303097621.git.joe@perches.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (expn.cat.pdx.edu [131.252.208.110]); Mon, 18 Apr 2011 15:56:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/17/2011 08:35 PM, Joe Perches wrote:
> Reduce drm text size ~1% by using drm_err and
> printf extension %pV to emit error messages.
> 
> Remove unused macro DRM_MEM_ERROR.
> 
> $ size drivers/gpu/drm/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  361159	   9663	    256	 371078	  5a986	drivers/gpu/drm/built-in.o.new
>  365416	   9663	    256	 375335	  5ba27	drivers/gpu/drm/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/gpu/drm/drm_stub.c |   21 +++++++++++++++++++++
>  include/drm/drmP.h         |   21 +++++++--------------
>  2 files changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
> index 001273d..6d7b083 100644
> --- a/drivers/gpu/drm/drm_stub.c
> +++ b/drivers/gpu/drm/drm_stub.c
> @@ -62,6 +62,26 @@ struct idr drm_minors_idr;
>  struct class *drm_class;
>  struct proc_dir_entry *drm_proc_root;
>  struct dentry *drm_debugfs_root;
> +
> +int drm_err(const char *func, const char *format, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +	int r;
> +
> +	va_start(args, format);
> +
> +	vaf.fmt = format;
> +	vaf.va = &args;
> +
> +	r = printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);

This code has ben reorganized a lot over the years, so this comment may
be bogus.  However...

I believe that DRM_NAME is a define, and drm_stub.c is in common code.
As a result, won't this change cause something different to get logged?

> +
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(drm_err);
> +
>  void drm_ut_debug_printk(unsigned int request_level,
>  			 const char *prefix,
>  			 const char *function_name,
> @@ -78,6 +98,7 @@ void drm_ut_debug_printk(unsigned int request_level,
>  	}
>  }
>  EXPORT_SYMBOL(drm_ut_debug_printk);
> +
>  static int drm_minor_get_id(struct drm_device *dev, int type)
>  {
>  	int new_id;
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 202424d..22db51d 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -126,6 +126,9 @@ extern void drm_ut_debug_printk(unsigned int request_level,
>  				const char *prefix,
>  				const char *function_name,
>  				const char *format, ...);
> +extern __attribute__((format (printf, 2, 3)))
> +int drm_err(const char *func, const char *format, ...);
> +
>  /***********************************************************************/
>  /** \name DRM template customization defaults */
>  /*@{*/
> @@ -181,21 +184,11 @@ extern void drm_ut_debug_printk(unsigned int request_level,
>   * \param fmt printf() like format string.
>   * \param arg arguments
>   */
> -#define DRM_ERROR(fmt, arg...) \
> -	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
> -
> -/**
> - * Memory error output.
> - *
> - * \param area memory area where the error occurred.
> - * \param fmt printf() like format string.
> - * \param arg arguments
> - */
> -#define DRM_MEM_ERROR(area, fmt, arg...) \
> -	printk(KERN_ERR "[" DRM_NAME ":%s:%s] *ERROR* " fmt , __func__, \
> -	       drm_mem_stats[area].name , ##arg)
> +#define DRM_ERROR(fmt, ...)				\
> +	drm_err(__func__, fmt, ##__VA_ARGS__)
>  
> -#define DRM_INFO(fmt, arg...)  printk(KERN_INFO "[" DRM_NAME "] " fmt , ##arg)
> +#define DRM_INFO(fmt, ...)				\
> +	printk(KERN_INFO "[" DRM_NAME "] " fmt, ##__VA_ARGS__)
>  
>  /**
>   * Debug output.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk2swbEACgkQX1gOwKyEAw+w/ACfd2QMJWOQU5f9sgavPXkfPPfW
GygAn2D8bjKkIV8wOXYC1fOI9w4DPWHj
=q3FM
-----END PGP SIGNATURE-----
