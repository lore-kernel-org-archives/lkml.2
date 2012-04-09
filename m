Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2DIKBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 06:01:17 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50083 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2DIKBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 06:01:15 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V5 12/14] memcg: move HugeTLB resource count to parent cgroup on memcg removal
In-Reply-To: <4F827EAD.9080300@jp.fujitsu.com>
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1333738260-1329-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F827EAD.9080300@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 09 Apr 2012 15:30:42 +0530
Message-ID: <87ty0tcjhx.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12040910-4790-0000-0000-0000021DCFE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> (2012/04/07 3:50), Aneesh Kumar K.V wrote:
>
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> This add support for memcg removal with HugeTLB resource usage.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
>
> Hmm 
>
>

....
...

>> +	csize = PAGE_SIZE << compound_order(page);
>> +	/*
>> +	 * uncharge from child and charge the parent. If we have
>> +	 * use_hierarchy set, we can never fail here. In-order to make
>> +	 * sure we don't get -ENOMEM on parent charge, we first uncharge
>> +	 * the child and then charge the parent.
>> +	 */
>> +	if (parent->use_hierarchy) {
>
>
>> +		res_counter_uncharge(&memcg->hugepage[idx], csize);
>> +		if (!mem_cgroup_is_root(parent))
>> +			ret = res_counter_charge(&parent->hugepage[idx],
>> +						 csize, &fail_res);
>
>
> Ah, why is !mem_cgroup_is_root() checked ? no res_counter update for
> root cgroup ?

My mistake. Earlier version of the patch series didn't charge/uncharge the root
cgroup during different operations. Later as per your review I updated
the charge/uncharge path to charge root cgroup. I missed to update this code.

>
> I think it's better to have res_counter_move_parent()...to do ops in atomic.
> (I'll post a patch for that for my purpose). OR, just ignore res->usage if
> parent->use_hierarchy == 1.
>
> uncharge->charge will have a race.



How about the below

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7b6e79a..5b4bc98 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3351,24 +3351,24 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
 
 	csize = PAGE_SIZE << compound_order(page);
 	/*
-	 * uncharge from child and charge the parent. If we have
-	 * use_hierarchy set, we can never fail here. In-order to make
-	 * sure we don't get -ENOMEM on parent charge, we first uncharge
-	 * the child and then charge the parent.
+	 * If we have use_hierarchy set we can never fail here. So instead of
+	 * using res_counter_uncharge use the open-coded variant which just
+	 * uncharge the child res_counter. The parent will retain the charge.
 	 */
 	if (parent->use_hierarchy) {
-		res_counter_uncharge(&memcg->hugepage[idx], csize);
-		if (!mem_cgroup_is_root(parent))
-			ret = res_counter_charge(&parent->hugepage[idx],
-						 csize, &fail_res);
+		unsigned long flags;
+		struct res_counter *counter;
+
+		counter = &memcg->hugepage[idx];
+		spin_lock_irqsave(&counter->lock, flags);
+		res_counter_uncharge_locked(counter, csize);
+		spin_unlock_irqrestore(&counter->lock, flags);
 	} else {
-		if (!mem_cgroup_is_root(parent)) {
-			ret = res_counter_charge(&parent->hugepage[idx],
-						 csize, &fail_res);
-			if (ret) {
-				ret = -EBUSY;
-				goto err_out;
-			}
+		ret = res_counter_charge(&parent->hugepage[idx],
+					 csize, &fail_res);
+		if (ret) {
+			ret = -EBUSY;
+			goto err_out;
 		}
 		res_counter_uncharge(&memcg->hugepage[idx], csize);
 	}


>
>> +	} else {
>> +		if (!mem_cgroup_is_root(parent)) {
>> +			ret = res_counter_charge(&parent->hugepage[idx],
>> +						 csize, &fail_res);
>> +			if (ret) {
>> +				ret = -EBUSY;
>> +				goto err_out;
>> +			}
>> +		}
>> +		res_counter_uncharge(&memcg->hugepage[idx], csize);
>> +	}
>
>
> Just a notice. Recently, Tejun changed failure of pre_destory() to show WARNING.
> Then, I'd like to move the usage to the root cgroup if use_hierarchy=0.
> Will it work for you ?

That should work.


>
>> +	/*
>> +	 * caller should have done css_get
>> +	 */
>
>
> Could you explain meaning of this comment ?
>

inherited from mem_cgroup_move_account. I guess it means css cannot go
away at this point. We have done a css_get on the child. For a generic
move_account function may be the comment is needed. I guess in our case
the comment is redundant ?

-aneesh

