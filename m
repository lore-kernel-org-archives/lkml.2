Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2CGJTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:19:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55042 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab2CGJTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:19:39 -0500
X-IronPort-AV: E=Sophos;i="4.73,545,1325433600"; 
   d="scan'208";a="4480368"
Message-ID: <4F5728DE.5070501@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 17:22:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH v2] cgroups: Run subsystem fork callback from cgroup_post_fork()
References: <1330057410-9375-1-git-send-email-fweisbec@gmail.com> <1330362171-30697-1-git-send-email-fweisbec@gmail.com> <20120229155500.GU3090@google.com> <20120229162148.GA8375@somewhere.redhat.com> <4F4EEB0F.2000504@cn.fujitsu.com> <20120304135300.GA18143@somewhere.redhat.com>
In-Reply-To: <20120304135300.GA18143@somewhere.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 17:17:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 17:17:43
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Mar 01, 2012 at 11:20:47AM +0800, Li Zefan wrote:
>> 于 2012年03月01日 00:21, Frederic Weisbecker 写道:
>>> On Wed, Feb 29, 2012 at 07:55:00AM -0800, Mandeep Singh Baines wrote:
>>>> Frederic Weisbecker (fweisbec@gmail.com) wrote:
>>>>> When a user freezes a cgroup, the freezer sets the subsystem state
>>>>> to CGROUP_FREEZING and then iterates over the tasks in the cgroup links.
>>>>>
>>>>> But there is a possible race here, although unlikely, if a task
>>>>> forks and the parent is preempted between write_unlock(tasklist_lock)
>>>>> and cgroup_post_fork(). If we freeze the cgroup while the parent
>>>>
>>>> So what if you moved cgroup_post_forks() a few lines up to be
>>>> inside the tasklist_lock?
>>>
>>> It won't work. Consider this scenario:
>>>
>>> CPU 0                                     CPU 1
>>>
>>>                                        cgroup_fork_callbacks()
>>>                                        write_lock(tasklist_lock)
>>> try_to_freeze_cgroup() {               add child to task list etc...
>>> 	cgroup_iter_start()
>>>         freeze tasks                        
>>>         cgroup_iter_end()
>>> }                                      cgroup_post_fork()
>>>                                        write_unlock(tasklist_lock)
>>>
>>> If this is not the first time we call cgroup_iter_start(), we won't go
>>> through the whole tasklist, we simply iterate through the css set task links.
>>>
>>> Plus we try to avoid anything under tasklist_lock when possible.
>>>
>>
>> Your patch won't close the race I'm afraid.
>>
>> // state will be set to FREEZING
>> echo FROZEN > /cgroup/sub/freezer.state
>>                                           write_lock(tasklist_lock)
>>                                           add child to task list ...
>> 					  write_unlock(tasklist_lock)
>> // state will be updated to FROZEN
>> cat /cgroup/sub/freezer.state
>> 					  cgroup_post_fork()
>> 					  ->freezer_fork()
>>
>> freezer_fork() will freeze the task only if the cgroup is in FREEZING
>> state, and will BUG if the state is FROZEN.
> 
> Good point!
> 
>>
>> We can fix freezer_fork(), but seems that requires we hold cgroup_mutex
>> in that function(), which we don't like at all. Not to say your
>> task_counter stuff..
>>
>> At this moment I don't see a solution without tasklist_lock involved,
>> any better idea?
> 
> Ok, everything would be _much_ simpler if we were adding the css set task
> link unconditionally.
> 
> Unfortunately this means acquiring a (global) lock unconditionally and
> doing a list_add() on every fork. Although the lock could perhaps
> be made per css set.
> 
> An idea could be to start the css set linking as soon as we create
> the first subdirectory of a freezer cgroup. The root css set can't be
> freezed and when we create the subdirectory we have no task there yet.
> Due to the threadgroup_lock() that follows, none of the tasks that will be
> attached there can be stuck in the middle of a fork so we are fine against
> their css_set links: we know that when we attach a task to the cgroup of that
> subdir, its css set link is set and we won't have any of the race we are describing.
> 
> How does that sound?
> 

I'm confused..

The race you described is about freezing a cgroup while a task is forking,
and it doesn't have something to do with attaching tasks manually and the
enabling of css set links. So how can the race be fixed in the way you
proposed?
