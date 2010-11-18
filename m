Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0KROZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:25:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:55444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab0KROZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:25:23 -0500
Subject: Re: [PATCH] sched: Simplify cpu-hot-unplug task migration
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101118140515.GA29303@redhat.com>
References: <1289490202.2084.140.camel@laptop>
	 <20101111163242.GA5697@redhat.com> <1289673355.2109.79.camel@laptop>
	 <20101113195857.GA11411@redhat.com> <1289680291.2109.244.camel@laptop>
	 <1289681497.2109.270.camel@laptop> <1289691081.2109.452.camel@laptop>
	 <1289851597.2109.547.camel@laptop> <20101117192713.GA11910@redhat.com>
	 <1290022954.2109.1217.camel@laptop>  <20101118140515.GA29303@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 15:24:09 +0100
Message-ID: <1290090249.2109.1522.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 15:05 +0100, Oleg Nesterov wrote:
> > -     /* Wait for it to sleep (leaving idle task). */
> > -     while (!idle_cpu(cpu))
> > -             yield();
> > +     /*
> > +      * The migration_call() CPU_DYING callback will have removed all
> > +      * runnable tasks from the cpu, there's only the idle task left now
> > +      * that the migration thread is done doing the stop_machine thing.
> > +      */
> > +     BUG_ON(!idle_cpu(cpu));
> 
> I am not sure.
> 
> Yes, we know for sure rhat the only runnable task is rq->idle.
> But only after migration thread calls schedule() and switches to the
> idle thread.
> 
> However, I see nothing which can guarantee this. Migration thread
> running on the dead cpu wakes up the caller of stop_cpus() before
> it calls schedule(), _cpu_down() can check rq->curr before it was
> changed.
> 
> No?
> 
> 
> 
> Hmm. In fact, I think it is possible that cpu_stopper_thread() can
> have more cpu_stop_work's queued when __stop_machine() returns.
> This has nothing to do with this patch, but I think it makes sense
> to clear stopper->enabled at CPU_DYING stage as well (of course,
> this needs a separate patch). 

Hmm, I think you're right, although I haven't hit that case during
testing.

There is no firm guarantee the dying cpu actually got to running the
idle thread (there's a guarantee it will at some point), so we ought to
maintain that wait-loop, possibly using cpu_relax(), I don't see the
point in calling yield() here.
