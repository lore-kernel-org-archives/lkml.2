Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1HYO02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:26:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:49224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1HYO00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:26:26 -0400
Subject: Re: [PATCH] perf_event: fix slow and broken cgroup context switch
 code
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ming.m.lin@intel.com
Date: Thu, 25 Aug 2011 16:26:14 +0200
In-Reply-To: <20110825135803.GA4697@quad>
References: <20110825135803.GA4697@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314282374.27911.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 15:58 +0200, Stephane Eranian wrote:
> +static inline void perf_cgroup_sched_out(struct task_struct *task,
> +                                        struct task_struct *next)
>  {
> +       struct perf_cgroup *cgrp1;
> +       struct perf_cgroup *cgrp2 = NULL;
> +
> +       /*
> +        * we come here when we know perf_cgroup_events > 0
> +        */
> +       cgrp1 = perf_cgroup_from_task(task);
> +
> +       /*
> +        * next is NULL when called from perf_event_enable_on_exec()
> +        * that will systematically cause a cgroup_switch()
> +        */
> +       if (next)
> +               cgrp2 = perf_cgroup_from_task(next);
> +
> +       /*
> +        * only schedule out current cgroup events if we know
> +        * that we are switching to a different cgroup. Otherwise,
> +        * do no touch the cgroup events.
> +        */
> +       if (cgrp1 != cgrp2)
> +               perf_cgroup_switch(task, PERF_CGROUP_SWOUT);
>  }
>  
> +static inline void perf_cgroup_sched_in(struct task_struct *prev,
> +                                       struct task_struct *task)
>  {
> +       struct perf_cgroup *cgrp1;
> +       struct perf_cgroup *cgrp2 = NULL;
> +
> +       /*
> +        * we come here when we know perf_cgroup_events > 0
> +        */
> +       cgrp1 = perf_cgroup_from_task(task);
> +
> +       /* prev can never be NULL */
> +       cgrp2 = perf_cgroup_from_task(prev);
> +
> +       /*
> +        * only need to schedule in cgroup events if we are changing
> +        * cgroup during ctxsw. Cgroup events were not scheduled
> +        * out of ctxsw out if that was not the case.
> +        */
> +       if (cgrp1 != cgrp2)
> +               perf_cgroup_switch(task, PERF_CGROUP_SWIN);
>  } 

OK, looks sane enough, queued the patch, thanks!
