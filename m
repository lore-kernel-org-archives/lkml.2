Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2JRB0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:26:07 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13477 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2JRB0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:26:04 -0400
Message-ID: <507F5A81.7010007@huawei.com>
Date: Thu, 18 Oct 2012 09:25:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <rjw@sisk.pl>, <oleg@redhat.com>, <linux-kernel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called after
 the task is added to css_set
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-2-git-send-email-tj@kernel.org> <507E6C4B.6000704@huawei.com>
In-Reply-To: <507E6C4B.6000704@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ÓÚ 2012/10/17 16:28, Li Zefan Ð´µÀ:
> On 2012/10/17 6:28, Tejun Heo wrote:
>> cgroup core has a bug which violates a basic rule about event
>> notifications - when a new entity needs to be added, you add that to
>> the notification list first and then make the new entity conform to
>> the current state.  If done in the reverse order, an event happening
>> inbetween will be lost.
>>
>> cgroup_subsys->fork() is invoked way before the new task is added to
>> the css_set.  Currently, cgroup_freezer is the only user of ->fork()
>> and uses it to make new tasks conform to the current state of the
>> freezer.  If FROZEN state is requested while fork is in progress
>> between cgroup_fork_callbacks() and cgroup_post_fork(), the child
>> could escape freezing - the cgroup isn't frozen when ->fork() is
>> called and the freezer couldn't see the new task on the css_set.
>>
>> This patch moves cgroup_subsys->fork() invocation to
>> cgroup_post_fork() after the new task is added to the css_set.
>> cgroup_fork_callbacks() is removed.
>>
>> Because now a task may be migrated during cgroup_subsys->fork(),
>> freezer_fork() is updated so that it adheres to the usual RCU locking
>> and the rather pointless comment on why locking can be different there
>> is removed (if it doesn't make anything simpler, why even bother?).
>>
> 
> I don't think rcu read section is sufficient. It guarantees the data you're
> accessing is valid, but the data can be new or can be old.
> 
> So a case below is possible:
> 
> in freezer_fork():
> rcu_read_lock();
> freezer = task_freezer(task);
>                                   move task from freezer to freezer2
>                                   which is in FREEZING/FROZEN state
> freezer is in THAWED state,
> nothing to do.
> rcu_read_unlock();
> 

forget about it. The task will be correctly frozen when moving to
another cgroup, so nothing unexpected will happen.

for this patch:

Acked-by: Li Zefan <lizefan@huawei.com>

