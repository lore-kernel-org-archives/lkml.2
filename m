Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0JAJWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:22:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40594 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0JAJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:22:46 -0400
Date: Fri, 1 Oct 2010 14:52:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH v2] memcg: fix thresholds with use_hierarchy == 1
Message-ID: <20101001092239.GG4261@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill A. Shutsemov <kirill@shutemov.name> [2010-09-30 13:16:32]:

> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> We need to check parent's thresholds if parent has use_hierarchy == 1 to
> be sure that parent's threshold events will be triggered even if parent
> itself is not active (no MEM_CGROUP_EVENTS).
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3eed583..df40eaf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3587,9 +3587,13 @@ unlock:
> 
>  static void mem_cgroup_threshold(struct mem_cgroup *memcg)
>  {
> -	__mem_cgroup_threshold(memcg, false);
> -	if (do_swap_account)
> -		__mem_cgroup_threshold(memcg, true);
> +	while (memcg) {
> +		__mem_cgroup_threshold(memcg, false);
> +		if (do_swap_account)
> +			__mem_cgroup_threshold(memcg, true);
> +
> +		memcg =  parent_mem_cgroup(memcg);
> +	}
>  }
>

Good catch!

 
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
