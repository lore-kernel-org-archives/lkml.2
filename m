Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1C1SGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab1C1SGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:06:01 -0400
Date: Mon, 28 Mar 2011 18:56:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110328165648.GA9304@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com> <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com> <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301327368.4859.28.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Peter Zijlstra wrote:
>
> Another fun race, suppose we do properly remove task_ctx and is_active,
> but then the task gets scheduled back in before free_event() gets around
> to disabling the jump_label..

Yes, this too...

Well, ignoring the HAVE_JUMP_LABEL case... perhaps we can split
perf_sched_events into 2 counters? I mean,

	atomic_t perf_sched_events_in, perf_sched_events_out;

	static inline void perf_event_task_sched_in(struct task_struct *task)
	{
		COND_STMT(&perf_sched_events_in, __perf_event_task_sched_in(task));
	}

	static inline
	void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
	{
		perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);

		COND_STMT(&perf_sched_events_out, __perf_event_task_sched_out(task, next));
	}

	void perf_sched_events_inc(void)
	{
		atomic_inc(&perf_sched_events_out);
		smp_mb__after_atomic_inc();
		atomic_inc(&perf_sched_events_in);
	}

	void perf_sched_events_dec(void)
	{
		if (atomic_dec_and_test(&perf_sched_events_in))
			synchronize_sched();
		atomic_dec(&perf_sched_events_out);
	}

The last 2 helpers should be used instead of jump_label_inc/dec.



Or we can remove COND_STMT() from perf_event_task_sched_out(). Say,
__perf_event_task_sched_in() can set PF_PERF_XXX or something, then
perf_event_task_sched_out() can check this bit.


As for HAVE_JUMP_LABEL, I still can't understand why this test-case
triggers the problem. But jump_label_inc/dec logic looks obviously
racy.

jump_label_dec:

	if (atomic_dec_and_test(key))
		jump_label_disable(key);

Another thread can create the PERF_ATTACH_TASK event in between
and call jump_label_update(JUMP_LABEL_ENABLE) first. Looks like,
jump_label_update() should ensure that "type" matches the state
of the "*key" under jump_label_lock().

But perhaps I misread this code completely.

Oleg.

