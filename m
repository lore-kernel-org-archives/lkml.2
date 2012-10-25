Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360Ab2JYJdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:33:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37510 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935099Ab2JYJdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:33:38 -0400
Date: Thu, 25 Oct 2012 11:33:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: danielfsantos@att.net
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
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 06/10] bug.h: Make BUILD_BUG_ON generate compile-time
 error
Message-ID: <20121025093336.GC16601@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, danielfsantos@att.net,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
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
	Steven Rostedt <rostedt@goodmis.org>,
	David Rientjes <rientjes@google.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
 <1351096441-12388-6-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351096441-12388-6-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:33:57AM -0500, danielfsantos@att.net wrote:
> Negative sized arrays wont create a compile-time error in some cases
> starting with gcc 4.4 (e.g., inlined functions), but gcc 4.3 introduced
> the error function attribute that will.  This patch modifies
> BUILD_BUG_ON to behave like BUILD_BUG already does, using the error
> function attribute so that you don't have to build the entire kernel to
> discover that you have a problem, and then enjoy trying to track it down
> from a link-time error.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> ---
>  include/linux/bug.h |   24 ++++++++++++++----------
>  1 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index a03c3ef..3d4b564 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -43,24 +43,28 @@ struct pt_regs;
>   * @condition: the condition which the compiler should know is false.
>   *
>   * If you have some code which relies on certain constants being equal, or
> - * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
> + * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
>   * detect if someone changes it.
>   *
>   * The implementation uses gcc's reluctance to create a negative array, but
>   * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
> - * to inline functions).  So as a fallback we use the optimizer; if it can't
> - * prove the condition is false, it will cause a link error on the undefined
> - * "__build_bug_on_failed".  This error message can be harder to track down
> - * though, hence the two different methods.
> + * to inline functions).  Luckily, in 4.3 they added the "error" function
> + * attribute just for this type of case.  Thus, we use a negative sized array
> + * (should always create an error pre-gcc-4.4) and then call an undefined

	.... always create an error on gcc versions older than 4.4)

> + * function with the error attribute (should always creates an error 4.3+).  If

					..... always create an error on gcc 4.3 and later)

> + * for some reason, neither creates a compile-time error, we'll still have a
> + * link-time error, which is harder to track down.
>   */
>  #ifndef __OPTIMIZE__
>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>  #else
> -extern int __build_bug_on_failed;
> -#define BUILD_BUG_ON(condition)					\
> -	do {							\
> -		((void)sizeof(char[1 - 2*!!(condition)]));	\
> -		if (condition) __build_bug_on_failed = 1;	\
> +#define BUILD_BUG_ON(condition)						\
> +	do {								\
> +		extern void __build_bug_on_failed(void)			\
> +			__compiletime_error("BUILD_BUG_ON failed");	\
> +		((void)sizeof(char[1 - 2*!!(condition)]));		\
> +		if (condition)						\
> +			__build_bug_on_failed();			\
>  	} while(0)
>  #endif

With the changes above:

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
    Boris.
