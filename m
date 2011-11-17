Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab1KQNBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:01:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab1KQNBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:01:06 -0500
Date: Thu, 17 Nov 2011 15:00:32 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
Message-ID: <20111117130032.GC16853@redhat.com>
References: <20111117123029.GB16853@redhat.com>
 <1321534159.27735.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321534159.27735.33.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 01:49:19PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-17 at 14:30 +0200, Gleb Natapov wrote:
> > jump_lable patching is very expensive operation that involves pausing all
> > cpus. The patching of perf_sched_events jump_label is easily controllable
> > from userspace by unprivileged user. When user runs loop like this
> > "while true; do perf stat -e cycles true; done" the performance of my
> > test application that just increments a counter for one second drops by
> > 4%. This is on a 16 cpu box with my test application using only one of
> > them. An impact on a real server doing real work will be much worse.
> > Performance of KVM PMU drops nearly 50% due to jump_lable for "perf
> > record" since KVM PMU implementation creates and destroys perf event
> > frequently.
> 
> Ideally we'd fix text_poke to not use stop_machine() we know how to, but
> we haven't had the green light from Intel/AMD yet.
> 
> Rostedt was going to implement it anyway and see if anything breaks.
> 
Hmm interesting.

> Also, virt might be able to pull something smart on text_poke() dunno.
> 
The problem with virt is not text_poke() in a guest, but the one in a
host. The guest I am testing with has only one cpu. Basically creating
fist perf event/destroying last perf event is very expensive currently
and when "perf record" is running in a guest this happens a lot in a
host.

> That said, I'd much rather throttle this particular jump label than
> remove it altogether, some people really don't like all this scheduler
> hot path crap.
What about moving perf_event_task_sched() to sched_(in|out)_preempt_notifiers?
preempt notifiers checking is already on the scheduler hot path, so no
additional overhead for perf case.

--
			Gleb.
