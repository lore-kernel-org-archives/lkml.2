Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1GZSnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:43:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1GZSns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:43:48 -0400
Date: Tue, 26 Jul 2011 20:43:42 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v2] cgroup/kmemcheck: Annotate alloc_page() for cgroup
 allocations
Message-ID: <20110726184342.GB26597@tiehlicka.suse.cz>
References: <1311699911.3526.87.camel@gandalf.stny.rr.com>
 <20110726173816.GA26597@tiehlicka.suse.cz>
 <1311702110.3526.98.camel@gandalf.stny.rr.com>
 <1311702244.3526.100.camel@gandalf.stny.rr.com>
 <1311704249.3526.106.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311704249.3526.106.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-07-11 14:17:29, Steven Rostedt wrote:
> When the cgroup base was allocated with kmalloc, it was necessary to
> annotate the variable with kmemcheck_not_leak(). But because it has
> recently been changed to be allocated with alloc_page() (which skips
> kmemleak checks) causes a warning on boot up.
> 
> I was triggering this output:
> 
> allocated 8388608 bytes of page_cgroup
> please try 'cgroup_disable=memory' option if you don't want memory
> cgroups
> kmemleak: Trying to color unknown object at 0xf5840000 as Grey
> Pid: 0, comm: swapper Not tainted 3.0.0-test #12
> Call Trace:
>  [<c17e34e6>] ? printk+0x1d/0x1f^M
>  [<c10e2941>] paint_ptr+0x4f/0x78
>  [<c178ab57>] kmemleak_not_leak+0x58/0x7d
>  [<c108ae9f>] ? __rcu_read_unlock+0x9/0x7d
>  [<c1cdb462>] kmemleak_init+0x19d/0x1e9
>  [<c1cbf771>] start_kernel+0x346/0x3ec
>  [<c1cbf1b4>] ? loglevel+0x18/0x18
>  [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0
> 
> After a bit of debugging I tracked the object 0xf840000 (and others)
> down to the cgroup code. The change from allocating base with kmalloc to
> alloc_page() has the base not calling kmemleak_alloc() which adds the
> pointer to the object_tree_root, but kmemleak_not_leak() adds it to the
> crt_early_log[] table. On kmemleak_init(), the entry is found in the
> early_log[] but not the object_tree_root, and this error message is
> displayed.
> 
> If alloc_page() fails then it defaults back to vmalloc() which still
> uses the kmemleak_alloc() which makes us still need the
> kmemleak_not_leak() call. The solution is to call the kmemleak_alloc()
> directly if the alloc_page() succeeds.

OK, so you are making the allocation [kv]malloc like wrt. kmemleak.
I can see that kmalloc_order does the exactly same thing and there are
couple of oders that do it as well so I guess this should be correct.

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Maybe just a nit. What about making 
gfp_t flags = GFP_KERNEL | __GFP_NOWARN;
and use it at both places?

Anyway feel free to add my:
Reviewed-by: Michal Hocko <mhocko@suse.cz>

> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 53bffc6..79c0e00 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -135,8 +135,10 @@ static void *__meminit alloc_page_cgroup(size_t size, int nid)
>  	void *addr = NULL;
>  
>  	addr = alloc_pages_exact_nid(nid, size, GFP_KERNEL | __GFP_NOWARN);
> -	if (addr)
> +	if (addr) {
> +		kmemleak_alloc(addr, size, 1, GFP_KERNEL | __GFP_NOWARN);
>  		return addr;
> +	}
>  
>  	if (node_state(nid, N_HIGH_MEMORY))
>  		addr = vmalloc_node(size, nid);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
