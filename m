Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946Ab2KAPLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:11:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43819 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761915Ab2KAPLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:11:09 -0400
MIME-Version: 1.0
In-Reply-To: <20121031194158.GB504@redhat.com>
References: <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com>
 <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Nov 2012 08:10:47 -0700
X-Google-Sender-Auth: 7BISRZuD_e8SUe4p0iOrYVfy4Mk
Message-ID: <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
Subject: Re: [PATCH 1/1] percpu_rw_semaphore: reimplement to not block the
 readers unnecessarily
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:41 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Currently the writer does msleep() plus synchronize_sched() 3 times
> to acquire/release the semaphore, and during this time the readers
> are blocked completely. Even if the "write" section was not actually
> started or if it was already finished.
>
> With this patch down_read/up_read does synchronize_sched() twice and
> down_read/up_read are still possible during this time, just they use
> the slow path.

The changelog is wrong (it's the write path, not read path, that does
the synchronize_sched).

>  struct percpu_rw_semaphore {
> -       unsigned __percpu *counters;
> -       bool locked;
> -       struct mutex mtx;
> +       int __percpu            *fast_read_ctr;

This change is wrong.

You must not make the 'fast_read_ctr' thing be an int. Or at least you
need to be a hell of a lot more careful about it.

Why?

Because the readers update the counters while possibly moving around
cpu's, the increment and decrement of the counters may be on different
CPU's. But that means that when you add all the counters together,
things can overflow (only the final sum is meaningful). And THAT in
turn means that you should not use a signed count, for the simple
reason that signed integers don't have well-behaved overflow behavior
in C.

Now, I doubt you'll find an architecture or C compiler where this will
actually ever make a difference, but the fact remains that you
shouldn't use signed integers for counters like this. You should use
unsigned, and you should rely on the well-defined modulo-2**n
semantics.

I'd also like to see a comment somewhere in the source code about the
whole algorithm and the rules.

Other than that, I guess it looks ok.

            Linus
