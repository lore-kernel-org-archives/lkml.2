Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab3AIP15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:27:57 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55217 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab3AIP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:27:55 -0500
Date: Wed, 9 Jan 2013 10:27:53 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Proposed removal of IS_ERR_OR_NULL() (was: Re: [PATCH
 1/4] gpiolib: introduce descriptor-based GPIO interface)
In-Reply-To: <20130109150427.GL3931@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1301091020580.6300@xanadu.home>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301081259.29839.arnd@arndb.de> <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com> <201301091035.23206.arnd@arndb.de> <20130109104414.GF3931@n2100.arm.linux.org.uk>
 <20130109111055.GG3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301090932400.6300@xanadu.home> <20130109150427.GL3931@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2013, Russell King - ARM Linux wrote:

> So, it seems there's some concensus building here, and it seems that
> I've become the chosen victi^wvolunteer for this.  So, here's a patch.
> It's missing a Guns-supplied-by: tag though.

Guns-supplied-by: NRA (obviously)

> From: Russell King <rmk+kernel@arm.linux.org.uk>
> Subject: Mark IS_ERR_OR_NULL() deprecated
> 
> IS_ERR_OR_NULL() attracts a lot of abuse: people use it without much
> thought about it's effects.  Common errors include:
>  1. checking the returned pointer for functions defined as only
>     returning errno-pointer values, rather than using IS_ERR().
>     This leads to: ptr = foo(); if (IS_ERR_OR_NULL(ptr)) return
>      PTR_ERR(ptr);
>  2. using it to check functions which only ever return NULL on error,
>     thereby leading to another zero-error value return.
> In the case of debugfs functions, these return errno-pointer values when
> debugfs is configured out, which means code which blindly checks using 
> IS_ERR_OR_NULL() ends up returning errors, which is rather perverse for
> something that's not implemented.
> 
> Therefore, let's schedule it for removal in a few releases.
> 
> Nicolas Pitre comments:
> > I do agree with Russell here.  Despite the original intentions behind
> > IS_ERR_OR_NULL() which were certainly legitimate, the end result in
> > practice is less reliable code with increased maintenance costs.
> > Unlike other convenience macros in the kernel, this one is giving a
> > false sense of correctness with too many people falling in the trap
> > of using it just because it is available.
> > 
> > I strongly think this macro should simply be removed from the source
> > tree entirely and the code reverted to explicit tests against NULL
> > when appropriate.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Tape-measuring-service-offered-by: Will Deacon <will.deacon@arm.com>
> Victim-for-firing-sqad: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Nicolas Pitre <nico@linaro.org>

Anyone with good coccinelle skills around to deal with the users?


> ---
> Ok, so I'm in the firing line for suggesting this, but it appears
> several people wish this to happen.
> 
> I'm not intending to push this patch forwards _just_ yet: we need to
> sort out the existing users _first_ to prevent the kernel turning into
> one hell of a mess of warnings.
> 
>  include/linux/err.h |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/err.h b/include/linux/err.h
> index f2edce2..d5a85df 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -34,7 +34,22 @@ static inline long __must_check IS_ERR(const void *ptr)
>  	return IS_ERR_VALUE((unsigned long)ptr);
>  }
>  
> -static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
> +/*
> + * IS_ERR_OR_NULL() attracts a lot of abuse: people use it without much
> + * thought about it's effects.  Common errors include:
> + *  1. checking the returned pointer for functions defined as only returning
> + *     errno-pointer values, rather than using IS_ERR().
> + *     This leads to: ptr = foo(); if (IS_ERR_OR_NULL(ptr)) return PTR_ERR(ptr);
> + *  2. using it to check functions which only ever return NULL on error,
> + *     thereby leading to another zero-error value return.
> + * In the case of debugfs functions, these return errno-pointer values when
> + * debugfs is configured out, which means code which blindly checks using
> + * IS_ERR_OR_NULL() ends up returning errors, which is rather perverse for
> + * something that's not implemented.
> + *
> + * Therefore, let's schedule it for removal in a few releases.
> + */
> +static inline long __must_check __deprecated IS_ERR_OR_NULL(const void *ptr)
>  {
>  	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
>  }
> 
