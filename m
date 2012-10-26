Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab2JZPRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:17:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37045 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:17:43 -0400
MIME-Version: 1.0
In-Reply-To: <1351241389.12171.45.camel@twins>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com> <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
 <1351172849.12171.10.camel@twins> <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
 <1351241389.12171.45.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 08:17:22 -0700
X-Google-Sender-Auth: w49TQh3lyn-RRkPB-e_EFb2M1EE
Message-ID: <CA+55aFwur9=1gFbcdD862rn-Vw0A_+oSr1iX+-=iHMBC_2L+Ng@mail.gmail.com>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 1:49 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> No, it does a compare on two u128

Actually, it apparently compares two multiplications.

That might be optimizable in itself.

> The point is (as mentioned in the comments below) overflowing an actual
> u64 is rare, however since some of this (specifically the
> dl_{runtime,deadline} parameters) is user specified, we have to assume
> we will overflow.

Any chance we could just limit them?

> +       u128 left, right;
> +
> +       /*
> +        * left and right are the two sides of the equation above,
> +        * after a bit of shuffling to use multiplications instead
> +        * of divisions.
> +        *
> +        * Note that none of the time values involved in the two
> +        * multiplications are absolute: dl_deadline and dl_runtime
> +        * are the relative deadline and the maximum runtime of each
> +        * instance, runtime is the runtime left for the last instance
> +        * and (deadline - t), since t is rq->clock, is the time left
> +        * to the (absolute) deadline. Therefore, overflowing the u64
> +        * type is very unlikely to occur in both cases.
> +        */
> +       left = mul_u64_u64(dl_se->dl_deadline, dl_se->runtime);
> +       right = mul_u64_u64((dl_se->deadline - t), dl_se->dl_runtime);
> +
> +       if (cmp_u128(left, right) > 0)
> +               return true;
> +
> +       return false;

So how often could we do this without doing the multiplication at all?

It's trivial to see that 'right > left' if the individual
multiplicands are both bigger, for example. Maybe that is common?

And even if it overflows in 64-bit does it overflow in 92? For 32-bit
machines, the difference there is quite noticeable.

So the above might actually be better written as a
"compare_64bit_multiply(a,b,c,d)". At the same time, are we
*seriously* ever talking about multi-second runtimes or deadlines?
Because even in nanoseconds, I assume that the common case *by*far* in
scheduling would be about values smaller than four seconds, in which
case all of the above values are 32-bit, making the compares *much*
cheaper.

So on a 32-bit machine (say, x86-32), you might just have:

 - or all the high words together, jump to slow case if the result is non-zero
 - otherwise, do just two 32x32 multiplies and check which of the two is bigger.

That's a *huge* reduction in expensive multiplications.

And *THAT* is why generic 128-bit math is stupid. Don't do it.

           Linus
