Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2GSHAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 03:00:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62921 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2GSHAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 03:00:30 -0400
Message-ID: <5007B034.4030909@huawei.com>
Date: Thu, 19 Jul 2012 14:59:00 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hugetlb/cgroup: Simplify pre_destroy callback
References: <1342589649-15066-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120718142628.76bf78b3.akpm@linux-foundation.org> <87hat4794l.fsf@skywalker.in.ibm.com>
In-Reply-To: <87hat4794l.fsf@skywalker.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.115]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2012/7/19 10:55, Aneesh Kumar K.V wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
>> On Wed, 18 Jul 2012 11:04:09 +0530
>> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>>
>>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>>>
>>> Since we cannot fail in hugetlb_cgroup_move_parent, we don't really
>>> need to check whether cgroup have any change left after that. Also skip
>>> those hstates for which we don't have any charge in this cgroup.
>>>
>>> ...
>>>
>>> +	for_each_hstate(h) {
>>> +		/*
>>> +		 * if we don't have any charge, skip this hstate
>>> +		 */
>>> +		idx = hstate_index(h);
>>> +		if (res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE) == 0)
>>> +			continue;
>>> +		spin_lock(&hugetlb_lock);
>>> +		list_for_each_entry(page, &h->hugepage_activelist, lru)
>>> +			hugetlb_cgroup_move_parent(idx, cgroup, page);
>>> +		spin_unlock(&hugetlb_lock);
>>> +		VM_BUG_ON(res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE));
>>> +	}
>>>  out:
>>>  	return ret;
>>>  }
>>
>> This looks fishy.
>>
>> We test RES_USAGE before taking hugetlb_lock.  What prevents some other
>> thread from increasing RES_USAGE after that test?
>>
>> After walking the list we test RES_USAGE after dropping hugetlb_lock. 
>> What prevents another thread from incrementing RES_USAGE before that
>> test, triggering the BUG?
> 
> IIUC core cgroup will prevent a new task getting added to the cgroup
> when we are in pre_destroy. Since we already check that the cgroup doesn't
> have any task, the RES_USAGE cannot increase in pre_destroy.
> 


You're wrong here. We release cgroup_lock before calling pre_destroy and retrieve
the lock after that, so a task can be attached to the cgroup in this interval.

See 3fa59dfbc3b223f02c26593be69ce6fc9a940405 ("cgroup: fix potential deadlock in pre_destroy")

But I think the memcg->pre_destroy has been reworked and now we can safely hold
cgroup_lock when calling the callback, and this can make the code a bit simpler.
