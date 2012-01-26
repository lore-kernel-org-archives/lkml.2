Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2AZDfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 22:35:41 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35084 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2AZDfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 22:35:39 -0500
MIME-Version: 1.0
In-Reply-To: <20120126024342.GA12492@gondor.apana.org.au>
References: <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au>
 <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au>
 <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Jan 2012 19:35:19 -0800
X-Google-Sender-Auth: zmHK3W-DNFCNJU2KmxxArti9l0o
Message-ID: <CA+55aFzFecPSQverH7VQBDZY+gS7_RALwh3W4oqWLbWBcBzLqg@mail.gmail.com>
Subject: Re: Crypto Fixes for 3.3
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 6:43 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This push fixes a race condition in sha512 that affects users
> who use it in process context and softirq context concurrently,
> in particular, this affects IPsec.  The result of the race is
> the production of incorrect hashes, which for IPsec leands to
> loss of connectivity.

Ugh. This once more has the crazy signed integer modulus operator,
which can be quite expensive depending on whether the compiler can
tell whether it is always positive or not.

Also, that modulus is exposed everywhere.

In git, the sha1 implementation (which has many of the same issues) does this:

  /* This "rolls" over the 512-bit array */
  #define W(x) (array[(x)&15])

which means that the modulus exists in just one place (and is the
correct binary 'and', not the possibly-expensive division).

We also avoid the problem with absolutely horrible gcc register usage
by having an arch-specific "accessor macro":

  /*
   * If you have 32 registers or more, the compiler can (and should)
   * try to change the array[] accesses into registers. However, on
   * machines with less than ~25 registers, that won't really work,
   * and at least gcc will make an unholy mess of it.
   *
   * So to avoid that mess which just slows things down, we force
   * the stores to memory to actually happen (we might be better off
   * with a 'W(t)=(val);asm("":"+m" (W(t))' there instead, as
   * suggested by Artur Skawina - that will also make gcc unable to
   * try to do the silly "optimize away loads" part because it won't
   * see what the value will be).
   *
   * Ben Herrenschmidt reports that on PPC, the C version comes close
   * to the optimized asm with this (ie on PPC you don't want that
   * 'volatile', since there are lots of registers).
   *
   * On ARM we get the best code generation by forcing a full memory barrier
   * between each SHA_ROUND, otherwise gcc happily get wild with spilling and
   * the stack frame size simply explode and performance goes down the drain.
   */

  #if defined(__i386__) || defined(__x86_64__)
    #define setW(x, val) (*(volatile unsigned int *)&W(x) = (val))
  #elif defined(__GNUC__) && defined(__arm__)
    #define setW(x, val) do { W(x) = (val); __asm__("":::"memory"); } while (0)
  #else
    #define setW(x, val) (W(x) = (val))
  #endif

which is not pretty, but as you guys found out, the alternative can be
much worse (ie totally crazy gcc register spilling)

                    Linus
