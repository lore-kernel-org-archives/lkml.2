Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab2C1Rhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:37:34 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36606 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab2C1Rhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:37:32 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
In-Reply-To: <20120328134020.GG20949@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120328134020.GG20949@tiehlicka.suse.cz>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 28 Mar 2012 23:07:14 +0530
Message-ID: <87y5qk1vat.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12032808-3568-0000-0000-0000016EEC3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Fri 16-03-12 23:09:24, Aneesh Kumar K.V wrote:
> [...]
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6728a7a..4b36c5e 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
> [...]
>> @@ -4887,6 +5013,7 @@ err_cleanup:
>>  static struct cgroup_subsys_state * __ref
>>  mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>>  {
>> +	int idx;
>>  	struct mem_cgroup *memcg, *parent;
>>  	long error = -ENOMEM;
>>  	int node;
>> @@ -4929,9 +5056,14 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>>  		 * mem_cgroup(see mem_cgroup_put).
>>  		 */
>>  		mem_cgroup_get(parent);
>> +		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
>> +			res_counter_init(&memcg->hugepage[idx],
>> +					 &parent->hugepage[idx]);
>
> Hmm, I do not think we want to make groups deeper in the hierarchy
> unlimited as we cannot reclaim. Shouldn't we copy the limit from the parent?
> Still not ideal but slightly more expected behavior IMO.

But we should be limiting the child group based on parent's limit only
when hierarchy is set right ?

>
> The hierarchy setups are still interesting and the limitations should be
> described in the documentation...
>

It should behave similar to memcg. ie, if hierarchy is set, then we limit
using MIN(parent's limit, child's limit). May be I am missing some of
the details of memcg use_hierarchy config. My goal was to keep it
similar to memcg. Can you explain why do you think the patch would
make it any different ?

-aneesh

