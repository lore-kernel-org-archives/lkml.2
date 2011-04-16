Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1DPNIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:08:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39813 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593Ab1DPNIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:08:16 -0400
Date: Sat, 16 Apr 2011 14:08:13 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFC][PATCH 2/5] signals: Introduce per-thread siglock and
 action rwlock
Message-ID: <20110416140813.5c90b1fc@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110414190012.GA23517@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-3-git-send-email-matt@console-pimps.org>
	<20110413194231.GA15330@redhat.com>
	<20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com>
	<20110414190012.GA23517@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 21:00:12 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

[Added Chris to Cc. Chris, check out point 3 below]
 
> No, tsk->signal can't go away, ->sighand can. This means that
> prepare_signal()->sig_ignored() is not safe.

Sorry, that was a typo - I meant tsk->sighand.
 
> Another problem is, __send_signal() shouldn't add the new sigqueue to
> tsk->pending if this tsk has already passed __exit_signal()->flush_sigqueue().

Right.

> > While we're discussing the technique for stopping tasks from exiting...
> >
> > Is there a reason that a short-term reference counter isn't used to
> > prevent this, instead of taking the siglock?
> 
> Well, sighand->count is the reference counter. The problem is, ->sighand
> is not per-process, we can share it with abother CLONE_SIGHAND process
> and de_thread() can change ->sighand during exec.

What I meant was, a reference to say "You can't change/free ->sighand
because I'm reading/modifying it". So you'd have two new functions,
get_sighand() and put_sighand(), which would protect the sighand from
changing while you were looking at it. Obviously, you'd still need to
see if sighand = NULL, but you wouldn't need to grab the shared
siglock.

Note how this is different from sighand->count. sighand->count is a
much longer term reference which stops it being freed while a task is
using it, kinda like a "Don't free _MY_ sighand" reference, whereas
what I'm talking about is a "I'm touching YOUR sighand, so don't
change/free it" reference, e.g. a short term ref for when we're
operating on a target task. It could be that the two references can
really be just one atomic_t, I would have to write the code to figure
that out.

(Note I haven't thought this through all the way yet. There may be a
reason that the above idea is the most stupid thing anyone's ever heard)

Now, at the moment that suggestion just seems like needless overhead
because siglock already provides the features we want. But, my problem
with siglock is,

	1. It needs to be acquired to stop a task passing through
	__exit_signal().

	2. It protects bits of signal_struct and that struct is getting
	pretty bloated and siglock is being used to protect lots of
	different things. Do we really need to completely prevent
	signals being generated/delivered to a thread group while we
	modify signal->it[] in kernel/itimer.c?

	3. I suspect most people find the rules of ->sighand pretty
	confusing. Just look at

		arch/tile/kernel/hardwall.c:do_hardwall_trap()

	the use of siglock there looks buggy to me. What if 'p' passes
	through __exit_signal()? 'p' might not have reached free_task()
	yet and so won't have called hardwall_deactivate(), which
	means 'p' could still be on rect->task_head. Chris?

	4. It's a heavily contended lock in thread groups (which was
	the reason for this patch series).

> I was going to try to add some cleanups here after the scope of ->signal
> was changed, but right now I can't recall what I had in mind. Anyway,
> everything in sighand_struct needs ->siglock anyway, a lockless access
> doesn't buy too much currently.

Well, as I think my patch series shows, (in theory) not needing to
acquire ->siglock gets us decent scalability improvements (in practice
it was buggy as hell but that should be fixable ;-).

Do you have any recollection of the cleanups? signal_struct needs to be
put on a diet for sure.

-- 
Matt Fleming, Intel Open Source Technology Center
