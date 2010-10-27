Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab0J0B7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:59:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:51389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab0J0B7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:59:06 -0400
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <mgalbraith@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 27 Oct 2010 03:58:58 +0200
Message-Id: <1288144738.7480.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 08:47 -0700, Linus Torvalds wrote:
> On Tue, Oct 26, 2010 at 12:29 AM, Mike Galbraith <mgalbraith@suse.de> wrote:
> > On Tue, 2010-10-26 at 09:07 +0200, Mike Galbraith wrote:
> >> On Thu, 2010-10-21 at 18:29 +0200, Oleg Nesterov wrote:
> >>
> >> > It is not clear to me why do we need rcu_read_lock() and how it can help.
> >> > The tty can go away right after dereferencing signal->tty.
> >>
> >> Which was Marcus' crash.  Didn't happen here only because I didn't have
> >> CONFIG_PREEMPT set.
> >>
> >> Changes since v2:
> >>   - drop
> >
> > Bumped mouse, message escaped.
> >
> > Doesn't matter though, damn thing just blew up during enable/disable
> > plus hackbench stress test, despite holding a reference to the tty at
> > every place tty changes (under sighand lock), and moving the task with
> > that reference held.
> 
> So I have a suggestion that may not be popular with you, because it
> does end up changing the approach of your patch a lot.

Suggestions highly welcome.  The raciness is driving me nuts.  I can't
afford additional locking, and barriers ain't working.

> And I have to say, I like how your last patch looked. It was
> surprisingly small, simple, and clean. So I hate saying "I think it
> should perhaps do things a bit differently". That said, I would
> suggest:
> 
>  - don't depend on "tsk->signal->tty" at all.
> 
>  - INSTEAD, introduce a "tsk->signal->sched_group" pointer that points
> to whatever the current auto-task_group is. Remember, long-term, we'd
> want to maybe have other heuristics than just the tty groups, so we'd
> want this separate from the tty logic _anyway_
> 
>  - at fork time, just copy the task_group pointer in copy_signal() if
> it is non-NULL, and increment the refcount (I don't think struct
> task_group is refcounted now, but this would require it).
> 
>  - at free_signal_struct(), just do a
> "put_task_group(sig->task_group);" before freeing it.
> 
>  - make the scheduler use the "tsk->signal->sched_group" as the
> default group if nothing else exists.
> 
> Now, all the basic logic is _entirely_ unaware of any tty logic, and
> it's generic. And none of it has any races with some odd tty release
> logic or anything like that.
> 
> Now, after this, the only thing you'd need to do is hook into
> __proc_set_tty(), which already holds the sighand lock, and _there_
> you would attach the task_group to the process. Notice how it would
> never be attached to a tty at all, so tty_release etc would never be
> involved in any taskgroup thing - it's not really the tty that owns
> the taskgroup, it's simply the act of becoming a tty task group leader
> that attaches the task to a new scheduling group.
> 
> It also means, for example, that if a process loses its tty (and
> doesn't get a new one - think hangup), it still remains in whatever
> scheduling group it started out with. The tty really is immaterial.
> 
> And the nice thing about this is that it should be trivial to make
> other things than tty's trigger this same thing, if we find a pattern
> (or create some new interface to let people ask for it) for something
> that should create a new group (like perhaps spawning a graphical
> application from the window manager rather than from a tty).
> 
> Comments?

Much more tasteful than what I was about to do as a last resort funky
race killer, namely make my on/off switch a machine wide atomic bomb :)

Thanks!

	-Mike

