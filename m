Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab0LIDYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:24:07 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45553 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0LIDYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:24:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qV8pD10MH7B1hVNIXatZj5EXdGzChCVXsK1dufnwfQAC9X/nzcX39JCjQyXlRXaPgY
         cEK5NxmzA0ndgs/3orEnrKyifC6T1qP8j2Aa4MJksPjmnkynopfEQkKvBrQdtS9owCbp
         +yQeFRijXYm1RhDgcf+CZcFSHIdJTvXe8Eq74=
Subject: Re: [PATCH] kptr_restrict for hiding kernel pointers from
 unprivileged users
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <1291863926.2965.1.camel@Dan>
References: <1291863926.2965.1.camel@Dan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 04:23:59 +0100
Message-ID: <1291865039.2795.46.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 décembre 2010 à 22:05 -0500, Dan Rosenberg a écrit :
> The below patch adds the %pK format specifier, the
> CONFIG_SECURITY_KPTR_RESTRICT configuration option, and the
> kptr_restrict sysctl.
> 
> The %pK format specifier is designed to hide exposed kernel pointers
> from unprivileged users, specifically via /proc interfaces.  Its
> behavior depends on the kptr_restrict sysctl, whose default value
> depends on CONFIG_SECURITY_KPTR_RESTRICT.  If kptr_restrict is set to 0,
> no deviation from the standard %p behavior occurs.  If kptr_restrict is
> set to 1, if the current user (intended to be a reader via seq_printf(),
> etc.) does not have CAP_SYSLOG (which is currently in the LSM tree),
> kernel pointers using %pK are printed as 0's.  This was chosen over the
> default "(null)", which cannot be parsed by userland %p, which expects
> "(nil)".
> 

Thanks for not giving credits to people suggesting this idea to you
(Thomas if I remember well), and not Ccing netdev where original
discussion took place. 


> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> --- 
> Documentation/sysctl/kernel.txt |   14 ++++++++++++++
>  include/linux/kernel.h          |    2 ++
>  kernel/sysctl.c                 |    9 +++++++++
>  lib/vsprintf.c                  |   18 ++++++++++++++++++
>  security/Kconfig                |   12 ++++++++++++
>  5 files changed, 55 insertions(+), 0 deletions(-)

...

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index c150d3d..c011249 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -936,6 +936,8 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
>  	return string(buf, end, uuid, spec);
>  }
>  
> +int kptr_restrict = CONFIG_SECURITY_KPTR_RESTRICT;
> +
>  /*
>   * Show a '%p' thing.  A kernel extension is that the '%p' is followed
>   * by an extra set of alphanumeric characters that are extended format
> @@ -979,6 +981,7 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
>   *       Implements a "recursive vsnprintf".
>   *       Do not use this feature without some mechanism to verify the
>   *       correctness of the format string and va_list arguments.
> + * - 'K' For a kernel pointer that should be hidden from unprivileged users
>   *
>   * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>   * function pointers are really function descriptors, which contain a
> @@ -1035,6 +1038,21 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		return buf + vsnprintf(buf, end - buf,
>  				       ((struct va_format *)ptr)->fmt,
>  				       *(((struct va_format *)ptr)->va));
> +	case 'K':
> +		if (kptr_restrict) {
> +			if (in_interrupt())
> +				WARN(1, "%%pK used in interrupt context.\n");

So caller can not block BH ?

This seems wrong to me, please consider :

normal process context :

spin_lock_bh() ...

for (...)  
	{xxx}printf( ...   "%pK"   ...)

spin_unlock_bh();


> +
> +			else if (capable(CAP_SYSLOG))
> +				break;
> +
> +			if (spec.field_width == -1) {
> +				spec.field_width = 2 * sizeof(void *);
> +				spec.flags |= ZEROPAD;
> +			}
> +			return number(buf, end, 0, spec);
> +		}
> +		break;
>  	}
>  	spec.flags |= SMALL;
>  	if (spec.field_width == -1) {
> diff --git a/security/Kconfig b/security/Kconfig
> index e80da95..944fc73 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -51,6 +51,18 @@ config SECURITY_DMESG_RESTRICT
>  
>  	  If you are unsure how to answer this question, answer N.
>  
> +config SECURITY_KPTR_RESTRICT
> +	bool "Hide kernel pointers from unprivileged users"
> +	default n
> +	help
> +	  This enforces restrictions on unprivileged users reading kernel
> +	  addresses via various interfaces, e.g. /proc.
> +
> +	  If this option is not selected, no restrictions will be enforced
> +	  unless the kptr_restrict sysctl is explicitly set to (1).
> +
> +	  If you are unsure how to answer this question, answer N.
> +
>  config SECURITY
>  	bool "Enable different security models"
>  	depends on SYSFS
> 


