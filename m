Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0DWBDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:03:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52167 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab0DWBDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:03:52 -0400
Message-ID: <4BD0F261.6080302@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 09:05:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@vnet.ibm.com>
Subject: Re: [PATCH 4/5] freezer cgroup: Fix an RCU warning in cgroup_freezing_or_frozen()
References: <4BD016F4.8060108@cn.fujitsu.com>	 <4BD01768.2020606@cn.fujitsu.com> <1271939275.1776.345.camel@laptop>	 <20100422195911.GN2524@linux.vnet.ibm.com> <1271966935.1646.4.camel@laptop>
In-Reply-To: <1271966935.1646.4.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> with CONFIG_PROVE_RCU, a warning can be triggered when we
>>>> resume from suspend:
>>>>
>>>> ...
>>>> include/linux/cgroup.h:533 invoked rcu_dereference_check() without protection!
>>>> ...
>>>>
>>>> task_freezer() calls task_subsys_state(), which needs to be
>>>> protected by rcu_read_lock or cgroup_mutex.
>>>>
>>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>>> ---
>>>>  kernel/cgroup_freezer.c |    2 ++
>>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
>>>> index 5038f4c..ac76983 100644
>>>> --- a/kernel/cgroup_freezer.c
>>>> +++ b/kernel/cgroup_freezer.c
>>>> @@ -53,6 +53,7 @@ int cgroup_freezing_or_frozen(struct task_struct *task)
>>>>  	struct freezer *freezer;
>>>>  	enum freezer_state state;
>>>>  
>>>> +	rcu_read_lock();
>>>>  	task_lock(task);
>>>>  	freezer = task_freezer(task);
>>>>  	if (!freezer->css.cgroup->parent)
>>>> @@ -60,6 +61,7 @@ int cgroup_freezing_or_frozen(struct task_struct *task)
>>>>  	else
>>>>  		state = freezer->state;
>>>>  	task_unlock(task);
>>>> +	rcu_read_unlock();
>>>>  
>>>>  	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
>>>>  }
>>> Hmm cgroup_attach_task() does hold task_lock() over setting
>>> tsk->cgroups, so doesn't that also pin the task to the cgroup and thus
>>> the cgroup itself?
>> So you are advocating for the rcu_dereference check including the
>> task lock, correct?
> 
> I think that might be correct yes, although I would prefer confirmation
> from someone who actually knows kernel/cgroup.c ;-)
> 

You are right in that taking task_lock() is sufficient (I forgot
this lock rule), but it's not true that whatever locks are held
in the ->attach method can pin a task's cgroup.

So the right fix is including task_lock in rcu_deref check in
task_subsys_state(). I'll send a new fix.
