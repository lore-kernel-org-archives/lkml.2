Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab0LQOdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:33:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:35672 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0LQOdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:33:23 -0500
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Peter Zijlstra <peterz@infradead.org>
To: Harald Gustafsson <harald.gustafsson@ericsson.com>
Cc: Dario Faggioli <faggioli@gandalf.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>
In-Reply-To: <1292596194.2266.283.camel@twins>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	 <1292596194.2266.283.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 15:32:49 +0100
Message-ID: <1292596369.2266.286.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 15:29 +0100, Peter Zijlstra wrote:
> On Fri, 2010-12-17 at 14:02 +0100, Harald Gustafsson wrote:
> 
> > This is a request for comments on additions to sched deadline v3 patches.
> > Deadline scheduler is the first scheduler (I think) we introduce in Linux that
> > specifies the runtime in time and not only as a weight or a relation.
> > I have introduced a normalized runtime clock dependent on the CPU frequency.
> > This is used, in [PATCH 2/3], to calculate the deadline thread's runtime
> > so that approximately the same number of cycles are giving to the thread
> > independent of the CPU frequency. 
> > 
> > I suggest that this is important for users of hard reservation based schedulers
> > that the intended amount of work can be accomplished independent of the CPU frequency.
> > The usage of CPU frequency scaling is important on mobile devices and hence 
> > the combination of deadline scheduler and cpufreq should be solved.
> 
> > So before I do this for the linux tip I would welcome a discussion about if this
> > is a good idea and also suggestions on how to improve this. 
> 
> I'm thinking this is going about it totally wrong..
> 
> Solving the CPUfreq problem involves writing a SCHED_DEADLINE aware
> CPUfreq governor. The governor must know about the constraints placed on
> the system by the task-set. You simply cannot lower the frequency when
> your system is at u=1.
> 
> Once you have a governor that keeps the freq such that: freq/max_freq >=
> utilization (which is only sufficient for deadline == period systems),
> then you need to frob the SCHED_DEADLINE runtime accounting.
> 
> Adding a complete normalized clock to the system like you've done is a
> total no-go, it adds overhead even for the !SCHED_DEADLINE case.
> 
> The simple solution would be to slow down the runtime accounting of
> SCHED_DEADLINE tasks by freq/max_freq. So instead of having:
> 
>   dl_se->runtime -= delta;
> 
> you do something like:
> 
>   dl_se->runtime -= (freq * delta) / max_freq;
> 
> Which auto-magically grows the actual bandwidth, and since the deadlines
> are wall-time already it all works out nicely. It also keeps the
> overhead inside SCHED_DEADLINE.

This is all assuming lowering the frequency is sensible to begin with in
the first place... but that's all part of the CPUfreq governor, it needs
to find a way to lower energy usage while conforming to the system
constraints.


