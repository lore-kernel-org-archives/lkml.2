Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1GZWNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:13:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:49113 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab1GZWNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:13:50 -0400
Date: Wed, 27 Jul 2011 00:13:36 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v3] cgroup/kmemcheck: Annotate alloc_page() for cgroup
 allocations
Message-ID: <20110726221336.GC667@cmpxchg.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 03:19:16PM -0400, Steven Rostedt wrote:
> When the cgroup base was allocated with kmalloc, it was necessary to
> annotate the variable with kmemcheck_not_leak(). But because it has
> recently been changed to be allocated with alloc_page() (which skips
> kmemleak checks) causes a warning on boot up.
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
> 
> If alloc_page() fails then it defaults back to vmalloc() which still
> uses the kmemleak_alloc() which makes us still need the
> kmemleak_not_leak() call. The solution is to call the kmemleak_alloc()
> directly if the alloc_page() succeeds.
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
