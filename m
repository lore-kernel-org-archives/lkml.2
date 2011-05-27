Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1E0UiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:38:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:54916 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1E0UiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:38:03 -0400
Date: Fri, 27 May 2011 22:37:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: early kernel crash when kmemleak is enabled
In-Reply-To: <20110527202503.GA2769@joi.lan>
Message-ID: <alpine.LFD.2.02.1105272236050.3078@ionos>
References: <20110515105505.GA21631@joi.lan> <20110519134218.GH627@htj.dyndns.org> <1305812924.26710.41.camel@e102109-lin.cambridge.arm.com> <20110519135425.GI627@htj.dyndns.org> <1305814133.26710.69.camel@e102109-lin.cambridge.arm.com>
 <20110527202503.GA2769@joi.lan>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, Marcin Slusarz wrote:
> On Thu, May 19, 2011 at 03:08:53PM +0100, Catalin Marinas wrote:
> > On Thu, 2011-05-19 at 14:54 +0100, Tejun Heo wrote:
> > > On Thu, May 19, 2011 at 02:48:44PM +0100, Catalin Marinas wrote:
> > > > Thanks for tracking this down. Untested (I can add a log afterwards):
> > > >
> > > > diff --git a/init/main.c b/init/main.c
> > > > index 4a9479e..48df882 100644
> > > > --- a/init/main.c
> > > > +++ b/init/main.c
> > > > @@ -580,8 +580,8 @@ asmlinkage void __init start_kernel(void)
> > > >  #endif
> > > >       page_cgroup_init();
> > > >       enable_debug_pagealloc();
> > > > -     kmemleak_init();
> > > >       debug_objects_mem_init();
> > > > +     kmemleak_init();
> > > >       setup_per_cpu_pageset();
> > > >       numa_policy_init();
> > > >       if (late_time_init)
> > > 
> > > Heh, that was swift.  Yeap, seems to work here.  Please feel free to
> > > add my Tested-by.
> > 
> > Thanks. I have two other minor kmemleak fixes, so I'll send Linus a pull
> > request in the next day or so.
> > 
> 
> With this patch applied kernel didn't panic, but kmemleak did not work either:
> 
> kmemleak: Early log buffer exceeded, please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
> kmemleak: Kernel memory leak detector disabled
> 
> I increased DEBUG_KMEMLEAK_EARLY_LOG_SIZE from 400 to 1000, and it crashed in
> exactly the same way:

...
 
> The problem is: debugobjects want to use workqueues (system_wq actually), but they
> are initialized much later in a boot process.
> 
> Attached patch fixes this issue for me.
> 
> 
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index 9d86e45..a78b7c6 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -198,7 +198,7 @@ static void free_object(struct debug_obj *obj)
>  	 * initialized:
>  	 */
>  	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
> -		sched = !work_pending(&debug_obj_work);
> +		sched = keventd_up() && !work_pending(&debug_obj_work);
>  	hlist_add_head(&obj->node, &obj_pool);
>  	obj_pool_free++;
>  	obj_pool_used--;
> 

Sigh, yes. Care to resend with changelog and signed-off-by ?

Thanks,

	tglx
