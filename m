Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2FKPff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:35:35 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60267 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2FKPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:35:26 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 12/16] hugetlb/cgroup: Add support for cgroup removal
In-Reply-To: <20120611131411.GN12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611085258.GD12402@tiehlicka.suse.cz> <87fwa25gqj.fsf@skywalker.in.ibm.com> <20120611131411.GN12402@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 11 Jun 2012 21:04:43 +0530
Message-ID: <87bokpvp4c.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061115-8878-0000-0000-000002DA8C60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Mon 11-06-12 15:10:20, Aneesh Kumar K.V wrote:
>> Michal Hocko <mhocko@suse.cz> writes:
> [...]
>> >> +static int hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
>> >> +				      struct page *page)
>> >
>> > deserves a comment about the locking (needs to be called with
>> > hugetlb_lock).
>> 
>> will do
>> 
>> >
>> >> +{
>> >> +	int csize;
>> >> +	struct res_counter *counter;
>> >> +	struct res_counter *fail_res;
>> >> +	struct hugetlb_cgroup *page_hcg;
>> >> +	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
>> >> +	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
>> >> +
>> >> +	if (!get_page_unless_zero(page))
>> >> +		goto out;
>> >> +
>> >> +	page_hcg = hugetlb_cgroup_from_page(page);
>> >> +	/*
>> >> +	 * We can have pages in active list without any cgroup
>> >> +	 * ie, hugepage with less than 3 pages. We can safely
>> >> +	 * ignore those pages.
>> >> +	 */
>> >> +	if (!page_hcg || page_hcg != h_cg)
>> >> +		goto err_out;
>> >
>> > How can we have page_hcg != NULL && page_hcg != h_cg?
>> 
>> pages belonging to other cgroup ?
>
> OK, I've forgot that you are iterating over all active huge pages in
> hugetlb_cgroup_pre_destroy. What prevents you from doing the filtering
> in the caller? 
> I am also wondering why you need to play with the page reference
> counting here. You are under hugetlb_lock so the page cannot disappear
> in the meantime or am I missing something?

That is correct. Updated the patch and also added the below comment to
the function.
+
+/*
+ * Should be called with hugetlb_lock held.
+ * Since we are holding hugetlb_lock, pages cannot get moved from
+ * active list or uncharged from the cgroup, So no need to get
+ * page reference and test for page active here.
+ */

-aneesh

