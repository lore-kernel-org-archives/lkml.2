Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1DRQqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:46:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab1DRQqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:46:10 -0400
Date: Mon, 18 Apr 2011 18:45:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFC][PATCH 2/5] signals: Introduce per-thread siglock and
	action rwlock
Message-ID: <20110418164513.GA25930@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-3-git-send-email-matt@console-pimps.org> <20110413194231.GA15330@redhat.com> <20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com> <20110414190012.GA23517@redhat.com> <20110416140813.5c90b1fc@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110416140813.5c90b1fc@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Matt Fleming wrote:
>
> On Thu, 14 Apr 2011 21:00:12 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > Is there a reason that a short-term reference counter isn't used to
> > > prevent this, instead of taking the siglock?
> >
> > Well, sighand->count is the reference counter. The problem is, ->sighand
> > is not per-process, we can share it with abother CLONE_SIGHAND process
> > and de_thread() can change ->sighand during exec.
>
> What I meant was, a reference to say "You can't change/free ->sighand
> because I'm reading/modifying it". So you'd have two new functions,
> get_sighand() and put_sighand(), which would protect the sighand from
> changing while you were looking at it. Obviously, you'd still need to
> see if sighand = NULL, but you wouldn't need to grab the shared
> siglock.
>
> Note how this is different from sighand->count. sighand->count is a
> much longer term reference which stops it being freed while a task is
> using it, kinda like a "Don't free _MY_ sighand" reference, whereas
> what I'm talking about is a "I'm touching YOUR sighand, so don't
> change/free it" reference, e.g. a short term ref for when we're
> operating on a target task. It could be that the two references can
> really be just one atomic_t, I would have to write the code to figure
> that out.

Can't understand...

OK, someone does get_sighand(). Now, what de_thread() should do if it
wants to change ->sighand?

And I don't really understand the point. You can read *sighand lockless.
But you need some per-CLONE_SIGHAND lock if you want to modify it anyway.

> Now, at the moment that suggestion just seems like needless overhead
> because siglock already provides the features we want. But, my problem
> with siglock is,
>
> 	1. It needs to be acquired to stop a task passing through
> 	__exit_signal().
>
> 	2. It protects bits of signal_struct and that struct is getting
> 	pretty bloated and siglock is being used to protect lots of
> 	different things.

Yes, this is the main problem: it is overused.

We need the better locking. Honestly, _personally_ I do not really care
about scalability (but perhaps I should) when it comes to signals, but
there are other problems. And, apart from the already mentioned problems
with signals-from-irq, I think the main problem is tasklist_lock in
do_wait/exit/etc pathes.

And we still have the problems with signals which should be fixed.
de_thread() can miss a signal, vfork() should be interruptible,
do_coredump() should be interruptible. But first of all we need to
define better the behaviour of explicit SIGKILL and what it means
after exit_signals(). This should be fixed first, I think.

> 	3. I suspect most people find the rules of ->sighand pretty
> 	confusing. Just look at
>
> 		arch/tile/kernel/hardwall.c:do_hardwall_trap()
>
> 	the use of siglock there looks buggy to me.

Indeed, I agree. It shouldn't use __group_send_sig_info() at all.
I'll send the patch. Nobody outside of signal code should play with
->sighand, this is almost always wrong.

There is another problem, historically we have a lot, a lot of send-signal
helpers, but you can never find the right one. And the naming sucks.

> Do you have any recollection of the cleanups? signal_struct needs to be
> put on a diet for sure.

I was going to remove ->sighand from fs/proc first, probably I should
try to resend these patches... Then we should remove the "sighand != NULL"
checks, we need the new helper, and btw it should be used instead of
pid_alive(). Then something else... boring ;)

Oleg.

