Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2E3LBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:01:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35519 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2E3LBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <4FC5F99B.2060109@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
 <1338371317-5980-2-git-send-email-glommer@parallels.com> <1338373759.26856.238.camel@twins>
 <4FC5F727.2040804@parallels.com> <1338374555.26856.243.camel@twins> <4FC5F99B.2060109@parallels.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 30 May 2012 04:00:37 -0700
Message-ID: <CAPM31RL-X2GYju-opjUumPq_cfGiRzGowXEOx9Tq4kVEG-z3SA@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] measure exec_clock for rt sched entities
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, devel@openvz.org, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 3:42 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 05/30/2012 02:42 PM, Peter Zijlstra wrote:
>>
>> On Wed, 2012-05-30 at 14:32 +0400, Glauber Costa wrote:
>>>>>
>>>>> +    for_each_sched_rt_entity(rt_se) {
>>>>> +            rt_rq = rt_rq_of_se(rt_se);
>>>>> +            schedstat_add(rt_rq, exec_clock, delta_exec);
>>>>> +    }
>>>>> +
>>>>>      if (!rt_bandwidth_enabled())
>>>>>              return;
>>>>
>>>>
>>>> See, this just makes me sad.. you now have a double
>>>> for_each_sched_rt_entity() loop.
>>>
>>>
>>> The way I read the rt.c code, it it is called from enqueue_task_rt only
>>> once.
>>
>>
>> Ah, what I meant was, right after that !rt_bandwidth_enabled() muck we
>> do another for_each_sched_rt_entity() walk.
>
> I guess I can fold it there...
>

Does this even need to be hierarchical?  While it's natural for it to
be in the CFS case, it feels forced here.

You could instead make this rt_rq->local_exec_clock  charging only to
the parenting rt_rq and post-aggregate when you want to report.  The
only thing you'd need to be careful of is also accounting children
somewhere on the parent on destruction (reaped_exec_clock?).

Harking back to symmetry, local_exec_clock is also a potentially
useful stat on the CFS side of things since it allows you to usefully
disambiguate versus your children (common case where this is useful is
calculating usage of threads in the root cgroup); so it wouldn't need
to be unique to rt_rq.
