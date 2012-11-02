Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192Ab2KBSF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:05:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933940Ab2KBSFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:05:51 -0400
Date: Fri, 2 Nov 2012 19:06:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] percpu_rw_semaphore: reimplement to not block the
	readers unnecessarily
Message-ID: <20121102180606.GA13255@redhat.com>
References: <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01, Linus Torvalds wrote:
>
> On Wed, Oct 31, 2012 at 12:41 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > With this patch down_read/up_read does synchronize_sched() twice and
> > down_read/up_read are still possible during this time, just they use
> > the slow path.
>
> The changelog is wrong (it's the write path, not read path, that does
> the synchronize_sched).

Fixed, thanks,

> >  struct percpu_rw_semaphore {
> > -       unsigned __percpu *counters;
> > -       bool locked;
> > -       struct mutex mtx;
> > +       int __percpu            *fast_read_ctr;
>
> This change is wrong.
>
> You must not make the 'fast_read_ctr' thing be an int. Or at least you
> need to be a hell of a lot more careful about it.
>
> Why?
>
> Because the readers update the counters while possibly moving around
> cpu's, the increment and decrement of the counters may be on different
> CPU's. But that means that when you add all the counters together,
> things can overflow (only the final sum is meaningful). And THAT in
> turn means that you should not use a signed count, for the simple
> reason that signed integers don't have well-behaved overflow behavior
> in C.

Yes, Mikulas has pointed this too, but I forgot to make it "unsigned".

> Now, I doubt you'll find an architecture or C compiler where this will
> actually ever make a difference,

Yes. And we have other examples, say, mnt->mnt_pcp->mnt_writers is "int".

> but the fact remains that you
> shouldn't use signed integers for counters like this. You should use
> unsigned, and you should rely on the well-defined modulo-2**n
> semantics.

OK, I changed this.

But please note that clear_fast_ctr() still returns "int", even if it
uses "unsigned" to calculate the result. Because we use this value for
atomic_add(int i) and it can be actually negative, so to me it looks
a bit better this way even if the generated code is the same.

> I'd also like to see a comment somewhere in the source code about the
> whole algorithm and the rules.

Added the comments before down_read and down_write.

> Other than that, I guess it looks ok.

Great, please see v2.

I am not sure I addressed Paul's concerns, so I guess I need his ack.

Oleg.

