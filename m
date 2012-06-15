Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2FOKum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:50:42 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48339 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab2FOKuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:50:40 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 14/15] hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new page during migration
In-Reply-To: <20120614100454.GL27397@tiehlicka.suse.cz>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120614100454.GL27397@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Fri, 15 Jun 2012 16:20:31 +0530
Message-ID: <87haucn91k.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061500-1396-0000-0000-000001656A8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Wed 13-06-12 15:57:33, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> With HugeTLB pages, hugetlb cgroup is uncharged in compound page destructor.  Since
>> we are holding a hugepage reference, we can be sure that old page won't
>> get uncharged till the last put_page().
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
>
> One question below
> [...]
>> +void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
>> +{
>> +	struct hugetlb_cgroup *h_cg;
>> +
>> +	if (hugetlb_cgroup_disabled())
>> +		return;
>> +
>> +	VM_BUG_ON(!PageHuge(oldhpage));
>> +	spin_lock(&hugetlb_lock);
>> +	h_cg = hugetlb_cgroup_from_page(oldhpage);
>> +	set_hugetlb_cgroup(oldhpage, NULL);
>> +	cgroup_exclude_rmdir(&h_cg->css);
>> +
>> +	/* move the h_cg details to new cgroup */
>> +	set_hugetlb_cgroup(newhpage, h_cg);
>> +	spin_unlock(&hugetlb_lock);
>> +	cgroup_release_and_wakeup_rmdir(&h_cg->css);
>> +	return;
>> +}
>> +
>
> The changelog says that the old page won't get uncharged - which means
> that the the cgroup cannot go away (even if we raced with the move
> parent, hugetlb_lock makes sure we either see old or new cgroup) so why
> do we need to play with css ref. counting?

Ok hugetlb_lock should be sufficient here i guess. I will send a patch
on top to remove the exclude_rmdir and release_and_wakeup_rmdir 

-aneesh

