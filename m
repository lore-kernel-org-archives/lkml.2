Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1AEVjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:39:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1AEVjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:39:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=COr9KG8KH796gOzwj7JDVJWVWltnmdcThlhEAjUuxflCs6kq5XX1hOEl59E13uTvCd
         UfxyYvVkakO1d8Qyuyvw==
MIME-Version: 1.0
In-Reply-To: <AANLkTin_NMwsymSaTaCkuMmkQ91YbW3VChhc2Mx41KN5@mail.gmail.com>
References: <4d2205a1.8b02e30a.3541.ffff8aee@mx.google.com>
	<1294226618.2016.259.camel@laptop>
	<AANLkTin_NMwsymSaTaCkuMmkQ91YbW3VChhc2Mx41KN5@mail.gmail.com>
Date: Wed, 5 Jan 2011 22:39:02 +0100
Message-ID: <AANLkTinGaHThAxO+0ObCtv+28W8bKULBEtV1KQ4Nax8H@mail.gmail.com>
Subject: Re: [PATCH 4/5] perf_events: add cgroup support (v7)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Wed, Jan 5, 2011 at 2:01 PM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Jan 5, 2011 at 12:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Mon, 2011-01-03 at 18:20 +0200, Stephane Eranian wrote:
>>> +void
>>> +perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
>>> +{
>>> +     struct perf_cgroup *cgrp_out = perf_cgroup_from_task(task);
>>> +     struct perf_cgroup *cgrp_in = perf_cgroup_from_task(next);
>>> +     struct perf_cpu_context *cpuctx;
>>> +     struct pmu *pmu;
>>> +     /*
>>> +      * if task is DEAD, then css_out is irrelevant, it has
>>> +      * been changed to init_cgrp in cgroup_exit() from do_exit().
>>> +      * Furthermore, perf_cgroup_exit_task(), has scheduled out
>>> +      * all css constrained events, only unconstrained events
>>> +      * remain. Therefore we need to reschedule based on css_in.
>>> +      */
>>> +     if (task->state != TASK_DEAD && cgrp_out == cgrp_in)
>>> +             return;
>>
>> I think that check is broken, TASK_DEAD is set way after calling
>> cgroup_exit(), so if we get preempted in between there you'll still go
>> funny.
>>

I looked at this part again.

The original code checking for TASK_DEAD is correct.

The reason is simple, you're looking at perf_cgroup_switch() which is
invoked as part of schedule() and NOT perf_event_task_exit() (called
prior to cgroup_exit()).
Thus, by the time you do the final schedule(), the task state has indeed
been switched to TASK_DEAD.

I remember testing for this condition during the debug phase.

I will resubmit with the other smaller cleanups.
