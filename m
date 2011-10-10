Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1JJPEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:04:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1JJPEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:04:47 -0400
Date: Mon, 10 Oct 2011 17:04:44 +0200
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, NamJae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] udf: Neaten logging output, use vsprintf extension
 %pV
Message-ID: <20111010150444.GD3944@quack.suse.cz>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
 <cover.1318233879.git.joe@perches.com>
 <f6af3ca08d9e966de00d77cc9a8251d91666f33f.1318233879.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6af3ca08d9e966de00d77cc9a8251d91666f33f.1318233879.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-10-11 01:08:06, Joe Perches wrote:
> Remove the warning and error prefixes that duplicate KERN_<level>.
  Please keep that in the prefix. It's easier to read messages when they
are that way ...

> Use %pV and remove a static buffer to save some text space.
  This is actually a bugfix because we could corrupt error message when
several error messages would be reported in parallel... Thanks for finding
this.

								Honza  
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/udf/super.c |   28 +++++++++++++++++-----------
>  1 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index ea1b44b..b72c5ab 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -75,8 +75,6 @@
>  
>  #define UDF_DEFAULT_BLOCKSIZE 2048
>  
> -static char error_buf[1024];
> -
>  /* These are the "meat" - everything else is stuffing */
>  static int udf_fill_super(struct super_block *, void *, int);
>  static void udf_put_super(struct super_block *);
> @@ -2075,29 +2073,37 @@ error_out:
>  void _udf_err(struct super_block *sb, const char *function,
>  	      const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
> -	if (!(sb->s_flags & MS_RDONLY)) {
> -		/* mark sb error */
> +	/* mark sb error */
> +	if (!(sb->s_flags & MS_RDONLY))
>  		sb->s_dirt = 1;
> -	}
> +
>  	va_start(args, fmt);
> -	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	pr_crit("device %s: %s: %pV", sb->s_id, function, &vaf);
> +
>  	va_end(args);
> -	pr_crit("error (device %s): %s: %s",
> -	       sb->s_id, function, error_buf);
>  }
>  
>  void _udf_warn(struct super_block *sb, const char *function,
>  	       const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	pr_warn("device %s: %s: %pV", sb->s_id, function, &vaf);
> +
>  	va_end(args);
> -	pr_warn("warning (device %s): %s: %s",
> -	       sb->s_id, function, error_buf);
>  }
>  
>  static void udf_put_super(struct super_block *sb)
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
