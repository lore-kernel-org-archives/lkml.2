Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998Ab2EPGVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:21:22 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46591 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab2EPGVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:21:20 -0400
Message-ID: <4FB346E3.5060507@parallels.com>
Date: Wed, 16 May 2012 10:19:15 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 19/29] skip memcg kmem allocations in specified code
 regions
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-20-git-send-email-glommer@parallels.com> <4FB1C398.1010000@jp.fujitsu.com>
In-Reply-To: <4FB1C398.1010000@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 06:46 AM, KAMEZAWA Hiroyuki wrote:
> (2012/05/12 2:44), Glauber Costa wrote:
> 
>> This patch creates a mechanism that skip memcg allocations during
>> certain pieces of our core code. It basically works in the same way
>> as preempt_disable()/preempt_enable(): By marking a region under
>> which all allocations will be accounted to the root memcg.
>>
>> We need this to prevent races in early cache creation, when we
>> allocate data using caches that are not necessarily created already.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Christoph Lameter<cl@linux.com>
>> CC: Pekka Enberg<penberg@cs.helsinki.fi>
>> CC: Michal Hocko<mhocko@suse.cz>
>> CC: Kamezawa Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Johannes Weiner<hannes@cmpxchg.org>
>> CC: Suleiman Souhlal<suleiman@google.com>
> 
> 
> The concept seems okay to me but...
> 
>> ---
>>   include/linux/sched.h |    1 +
>>   mm/memcontrol.c       |   25 +++++++++++++++++++++++++
>>   2 files changed, 26 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 81a173c..0501114 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1613,6 +1613,7 @@ struct task_struct {
>>   		unsigned long nr_pages;	/* uncharged usage */
>>   		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
>>   	} memcg_batch;
>> +	atomic_t memcg_kmem_skip_account;
> 
> 
> If only 'current' thread touch this, you don't need to make this atomic counter.
> you can use 'long'.
> 
You're absolutely right, Kame, thanks.
I first used atomic_t because I had it tested against current->mm->owner.

Do you, btw, agree to use current instead of owner here?
You can find the rationale in earlier mails between me and Suleiman.


