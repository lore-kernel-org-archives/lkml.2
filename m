Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2FKK3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:29:23 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34759 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2FKK3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:29:21 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 14/16] hugetlb/cgroup: add charge/uncharge calls for HugeTLB alloc/free
In-Reply-To: <20120611092133.GI12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611092133.GI12402@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 11 Jun 2012 15:59:11 +0530
Message-ID: <8762ay5eh4.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061110-8256-0000-0000-000002E080DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Sat 09-06-12 14:29:59, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> This adds necessary charge/uncharge calls in the HugeTLB code.  We do
>> hugetlb cgroup charge in page alloc and uncharge in compound page destructor.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>  mm/hugetlb.c        |   16 +++++++++++++++-
>>  mm/hugetlb_cgroup.c |    7 +------
>>  2 files changed, 16 insertions(+), 7 deletions(-)
>> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index bf79131..4ca92a9 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -628,6 +628,8 @@ static void free_huge_page(struct page *page)
>>  	BUG_ON(page_mapcount(page));
>>  
>>  	spin_lock(&hugetlb_lock);
>> +	hugetlb_cgroup_uncharge_page(hstate_index(h),
>> +				     pages_per_huge_page(h), page);
>>  	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
>>  		/* remove the page from active list */
>>  		list_del(&page->lru);
>> @@ -1116,7 +1118,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>>  	struct hstate *h = hstate_vma(vma);
>>  	struct page *page;
>>  	long chg;
>> +	int ret, idx;
>> +	struct hugetlb_cgroup *h_cg;
>>  
>> +	idx = hstate_index(h);
>>  	/*
>>  	 * Processes that did not create the mapping will have no
>>  	 * reserves and will not have accounted against subpool
>> @@ -1132,6 +1137,11 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>>  		if (hugepage_subpool_get_pages(spool, chg))
>>  			return ERR_PTR(-ENOSPC);
>>  
>> +	ret = hugetlb_cgroup_charge_page(idx, pages_per_huge_page(h), &h_cg);
>
> So we do not have any page yet and hugetlb_cgroup_charge_cgroup sound
> more appropriate
>

Will do

-aneesh

