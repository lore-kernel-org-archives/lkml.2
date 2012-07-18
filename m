Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2GRV0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:26:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2GRV03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:26:29 -0400
Date: Wed, 18 Jul 2012 14:26:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb/cgroup: Simplify pre_destroy callback
Message-Id: <20120718142628.76bf78b3.akpm@linux-foundation.org>
In-Reply-To: <1342589649-15066-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1342589649-15066-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012 11:04:09 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Since we cannot fail in hugetlb_cgroup_move_parent, we don't really
> need to check whether cgroup have any change left after that. Also skip
> those hstates for which we don't have any charge in this cgroup.
> 
> ...
>
> +	for_each_hstate(h) {
> +		/*
> +		 * if we don't have any charge, skip this hstate
> +		 */
> +		idx = hstate_index(h);
> +		if (res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE) == 0)
> +			continue;
> +		spin_lock(&hugetlb_lock);
> +		list_for_each_entry(page, &h->hugepage_activelist, lru)
> +			hugetlb_cgroup_move_parent(idx, cgroup, page);
> +		spin_unlock(&hugetlb_lock);
> +		VM_BUG_ON(res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE));
> +	}
>  out:
>  	return ret;
>  }

This looks fishy.

We test RES_USAGE before taking hugetlb_lock.  What prevents some other
thread from increasing RES_USAGE after that test?

After walking the list we test RES_USAGE after dropping hugetlb_lock. 
What prevents another thread from incrementing RES_USAGE before that
test, triggering the BUG?

