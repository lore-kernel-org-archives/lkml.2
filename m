Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0C0XnW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:43:22 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36507 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab0C0XnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:43:21 -0400
Date: Sat, 27 Mar 2010 16:43:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com
Subject: Re: [patch 0/6] rcu head debugobjects
Message-ID: <20100327234314.GL2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100327153233.993367557@efficios.com>
 <20100327224606.GK2343@linux.vnet.ibm.com>
 <20100327231421.GA4685@Krystal>
 <20100327232024.GB4685@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100327232024.GB4685@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 07:20:24PM -0400, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> [...]
> > > o	Patch 6/6: Would it be possible to use the object_is_on_stack()
> > > 	function defined in include/linux/sched.h instead of passing
> > > 	in the flag on_stack to bdi_work_init()?  It looks like
> > > 	fs/fs-writeback.c already includes include/linux/sched.h, so
> > > 	shouldn't be a problem from a #include-hell viewpoint.
> > 
> > Wow, that's cool! We learn about exciting internal API functions every day,
> > isn't life great ? I will definitely change the fs-writeback.c code to make use
> > of it.
> > 
> > We might event want to go further. A similar scheme could be used for the
> > rcu_head debugobject activation fixup. Basically, I need a way to distinguish
> > between:
> > 
> > A) objects on stack and allocated objects
> > and
> > B) objects statically initialized
> > 
> > So either we use something resembling:
> > 
> >   if (object_is_on_stack() || object_is_allocated())
> > 
> > or
> > 
> >   if (object_is_static())
> > 
> > I am not aware of the proper API members to do that though.
> > 
> 
> Something close to "object_is_static()" would be "kernel_text_address()", but it
> only considers the text section addresses. I'd need something that would be
> broader than that, containing all core kernel and module bss and data sections.
> 
> Still looking...

I was actually feeling pretty good about remembering object_is_on_stack()
and finding it again.  ;-)

I am not seeing anything the identifies data or bss, and in any case,
other situations such as per-CPU, __read_mostly, and who knows what all
else would also need to be handled.  So in the short term, my guess would
be that it would be best to provide the three functions (possibly renaming
them as noted above), but to leave the responsibility for figuring out
which to invoke with the caller.  Always happy to be proven wrong, of
course!

							Thanx, Paul
