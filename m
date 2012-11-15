Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768216Ab2KOPHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:07:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56509 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768160Ab2KOPHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:07:46 -0500
Date: Thu, 15 Nov 2012 16:08:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 8/9] compiler.h, bug.h: Prevent double error messages
 with BUILD_BUG{,_ON}
Message-ID: <20121115150804.GF4956@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
 <1352844821-18952-8-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1352844821-18952-8-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 04:13:40PM -0600, danielfsantos@att.net wrote:
> Prior to the introduction of __attribute__((error("msg"))) in gcc 4.3,
> creating compile-time errors required a little trickery.
> BUILD_BUG{,_ON} uses this attribute when available to generate
> compile-time errors, but also uses the negative-sized array trick for
> older compilers, resulting in two error messages in some cases.  The
> reason it's "some" cases is that as of gcc 4.4, the negative-sized array
> will not create an error in some situations, like inline functions.
> 
> This patch replaces the negative-sized array code with the new
> __compiletime_error_fallback() macro which expands to the same thing
> unless the the error attribute is available, in which case it expands to
> do{}while(0), resulting in exactly one compile-time error on all
> versions of gcc.
> 
> Note that we are not changing the negative-sized array code for the
> unoptimized version of BUILD_BUG_ON, since it has the potential to catch
> problems that would be disabled in later versions of gcc were
> __compiletime_error_fallback used.  The reason is that that an
> unoptimized build can't always remove calls to an error-attributed
> function call (like we are using) that should effectively become dead
> code if it were optimized.  However, using a negative-sized array with a
> similar value will not result in an false-positive (error). The only
> caveat being that it will also fail to catch valid conditions, which we
> should be expecting in an unoptimized build anyway.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> ---
>  include/linux/bug.h      |    2 +-
>  include/linux/compiler.h |    5 +++++
>  2 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index dd4f506..125e744 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -66,7 +66,7 @@ struct pt_regs;
>  			__compiletime_error("BUILD_BUG_ON failed");	\
>  		if (__cond)						\
>  			__build_bug_on_failed();			\
> -		((void)sizeof(char[1 - 2*!!(__cond)]));			\
> +		__compiletime_error_fallback(__cond);			\

We're passing an already evaluated __cond here which gets doubly-negated
again in __compiletime_error_fallback. If __compiletime_error_fallback
is going to be called only from BUILD_BUG_ON, then its definition should
be:

	do { ((void)sizeof(char[1 - 2 * (condition)])); } while (0)

i.e., without the !!.


>  	} while(0)
>  #endif
>  
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index cbf6d9d..8e5b9d5 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -298,7 +298,12 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  #endif
>  #ifndef __compiletime_error
>  # define __compiletime_error(message)
> +# define __compiletime_error_fallback(condition) \
> +	do { ((void)sizeof(char[1 - 2*!!(condition)])); } while (0)
> +#else
> +# define __compiletime_error_fallback(condition) do { } while (0)
>  #endif
> +
>  /*
>   * Prevent the compiler from merging or refetching accesses.  The compiler
>   * is also forbidden from reordering successive instances of ACCESS_ONCE(),
> -- 
> 1.7.3.4

Thanks.

-- 
Regards/Gruss,
Boris.
