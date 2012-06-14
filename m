Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2FNJDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:03:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:38905 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2FNJDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:03:08 -0400
Message-ID: <4FD9A79D.9030303@huawei.com>
Date: Thu, 14 Jun 2012 16:58:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>, <dhillf@gmail.com>,
        <rientjes@google.com>, <mhocko@suse.cz>, <akpm@linux-foundation.org>,
        <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH -V9 11/15] hugetlb/cgroup: Add charge/uncharge routines
 for hugetlb cgroup
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.162]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,

> +				 struct hugetlb_cgroup **ptr)
> +{
> +	int ret = 0;
> +	struct res_counter *fail_res;
> +	struct hugetlb_cgroup *h_cg = NULL;
> +	unsigned long csize = nr_pages * PAGE_SIZE;
> +
> +	if (hugetlb_cgroup_disabled())
> +		goto done;
> +	/*
> +	 * We don't charge any cgroup if the compound page have less
> +	 * than 3 pages.
> +	 */
> +	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
> +		goto done;
> +again:
> +	rcu_read_lock();
> +	h_cg = hugetlb_cgroup_from_task(current);
> +	if (!h_cg)


In no circumstances should h_cg be NULL.

> +		h_cg = root_h_cgroup;
> +
> +	if (!css_tryget(&h_cg->css)) {
> +		rcu_read_unlock();
> +		goto again;
> +	}
> +	rcu_read_unlock();
> +
> +	ret = res_counter_charge(&h_cg->hugepage[idx], csize, &fail_res);
> +	css_put(&h_cg->css);
> +done:
> +	*ptr = h_cg;
> +	return ret;
> +}


