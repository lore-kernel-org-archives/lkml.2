Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1BRCg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:36:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60988 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab1BRCgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:36:24 -0500
Message-ID: <4D5DDB77.8090807@cn.fujitsu.com>
Date: Fri, 18 Feb 2011 10:37:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] cpuset: Remove unneeded NODEMASK_ALLOC() in cpuset_attch()
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7EBF.2070603@cn.fujitsu.com> <AANLkTimRH=LVRLnajbtL3a8FwKkbEfLspAHXXeQLUY8=@mail.gmail.com>
In-Reply-To: <AANLkTimRH=LVRLnajbtL3a8FwKkbEfLspAHXXeQLUY8=@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-18 10:35:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-18 10:35:25,
	Serialize complete at 2011-02-18 10:35:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Feb 16, 2011 at 5:49 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> oldcs->mems_allowed is not modified during cpuset_attch(), so
>> we don't have to copy it to a buffer allocated by NODEMASK_ALLOC().
>> Just pass it to cpuset_migrate_mm().
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> I'd be inclined to skip this one - we're already allocating one
> nodemask, so one more isn't really any extra complexity, and we're
> doing horrendously complicated stuff in cpuset_migrate_mm() that's
> much more likely to fail in low-memory situations.

That's true, but it's not a reason to add more cases that can fail.

> 
> It's true that mems_allowed can't change during the call to

Sorry to lead you to mistake what I meant. I meant 'from' is not modified
after it's copied from oldcs->mems_allowed, so the two are exactly the
same and thus we only need one.

> cpuset_attach(), but that's due to the fact that both cgroup_attach()
> and the cpuset.mems write paths take cgroup_mutex. I might prefer to
> leave the allocated nodemask here and wrap callback_mutex around the
> places in cpuset_attach() where we're reading from a cpuset's
> mems_allowed - that would remove the implicit synchronization via
> cgroup_mutex and leave the code a little more understandable.

It's not an implicit synchronization, but instead the lock rule for
reading/writing a cpuset's mems/cpus is described in the comment.

> 
>> ---
>>  kernel/cpuset.c |    7 ++-----
>>  1 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index f13ff2e..70c9ca2 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -1438,10 +1438,9 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>>        struct mm_struct *mm;
>>        struct cpuset *cs = cgroup_cs(cont);
>>        struct cpuset *oldcs = cgroup_cs(oldcont);
>> -       NODEMASK_ALLOC(nodemask_t, from, GFP_KERNEL);
>>        NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
>>
>> -       if (from == NULL || to == NULL)
>> +       if (to == NULL)
>>                goto alloc_fail;
>>
>>        if (cs == &top_cpuset) {
>> @@ -1463,18 +1462,16 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>>        }
>>
>>        /* change mm; only needs to be done once even if threadgroup */
>> -       *from = oldcs->mems_allowed;
>>        *to = cs->mems_allowed;
>>        mm = get_task_mm(tsk);
>>        if (mm) {
>>                mpol_rebind_mm(mm, to);
>>                if (is_memory_migrate(cs))
>> -                       cpuset_migrate_mm(mm, from, to);
>> +                       cpuset_migrate_mm(mm, &oldcs->mems_allowed, to);
>>                mmput(mm);
>>        }
>>
>>  alloc_fail:
>> -       NODEMASK_FREE(from);
>>        NODEMASK_FREE(to);
>>  }
>>
>> --
>> 1.7.3.1
>>
> 
