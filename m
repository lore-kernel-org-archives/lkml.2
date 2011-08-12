Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1HLKCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 06:02:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47938 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041Ab1HLKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 06:02:40 -0400
Date: Fri, 12 Aug 2011 10:58:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v3] cgroup/kmemcheck: Annotate alloc_page() for cgroup
 allocations
Message-ID: <20110812095827.GB1639@e102109-lin.cambridge.arm.com>
References: <1311699911.3526.87.camel@gandalf.stny.rr.com>
 <20110726173816.GA26597@tiehlicka.suse.cz>
 <1311702110.3526.98.camel@gandalf.stny.rr.com>
 <1311702244.3526.100.camel@gandalf.stny.rr.com>
 <1311704249.3526.106.camel@gandalf.stny.rr.com>
 <20110726184342.GB26597@tiehlicka.suse.cz>
 <1311707088.21143.0.camel@gandalf.stny.rr.com>
 <1311707956.21143.2.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311707956.21143.2.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 08:19:16PM +0100, Steven Rostedt wrote:
> When the cgroup base was allocated with kmalloc, it was necessary to
> annotate the variable with kmemcheck_not_leak(). But because it has
> recently been changed to be allocated with alloc_page() (which skips
> kmemleak checks) causes a warning on boot up.

Sorry for the delay, too much holiday over here :)

> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 53bffc6..1eb534a 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -133,10 +133,13 @@ struct page *lookup_cgroup_page(struct page_cgroup *pc)
>  static void *__meminit alloc_page_cgroup(size_t size, int nid)
>  {
>  	void *addr = NULL;
> +	gfp_t flags = GFP_KERNEL | __GFP_NOWARN;
>  
> -	addr = alloc_pages_exact_nid(nid, size, GFP_KERNEL | __GFP_NOWARN);
> -	if (addr)
> +	addr = alloc_pages_exact_nid(nid, size, flags);
> +	if (addr) {
> +		kmemleak_alloc(addr, size, 1, flags);
>  		return addr;
> +	}
>  
>  	if (node_state(nid, N_HIGH_MEMORY))
>  		addr = vmalloc_node(size, nid);

The __GFP_NOWARN is already added by kmemleak_alloc but there is no harm
in leaving it.

One minor thing with the subject, unless you already submitted the
patch - it's kmemleak rather than kmemcheck (different things,
confusingly).

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
