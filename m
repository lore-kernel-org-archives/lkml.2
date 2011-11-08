Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1KHNKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:10:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55513 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1KHNKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:10:17 -0500
MIME-Version: 1.0
In-Reply-To: <20111107175523.GK2332@linux.vnet.ibm.com>
References: <4EAA14A1.5060204@cn.fujitsu.com>
	<20111029182710.GG6160@linux.vnet.ibm.com>
	<4EAE57AF.1060706@cn.fujitsu.com>
	<20111031093256.GI6160@linux.vnet.ibm.com>
	<4EAF5B68.8090005@cn.fujitsu.com>
	<1320678902.18053.63.camel@twins>
	<CABPqkBTbWE6wVkg_sFnoVL0r4_yi6gCwCoUXzC97kxcxC47zYQ@mail.gmail.com>
	<1320683756.17809.28.camel@twins>
	<20111107165603.GD2332@linux.vnet.ibm.com>
	<1320685789.17809.30.camel@twins>
	<20111107175523.GK2332@linux.vnet.ibm.com>
Date: Tue, 8 Nov 2011 14:10:16 +0100
Message-ID: <CABPqkBRVSGU8SeZMb5iDkMvptQ5GqSroO-kc9YX2Dx569YeJXg@mail.gmail.com>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Stephane Eranian <eranian@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com,
        shaohua.li@intel.com, ak@linux.intel.com, mhocko@suse.cz,
        alex.shi@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hardcoding 1 (true) assumes we will always call perf_cgroup_set_timestamp()
on current task. That's true today but we should make sure we don't
miss an error
if we ever change that in the future.


On Mon, Nov 7, 2011 at 6:55 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Nov 07, 2011 at 06:09:49PM +0100, Peter Zijlstra wrote:
>> On Mon, 2011-11-07 at 08:56 -0800, Paul E. McKenney wrote:
>> >
>> > If this really is a false positive, what should be used to get rid of
>> > the splats?
>>
>>
>> Probably something slightly less horrid than the below.. ;-)
>
> Hmmm...  Could the "1" below be replaced by the task's reference count?
> Probabilistic, but should eventually catch it.
>
>                                                        Thanx, Paul
>
>> ---
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index d1a1bee..8f05201 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -229,7 +229,7 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
>>  static inline struct perf_cgroup *
>>  perf_cgroup_from_task(struct task_struct *task)
>>  {
>> -     return container_of(task_subsys_state(task, perf_subsys_id),
>> +     return container_of(task_subsys_state_check(task, perf_subsys_id, 1),
>>                       struct perf_cgroup, css);
>>  }
>>
>>
>
>
