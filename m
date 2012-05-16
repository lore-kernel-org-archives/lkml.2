Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab2EPH5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:57:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40053 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668Ab2EPH5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:57:51 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB35D85.5070304@jp.fujitsu.com>
Date: Wed, 16 May 2012 16:55:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 19/29] skip memcg kmem allocations in specified code
 regions
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-20-git-send-email-glommer@parallels.com> <4FB1C398.1010000@jp.fujitsu.com> <4FB346E3.5060507@parallels.com>
In-Reply-To: <4FB346E3.5060507@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/16 15:19), Glauber Costa wrote:

> On 05/15/2012 06:46 AM, KAMEZAWA Hiroyuki wrote:
>> (2012/05/12 2:44), Glauber Costa wrote:
>>
>>> This patch creates a mechanism that skip memcg allocations during
>>> certain pieces of our core code. It basically works in the same way
>>> as preempt_disable()/preempt_enable(): By marking a region under
>>> which all allocations will be accounted to the root memcg.
>>>
>>> We need this to prevent races in early cache creation, when we
>>> allocate data using caches that are not necessarily created already.
>>>
>>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>>> CC: Christoph Lameter<cl@linux.com>
>>> CC: Pekka Enberg<penberg@cs.helsinki.fi>
>>> CC: Michal Hocko<mhocko@suse.cz>
>>> CC: Kamezawa Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>>> CC: Johannes Weiner<hannes@cmpxchg.org>
>>> CC: Suleiman Souhlal<suleiman@google.com>
>>
>>
>> The concept seems okay to me but...
>>
>>> ---
>>>   include/linux/sched.h |    1 +
>>>   mm/memcontrol.c       |   25 +++++++++++++++++++++++++
>>>   2 files changed, 26 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>> index 81a173c..0501114 100644
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -1613,6 +1613,7 @@ struct task_struct {
>>>   		unsigned long nr_pages;	/* uncharged usage */
>>>   		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
>>>   	} memcg_batch;
>>> +	atomic_t memcg_kmem_skip_account;
>>
>>
>> If only 'current' thread touch this, you don't need to make this atomic counter.
>> you can use 'long'.
>>
> You're absolutely right, Kame, thanks.
> I first used atomic_t because I had it tested against current->mm->owner.
> 
> Do you, btw, agree to use current instead of owner here?
> You can find the rationale in earlier mails between me and Suleiman.

I agree to use current. This information depends on the context of callers.

Thanks,
-Kame


