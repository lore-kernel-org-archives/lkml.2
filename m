Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0EEFIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:08:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36522 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0EEFIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QqhjWmwJD/dcxWwTUQG6R7rCs2f+C19FbOoeukl9DSvy3YRp0eXmuTJG+GW3jkRFnS
         HSX9RDSMRq9Sndv0YgSTmt1w6/nl4tpgELNeHZlB4Uxp/NBRF3/oQdA3o7ObWyghIkiI
         BtSDYrxtQ6b8azAIBnIeVyNMmKRD6OCN3zL0I=
Date: Wed, 5 May 2010 07:08:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 03/12] perf: add perf_event_task_migrate()
Message-ID: <20100505050846.GG5427@nowhere>
References: <1272976724-14312-1-git-send-email-tj@kernel.org> <1272976724-14312-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272976724-14312-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 02:38:35PM +0200, Tejun Heo wrote:
> Instead of calling perf_sw_event() directly from set_task_cpu(),
> implement perf_event_task_migrate() which takes the same arguments as
> trace_sched_migrate_task() and invokes perf_sw_event() is the task is
> really migrating (cur_cpu != new_cpu).  This will help unifying
> notifiers in sched.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  include/linux/perf_event.h |    3 +++
>  kernel/perf_event.c        |   11 +++++++++++
>  kernel/sched.c             |    5 ++---
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index c8e3754..a5eec48 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -754,6 +754,7 @@ extern int perf_max_events;
>  
>  extern const struct pmu *hw_perf_event_init(struct perf_event *event);
>  
> +extern void perf_event_task_migrate(struct task_struct *task, int new_cpu);
>  extern void perf_event_task_sched_in(struct task_struct *task);
>  extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
>  extern void perf_event_task_tick(struct task_struct *task);
> @@ -949,6 +950,8 @@ extern void perf_event_enable(struct perf_event *event);
>  extern void perf_event_disable(struct perf_event *event);
>  #else
>  static inline void
> +perf_event_task_migrate(struct task_struct *task, int new_cpu)		{ }
> +static inline void
>  perf_event_task_sched_in(struct task_struct *task)			{ }
>  static inline void
>  perf_event_task_sched_out(struct task_struct *task,
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 3d1552d..a01ba31 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1148,6 +1148,17 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
>  }
>  
>  /*
> + * Called from scheduler set_task_cpu() to notify migration events.
> + * If the task is moving to a different cpu, generate a migration sw
> + * event.
> + */
> +void perf_event_task_migrate(struct task_struct *task, int new_cpu)
> +{
> +	if (task_cpu(task) != new_cpu)
> +		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
> +}



This needs to be static and inline (I haven't seem external users in this
patchset).

And we want it to be inlined because we save the caller address and the frame
pointer from perf_sw_event(), and a new level of call is not wanted here.



> +
> +/*
>   * Called from scheduler to remove the events of the current task,
>   * with interrupts disabled.
>   *
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c20fd31..2568911 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2084,11 +2084,10 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>  #endif
>  
>  	trace_sched_migrate_task(p, new_cpu);
> +	perf_event_task_migrate(p, new_cpu);
>  
> -	if (task_cpu(p) != new_cpu) {
> +	if (task_cpu(p) != new_cpu)



In fact why not moving both tracing calls under this check.
This is going to fix the migrate trace event that gets called
even on "spurious" migrations, and you avoid the duplicate check
in the perf callback.

Thanks.


>  		p->se.nr_migrations++;
> -		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
> -	}
>  
>  	__set_task_cpu(p, new_cpu);
>  }
> -- 
> 1.6.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

