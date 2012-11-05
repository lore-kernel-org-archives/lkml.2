Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2KEDYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 22:24:23 -0500
Received: from ozlabs.org ([203.10.76.45]:43752 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab2KEDYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 22:24:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Beulich <JBeulich@suse.com>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the compiler supports it
In-Reply-To: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 05 Nov 2012 12:49:11 +1030
Message-ID: <87pq3syeow.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <JBeulich@suse.com> writes:
> This makes the resulting diagnostics quite a bit more useful.
>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Nice.  I'm a bit disappointed we can't just treat _Static_assert() as
void, like:

#define BUILD_BUG_ON_ZERO(e) (_Static_assert(!(e), "!(" #e ")"), 0)

> @@ -54,6 +61,15 @@ struct pt_regs;
>   */
>  #ifndef __OPTIMIZE__
>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
> +#elif __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 3)
> +#define __build_bug_on_failed(n) __build_bug_on_##n##_failed
> +#define _BUILD_BUG_ON(n, condition)				\
> +	do {							\
> +		extern void __compiletime_error(#condition)	\
> +		__build_bug_on_failed(n)(void);			\
> +		if (condition) __build_bug_on_failed(n)();	\
> +	} while(0)
> +#define BUILD_BUG_ON(condition...) _BUILD_BUG_ON(__COUNTER__, ##condition)
>  #else
>  extern int __build_bug_on_failed;
>  #define BUILD_BUG_ON(condition)					\

Why does this depend on gcc version?  Looks like residue from an attempt
to use _Static_assert here?

Thanks,
Rusty.
