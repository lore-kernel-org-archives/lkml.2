Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab2JFRm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:42:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34419 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2JFRmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:42:23 -0400
Date: Sat, 6 Oct 2012 19:42:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: danielfsantos@att.net
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v2 01/10] compiler-gcc4.h: Reorder macros based upon gcc
 ver
Message-ID: <20121006174220.GB6110@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, danielfsantos@att.net,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Howells <dhowells@redhat.com>,
	David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>,
	Daniel Santos <daniel.santos@pobox.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
 <1349466169-20637-1-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349466169-20637-1-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 02:42:40PM -0500, danielfsantos@att.net wrote:
> This helps to keep the file from getting confusing, removes one
> duplicate version check and should encourage future editors to put new
> macros where they belong.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> Acked-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/compiler-gcc4.h |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 8721704..4506d65 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -13,6 +13,10 @@
>  #define __must_check 		__attribute__((warn_unused_result))
>  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
>  
> +#if __GNUC_MINOR__ > 0
> +# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
> +#endif
> +
>  #if __GNUC_MINOR__ >= 3
>  /* Mark functions as cold. gcc will assume any path leading to a call
>     to them will be unlikely.  This means a lot of manual unlikely()s
> @@ -31,6 +35,12 @@
>  
>  #define __linktime_error(message) __attribute__((__error__(message)))
>  
> +#ifndef __CHECKER__
> +# define __compiletime_warning(message) __attribute__((warning(message)))
> +# define __compiletime_error(message) __attribute__((error(message)))
> +#endif /* __CHECKER__ */
> +#endif /* __GNUC_MINOR__ >= 3 */
> +
>  #if __GNUC_MINOR__ >= 5
>  /*
>   * Mark a position in code as unreachable.  This can be used to
> @@ -46,8 +56,7 @@
>  /* Mark a function definition as prohibited from being cloned. */
>  #define __noclone	__attribute__((__noclone__))
>  
> -#endif
> -#endif
> +#endif /* __GNUC_MINOR__ >= 5 */
>  
>  #if __GNUC_MINOR__ >= 6
>  /*
> @@ -56,10 +65,3 @@
>  #define __visible __attribute__((externally_visible))
>  #endif
>  
> -#if __GNUC_MINOR__ > 0
> -#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
> -#endif
> -#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)

This last hunk doesn't apply since mainline has a "4" above instead of
"3". And it has had a "4" since it got added by 4a3127693001c so unless
I'm missing something, how did the 3 appear in your patches?

> -#define __compiletime_warning(message) __attribute__((warning(message)))
> -#define __compiletime_error(message) __attribute__((error(message)))
> -#endif
> -- 
> 1.7.3.4

Thanks.

-- 
Regards/Gruss,
    Boris.
