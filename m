Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab0KOXqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:46:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59997 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752793Ab0KOXqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:46:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19B8toigX1Bqhi8D6snppoKXbjl33kUgDAoST9Cie
	56i8JWD61tuLxQ
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Valdis.Kletnieks@vt.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <30291.1289860866@localhost>
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
	 <1289489200.11397.21.camel@maggy.simson.net>  <30291.1289860866@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 16:46:20 -0700
Message-ID: <1289864780.14719.172.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 17:41 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 11 Nov 2010 08:26:40 MST, Mike Galbraith said:
> 
> > Implementation: each task struct contains an inherited pointer to a refcounted
> > autogroup struct containing a task group pointer, the default for all tasks
> > pointing to the init_task_group.  When a task calls __proc_set_tty(), the
> > task's reference to the default group is dropped, a new task group is created,
> > and the task is moved out of the old group and into the new.  Children thereafter
> > inherit this task group, and increase it's refcount.  Calls to __tty_hangup()
> > and proc_clear_tty() move the caller back to the init_task_group, and possibly
> > destroy the task group.  On exit, reference to the current task group is dropped,
> > and the task group is potentially destroyed.  At runqueue selection time, iff
> > a task has no cgroup assignment, it's current autogroup is used.
> 
> So the set of all tasks that never call proc_set_tty() ends up in the same one
> big default group, correct?  Do we have any provisions for making sure that if
> a user has 8 or 10 windows open doing heavy work, the default group (with a lot
> of important daemons/etc in it) doesn't get starved with only a 1/10th share of
> the CPU? Or am I missing something here?

Yes, all tasks never having had a tty association are relegated to the
root task group, and no, there is no provision for the root task group
getting more than it's fair share of CPU.

The patch is only intended to (hopefully) better suit the general case
desktop.  One size has zero chance of fitting all ;-)

> > +extern void sched_autogroup_detatch(struct task_struct *p);
> 
> sched_autogroup_detach() instead?

Hm, why?

	-Mike

	-Mike

