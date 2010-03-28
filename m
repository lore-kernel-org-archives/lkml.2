Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0C1Eaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:30:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36870 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab0C1Eax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:30:53 -0400
Date: Sat, 27 Mar 2010 21:30:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: Re: [patch 0/6] rcu head debugobjects
Message-ID: <20100328043047.GT2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100327153233.993367557@efficios.com>
 <20100327224606.GK2343@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1003280339590.3147@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003280339590.3147@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 04:07:10AM +0200, Thomas Gleixner wrote:
> B1;2005;0cOn Sat, 27 Mar 2010, Paul E. McKenney wrote:
> > 
> > o	Patch 4/6 looks good to me, and given that Thomas hasn't
> > 	complained, I am guessing that he is OK with it.
> 
> Looks sane at the first glance. Will go over it in detail tomorrow.
> 
> > o	Patch 6/6: Would it be possible to use the object_is_on_stack()
> > 	function defined in include/linux/sched.h instead of passing
> > 	in the flag on_stack to bdi_work_init()?  It looks like
> > 	fs/fs-writeback.c already includes include/linux/sched.h, so
> > 	shouldn't be a problem from a #include-hell viewpoint.
> 
> Well, I'm a bit wary about that. The reason is that we really want
> the annotation of:
> 
>        init_on_stack();
>        ....
>        destroy_on_stack();
> 
> instead of the confusing:
> 
>        init();
>        ....
>        destroy_on_stack();
> 
> So having an automatism in the bdi_work_init() function will people
> make forget to put the destroy_on_stack() annotation into it.
> 
> The flag is horrible as well. How about this:
> 
> /* helper function, do not use in code ! */
> __bdi_work_init(....., onstack)
> {
> 	....
> 	if (on_stack) {
> 	   work.state |= WS_ONSTACK;
> 	   init_rcu_head_on_stack(&work.rcu_head);
> 	} else {
> 	....
> }
> 
> See, how this moves also the "work.state |= WS_ONSTACK;" line out of
> the calling code.
> 
> bdi_work_init(...)
> {
> 	 __bdi_work_init(...., false);
> }
> 
> bdi_work_init_on_stack(...)
> {
> 	 __bdi_work_init(...., true);
> }
> 
> 
> out of the code.
> 
> To make it complete, please do not use the asymmetric:
> 
>    destroy_rcu_head_on_stack(&work.rcu_head);
> 
> Create a helper function:
> 
> bdi_destroy_work_on_stack(...)
> {
>    destroy_rcu_head_on_stack(work->rcu_head);
> }    
> 
> That makes it way more readable and we did that with the other on
> stack initializers as well.

Hello, Thomas,

I must defer to you on this one.  ;-)

							Thanx, Paul
