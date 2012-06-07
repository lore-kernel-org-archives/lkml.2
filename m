Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368Ab2FGTFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:05:19 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:58681 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322Ab2FGTFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:05:16 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V7 07/14] mm/page_cgroup: Make page_cgroup point to the cgroup rather than the mem_cgroup
In-Reply-To: <4FCD7FBB.1000304@jp.fujitsu.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4FCD648E.90709@jp.fujitsu.com> <87ehpu8o5z.fsf@skywalker.in.ibm.com> <4FCD7FBB.1000304@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 08 Jun 2012 00:35:00 +0530
Message-ID: <87sje72bab.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12060708-9264-0000-0000-000001A9E405
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> You can use other pages than head/tails.
> For example,I think you have 512 pages per 2M pages.

How about the below. This limit the usage to hugetlb cgroup to only
hugepages with more than 3 normal pages. I guess that is an acceptable limitation.

static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
{
	if (!PageHuge(page))
		return NULL;
	if (compound_order(page) < 3)
		return NULL;
	return (struct hugetlb_cgroup *)page[2].lru.next;
}

static inline
int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
{
	if (!PageHuge(page))
		return -1;
	if (compound_order(page) < 3)
		return -1;
	page[2].lru.next = (void *)h_cg;
	return 0;
}


-aneesh

