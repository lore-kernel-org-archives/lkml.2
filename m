Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2FKJkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:40:33 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35370 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2FKJkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:40:31 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 12/16] hugetlb/cgroup: Add support for cgroup removal
In-Reply-To: <20120611085258.GD12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611085258.GD12402@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 11 Jun 2012 15:10:20 +0530
Message-ID: <87fwa25gqj.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061109-9574-0000-0000-000003201E96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Sat 09-06-12 14:29:57, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> This patch add support for cgroup removal. If we don't have parent
>> cgroup, the charges are moved to root cgroup.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>  mm/hugetlb_cgroup.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 79 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
>> index 48efd5a..9458fe3 100644
>> --- a/mm/hugetlb_cgroup.c
>> +++ b/mm/hugetlb_cgroup.c
>> @@ -99,10 +99,87 @@ static void hugetlb_cgroup_destroy(struct cgroup *cgroup)
>>  	kfree(h_cgroup);
>>  }
>>  
>> +
>> +static int hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
>> +				      struct page *page)
>
> deserves a comment about the locking (needs to be called with
> hugetlb_lock).

will do

>
>> +{
>> +	int csize;
>> +	struct res_counter *counter;
>> +	struct res_counter *fail_res;
>> +	struct hugetlb_cgroup *page_hcg;
>> +	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
>> +	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
>> +
>> +	if (!get_page_unless_zero(page))
>> +		goto out;
>> +
>> +	page_hcg = hugetlb_cgroup_from_page(page);
>> +	/*
>> +	 * We can have pages in active list without any cgroup
>> +	 * ie, hugepage with less than 3 pages. We can safely
>> +	 * ignore those pages.
>> +	 */
>> +	if (!page_hcg || page_hcg != h_cg)
>> +		goto err_out;
>
> How can we have page_hcg != NULL && page_hcg != h_cg?

pages belonging to other cgroup ?

-aneesh

