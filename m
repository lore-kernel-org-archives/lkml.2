Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1GZXEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:04:01 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55252 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab1GZXD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:03:58 -0400
MIME-Version: 1.0
In-Reply-To: <1311707956.21143.2.camel@gandalf.stny.rr.com>
References: <1311699911.3526.87.camel@gandalf.stny.rr.com>
	<20110726173816.GA26597@tiehlicka.suse.cz>
	<1311702110.3526.98.camel@gandalf.stny.rr.com>
	<1311702244.3526.100.camel@gandalf.stny.rr.com>
	<1311704249.3526.106.camel@gandalf.stny.rr.com>
	<20110726184342.GB26597@tiehlicka.suse.cz>
	<1311707088.21143.0.camel@gandalf.stny.rr.com>
	<1311707956.21143.2.camel@gandalf.stny.rr.com>
Date: Wed, 27 Jul 2011 08:03:57 +0900
Message-ID: <CAEwNFnDLR891ky3Vzc1Jih9aZxyR7pQvdJ6icBWzmFK_7gvUDQ@mail.gmail.com>
Subject: Re: [PATCH v3] cgroup/kmemcheck: Annotate alloc_page() for cgroup allocations
From: Minchan Kim <minchan.kim@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 4:19 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
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
>  [<c17e34e6>] ? printk+0x1d/0x1f^M
>  [<c10e2941>] paint_ptr+0x4f/0x78
>  [<c178ab57>] kmemleak_not_leak+0x58/0x7d
>  [<c108ae9f>] ? __rcu_read_unlock+0x9/0x7d
>  [<c1cdb462>] kmemleak_init+0x19d/0x1e9
>  [<c1cbf771>] start_kernel+0x346/0x3ec
>  [<c1cbf1b4>] ? loglevel+0x18/0x18
>  [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0
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
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
