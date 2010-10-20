Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0JTBKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:10:04 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54602 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab0JTBKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:10:01 -0400
Date: Wed, 20 Oct 2010 09:50:56 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v3 07/11] memcg: add dirty limits to mem_cgroup
Message-Id: <20101020095056.48098b34.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1287448784-25684-8-git-send-email-gthelen@google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-8-git-send-email-gthelen@google.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static unsigned long long
> +memcg_hierarchical_free_pages(struct mem_cgroup *mem)
> +{
> +	struct cgroup *cgroup;
> +	unsigned long long min_free, free;
> +
> +	min_free = res_counter_read_u64(&mem->res, RES_LIMIT) -
> +		res_counter_read_u64(&mem->res, RES_USAGE);
> +	cgroup = mem->css.cgroup;
> +	if (!mem->use_hierarchy)
> +		goto out;
> +
> +	while (cgroup->parent) {
> +		cgroup = cgroup->parent;
> +		mem = mem_cgroup_from_cont(cgroup);
> +		if (!mem->use_hierarchy)
> +			break;
> +		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
> +			res_counter_read_u64(&mem->res, RES_USAGE);
> +		min_free = min(min_free, free);
> +	}
> +out:
> +	/* Translate free memory in pages */
> +	return min_free >> PAGE_SHIFT;
> +}
> +
I think you can simplify this function using parent_mem_cgroup().

	unsigned long free, min_free = ULLONG_MAX;

	while (mem) {
		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
			res_counter_read_u64(&mem->res, RES_USAGE);
		min_free = min(min_free, free);
		mem = parent_mem_cgroup();
	}

	/* Translate free memory in pages */
	return min_free >> PAGE_SHIFT;

And, IMHO, we should return min(global_page_state(NR_FREE_PAGES), min_free >> PAGE_SHIFT).
Because we are allowed to set no-limit(or a very big limit) in memcg,
so min_free can be very big if we don't set a limit against all the memcg's in hierarchy.


Thanks,
Dasiuke Nishimura.
