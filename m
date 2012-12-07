Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2LGIdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:33:12 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57753 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2LGIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:33:10 -0500
MIME-Version: 1.0
In-Reply-To: <50C14747.9060707@intel.com>
References: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
	<1354542848-29638-3-git-send-email-alex.shi@intel.com>
	<CAFTL4hz=PQZuSsF_6--i5BmiJGVxXngdQjDRD4gx4-SwDk36zw@mail.gmail.com>
	<50C14747.9060707@intel.com>
Date: Fri, 7 Dec 2012 09:33:09 +0100
Message-ID: <CAFTL4hyVx6otU=PBsXLbd3dqsdem9CXPaxetp_zz+8UhqsS=hw@mail.gmail.com>
Subject: Re: [PATCH 02/10] sched: fix find_idlest_group mess logical
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/7 Alex Shi <alex.shi@intel.com>:
> On 12/07/2012 08:56 AM, Frederic Weisbecker wrote:
>> 2012/12/3 Alex Shi <alex.shi@intel.com>:
>>> There is 4 situations in the function:
>>> 1, no task allowed group;
>>>         so min_load = ULONG_MAX, this_load = 0, idlest = NULL
>>> 2, only local group task allowed;
>>>         so min_load = ULONG_MAX, this_load assigned, idlest = NULL
>>> 3, only non-local task group allowed;
>>>         so min_load assigned, this_load = 0, idlest != NULL
>>> 4, local group + another group are task allowed.
>>>         so min_load assigned, this_load assigned, idlest != NULL
>>>
>>> Current logical will return NULL in first 3 kinds of scenarios.
>>> And still return NULL, if idlest group is heavier then the
>>> local group in the 4th situation.
>>>
>>> Actually, I thought groups in situation 2,3 are also eligible to host
>>> the task. And in 4th situation, agree to bias toward local group.
>>> So, has this patch.
>>
>> The way I understand the loop that use this in select_task_rq_fair() is:
>>
>> a) start from the highest domain level we are allowed to run to
>> migrate the task in
>> b) from that top level domain, find the idlest group. If the idlest
>> group contains current CPU, zoom in the child domain and repeat b). If
>> the idlest group doesn't contain the current CPU, pick the idlest CPU
>> from that group.
>> c) In the end if we found no idler target than current CPU, then take it.
>>
>> So if you also return a group that contains current CPU from
>> find_idlest_group(), you don't recursively zoom in the child domain
>> anymore. find_idlest_cpu() will fix that for you but it may come with
>> some cost because now it iterates through every CPUs, or may be half
>> of them.
>
> Not exactly, the old logical won't select cpu from group of situation 2
> and 3. That is wrong. and may cause the task keep stay on prev_cpu even
> there are still other idler and allowed cpu exist.

For situation 2 I don't understand the issue. If current CPU belong to
idlest group we want to zoom in our lookup until we find something an
idler group than the current CPU's? If we eventually don't find it,
then we fallback to current CPU, don't we?

I just have a doubt to express. How does the final leaf child domain
look like? Is it made of current CPU only or can it contain other
siblings? In the first case we are fine. In the second one, if this
domain is made of only one group of several CPUs, we are skipping the
find_idlest_cpu() call for that group and choose this_cpu by default.
Which is probably suboptimized?

Concerning situation 3, if this_cpu is not a CPU allowed by the task,
we may indeed have an issue because find_idlest_group() doesn't seem
to be selecting non-local groups in this case. But your current fix
still breaks the recursive find_idlest_group() on other cases and may
not scale with big number of CPUs.
