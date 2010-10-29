Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab0J2ArY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:47:24 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:38078 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab0J2ArR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:47:17 -0400
Date: Fri, 29 Oct 2010 09:38:53 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Dan Carpenter <error27@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [patch] memcg: null dereference on allocation failure
Message-Id: <20101029093853.49e75309.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20101028111241.GC6062@bicker>
References: <20101028111241.GC6062@bicker>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I add Andrew to CC-list)

On Thu, 28 Oct 2010 13:12:41 +0200
Dan Carpenter <error27@gmail.com> wrote:

> The original code had a null dereference if alloc_percpu() failed.
> This was introduced in 711d3d2c9bc3 "memcg: cpu hotplug aware percpu
> count updates"
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9a99cfa..2efa8ea 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4208,15 +4208,17 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>  
>  	memset(mem, 0, size);
>  	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
> -	if (!mem->stat) {
> -		if (size < PAGE_SIZE)
> -			kfree(mem);
> -		else
> -			vfree(mem);
> -		mem = NULL;
> -	}
> +	if (!mem->stat)
> +		goto out_free;
>  	spin_lock_init(&mem->pcp_counter_lock);
>  	return mem;
> +
> +out_free:
> +	if (size < PAGE_SIZE)
> +		kfree(mem);
> +	else
> +		vfree(mem);
> +	return NULL;
>  }
>  
>  /*
