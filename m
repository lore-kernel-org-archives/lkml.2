Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761022Ab2CNMmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:42:01 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49747 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963Ab2CNMl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:41:57 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 7/8] memcg: move HugeTLB resource count to parent cgroup on memcg removal
In-Reply-To: <20120313144705.020b6dde.akpm@linux-foundation.org>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120313144705.020b6dde.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 14 Mar 2012 17:52:28 +0530
Message-ID: <87ipi78j97.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031412-4790-0000-0000-000001C76162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 14:47:05 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 13 Mar 2012 12:37:11 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > This add support for memcg removal with HugeTLB resource usage.
> > 
> > ...
> >
> > +int hugetlb_force_memcg_empty(struct cgroup *cgroup)
> 
> It's useful to document things, you know.  For a major function like
> this, a nice little description of why it exists, what its role is,
> etc.  Programming is not just an act of telling a computer what to do:
> it is also an act of telling other programmers what you wished the
> computer to do.  Both are important, and the latter deserves care.
> 


Will do.

> > +{
> > +	struct hstate *h;
> > +	struct page *page;
> > +	int ret = 0, idx = 0;
> > +
> > +	do {
> > +		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
> > +			goto out;
> > +		if (signal_pending(current)) {
> > +			ret = -EINTR;
> > +			goto out;
> > +		}
> 
> Why is its behaviour altered by signal_pending()?  This seems broken.

If the task that is doing a cgroup_rmdir got a signal we don't really
need to loop till the hugetlb resource usage become zero. 


> 
> > +		for_each_hstate(h) {
> > +			spin_lock(&hugetlb_lock);
> > +			list_for_each_entry(page, &h->hugepage_activelist, lru) {
> > +				ret = mem_cgroup_move_hugetlb_parent(idx, cgroup, page);
> > +				if (ret) {
> > +					spin_unlock(&hugetlb_lock);
> > +					goto out;
> > +				}
> > +			}
> > +			spin_unlock(&hugetlb_lock);
> > +			idx++;
> > +		}
> > +		cond_resched();
> > +	} while (mem_cgroup_hugetlb_usage(cgroup) > 0);
> > +out:
> > +	return ret;
> > +}

-aneesh

