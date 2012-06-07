Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab2FGNQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:16:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:57035 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597Ab2FGNQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:16:48 -0400
Message-ID: <4FD0A9B9.3050608@windriver.com>
Date: Thu, 7 Jun 2012 09:16:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: <daniel.santos@pobox.com>
CC: Daniel Santos <danielfsantos@att.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 1/6] [RFC] compiler{,-gcc4}.h: Remove duplicate macro
 & cleanup
References: <4FD070F9.3060709@att.net>
In-Reply-To: <4FD070F9.3060709@att.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-06-07 05:14 AM, Daniel Santos wrote:
> __linktime_error() does the same thing as __compiletime_error() and is
> only used in bug.h.  Since the macro defines a function attribute that
> will cause a failure at compile-time (not link-time), it makes more
> sense to keep __compiletime_error(), which is also neatly mated with
> __compiletime_warning().
> 
> However, gcc version check for __compiletime_error() prevented its use
> one minor version after it was availble (4.4 instead of 4.3). So to fix
> this and clean things up a bit, I've moved it in with other macros
> defined for 4.3 and later.

When you find yourself making lists of changes like this, it is good
to consider instead breaking it up into separate logical changes for
ease of review and integration -- i.e. if the compiletime_error was
incorrectly limited to 4.4+ instead of 4.3+ then make that as a commit.

Also, your removal of linktime error from compiler.h probably breaks
anyone who might still be trying to use gcc-3.x (I don't know without
looking, which arch still support it).

Finally, you should expand your cc list to include folks like Andrew,
Rusty, Ingo, Andi, etc. to get more (and likely better quality) review
comments.

P.
--
 
> 
> Finally, I moved __compiletime_object_size() towards the top of the file
> so that all macros are defined in order of the gcc version they appear
> in.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> ---
>  include/linux/compiler-gcc4.h |   21 ++++++++++-----------
>  include/linux/compiler.h      |    3 ---
>  2 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 2f40791..77be10c 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -13,6 +13,10 @@
>  #define __must_check 		__attribute__((warn_unused_result))
>  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
>  +#if __GNUC_MINOR__ >= 1
> +#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
> +#endif /* __GNUC_MINOR__ >= 1 */
> +
>  #if __GNUC_MINOR__ >= 3
>  /* Mark functions as cold. gcc will assume any path leading to a call
>     to them will be unlikely.  This means a lot of manual unlikely()s
> @@ -29,7 +33,11 @@
>     the kernel context */
>  #define __cold			__attribute__((__cold__))
>  -#define __linktime_error(message) __attribute__((__error__(message)))
> +#if !defined(__CHECKER__)
> +#define __compiletime_warning(message) __attribute__((warning(message)))
> +#define __compiletime_error(message) __attribute__((error(message)))
> +#endif /* !defined(__CHECKER__) */
> +#endif /* __GNUC_MINOR__ >= 3 */
>   #if __GNUC_MINOR__ >= 5
>  /*
> @@ -45,14 +53,5 @@
>   /* Mark a function definition as prohibited from being cloned. */
>  #define __noclone	__attribute__((__noclone__))
> +#endif /* __GNUC_MINOR__ >= 5 */
>  -#endif
> -#endif
> -
> -#if __GNUC_MINOR__ > 0
> -#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
> -#endif
> -#if __GNUC_MINOR__ >= 4 && !defined(__CHECKER__)
> -#define __compiletime_warning(message) __attribute__((warning(message)))
> -#define __compiletime_error(message) __attribute__((error(message)))
> -#endif
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 923d093..4d9f353 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -293,9 +293,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  #ifndef __compiletime_error
>  # define __compiletime_error(message)
>  #endif
> -#ifndef __linktime_error
> -# define __linktime_error(message)
> -#endif
>  /*
>   * Prevent the compiler from merging or refetching accesses.  The compiler
>   * is also forbidden from reordering successive instances of ACCESS_ONCE(),
