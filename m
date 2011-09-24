Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1IXAqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 20:46:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:32779 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1IXAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 20:46:30 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=IHHmwdYJPJ0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=ufHFDILaAAAA:8 a=1XWaLZrsAAAA:8 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=oqEcCPETI-XWw8UmE9oA:9 a=0alzAb2czqQn2LHHQhUA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=l7ZknGph1ugA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 3/5] memcg: Disable preemption in
 memcg_check_events()
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Date: Fri, 23 Sep 2011 20:46:25 -0400
In-Reply-To: <20110919212641.015320989@goodmis.org>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212641.015320989@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316825188.6387.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 17:20 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0003-memcg-Disable-preemption-in-memcg_check_events.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The code in memcg_check_events() calls this_cpu_read() on
> different variables without disabling preemption, and can cause
> the calculations to be done from two different CPU variables.
> 
> Disable preemption throughout the check to keep apples and oranges
> from becoming a mixed drink.
> 


> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Oops, I just noticed that I cut and pasted from another commit and was
suppose to change these to Cc's as all the above (except Johannes) did
not give their ack or sob.

I'll merge in Johannes's changes and push out a patch for someone to
take.

Thanks,


-- Steve


> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  mm/memcontrol.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3508777..a164c93 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -718,6 +718,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
>   */
>  static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
>  {
> +	preempt_disable();
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(__memcg_event_check(mem, MEM_CGROUP_TARGET_THRESH))) {
>  		mem_cgroup_threshold(mem);
> @@ -737,6 +738,7 @@ static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
>  		}
>  #endif
>  	}
> +	preempt_enable();
>  }
>  
>  static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)


