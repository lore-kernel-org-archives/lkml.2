Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2KRCoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 21:44:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61564 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab2KRCoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 21:44:04 -0500
Date: Sat, 17 Nov 2012 18:40:53 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dragos.tatulea@intel.com
Cc: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        octavian.purdila@intel.com
Subject: Re: [PATCH v3 7/9] pstore: make sure pstore_write exists on flush
 error
Message-ID: <20121118024052.GA12833@lizard.sbx05977.paloaca.wayport.net>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
 <1350558367-31801-8-git-send-email-dragos.tatulea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350558367-31801-8-git-send-email-dragos.tatulea@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:06:05PM +0300, dragos.tatulea@intel.com wrote:
> From: Dragos Tatulea <dragos.tatulea@intel.com>
> 
> Return error if flushing to backend failed.

I think you can easily fold this into 'pstore: add support for external
writers'.

Thanks.

> Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
> ---
>  fs/pstore/platform.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 3a4c38f..25f59ed 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -445,7 +445,7 @@ void pstore_del_timer(void)
>  int pstore_write(enum pstore_type_id type, const char *buf, size_t size)
>  {
>  	size_t len;
> -	int err = 0, err2;
> +	int err = 0;
>  
>  	if (!psinfo)
>  		return -ENODEV;
> @@ -461,16 +461,14 @@ int pstore_write(enum pstore_type_id type, const char *buf, size_t size)
>  		psinfo->ext_part = 1;
>  	}
>  
> -	while (size) {
> +	while (size && !err) {
>  		len = min(size, psinfo->bufsize - psinfo->ext_len);
>  		memcpy(psinfo->buf + psinfo->ext_len, buf, len);
>  		psinfo->ext_len += len;
>  		buf += len;
>  		size -= len;
>  		if (psinfo->ext_len == psinfo->bufsize) {
> -			err2 = pstore_ext_flush();
> -			if (err2 && !err)
> -				err = err2;
> +			err = pstore_ext_flush();
>  		}
>  	}
>  
> -- 
> 1.7.9.5
