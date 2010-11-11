Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab0KKWNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:13:17 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60867 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0KKWNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:13:16 -0500
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
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
In-Reply-To: <1288334546.8661.161.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334546.8661.161.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 23:12:53 +0100
Message-ID: <1289513573.2084.199.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:42 +0200, Raistlin wrote:
> The bandwidth enforcing mechanism implemented inside the
> SCHED_DEADLINE policy ensures that overrunning tasks are slowed
> down without interfering with well behaving ones.
> This, however, comes at the price of limiting the capability of
> a task to exploit more bandwidth than it is asigned.
> 
> The current implementation always stops a task that is trying
> to use more than its runtime (every deadline). Something else that
> could be done is to let it continue running, but with a "decreased
> priority". This way, we can exploit full CPU bandwidth and still
> avoid interferences.
> 
> In order of "decreasing the priority" of a deadline task, we can:
>  - let it stay SCHED_DEADLINE and postpone its deadline. This way it
>    will always be scheduled before -rt and -other tasks but it
>    won't affect other -deadline tasks;
>  - put it in SCHED_FIFO with some priority. This way it will always
>    be scheduled before -other tasks but it won't affect -deadline
>    tasks, nor other -rt tasks with higher priority;
>  - put it in SCHED_OTHER.
> 
> Notice also that this can be done on a per-task basis, e.g., each
> task can specify what kind of reclaiming mechanism it wants to use
> by means of the sched_flags field of sched_param_ex.
> 
> Therefore, this patch:
>  - adds the flags for specyfing DEADLINE, RT or OTHER reclaiming
>    behaviour;
>  - adds the logic that changes the scheduling class of a task when
>    it overruns, according to the requested policy.

The first two definitely should require SYS_CAP_ADMIN because it allows
silly while(1) loops again.. but can we postpone this fancy feature as
well? 

I'd much rather have the stochastic thing implemented that allows
limited temporal overrun.
