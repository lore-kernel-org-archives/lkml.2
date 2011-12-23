Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab1LWUyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:54:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62119 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab1LWUye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:54:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112231031001.3482@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com> <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com> <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com> <alpine.DEB.2.00.1112221154380.11787@router.home>
 <CA+55aFzY_6QYVyjAmP+w8D0Xy1Pq++XEUaBJRcCN9SbDE-pOhw@mail.gmail.com> <alpine.DEB.2.00.1112231031001.3482@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Dec 2011 12:54:12 -0800
X-Google-Sender-Auth: kIkEbtdLXaHt6F09LiTSZf15IEc
Message-ID: <CA+55aFzCY7TyEgkWFn6wxUMjBBaKGcx0hdV6gTdta5u8eK=Ymg@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 8:55 AM, Christoph Lameter <cl@linux.com> wrote:
>
> There is an #ifndef CONFIG_M386 around the implementation of these for
> x86. Use on i386 will not generate an xadd instructions but fallback to a
> generic implementation.

Ok, good. It's not the really right thing to do, but it will at least work.

> The add_return stuff was already available with the earlier per cpu apis
> (local_t and percpu) that this_cpu replaces and is still available through
> the atomic operations.

Sure. The "atomic_op_return()" form actually *makes*sense*. It has
atomicity guarantees, and the return value is meaningful.

The same IS SIMPLY NOT TRUE of the "this_cpu" versions.

> If one wants to exploit the per cpu atomicity then one may want to know
> what the result was.

No. You're blathering and doing "magical thinking" instead of actually
thinking things through.

Think about the semantics. What does it mean to get a result of the op
on a percpu variable?

You have two cases:

Case 1: you actually know what CPU you are on, and the number may have
some meaning. But in that case you are also *pinned* to that CPU, and
there is no difference between

   x = percpu_value;
   x += y;
   percpu_value = x;
   .. look at 'x' .. to see what you did

and

    percpu_value += x;
   ..look at percpu_value to see what you did ..

and

    x = xadd percpu_value,y

so there are no "atomicity advantages" - xadd is the same as
open-coding it. You are pinned to the CPU, all three ways are 100%
equivalent.

The other case is:

Case 2: you're not pinned to the CPU, and you just do statistics and
add some value to memory. BUT NOW THE RESULT HAS ABSOLUTELY NO
MEANING!

Now "xadd" would possibly give different results from "add and read
the result", since you migth be moving around between cpu's, but there
is absolutely no way you could ever care, sine the value you read back
is meaningless regardless of whether it's the return value of xadd, or
the value from some other CPU. There are other cpu's with the same
percpu variable, and they are all equivalent as far as you are
concerned, because you're not pinned to one of them.

See? xadd buys you *nothing* from a semantic standpoint. And anybody
who *thinks* it buys you something is just confused and just
introduced a bug.

So the "thiscpu_op_return" functions are broken-by-design! They have
no meaning. They are completely crazy.

That's why they should be removed. Anybody who thinks they add value
has not thought through what they actually do or mean.

                            Linus
