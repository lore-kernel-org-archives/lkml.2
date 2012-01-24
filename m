Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2AXBrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:47:37 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:38137 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab2AXBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:47:36 -0500
Date: Mon, 23 Jan 2012 21:47:17 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Andy Whitcroft <apw@canonical.com>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Xen-devel] [PATCH] include/checkpatch: Prefer __scanf to __attribute__((format(scanf, ...)
Message-ID: <20120124014717.GA24204@andromeda.dapyr.net>
References: <2cf7ddd75001233e79e928c4dcfae6768af5790c.1327103792.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf7ddd75001233e79e928c4dcfae6768af5790c.1327103792.git.joe@perches.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:01:12PM -0800, Joe Perches wrote:
> It's equivalent to __printf, so prefer __scanf.

So ... looking at this patch it just seems to macro-fy the
__printf and __scanf attributes. Is this required to make
cleanpatch.pl work easier?

And there is also some checkpatch.pl features. Should that part
be in a seperate patch?

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/compiler-gcc.h |    3 ++-
>  include/linux/kernel.h       |    8 ++++----
>  include/xen/xenbus.h         |    4 ++--
>  scripts/checkpatch.pl        |    6 ++++++
>  4 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index 3fd17c2..e5834aa 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -87,7 +87,8 @@
>   */
>  #define __pure				__attribute__((pure))
>  #define __aligned(x)			__attribute__((aligned(x)))
> -#define __printf(a,b)			__attribute__((format(printf,a,b)))
> +#define __printf(a, b)			__attribute__((format(printf, a, b)))
> +#define __scanf(a, b)			__attribute__((format(scanf, a, b)))
>  #define  noinline			__attribute__((noinline))
>  #define __attribute_const__		__attribute__((__const__))
>  #define __maybe_unused			__attribute__((unused))
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index e834342..30f21ec 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -315,10 +315,10 @@ extern __printf(2, 3)
>  char *kasprintf(gfp_t gfp, const char *fmt, ...);
>  extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
>  
> -extern int sscanf(const char *, const char *, ...)
> -	__attribute__ ((format (scanf, 2, 3)));
> -extern int vsscanf(const char *, const char *, va_list)
> -	__attribute__ ((format (scanf, 2, 0)));
> +extern __scanf(2, 3)
> +int sscanf(const char *, const char *, ...);
> +extern __scanf(2, 0)
> +int vsscanf(const char *, const char *, va_list);
>  
>  extern int get_option(char **str, int *pint);
>  extern char *get_options(const char *str, int nints, int *ints);
> diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
> index e8c599b..0a7515c 100644
> --- a/include/xen/xenbus.h
> +++ b/include/xen/xenbus.h
> @@ -139,9 +139,9 @@ int xenbus_transaction_start(struct xenbus_transaction *t);
>  int xenbus_transaction_end(struct xenbus_transaction t, int abort);
>  
>  /* Single read and scanf: returns -errno or num scanned if > 0. */
> +__scanf(4, 5)
>  int xenbus_scanf(struct xenbus_transaction t,
> -		 const char *dir, const char *node, const char *fmt, ...)
> -	__attribute__((format(scanf, 4, 5)));
> +		 const char *dir, const char *node, const char *fmt, ...);
>  
>  /* Single printf and write: returns -errno or 0. */
>  __printf(4, 5)
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index e3bfcbe..2b52aeb 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3117,6 +3117,12 @@ sub process {
>  			     "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr);
>  		}
>  
> +# Check for __attribute__ format(scanf, prefer __scanf
> +		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\b/) {
> +			WARN("PREFER_SCANF",
> +			     "__scanf(string-index, first-to-check) is preferred over __attribute__((format(scanf, string-index, first-to-check)))\n" . $herecurr);
> +		}
> +
>  # check for sizeof(&)
>  		if ($line =~ /\bsizeof\s*\(\s*\&/) {
>  			WARN("SIZEOF_ADDRESS",
> -- 
> 1.7.8.111.gad25c.dirty
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
