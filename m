Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1AUPKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:10:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36822 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1AUPJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:09:56 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110121150323.GC6051@zhy>
References: <1295499568.8027.30.camel@marge.simson.net>
	 <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
	 <1295503938.8027.59.camel@marge.simson.net>
	 <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
	 <1295512625.8027.88.camel@marge.simson.net>
	 <AANLkTi=WhLy=4MNdm-HaOUOmbKXsNSJojnzqRTYp6qop@mail.gmail.com>
	 <1295518047.8027.104.camel@marge.simson.net>
	 <1295608136.28776.266.camel@laptop> <20110121122412.GA5071@zhy>
	 <1295617258.28776.274.camel@laptop>  <20110121150323.GC6051@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 Jan 2011 16:10:27 +0100
Message-ID: <1295622627.28776.295.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 23:03 +0800, Yong Zhang wrote:
> On Fri, Jan 21, 2011 at 02:40:58PM +0100, Peter Zijlstra wrote:
> > On Fri, 2011-01-21 at 20:24 +0800, Yong Zhang wrote:
> > > > Index: linux-2.6/kernel/sched.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/kernel/sched.c
> > > > +++ linux-2.6/kernel/sched.c
> > > > @@ -2624,6 +2624,8 @@ void sched_fork(struct task_struct *p, i
> > > >  
> > > >       if (!rt_prio(p->prio))
> > > >               p->sched_class = &fair_sched_class;
> > > > +     else
> > > > +             p->se.vruntime = 0;
> > > 
> > > This can be moved to __sched_fork() 
> > 
> > But we cannot do it unconditionally, we want to inherit the parent's
> > ->vruntime when we're a fair task clone.
> 
> Doesn't task_fork_fair()(which is called after __sched_fork())
> take the inherit job?
> 
> Am I missing something?

Ah, indeed, we do the place_entity(.initial=1) thing there
unconditionally. For some reason I thought we relied on the inherited
vruntime.
