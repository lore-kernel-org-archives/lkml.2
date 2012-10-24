Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab2JXXSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 19:18:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38203 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2JXXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 19:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com> <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Oct 2012 16:18:13 -0700
X-Google-Sender-Auth: JbwEx8Np5_yQPeCOBEDQj5S-S-M
Message-ID: <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 2:53 PM, Juri Lelli <juri.lelli@gmail.com> wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Grow rudimentary u128 support without relying on gcc/libgcc.

I missed the part where somebody explains why and what needs this?
It's going to be very expensive indeed on some platforms, so the fact
that it is *sometimes* cheap doesn't necessarily imply it should ever
be used.

So please, explain what the pressing need is that is so worthwhile
that this is worth it. Maybe it was in a 00/16 cover letter, but not
only was that not sent out to the people who got 01, you'd still want
it in the commit message.

> +typedef union {
> +       struct {
> +#if __BYTE_ORDER__  == __ORDER_LITTLE_ENDIAN__
> +               u64 lo, hi;
> +#else
> +               u64 hi, lo;
> +#endif
> +       };
> +#ifdef __SIZEOF_INT128__ /* gcc-4.6+ */
> +       unsigned __int128 val;
> +#endif
> +} u128;

This also looks totally wrong.

If gcc has native support for __int128, then the union is pointless.
Don't do it. Just do

  #ifdef __SIZEOF_INT128__
    typedef unsigned __int128 u128;
  #else
    typedef struct { ... u64 hi/lo in the right order } u128;
  #endif

because it's possible that using the native bare type will make gcc
able to do better for various things.

Sure, it's possible that you want to use a union in low-level
architecture code that implements the actual math, BUT EVEN THEN the
above union is pure and utter garbage. On 32-bit machines, you'd want
to make it a union of 4 32-bit entities etc. So putting it like this
in a generic file looks wrong. In fact, your very own generic
mul_u64_u64() would seem to want to use the "4 32-bit words" kind of
model.

Also, the union isn't used for generic code anyway, since the generic
code has that same __SIZEOF_INT128__ test for which generic version it
should include (and I wonder if it should just be

  #ifdef __SIZEOF_INT128__
    #include <linux/native-128bit.h>
  #elif CONFIG_64BIT
    #include <linux/generic64bit-128bit.h>
  #else
    #include <linux/generic64bit-128bit.h>
  #endif

and then have separate files entirely for the "gcc handles the common
operations" vs "64-bit architecture needs two words for most things"
vs "32-bit architectures need 4 words for most things".

I dunno. But I think this is wrong.

             Linus
