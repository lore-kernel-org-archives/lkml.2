Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab1ATOix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:38:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:47117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab1ATOiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:38:52 -0500
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com, Paul Menage <menage@google.com>
In-Reply-To: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 Jan 2011 15:39:05 +0100
Message-ID: <1295534345.28776.175.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 15:30 +0200, Stephane Eranian wrote:
> @@ -4259,8 +4261,20 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>  
>         /* Reassign the task to the init_css_set. */
>         task_lock(tsk);
> +       /*
> +        * we mask interrupts to prevent:
> +        * - timer tick to cause event rotation which
> +        *   could schedule back in cgroup events after
> +        *   they were switched out by perf_cgroup_sched_out()
> +        *
> +        * - preemption which could schedule back in cgroup events
> +        */
> +       local_irq_save(flags);
> +       perf_cgroup_sched_out(tsk);
>         cg = tsk->cgroups;
>         tsk->cgroups = &init_css_set;
> +       perf_cgroup_sched_in(tsk);
> +       local_irq_restore(flags);
>         task_unlock(tsk);
>         if (cg)
>                 put_css_set_taskexit(cg); 

So you too need a callback on cgroup change there.. Li, Paul, any chance
we can fix this cgroup_subsys::exit callback? The scheduler code needs
to do funny thing because its in the wrong place as well.
