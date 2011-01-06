Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1AFKPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:15:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:36323 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1AFKPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:15:42 -0500
Subject: Re: [PATCH 4/5] perf_events: add cgroup support (v7)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <AANLkTinGaHThAxO+0ObCtv+28W8bKULBEtV1KQ4Nax8H@mail.gmail.com>
References: <4d2205a1.8b02e30a.3541.ffff8aee@mx.google.com>
	 <1294226618.2016.259.camel@laptop>
	 <AANLkTin_NMwsymSaTaCkuMmkQ91YbW3VChhc2Mx41KN5@mail.gmail.com>
	 <AANLkTinGaHThAxO+0ObCtv+28W8bKULBEtV1KQ4Nax8H@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Jan 2011 11:15:09 +0100
Message-ID: <1294308909.2016.321.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 22:39 +0100, Stephane Eranian wrote:
> Peter,
> 
> On Wed, Jan 5, 2011 at 2:01 PM, Stephane Eranian <eranian@google.com> wrote:
> > On Wed, Jan 5, 2011 at 12:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> On Mon, 2011-01-03 at 18:20 +0200, Stephane Eranian wrote:
> >>> +void
> >>> +perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
> >>> +{
> >>> +     struct perf_cgroup *cgrp_out = perf_cgroup_from_task(task);
> >>> +     struct perf_cgroup *cgrp_in = perf_cgroup_from_task(next);
> >>> +     struct perf_cpu_context *cpuctx;
> >>> +     struct pmu *pmu;
> >>> +     /*
> >>> +      * if task is DEAD, then css_out is irrelevant, it has
> >>> +      * been changed to init_cgrp in cgroup_exit() from do_exit().
> >>> +      * Furthermore, perf_cgroup_exit_task(), has scheduled out
> >>> +      * all css constrained events, only unconstrained events
> >>> +      * remain. Therefore we need to reschedule based on css_in.
> >>> +      */
> >>> +     if (task->state != TASK_DEAD && cgrp_out == cgrp_in)
> >>> +             return;
> >>
> >> I think that check is broken, TASK_DEAD is set way after calling
> >> cgroup_exit(), so if we get preempted in between there you'll still go
> >> funny.
> >>
> 
> I looked at this part again.
> 
> The original code checking for TASK_DEAD is correct.
> 
> The reason is simple, you're looking at perf_cgroup_switch() which is
> invoked as part of schedule() and NOT perf_event_task_exit() (called
> prior to cgroup_exit()).
> Thus, by the time you do the final schedule(), the task state has indeed
> been switched to TASK_DEAD.
> 
> I remember testing for this condition during the debug phase.

But, cgroup_exit() detaches the task from the cgroup, after which the
cgroup can disappear. Furthermore, we can schedule after cgroup_exit()
and before the explicit schedule() invocation.

Some of the exit functions (say proc_exit_connector) can block and cause
scheduling, and with PREEMPT=y we can get preempted.

This means you'll be context switching, and thus possibly calling
perf_cgroup_switch(), on a task who's cgroup is possibly destroyed.

So I'm not at all seeing how this is correct.
