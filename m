Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672Ab2CSGxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:53:49 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40313 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923Ab2CSGxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:53:47 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
In-Reply-To: <4F669C2E.1010502@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F669C2E.1010502@jp.fujitsu.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 Mar 2012 12:22:53 +0530
Message-ID: <874ntlkrp6.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031906-8878-0000-0000-000001B7B31F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 11:38:38 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > This patch implements a memcg extension that allows us to control
> > HugeTLB allocations via memory controller.
> > 
> 
> 
> If you write some details here, it will be helpful for review and
> seeing log after merge.

Will add more info.

> 
> 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  include/linux/hugetlb.h    |    1 +
> >  include/linux/memcontrol.h |   42 +++++++++++++
> >  init/Kconfig               |    8 +++
> >  mm/hugetlb.c               |    2 +-
> >  mm/memcontrol.c            |  138 ++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 190 insertions(+), 1 deletions(-)

....

> > +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> > +static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
> > +{
> > +	int idx;
> > +	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
> > +		if (memcg->hugepage[idx].usage > 0)
> > +			return 1;
> > +	}
> > +	return 0;
> > +}
> 
> 
> Please use res_counter_read_u64() rather than reading the value directly.
> 

The open-coded variant is mostly derived from mem_cgroup_force_empty. I
have updated the patch to use res_counter_read_u64. 

> 
> > +
> > +int mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
> > +				   struct mem_cgroup **ptr)
> > +{
> > +	int ret = 0;
> > +	struct mem_cgroup *memcg;
> > +	struct res_counter *fail_res;
> > +	unsigned long csize = nr_pages * PAGE_SIZE;
> > +
> > +	if (mem_cgroup_disabled())
> > +		return 0;
> > +again:
> > +	rcu_read_lock();
> > +	memcg = mem_cgroup_from_task(current);
> > +	if (!memcg)
> > +		memcg = root_mem_cgroup;
> > +	if (mem_cgroup_is_root(memcg)) {
> > +		rcu_read_unlock();
> > +		goto done;
> > +	}
> 
> 
> One concern is.... Now, yes, memory cgroup doesn't account root cgroup
> and doesn't update res->usage to avoid updating shared counter overheads
> when memcg is not mounted. But memory.usage_in_bytes files works
> for root memcg with reading percpu statistics.
> 
> So, how about counting usage for root cgroup even if it cannot be limited ?
> Considering hugetlb fs usage, updating res_counter here doesn't have
> performance problem of false sharing..
> Then, you can remove root_mem_cgroup() checks inserted several places.
> 

Yes. That is a good idea. Will update the patch.


> <snip>
> 
> >  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> > +	/*
> > +	 * Don't allow memcg removal if we have HugeTLB resource
> > +	 * usage.
> > +	 */
> > +	if (mem_cgroup_have_hugetlb_usage(memcg))
> > +		return -EBUSY;
> >  
> >  	return mem_cgroup_force_empty(memcg, false);
> >  }
> 
> 
> Is this fixed by patch 8+9 ?

Yes. 

-aneesh

