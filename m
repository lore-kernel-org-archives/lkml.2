Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2DIF6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 01:58:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36025 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2DIF6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 01:58:10 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F827A01.4000302@jp.fujitsu.com>
Date: Mon, 09 Apr 2012 14:56:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V5 09/14] memcg: track resource index in cftype private
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1333738260-1329-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1333738260-1329-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/07 3:50), Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> This helps in using same memcg callbacks for non reclaim resource
> control files.
>


please modify the changelog. This doesn't explain any contents in this patch.

 - add 'index' field to memcg files's attribute
 - support hugetlb type.
 - support modification of hugetlb res_counter.

Thanks,
-Kame

 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  mm/memcontrol.c |   27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0a1f776..3bb3b42 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -381,9 +381,14 @@ enum charge_type {
>  #define _MEM			(0)
>  #define _MEMSWAP		(1)
>  #define _OOM_TYPE		(2)
> -#define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
> -#define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
> -#define MEMFILE_ATTR(val)	((val) & 0xffff)
> +#define _MEMHUGETLB		(3)
> +
> +/*  0 ... val ...16.... x...24...idx...32*/
> +#define __MEMFILE_PRIVATE(idx, x, val)	(((idx) << 24) | ((x) << 16) | (val))
> +#define MEMFILE_PRIVATE(x, val)		__MEMFILE_PRIVATE(0, x, val)
> +#define MEMFILE_TYPE(val)		(((val) >> 16) & 0xff)
> +#define MEMFILE_IDX(val)		(((val) >> 24) & 0xff)
> +#define MEMFILE_ATTR(val)		((val) & 0xffff)
>  /* Used for OOM nofiier */
>  #define OOM_CONTROL		(0)
>  
> @@ -4003,7 +4008,7 @@ static ssize_t mem_cgroup_read(struct cgroup *cont, struct cftype *cft,
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>  	char str[64];
>  	u64 val;
> -	int type, name, len;
> +	int type, name, len, idx;
>  
>  	type = MEMFILE_TYPE(cft->private);
>  	name = MEMFILE_ATTR(cft->private);
> @@ -4024,6 +4029,10 @@ static ssize_t mem_cgroup_read(struct cgroup *cont, struct cftype *cft,
>  		else
>  			val = res_counter_read_u64(&memcg->memsw, name);
>  		break;
> +	case _MEMHUGETLB:
> +		idx = MEMFILE_IDX(cft->private);
> +		val = res_counter_read_u64(&memcg->hugepage[idx], name);
> +		break;
>  	default:
>  		BUG();
>  	}
> @@ -4061,7 +4070,10 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
>  			break;
>  		if (type == _MEM)
>  			ret = mem_cgroup_resize_limit(memcg, val);
> -		else
> +		else if (type == _MEMHUGETLB) {
> +			int idx = MEMFILE_IDX(cft->private);
> +			ret = res_counter_set_limit(&memcg->hugepage[idx], val);
> +		} else
>  			ret = mem_cgroup_resize_memsw_limit(memcg, val);
>  		break;
>  	case RES_SOFT_LIMIT:
> @@ -4127,7 +4139,10 @@ static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
>  	case RES_MAX_USAGE:
>  		if (type == _MEM)
>  			res_counter_reset_max(&memcg->res);
> -		else
> +		else if (type == _MEMHUGETLB) {
> +			int idx = MEMFILE_IDX(event);
> +			res_counter_reset_max(&memcg->hugepage[idx]);
> +		} else
>  			res_counter_reset_max(&memcg->memsw);
>  		break;
>  	case RES_FAILCNT:



