Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab1C3ROB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:14:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab1C3ROA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:14:00 -0400
Date: Wed, 30 Mar 2011 19:13:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110330171331.GB6038@redhat.com>
References: <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com> <20110330130951.GA2124@jolsa.brq.redhat.com> <20110330153228.GA1787@redhat.com> <1301501507.4859.210.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301501507.4859.210.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Peter Zijlstra wrote:
>
> On Wed, 2011-03-30 at 17:32 +0200, Oleg Nesterov wrote:
> > probably smp_mb__after_atomic_inc() needs a comment...
> >
> > It is needed to avoid the race between perf_sched_events_dec() and
> > perf_sched_events_inc().
> >
> > Suppose that we have a single event, both counters == 1. We create
> > another event and call perf_sched_events_inc(). Without the barrier
> > we could increment the counters in reverse order,
> >
> >         jump_label_inc(&perf_sched_events_in);
> >         /* ---- WINDOW ---- */
> >         jump_label_inc(&perf_sched_events_out);
> >
> > Now, if perf_sched_events_dec() is called in between, it can disable
> > _out but not _in. This means we can leak ->task_ctx again.
>
> But in that case we need an mb in perf_sched_events_dec() too, because
> for the !JUMP_LABEL case that's a simple atomic_dec() and combined with
> synchronize_sched() being a nop for num_online_cpus()==1 there's no
> ordering there either.

I think you are right... afaics we only need barrier() in this case.

> Also, wouldn't this then require an smp_rmb() in the
> perf_event_task_sched_{in,out} COND_STMT/JUMP_LABEL read side?

Oh, I don't think so, but can't prove. We don't need it in UP case.
And if synchronize_sched() worked (see another email), it should
ensure that perf_sched_events_in == 0 must be visible after it
completes.

Oleg.

