Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0DOH3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab0DOH3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:30 -0400
Subject: Re: [RFC][PATCH 10/11] sched: add bandwidth management for
 sched_dl.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267385230.13676.101.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
	 <1267385230.13676.101.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 12:09:48 +0200
Message-ID: <1271239788.32749.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 20:27 +0100, Raistlin wrote:
> @@ -2063,6 +2210,30 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
>         return delta < (s64)sysctl_sched_migration_cost;
>  }
>  
> +/*
> + * When dealing with a -deadline task, we have to check if moving it to
> + * a new CPU is possible or not. In fact, this is only true iff there
> + * is enough bandwidth available on such CPU, otherwise we want the
> + * whole migration progedure to fail over.
> + */
> +static inline
> +bool __set_task_cpu_dl(struct task_struct *p, unsigned int cpu)
> +{
> +       struct dl_bandwidth *dl_b = task_dl_bandwidth(p);
> +
> +       raw_spin_lock(&dl_b->dl_runtime_lock);
> +       if (dl_b->dl_bw < dl_b->dl_total_bw[cpu] + p->dl.dl_bw) {
> +               raw_spin_unlock(&dl_b->dl_runtime_lock);
> +
> +               return 0;
> +       }
> +       dl_b->dl_total_bw[task_cpu(p)] -= p->dl.dl_bw;
> +       dl_b->dl_total_bw[cpu] += p->dl.dl_bw;
> +       raw_spin_unlock(&dl_b->dl_runtime_lock);
> +
> +       return 1;
> +}
> +
>  void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>  {
>  #ifdef CONFIG_SCHED_DEBUG
> @@ -2077,6 +2248,9 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>         trace_sched_migrate_task(p, new_cpu);
>  
>         if (task_cpu(p) != new_cpu) {
> +               if (task_has_dl_policy(p) && !__set_task_cpu_dl(p, new_cpu))
> +                       return;
> +
>                 p->se.nr_migrations++;
>                 perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
>         } 

Yikes!!, I'm not sure we can sanely deal with set_task_cpu() doing that.

I'd much rather see us never attempting set_task_cpu() when we know its
not going to be possible.

That also means that things like set_cpus_allowed_ptr() /
sys_sched_setaffinity() will need to propagate the error back to their
users, which in turn will need to be able to cope.

