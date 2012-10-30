Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956Ab2J3RRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:17:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49320 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964823Ab2J3RRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:17:51 -0400
Date: Tue, 30 Oct 2012 18:17:47 +0100
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
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 8/9] bug.h: Add BUILD_BUG_ON_MSG & _BUILD_BUG_INTERNAL
Message-ID: <20121030171747.GF28499@liondog.tnic>
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
	Steven Rostedt <rostedt@goodmis.org>,
	David Rientjes <rientjes@google.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
 <1351457835-7553-8-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351457835-7553-8-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 03:57:14PM -0500, danielfsantos@att.net wrote:
> Add BUILD_BUG_ON_MSG which behaves like BUILD_BUG_ON (with optimizations
> enabled), except that it allows you to specify the error message you
> want emitted as the third parameter.  Under the hood, this relies on
> _BUILD_BUG_INTERNAL, which does the actual work and is pretty-much
> identical to BUILD_BUG_ON.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> ---
>  include/linux/bug.h |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index 6c38988..3bc1ddf 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -16,6 +16,7 @@ struct pt_regs;
>  #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
>  #define BUILD_BUG_ON_ZERO(e) (0)
>  #define BUILD_BUG_ON_NULL(e) ((void*)0)
> +#define BUILD_BUG_ON_MSG(cond, msg) (0)
>  #define BUILD_BUG_ON(condition) (0)
>  #define BUILD_BUG() (0)
>  #else /* __CHECKER__ */
> @@ -38,6 +39,27 @@ struct pt_regs;
>   */
>  #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
>  
> +#define __BUILD_BUG_INTERNAL(condition, msg, line)		\
> +	do {							\
> +		extern void __build_bug_on_failed_ ## line	\
> +			(void) __compiletime_error(msg);	\
> +		__compiletime_error_fallback(condition);	\
> +		if (condition)					\
> +			__build_bug_on_failed_ ## line();	\
> +	} while (0)
> +
> +#define _BUILD_BUG_INTERNAL(condition, msg, line) \
> +	__BUILD_BUG_INTERNAL(condition, msg, line)

Stupid question:

can BUILD_BUG_ON and BUILD_BUG_ON_MSG both use __BUILD_BUG_INTERNAL?

In the BUILD_BUG_ON msg will be "BUILD_BUG_ON failed" and line empty.
Can that even work?

Thanks.

-- 
Regards/Gruss,
    Boris.
