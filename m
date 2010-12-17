Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0LQTCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:02:13 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35818 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0LQTCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:02:12 -0500
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Peter Zijlstra <peterz@infradead.org>
To: Dario Faggioli <raistlin@linux.it>
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Harald Gustafsson <hgu1972@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1292612166.2697.68.camel@Palantir>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	 <1292596194.2266.283.camel@twins>  <1292612166.2697.68.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 19:59:45 +0100
Message-ID: <1292612385.2708.108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 19:56 +0100, Dario Faggioli wrote:
> On Fri, 2010-12-17 at 15:29 +0100, Peter Zijlstra wrote: 
> > Solving the CPUfreq problem involves writing a SCHED_DEADLINE aware
> > CPUfreq governor. The governor must know about the constraints placed on
> > the system by the task-set. You simply cannot lower the frequency when
> > your system is at u=1.
> > 
> We already did the very same thing (for another EU Project called
> FRESCOR), although it was done in an userspace sort of daemon. It was
> also able to consider other "high level" parameters like some estimation
> of the QoS of each application and of the global QoS of the system.
> 
> However, converting the basic mechanism into a CPUfreq governor should
> be easily doable... The only problem is finding the time for that! ;-P 

Ah, I think Harald will solve that for you,.. :)

> > The simple solution would be to slow down the runtime accounting of
> > SCHED_DEADLINE tasks by freq/max_freq. So instead of having:
> > 
> >   dl_se->runtime -= delta;
> > 
> > you do something like:
> > 
> >   dl_se->runtime -= (freq * delta) / max_freq;
> > 
> > Which auto-magically grows the actual bandwidth, and since the deadlines
> > are wall-time already it all works out nicely. It also keeps the
> > overhead inside SCHED_DEADLINE.
> > 
> And, at least for the meantime, this seems a very very nice solution.
> The only thing I don't like is that division which would end up in being
> performed at each tick/update_curr_dl(), but we can try to find out a
> way to mitigate this, what do you think Harald?

A simple mult and shift-right should do. You can either pre-compute for
a platform, or compute the inv multiplier in the cpufreq notifier thing.
