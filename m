Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2GSJmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:42:11 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:42205 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2GSJmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:42:09 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb/cgroup: Simplify pre_destroy callback
In-Reply-To: <5007B034.4030909@huawei.com>
References: <1342589649-15066-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120718142628.76bf78b3.akpm@linux-foundation.org> <87hat4794l.fsf@skywalker.in.ibm.com> <5007B034.4030909@huawei.com>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 19 Jul 2012 15:11:44 +0530
Message-ID: <87wr20f5pj.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12071909-2674-0000-0000-0000054DB8F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan <lizefan@huawei.com> writes:

> on 2012/7/19 10:55, Aneesh Kumar K.V wrote:
>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>>> On Wed, 18 Jul 2012 11:04:09 +0530
>>> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>>>
>>>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>>>>
>>>> Since we cannot fail in hugetlb_cgroup_move_parent, we don't really
>>>> need to check whether cgroup have any change left after that. Also skip
>>>> those hstates for which we don't have any charge in this cgroup.
>>>>
>>>> ...
>>>>
>>>> +	for_each_hstate(h) {
>>>> +		/*
>>>> +		 * if we don't have any charge, skip this hstate
>>>> +		 */
>>>> +		idx = hstate_index(h);
>>>> +		if (res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE) == 0)
>>>> +			continue;
>>>> +		spin_lock(&hugetlb_lock);
>>>> +		list_for_each_entry(page, &h->hugepage_activelist, lru)
>>>> +			hugetlb_cgroup_move_parent(idx, cgroup, page);
>>>> +		spin_unlock(&hugetlb_lock);
>>>> +		VM_BUG_ON(res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE));
>>>> +	}
>>>>  out:
>>>>  	return ret;
>>>>  }
>>>
>>> This looks fishy.
>>>
>>> We test RES_USAGE before taking hugetlb_lock.  What prevents some other
>>> thread from increasing RES_USAGE after that test?
>>>
>>> After walking the list we test RES_USAGE after dropping hugetlb_lock. 
>>> What prevents another thread from incrementing RES_USAGE before that
>>> test, triggering the BUG?
>> 
>> IIUC core cgroup will prevent a new task getting added to the cgroup
>> when we are in pre_destroy. Since we already check that the cgroup doesn't
>> have any task, the RES_USAGE cannot increase in pre_destroy.
>> 
>
>
> You're wrong here. We release cgroup_lock before calling pre_destroy and retrieve
> the lock after that, so a task can be attached to the cgroup in this interval.
>

But that means rmdir can be racy right ? What happens if the task got
added, allocated few pages and then moved out ? We still would have task
count 0 but few pages, which we missed to to move to parent cgroup. 

-aneesh

