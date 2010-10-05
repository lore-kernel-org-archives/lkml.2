Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0JEHTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:19:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60096 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab0JEHTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:19:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Oct 2010 16:13:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 08/10] memcg: add cgroupfs interface to memcg dirty
 limits
Message-Id: <20101005161340.9bb7382e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1286175485-30643-9-git-send-email-gthelen@google.com>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<1286175485-30643-9-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  3 Oct 2010 23:58:03 -0700
Greg Thelen <gthelen@google.com> wrote:

> Add cgroupfs interface to memcg dirty page limits:
>   Direct write-out is controlled with:
>   - memory.dirty_ratio
>   - memory.dirty_bytes
> 
>   Background write-out is controlled with:
>   - memory.dirty_background_ratio
>   - memory.dirty_background_bytes
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

a question below.


> ---
>  mm/memcontrol.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 89 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6ec2625..2d45a0a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -100,6 +100,13 @@ enum mem_cgroup_stat_index {
>  	MEM_CGROUP_STAT_NSTATS,
>  };
>  
> +enum {
> +	MEM_CGROUP_DIRTY_RATIO,
> +	MEM_CGROUP_DIRTY_BYTES,
> +	MEM_CGROUP_DIRTY_BACKGROUND_RATIO,
> +	MEM_CGROUP_DIRTY_BACKGROUND_BYTES,
> +};
> +
>  struct mem_cgroup_stat_cpu {
>  	s64 count[MEM_CGROUP_STAT_NSTATS];
>  };
> @@ -4292,6 +4299,64 @@ static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
>  	return 0;
>  }
>  
> +static u64 mem_cgroup_dirty_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
> +	bool root;
> +
> +	root = mem_cgroup_is_root(mem);
> +
> +	switch (cft->private) {
> +	case MEM_CGROUP_DIRTY_RATIO:
> +		return root ? vm_dirty_ratio : mem->dirty_param.dirty_ratio;
> +	case MEM_CGROUP_DIRTY_BYTES:
> +		return root ? vm_dirty_bytes : mem->dirty_param.dirty_bytes;
> +	case MEM_CGROUP_DIRTY_BACKGROUND_RATIO:
> +		return root ? dirty_background_ratio :
> +			mem->dirty_param.dirty_background_ratio;
> +	case MEM_CGROUP_DIRTY_BACKGROUND_BYTES:
> +		return root ? dirty_background_bytes :
> +			mem->dirty_param.dirty_background_bytes;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static int
> +mem_cgroup_dirty_write(struct cgroup *cgrp, struct cftype *cft, u64 val)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> +	int type = cft->private;
> +
> +	if (cgrp->parent == NULL)
> +		return -EINVAL;
> +	if ((type == MEM_CGROUP_DIRTY_RATIO ||
> +	     type == MEM_CGROUP_DIRTY_BACKGROUND_RATIO) && val > 100)
> +		return -EINVAL;
> +	switch (type) {
> +	case MEM_CGROUP_DIRTY_RATIO:
> +		memcg->dirty_param.dirty_ratio = val;
> +		memcg->dirty_param.dirty_bytes = 0;
> +		break;
> +	case MEM_CGROUP_DIRTY_BYTES:
> +		memcg->dirty_param.dirty_bytes = val;
> +		memcg->dirty_param.dirty_ratio  = 0;
> +		break;
> +	case MEM_CGROUP_DIRTY_BACKGROUND_RATIO:
> +		memcg->dirty_param.dirty_background_ratio = val;
> +		memcg->dirty_param.dirty_background_bytes = 0;
> +		break;
> +	case MEM_CGROUP_DIRTY_BACKGROUND_BYTES:
> +		memcg->dirty_param.dirty_background_bytes = val;
> +		memcg->dirty_param.dirty_background_ratio = 0;
> +		break;


Curious....is this same behavior as vm_dirty_ratio ?


Thanks,
-Kame

