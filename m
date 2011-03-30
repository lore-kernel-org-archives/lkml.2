Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1C3QMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:12:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49960 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1C3QMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:12:19 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110330153228.GA1787@redhat.com>
References: <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins>
	 <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com>
	 <20110330130951.GA2124@jolsa.brq.redhat.com>
	 <20110330153228.GA1787@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Mar 2011 18:11:47 +0200
Message-ID: <1301501507.4859.210.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 17:32 +0200, Oleg Nesterov wrote:
> probably smp_mb__after_atomic_inc() needs a comment...
> 
> It is needed to avoid the race between perf_sched_events_dec() and
> perf_sched_events_inc().
> 
> Suppose that we have a single event, both counters == 1. We create
> another event and call perf_sched_events_inc(). Without the barrier
> we could increment the counters in reverse order,
> 
>         jump_label_inc(&perf_sched_events_in);
>         /* ---- WINDOW ---- */
>         jump_label_inc(&perf_sched_events_out);
> 
> Now, if perf_sched_events_dec() is called in between, it can disable
> _out but not _in. This means we can leak ->task_ctx again. 

But in that case we need an mb in perf_sched_events_dec() too, because
for the !JUMP_LABEL case that's a simple atomic_dec() and combined with
synchronize_sched() being a nop for num_online_cpus()==1 there's no
ordering there either.

Also, wouldn't this then require an smp_rmb() in the
perf_event_task_sched_{in,out} COND_STMT/JUMP_LABEL read side?

