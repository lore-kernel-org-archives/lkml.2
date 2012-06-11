Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2FKJ30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:29:26 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53246 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2FKJ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:29:23 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 11/16] hugetlb/cgroup: Add charge/uncharge routines for hugetlb cgroup
In-Reply-To: <20120611083810.GC12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611083810.GC12402@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 11 Jun 2012 14:58:45 +0530
Message-ID: <87liju5h9u.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061109-5816-0000-0000-000003182B57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Sat 09-06-12 14:29:56, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> This patchset add the charge and uncharge routines for hugetlb cgroup.
>> This will be used in later patches when we allocate/free HugeTLB
>> pages.
>
> Please describe the locking rules.

All the update happen within hugetlb_lock.

>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>  mm/hugetlb_cgroup.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 87 insertions(+)
>> 
>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>> index 20a32c5..48efd5a 100644
>> --- a/mm/hugetlb_cgroup.c
>> +++ b/mm/hugetlb_cgroup.c
>> @@ -105,6 +105,93 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
>>  	   return -EBUSY;
>>  }
>>  
>> +int hugetlb_cgroup_charge_page(int idx, unsigned long nr_pages,
>> +			       struct hugetlb_cgroup **ptr)
>
> Missing doc.
>
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
>> +	if (hstates[idx].order < 2)
>> +		goto done;
>
> huge_page_order here? Not that important because we are using order in
> the code directly at many places but easier for grep and maybe worth a
> separate clean up patch.
>

Fixed.

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
>> +	ret = res_counter_charge(&h_cg->hugepage[idx], csize, &fail_res);
>> +	css_put(&h_cg->css);
>> +done:
>> +	*ptr = h_cg;
>> +	return ret;
>> +}
>> +
>> +void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
>> +				  struct hugetlb_cgroup *h_cg,
>> +				  struct page *page)
>> +{
>> +	if (hugetlb_cgroup_disabled() || !h_cg)
>> +		return;
>> +
>> +	spin_lock(&hugetlb_lock);
>> +	if (hugetlb_cgroup_from_page(page)) {
>
> How can this happen? Is it possible that two CPUs are trying to charge
> one page?

That is why I added that. I looked at the alloc_huge_page, and I
don't see we would end with same page from different CPUs but then
we have similar checks in memcg, where we drop the charge if we find
the page cgroup already used.

>
>> +		hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
>> +		goto done;
>> +	}
>> +	set_hugetlb_cgroup(page, h_cg);
>> +done:
>> +	spin_unlock(&hugetlb_lock);
>> +	return;
>> +}
>> +
>> +void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>> +				  struct page *page)
>> +{
>> +	struct hugetlb_cgroup *h_cg;
>> +	unsigned long csize = nr_pages * PAGE_SIZE;
>> +
>> +	if (hugetlb_cgroup_disabled())
>> +		return;
>> +
>> +	spin_lock(&hugetlb_lock);
>> +	h_cg = hugetlb_cgroup_from_page(page);
>> +	if (unlikely(!h_cg)) {
>> +		spin_unlock(&hugetlb_lock);
>> +		return;
>> +	}
>> +	set_hugetlb_cgroup(page, NULL);
>> +	spin_unlock(&hugetlb_lock);
>> +
>> +	res_counter_uncharge(&h_cg->hugepage[idx], csize);
>> +	return;
>> +}
>> +
>> +void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>> +				    struct hugetlb_cgroup *h_cg)
>> +{
>
> Really worth a separate function to do the same tests again?
> Will have a look at the follow up patches. It would be much easier if
> the functions were used in the same patch...

v9 actually folded this to the patch that actually use these function. 

>
>> +	unsigned long csize = nr_pages * PAGE_SIZE;
>> +
>> +	if (hugetlb_cgroup_disabled() || !h_cg)
>> +		return;
>> +
>> +	res_counter_uncharge(&h_cg->hugepage[idx], csize);
>> +	return;
>> +}
>> +
>>  struct cgroup_subsys hugetlb_subsys = {
>>  	.name = "hugetlb",
>>  	.create     = hugetlb_cgroup_create,
>> -- 

-aneesh

