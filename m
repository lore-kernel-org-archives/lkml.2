Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2KLXzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:55:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41256 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab2KLXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:55:03 -0500
Date: Mon, 12 Nov 2012 23:53:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Clark <rob.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Message-ID: <20121112235348.GD28341@n2100.arm.linux.org.uk>
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org> <20121112192727.GB28341@n2100.arm.linux.org.uk> <CAF6AEGu4L+ukxhMBLYK3d2g4CBBXi6o5nN_wXvakZCT8qMfSEA@mail.gmail.com> <20121112230819.GC28341@n2100.arm.linux.org.uk> <CAF6AEGtLKjJ=BfBnOq+oE6cgneF5YqsbYqNnCPrz4sTFRzdibg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGtLKjJ=BfBnOq+oE6cgneF5YqsbYqNnCPrz4sTFRzdibg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 05:33:41PM -0600, Rob Clark wrote:
> I'm sort of thinking maybe we want to change 'switch (sizeof(*(__p)))'
> with 'switch (sizeof(typeof(x)))' in case someone ignores the compiler
> warning when they try something like:

Definitely not.  Ttype of access is controlled by the pointer, not by the
size of what it's being assigned to.  Switching that around is likely to
break stuff hugely.  Consider this:

	unsigned char __user *p;
	int val;

	get_user(val, p);

If the pointer type is used to determine the access size, a char will be
accessed.  This is legal - because we end up assigning an unsigned character
to an int.

If the size of the destination was used, we'd access an int instead, which
is larger than the pointer, and probably the wrong thing to do anyway.

Think of get_user(a, b) as being a special accessor having the ultimate
semantics of: "a = *b;" but done in a safe way with error checking.

>    uint32_t x;
>    uint64_t *p = ...;
>    get_user(x, p);
> 
> that was my one concern about 'register typeof(x) __r2 ...', but I
> think just changing the switch condition is enough.  But maybe good to
> have some eyes on in case there is something else I'm not thinking of.

And what should happen in the above is exactly the same as what happens
if you do:

	x = *p;

with those types.  For ARM, that would be a 64-bit access (if the
compiler decides not to optimize away the upper 32-bit access) followed
by a narrowing cast down to 32-bit.  With get_user() of course, there's
no option not to optimize it away.

However, this _does_ reveal a bug with your approach.  With sizeof(*p)
being 8, and the type of __r2 being a 32-bit quantity, the compiler will
choose the 64-bit accessor, which will corrupt r3 - and the compiler
won't know that r3 has been corrupted.

That's too unsafe.

I just tried a variant of your approach, but got lots of warnings again:
	register unsigned long long __r2 asm("r2");
	__get_user_x(__r2, __p, __e, 8, "lr");
	x = (typeof(*(__p))) ((typeof(x))__r2);
because typeof(x) in the test_ptr() case ends up being a pointer itself.

So, back to the drawing board, and I think back to the original position
of "we don't support this".
