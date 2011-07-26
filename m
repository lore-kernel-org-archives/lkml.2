Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1GZRic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:38:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab1GZRi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:38:26 -0400
Date: Tue, 26 Jul 2011 19:38:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroup/kmemcheck: No need to annotate base anymore
Message-ID: <20110726173816.GA26597@tiehlicka.suse.cz>
References: <1311699911.3526.87.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311699911.3526.87.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-07-11 13:05:11, Steven Rostedt wrote:
> When the cgroup base was allocated with kmalloc, it was necessary to
> annotate the variable with kmemcheck_not_leak(). But because it has
> recently been changed to be allocated with alloc_page(), the annotation
> is no longer needed.
> 
> I was triggering this output:
> 
> allocated 8388608 bytes of page_cgroup
> please try 'cgroup_disable=memory' option if you don't want memory cgroups
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

We can still fall back to vmalloc allocation (even though it is really
not probable that alloc_pages_exact_nid would fail that early).
Is vmalloc a problem here? (sorry I am not familiar with kmemleak
internals) The original code didn't distinguish kmalloc vs. vmalloc.

> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 53bffc6..955a49f 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -9,7 +9,6 @@
>  #include <linux/vmalloc.h>
>  #include <linux/cgroup.h>
>  #include <linux/swapops.h>
> -#include <linux/kmemleak.h>
>  
>  static void __meminit init_page_cgroup(struct page_cgroup *pc, unsigned long id)
>  {
> @@ -179,13 +178,6 @@ static int __meminit init_section_page_cgroup(unsigned long pfn, int nid)
>  	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
>  	base = alloc_page_cgroup(table_size, nid);
>  
> -	/*
> -	 * The value stored in section->page_cgroup is (base - pfn)
> -	 * and it does not point to the memory block allocated above,
> -	 * causing kmemleak false positives.
> -	 */
> -	kmemleak_not_leak(base);
> -
>  	if (!base) {
>  		printk(KERN_ERR "page cgroup allocation failure\n");
>  		return -ENOMEM;
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
