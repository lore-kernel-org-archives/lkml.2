Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab2D1AZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:25:04 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54041 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2D1AZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:25:01 -0400
MIME-Version: 1.0
In-Reply-To: <CALWz4iyiM-CFgVaHiE1Lgd1ZwJzHwY3tx9XX6HeDPUV_wVPAtQ@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A375D.7@jp.fujitsu.com>
	<CALWz4iyiM-CFgVaHiE1Lgd1ZwJzHwY3tx9XX6HeDPUV_wVPAtQ@mail.gmail.com>
Date: Sat, 28 Apr 2012 09:25:00 +0900
Message-ID: <CABEgKgrXqbF8XBc6vHa2b5KQe9E7_+WODvq3hE0vaT0Eyxo5=w@mail.gmail.com>
Subject: Re: [RFC][PATCH 9/9 v2] memcg: never return error at pre_destroy()
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 6:28 AM, Ying Han <yinghan@google.com> wrote:
> On Thu, Apr 26, 2012 at 11:06 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> When force_empty() called by ->pre_destroy(), no memory reclaim happens
>> and it doesn't take very long time which requires signal_pending() check.
>> And if we return -EINTR from pre_destroy(), cgroup.c show warning.
>>
>> This patch removes signal check in force_empty(). By this, ->pre_destroy()
>> returns success always.
>>
>> Note: check for 'cgroup is empty' remains for force_empty interface.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  mm/hugetlb.c    |   10 +---------
>>  mm/memcontrol.c |   14 +++++---------
>>  2 files changed, 6 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 4dd6b39..770f1642 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1922,20 +1922,12 @@ int hugetlb_force_memcg_empty(struct cgroup *cgroup)
>>        int ret = 0, idx = 0;
>>
>>        do {
>> +               /* see memcontrol.c::mem_cgroup_force_empty() */
>>                if (cgroup_task_count(cgroup)
>>                        || !list_empty(&cgroup->children)) {
>>                        ret = -EBUSY;
>>                        goto out;
>>                }
>> -               /*
>> -                * If the task doing the cgroup_rmdir got a signal
>> -                * we don't really need to loop till the hugetlb resource
>> -                * usage become zero.
>> -                */
>> -               if (signal_pending(current)) {
>> -                       ret = -EINTR;
>> -                       goto out;
>> -               }
>>                for_each_hstate(h) {
>>                        spin_lock(&hugetlb_lock);
>>                        list_for_each_entry(page, &h->hugepage_activelist, lru) {
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2715223..ee350c5 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3852,8 +3852,6 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>>                pc = lookup_page_cgroup(page);
>>
>>                ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
>> -               if (ret == -ENOMEM || ret == -EINTR)
>> -                       break;
>>
>>                if (ret == -EBUSY || ret == -EINVAL) {
>>                        /* found lock contention or "pc" is obsolete. */
>> @@ -3863,7 +3861,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>>                        busy = NULL;
>>        }
>>
>> -       if (!ret && !list_empty(list))
>> +       if (!loop)
>
> This looks a bit strange to me... why we make the change ?
>
Ah, I should this move to an independet patch.
Because we don't have -ENOMEM path to exit loop, the return value of
this function
is
  0 (if loop !=0 this means lru is empty under the lru lock )
  -EBUSY (if loop== 0)

I'll move this part out as an independent clean up patch

thanks,
-kame
