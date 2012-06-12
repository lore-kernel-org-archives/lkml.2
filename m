Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2FLKuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:50:24 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:49462 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2FLKuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:50:19 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 11/16] hugetlb/cgroup: Add charge/uncharge routines for hugetlb cgroup
In-Reply-To: <4FD6F8F9.2040901@jp.fujitsu.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FD6F8F9.2040901@jp.fujitsu.com>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 12 Jun 2012 16:20:03 +0530
Message-ID: <87ipewold0.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061200-5140-0000-0000-0000019047FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> (2012/06/09 17:59), Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
>> 
>> This patchset add the charge and uncharge routines for hugetlb cgroup.
>> This will be used in later patches when we allocate/free HugeTLB
>> pages.
>> 
>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>
>
> I'm sorry if following has been already pointed out.
>
>> ---
>>   mm/hugetlb_cgroup.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 87 insertions(+)
>> 
>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>> index 20a32c5..48efd5a 100644
>> --- a/mm/hugetlb_cgroup.c
>> +++ b/mm/hugetlb_cgroup.c
>> @@ -105,6 +105,93 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
>>   	   return -EBUSY;
>>   }
>> 
>> +int hugetlb_cgroup_charge_page(int idx, unsigned long nr_pages,
>> +			       struct hugetlb_cgroup **ptr)
>> +{
>> +	int ret = 0;
>> +	struct res_counter *fail_res;
>> +	struct hugetlb_cgroup *h_cg = NULL;
>> +	unsigned long csize = nr_pages * PAGE_SIZE;
>> +
>> +	if (hugetlb_cgroup_disabled())
>> +		goto done;
>> +	/*
>> +	 * We don't charge any cgroup if the compound page have less
>> +	 * than 3 pages.
>> +	 */
>> +	if (hstates[idx].order<  2)
>> +		goto done;
>> +again:
>> +	rcu_read_lock();
>> +	h_cg = hugetlb_cgroup_from_task(current);
>> +	if (!h_cg)
>> +		h_cg = root_h_cgroup;
>> +
>> +	if (!css_tryget(&h_cg->css)) {
>> +		rcu_read_unlock();
>> +		goto again;
>> +	}
>> +	rcu_read_unlock();
>> +
>> +	ret = res_counter_charge(&h_cg->hugepage[idx], csize,&fail_res);
>> +	css_put(&h_cg->css);
>> +done:
>> +	*ptr = h_cg;
>> +	return ret;
>> +}
>> +
>
> Memory cgroup uses very complicated 'charge' routine for handling pageout...
> which gets sleep.
>
> For hugetlbfs, it has not sleep routine, you can do charge in simple way.
> I guess...get/put here is overkill.
>
> For example, h_cg cannot be freed while it has tasks. So, if 'current' is
> belongs to the cgroup, it cannot be disappear. Then, you don't need get/put,
> additional atomic ops for holding cgroup.
>
> 	rcu_read_lock();
> 	h_cg = hugetlb_cgroup_from_task(current);
> 	ret = res_counter_charge(&h_cg->hugetpage[idx], csize,  &fail_res);
> 	rcu_read_unlock();
>
> 	return ret;
>

What if the task got moved ot of the cgroup and cgroup got deleted by an
rmdir ?

-aneesh

