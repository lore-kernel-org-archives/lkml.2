Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab2CMVmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:42:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2CMVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:42:35 -0400
Date: Tue, 13 Mar 2012 14:42:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 5/8] hugetlbfs: Add memcg control files for
 hugetlbfs
Message-Id: <20120313144233.49026e6a.akpm@linux-foundation.org>
In-Reply-To: <1331622432-24683-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 12:37:09 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> This add control files for hugetlbfs in memcg
> 
> ...
>
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -220,6 +221,10 @@ struct hstate {
>  	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>  	unsigned int free_huge_pages_node[MAX_NUMNODES];
>  	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
> +	/* cgroup control files */
> +	struct cftype cgroup_limit_file;
> +	struct cftype cgroup_usage_file;
> +	struct cftype cgroup_max_usage_file;
>  	char name[HSTATE_NAME_LEN];
>  };

We don't need all these in here if, for example, cgroups is disabled?

> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1817,6 +1817,36 @@ static int __init hugetlb_init(void)
>  }
>  module_init(hugetlb_init);
>  
> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> +int register_hugetlb_memcg_files(struct cgroup *cgroup,
> +				 struct cgroup_subsys *ss)
> +{
> +	int ret = 0;
> +	struct hstate *h;
> +
> +	for_each_hstate(h) {
> +		ret = cgroup_add_file(cgroup, ss, &h->cgroup_limit_file);
> +		if (ret)
> +			return ret;
> +		ret = cgroup_add_file(cgroup, ss, &h->cgroup_usage_file);
> +		if (ret)
> +			return ret;
> +		ret = cgroup_add_file(cgroup, ss, &h->cgroup_max_usage_file);
> +		if (ret)
> +			return ret;
> +
> +	}
> +	return ret;
> +}
> +/* mm/memcontrol.c because mem_cgroup_read/write is not availabel outside */

Comment has a spelling mistake.

> +int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx);


No, please put it in a header file.  Always.  Where both callers and
the implementation see the same propotype.

> +#else
> +static int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx)
> +{
> +	return 0;
> +}
> +#endif

So this will go into the same header file.

