Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab2DXTiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:38:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43613 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab2DXTiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:38:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120424162224.526249106@chello.nl>
References: <20120424161039.293018424@chello.nl> <20120424162224.526249106@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Apr 2012 12:37:53 -0700
X-Google-Sender-Auth: rp_qFneZVih0vBackfdm35Dk_Qw
Message-ID: <CA+55aFyvBTDh_DkXs6Z6zFmjyYxvWaAEm9-rJDXhvPx8CpDiKA@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 9:10 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Grow rudimentary u128 support without relying on gcc/libgcc.
>
> +#ifndef add_u128
> +static inline u128 add_u128(u128 a, u128 b)
> +{
> +       u128 res;
> +
> +       res.hi = a.hi + b.hi;
> +       res.lo = a.lo + b.lo;
> +
> +       if (res.lo < a.lo || res.lo < b.lo)
> +               res.hi++;

This is wrong. Or at least stupid.

Just do one of the comparisons, not both. If overflow occurs, the
result will be smaller than *either* of the added numbers, so
comparing both is just silly and confused.

So just pick one.

Also, it might be worth looking at code generation, to see if it's
better to just do

   a.hi += b.hi;
   a.low += b.low;
   if (a.low < b.low)
      a.hi++;
   return a;

because that might make it clear that there are fewer actual values
live at any particular time. But gcc may not care. Try it.

Also, for the multiply, please make sure gcc knows to do a "32x32->64"
multiplication, rather than thinking it needs to do full 64x64
multiplies..

I'm not sure gcc understands that as you wrote it. You are probably
better off actually using 32-bit values, and then an explicit cast, ie

  u32 a32_0 = .. low 32 bits of a ..
  u32 b32_0 = .. low 32 bits of b ..
  u64 res64_0 = (u64) a32_0 * (u64) b32_0;

but if gcc understands it from the shifts and masks, I guess it doesn't matter.

        Linus
