Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0DUMrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:47:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41120 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0DUMq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:46:58 -0400
X-Authority-Analysis: v=1.1 cv=ZUag8tkj9kgmNMrzofuoEsXxpG43g9sRv4eUZcQ4+as= c=1 sm=0 a=eOOYVsMsLpwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=oRtg6tDsmDOHrS7nfZYA:9 a=twKCPHoRJ3Xqk5MhMx0A:7 a=UodM5Gt4UhZNgPl-v1J8SPwsVfoA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Considerations on sched APIs under RT patch
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Primiano Tucci <p.tucci@gmail.com>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
In-Reply-To: <1271839772.1776.58.camel@laptop>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 21 Apr 2010 08:46:56 -0400
Message-ID: <1271854016.10448.172.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 10:49 +0200, Peter Zijlstra wrote:
> On Wed, 2010-04-21 at 07:16 +0200, Primiano Tucci wrote:
> > Hi steve
> > > read_locks are converted into "special" rt_mutexes. The only thing
> > > special about them, is the owner may grab the same read lock more than
> > > once (recursive).
> > >
> > > If a lower priority process currently holds the tasklist_lock for write,
> > > when a high priority process tries to take it for read (or write for
> > > that matter) it will block on the lower priority process. But that lower
> > > priority process will acquire the priority of the higher priority
> > > process (priority inheritance) and will run at that priority until it
> > > releases the lock. Then it will go back to its low priority and the
> > > higher priority process will then preempt it and acquire the lock for
> > > read.
> > 
> > In your example you implied that the low priority process, holding the
> > lock for write, runs on the same CPU of the higher priority process
> > that wants to lock it for read. This is clear to me.
> > My problem is, in a SMP environment, what happens if a process (let's
> > say T1 on CPU #1) holds the lock for write (its priority does not
> > matter, it is not a PI problem) and now a process T0 on cpu #0 wants
> > to lock it for read?
> > The process T0 will be blocked! But who will run now on CPU 0, until
> > the rwlock is held by T1? Probably the next ready process on CPU #'0.
> > Is it right?
> 
> Yes. This is the reality of SMP systems, nothing much you can do about
> that. System resources are shared between all cpus, irrespective of task
> affinities.

Actually, we do better than that. With adaptive locks, if the process on
the other CPU is still running, the high priority task will spin until
the other process releases the lock or goes to sleep. If it goes to
sleep, then the high prio task will also sleep, otherwise it just spins
and takes the lock when it is released.

-- Steve



