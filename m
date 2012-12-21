Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab2LUE27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 23:28:59 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53769 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 23:28:55 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-72-50d3e5847931
From: Namhyung Kim <namhyung@kernel.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Alex Shi <alex.shi@intel.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 01/18] sched: select_task_rq_fair clean up
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<1355127754-8444-2-git-send-email-alex.shi@intel.com>
	<50C6B530.3030307@linux.vnet.ibm.com> <50C6C462.6030808@intel.com>
	<50C6D31F.1030408@linux.vnet.ibm.com>
Date: Fri, 21 Dec 2012 13:28:52 +0900
In-Reply-To: <50C6D31F.1030408@linux.vnet.ibm.com> (Preeti U. Murthy's message
	of "Tue, 11 Dec 2012 12:00:55 +0530")
Message-ID: <87k3scf2pn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 11 Dec 2012 12:00:55 +0530, Preeti U. Murthy wrote:
> On 12/11/2012 10:58 AM, Alex Shi wrote:
>> On 12/11/2012 12:23 PM, Preeti U Murthy wrote:
>>> Hi Alex,
>>>
>>> On 12/10/2012 01:52 PM, Alex Shi wrote:
>>>> It is impossible to miss a task allowed cpu in a eligible group.
>>>
>>> The one thing I am concerned with here is if there is a possibility of
>>> the task changing its tsk_cpus_allowed() while this code is running.
>>>
>>> i.e find_idlest_group() finds an idle group,then the tsk_cpus_allowed()
>>> for the task changes,perhaps by the user himself,which might not include
>>> the cpus in the idle group.After this find_idlest_cpu() is called.I mean
>>> a race condition in short.Then we might not have an eligible cpu in that
>>> group right?
>> 
>> your worry make sense, but the code handle the situation, in
>> select_task_rq(), it will check the cpu allowed again. if the answer is
>> no, it will fallback to old cpu.
>>>
>>>> And since find_idlest_group only return a different group which
>>>> excludes old cpu, it's also imporissible to find a new cpu same as old
>>>> cpu.
>
> I doubt this will work correctly.Consider the following situation:sched
> domain begins with sd that encloses both socket1 and socket2
>
> cpu0 cpu1  | cpu2 cpu3
> -----------|-------------
>  socket1   |  socket2
>
> old cpu = cpu1
>
> Iteration1:
> 1.find_idlest_group() returns socket2 to be idlest.
> 2.task changes tsk_allowed_cpus to 0,1
> 3.find_idlest_cpu() returns cpu2

AFAIK The tsk->cpus_allowed cannot be changed during the operation since
it's protected by tsk->pi_lock.  I can see the following comment:

kernel/sched/core.c:
/*
 * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
 */
static inline
int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
{
	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);



Thanks,
Namhyung
