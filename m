Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab2FUI21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:28:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39078 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2FUI2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:28:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE2DAA3.20606@jp.fujitsu.com>
Date: Thu, 21 Jun 2012 17:26:11 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] memcg: remove -EINTR at rmdir()
References: <4FDF17A3.9060202@jp.fujitsu.com> <20120618133012.GB2313@tiehlicka.suse.cz> <4FDFC34B.3010003@jp.fujitsu.com> <20120619124036.GB22254@tiehlicka.suse.cz>
In-Reply-To: <20120619124036.GB22254@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/19 21:40), Michal Hocko wrote:
> On Tue 19-06-12 09:09:47, KAMEZAWA Hiroyuki wrote:
>> (2012/06/18 22:30), Michal Hocko wrote:
>>> On Mon 18-06-12 20:57:23, KAMEZAWA Hiroyuki wrote:
>>>> 2 follow-up patches for "memcg: move charges to root cgroup if use_hierarchy=0",
>>>> developped/tested onto memcg-devel tree. Maybe no HUNK with -next and -mm....
>>>> -Kame
>>>> ==
>>>> memcg: remove -EINTR at rmdir()
>>>>
>>>> By commit "memcg: move charges to root cgroup if use_hierarchy=0",
>>>> no memory reclaiming will occur at removing memory cgroup.
>>>
>>> OK, so the there are only 2 reasons why move_parent could fail in this
>>> path. 1) it races with somebody else who is uncharging or moving the
>>> charge and 2) THP split.
>>> 1) works for us and 2) doens't seem to be serious enough to expect that
>>> it would stall rmdir on the group for unbound amount of time so the
>>> change is safe (can we make this into the changelog please?).
>>>
>>
>> Yes. But the failure of move_parent() (-EBUSY) will be retried.
>>
>> Remaining problems are
>>   - attaching task while pre_destroy() is called.
>>   - creating child cgroup while pre_destroy() is called.
>
> I don't know why but I thought that tasks and subgroups are not alowed
> when pre_destroy is called. If this is possible then we probably want to
> check for pending signals or at least add cond_resched.


Now, pre_destroy() call is done as

	lock_cgroup_mutex();
	do some pre-check, no child, no tasks.
	unlock_cgroup_mutex();

	->pre_destroy()

	lock_cgroup_mutex()
	check css's refcnt....

What I take care of now is following case.
		CPU A			    CPU-B
	unlock_cgroup_mutex()
	->pre_destroy()

	<delay by something>		attach new task
					add new charge
					detach the task
	lock_cgroup_mutex()
	check rss' refcnt

This will cause account leak even if I think this will not happen in the real world.
I'd like to disable attach task.

Now, our ->pre_destroy() is quite fast because we don't have no memory reclaim.
I believe we can call ->pre_destroy() without dropping cgroup_mutex.

	lock_cgroup_mutex()
	do pre-check

	->pre_destroy()

	check css's refcnt

I think this is straightforward. I'd like to post a patch.
Thanks,
-Kame






















