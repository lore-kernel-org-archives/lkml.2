Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1KGRuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:50:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49320 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGRui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <1320686777.17809.34.camel@twins>
References: <20111027075901.GB2313@linux.vnet.ibm.com>
	<20111027080016.GA16885@elte.hu>
	<4EAA14A1.5060204@cn.fujitsu.com>
	<20111029182710.GG6160@linux.vnet.ibm.com>
	<4EAE57AF.1060706@cn.fujitsu.com>
	<20111031093256.GI6160@linux.vnet.ibm.com>
	<4EAF5B68.8090005@cn.fujitsu.com>
	<1320678902.18053.63.camel@twins>
	<CABPqkBTbWE6wVkg_sFnoVL0r4_yi6gCwCoUXzC97kxcxC47zYQ@mail.gmail.com>
	<1320683756.17809.28.camel@twins>
	<20111107165603.GD2332@linux.vnet.ibm.com>
	<CABPqkBRvK9R7wV6c1GB3HT6Nro2w3787QKo80_Bq5XHQ=HffHQ@mail.gmail.com>
	<1320686777.17809.34.camel@twins>
Date: Mon, 7 Nov 2011 17:50:37 +0000
Message-ID: <CABPqkBTD_ygsE2NGRF9bxVrPkishBuPBAKicN27WUR0AVezvKw@mail.gmail.com>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com,
        shaohua.li@intel.com, ak@linux.intel.com, mhocko@suse.cz,
        alex.shi@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 5:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-11-07 at 17:12 +0000, Stephane Eranian wrote:
>> I think on that path:
>>
>> >>> [<8108aa02>] perf_event_enable_on_exec+0x1d2/0x1e0
>> >>> [<81063764>] ? __lock_release+0x54/0xb0
>> >>> [<8108cca8>] perf_event_comm+0x18/0x60
>> >>> [<810d1abd>] ? set_task_comm+0x5d/0x80
>> >>> [<81af622d>] ? _raw_spin_unlock+0x1d/0x40
>> >>> [<810d1ac4>] set_task_comm+0x64/0x80
>>
>> We are neither holding the rcu_read_lock() nor the task_lock() but we
>> are operating on the current task. The task cannot just vanish. So
>> the rcu_dereference() and lock_is_held() macros may detect a false
>> positive in that case. Yet, I doubt this would be the only place....
>
> Well, normally being current doesn't guarantee your cgroup won't
> disappear. The perf stuff hwoever takes refs and is synced against
> ->attach() by virtue of it calling perf_cgroup_switch() etc..
>
perf_event_enable_on_exec()
   perf_cgroup_sched_out(current, NULL);
     perf_cgroup_from_task(current)
        task_subsys_state(current, perf_subsys_id)

That is the sequence triggering the warning.
Obviously, we come here without task_lock() nor rcu_read_lock().

The cgroup cannot disappear because it is refcounted by perf_events.
The task cannot disappear because it's the current task.

So I think we need to simply quiesce the warning, most likely like
what Peter just suggested.
