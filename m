Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0HWFwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 01:52:50 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44971 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0HWFws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 01:52:48 -0400
Date: Mon, 23 Aug 2010 14:32:37 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: use ID in page_cgroup
Message-Id: <20100823143237.b7822ffc.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100820190132.43684862.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820190132.43684862.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 19:01:32 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> I have an idea to remove page_cgroup->page pointer, 8bytes reduction per page.
> But it will be after this work.
Another off topic. I think we can reduce the size of mem_cgroup by packing
some boolean members into one "unsinged long flags".

> @@ -300,12 +300,13 @@ static atomic_t mem_cgroup_num;
>  #define NR_MEMCG_GROUPS (CONFIG_MEM_CGROUP_MAX_GROUPS + 1)
>  static struct mem_cgroup *mem_cgroups[NR_MEMCG_GROUPS] __read_mostly;
>  
> -/* Must be called under rcu_read_lock */
> -static struct mem_cgroup *id_to_memcg(unsigned short id)
> +/* Must be called under rcu_read_lock, set safe==true if under lock */
Do you mean, "Set safe==true if we can ensure by some locks that the id can be
safely dereferenced without rcu_read_lock", right ?

> +static struct mem_cgroup *id_to_memcg(unsigned short id, bool safe)
>  {
>  	struct mem_cgroup *ret;
>  	/* see mem_cgroup_free() */
> -	ret = rcu_dereference_check(mem_cgroups[id], rch_read_lock_held());
> +	ret = rcu_dereference_check(mem_cgroups[id],
> +				rch_read_lock_held() || safe);
>  	if (likely(ret && ret->valid))
>  		return ret;
>  	return NULL;

(snip)
> @@ -723,6 +729,11 @@ static inline bool mem_cgroup_is_root(st
>  	return (mem == root_mem_cgroup);
>  }
>  
> +static inline bool mem_cgroup_is_rootid(unsigned short id)
> +{
> +	return (id == 1);
> +}
> +
It might be better to add

	BUG_ON(newid->id != 1)

in cgroup.c::cgroup_init_idr().


Thanks,
Daisuke Nishimura.
