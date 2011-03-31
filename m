Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab1CaN2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab1CaN2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:28:41 -0400
Date: Thu, 31 Mar 2011 15:28:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110331132815.GA4267@redhat.com>
References: <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com> <20110330130951.GA2124@jolsa.brq.redhat.com> <1301496684.4859.192.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301496684.4859.192.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Peter Zijlstra wrote:
>
> -atomic_t perf_sched_events __read_mostly;
> +atomic_t perf_sched_events_in __read_mostly;
> +atomic_t perf_sched_events_out __read_mostly;
>  static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
>
> +static void perf_sched_events_inc(void)
> +{
> +	jump_label_inc(&perf_sched_events_out);
> +	jump_label_inc(&perf_sched_events_in);
> +}
> +
> +static void perf_sched_events_dec(void)
> +{
> +	jump_label_dec(&perf_sched_events_in);
> +	JUMP_LABEL(&perf_sched_events_in, no_sync);
> +	synchronize_sched();
> +no_sync:
> +	jump_label_dec(&perf_sched_events_out);
> +}

OK, synchronize_sched() can't work. How about

	static int force_perf_event_task_sched_out(void *unused)
	{
		struct task_struct *curr = current;

		__perf_event_task_sched_out(curr, task_rq(curr)->idle);

		return 0;
	}

	void synchronize_perf_event_task_sched_out(void)
	{
		stop_machine(force_perf_event_task_sched_out, NULL,
				cpu_possible_mask);
	}

instead?

	- stop_machine(cpu_possible_mask) ensures that each cpu
	  does the context switch and calls _sched_out

	- force_perf_event_task_sched_out() is only needed because
	  the migration thread can have the counters too.

Note, I am not sure this is the best solution. Just in case we don't
find something better.

In any case, do you think this can work or I missed something again?

Oleg.

