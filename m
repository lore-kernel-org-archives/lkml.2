Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab2FLHyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:54:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42405 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2FLHyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:54:21 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD6F530.6050603@jp.fujitsu.com>
Date: Tue, 12 Jun 2012 16:52:16 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 10/16] hugetlb/cgroup: Add the cgroup pointer to page
 lru
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1339232401-14392-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/09 17:59), Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
> 
> Add the hugetlb cgroup pointer to 3rd page lru.next. This limit
> the usage to hugetlb cgroup to only hugepages with 3 or more
> normal pages. I guess that is an acceptable limitation.
> 
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
> ---
>   include/linux/hugetlb_cgroup.h |   31 +++++++++++++++++++++++++++++++
>   mm/hugetlb.c                   |    4 ++++
>   2 files changed, 35 insertions(+)
> 
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index 5794be4..ceff1d5 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -26,6 +26,26 @@ struct hugetlb_cgroup {
>   };
> 
>   #ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
> +static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
> +{
> +	if (!PageHuge(page))
> +		return NULL;

I'm not very sure but....

	VM_BUG_ON(!PageHuge(page)) ??



> +	if (compound_order(page)<  3)
> +		return NULL;
> +	return (struct hugetlb_cgroup *)page[2].lru.next;
> +}
> +
> +static inline
> +int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
> +{
> +	if (!PageHuge(page))
> +		return -1;

ditto.

> +	if (compound_order(page)<  3)
> +		return -1;
> +	page[2].lru.next = (void *)h_cg;
> +	return 0;
> +}
> +

Thanks,
-Kame

