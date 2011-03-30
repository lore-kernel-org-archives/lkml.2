Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab1C3Qh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:37:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1C3Qhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:37:54 -0400
Date: Wed, 30 Mar 2011 18:37:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110330163730.GA6038@redhat.com>
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
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -125,9 +125,25 @@ enum event_type_t {
>   * perf_sched_events : >0 events exist
>   * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
>   */
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

Nice! I didn't realize we can simply use JUMP_LABEL() directly and then
the code doesn't depend on HAVE_JUMP_LABEL.

Now, the problem is, after I read the comments I am not sure I understand
what synchronize_sched() actually doe. Add Paul.



So. synchronize_sched() above should ensure that all CPUs do context
switch at least once (ignoring idle). And I _thought_ that in practice
this should work.

But, unles I misread the comment above synchronize_sched(), it seems that
it only guarantees the end of "everything" which disables preemption,
explicitly or not. IOW, say, in theory rcu_read_unlock_sched() could
trigger ->passed_quiesc == T without reschedule.

Oh, and this is not theoretical, afaics. run_ksoftirqd() does
rcu_note_context_switch().



So, I think we need something else :/

Oleg.

