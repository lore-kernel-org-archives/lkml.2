Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1ITOdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:33:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1ITOdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:33:20 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=IHHmwdYJPJ0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=ufHFDILaAAAA:8 a=2DqJV-RvnIXetqkWoOgA:9 a=PPUesukTviSeW2mbjvoA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=l7ZknGph1ugA:10 a=9WkVHmeLdUX-G-Od:21 a=mgYWUC4nQTEIrbRY:21 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 3/5] memcg: Disable preemption in
 memcg_check_events()
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110920142456.GC17198@cmpxchg.org>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212641.015320989@goodmis.org> <20110920142031.GB17198@cmpxchg.org>
	 <20110920142456.GC17198@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 10:33:17 -0400
Message-ID: <1316529197.29966.50.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 16:24 +0200, Johannes Weiner wrote:
> On Tue, Sep 20, 2011 at 04:20:31PM +0200, Johannes Weiner wrote:
> > On Mon, Sep 19, 2011 at 05:20:43PM -0400, Steven Rostedt wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > The code in memcg_check_events() calls this_cpu_read() on
> > > different variables without disabling preemption, and can cause
> > > the calculations to be done from two different CPU variables.
> > > 
> > > Disable preemption throughout the check to keep apples and oranges
> > > from becoming a mixed drink.
> > 
> > Makes sense, thanks!
> > 
> > Since the atomic versions are no longer required with preemption
> > disabled explicitely, could you also make the this_cpu ops in
> > __memcg_event_check and __mem_cgroup_target_update non-atomic in the
> > same go?

Although this patch set is RFC, I probably should go ahead and push this
one forward, as it looks to be a real bug.

> 
> Sorry, shouldn't be on you, can you fold this in?

Sure, thanks!

-- Steve

> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b76011a..9d4ba65 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -683,8 +683,8 @@ static bool __memcg_event_check(struct mem_cgroup *memcg, int target)
>  {
>  	unsigned long val, next;
>  
> -	val = this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
> -	next = this_cpu_read(memcg->stat->targets[target]);
> +	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
> +	next = __this_cpu_read(memcg->stat->targets[target]);
>  	/* from time_after() in jiffies.h */
>  	return ((long)next - (long)val < 0);
>  }
> @@ -693,7 +693,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
>  {
>  	unsigned long val, next;
>  
> -	val = this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
> +	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
>  
>  	switch (target) {
>  	case MEM_CGROUP_TARGET_THRESH:
> @@ -709,7 +709,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
>  		return;
>  	}
>  
> -	this_cpu_write(memcg->stat->targets[target], next);
> +	__this_cpu_write(memcg->stat->targets[target], next);
>  }
>  
>  /*


