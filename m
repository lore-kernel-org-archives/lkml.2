Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1C3Pcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab1C3Pcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:32:53 -0400
Date: Wed, 30 Mar 2011 17:32:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110330153228.GA1787@redhat.com>
References: <20110326161346.GA18272@redhat.com> <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com> <20110330130951.GA2124@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330130951.GA2124@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Jiri Olsa wrote:
>
> On Mon, Mar 28, 2011 at 06:56:48PM +0200, Oleg Nesterov wrote:
> >
> > As for HAVE_JUMP_LABEL, I still can't understand why this test-case
> > triggers the problem. But jump_label_inc/dec logic looks obviously
> > racy.
>
> I think the reason is, that there are actually 2 places that
> needs to be updated by jump label code
>  - perf_event_task_sched_in
>  - perf_event_task_sched_out
>
> As for my image it first patches perf_event_task_sched_out and then
> perf_event_task_sched_in

Indeed! Thanks a lot Jiri, now I understand.

jump_label_update() doesn't change all entries in a batch. So, as you
explained, it is quite possible that jump_label_update() disables
perf_event_task_sched_out() first. When the caller calls
arch_jump_label_transform() again to disable the next entry, it has
task_ctx != NULL which can't be cleared.

> IIUIC that calling synchronize_sched in perf_sched_events_dec
> ensures that final schedule back to the release code will not
> call perf_event_task_sched_in, so task_ctx stays sane (NULL).

Yes. IOW, this guarantees that perf_event_task_sched_in() is always
paired with perf_event_task_sched_out().

> The cool think is, that it also fixies the original issue,
> which was: wrong counters for perf builtin test #3..
> which I started with from the very beggining :)

Great ;)

> please let me know what you think, thanks

Yes, this is what I meant.

I'd like to look at this patch again later, perhaps we can move some
code from #ifdef/#else... But I have the headache today, just can't
understand all these ifdef's.

> +#ifdef HAVE_JUMP_LABEL
> +static inline
> +void perf_sched_events_inc(void)
> +{
> +	jump_label_inc(&perf_sched_events_out);
> +	smp_mb__after_atomic_inc();
> +	jump_label_inc(&perf_sched_events_in);
> +}
> +
> +static inline
> +void perf_sched_events_dec(void)
> +{
> +	if (atomic_dec_and_test(&perf_sched_events_in)) {
> +		jump_label_disable(&perf_sched_events_in);
> +		synchronize_sched();
> +	}
> +
> +	jump_label_dec(&perf_sched_events_out);

probably smp_mb__after_atomic_inc() needs a comment...

It is needed to avoid the race between perf_sched_events_dec() and
perf_sched_events_inc().

Suppose that we have a single event, both counters == 1. We create
another event and call perf_sched_events_inc(). Without the barrier
we could increment the counters in reverse order,

	jump_label_inc(&perf_sched_events_in);
	/* ---- WINDOW ---- */
	jump_label_inc(&perf_sched_events_out);

Now, if perf_sched_events_dec() is called in between, it can disable
_out but not _in. This means we can leak ->task_ctx again.


---------------------------------------------------------------------

HOWEVER. While I think synchronize_sched() should work in practice,
in theory (according to the documentation) it can't always help in
this case. I'll write another email tomorrow, can't think properly
today. Anyway this looks solveable, but perhaps we need stop_cpus()
instead.

Oleg.

