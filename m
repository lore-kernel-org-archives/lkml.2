Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1DWUaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 16:30:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60480 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab1DWUaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 16:30:07 -0400
Date: Sat, 23 Apr 2011 13:30:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110423203001.GG2628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D9D507F.2040006@cn.fujitsu.com>
 <20110407154737.GF2262@linux.vnet.ibm.com>
 <20110407162600.GA24227@linux.vnet.ibm.com>
 <4D9E6438.5030206@cn.fujitsu.com>
 <20110408051359.GA2318@linux.vnet.ibm.com>
 <4DA2709E.50902@cn.fujitsu.com>
 <20110411051241.GB18415@linux.vnet.ibm.com>
 <4DA2BC4E.4010000@cn.fujitsu.com>
 <20110411210223.GB2226@linux.vnet.ibm.com>
 <4DB12C1E.8050200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB12C1E.8050200@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 03:19:58PM +0800, Lai Jiangshan wrote:
> On 04/12/2011 05:02 AM, Paul E. McKenney wrote:
> > On Mon, Apr 11, 2011 at 04:31:10PM +0800, Lai Jiangshan wrote:
> >> On 04/11/2011 01:12 PM, Paul E. McKenney wrote:
> >>
> >>> -static inline struct task_struct *next_thread(const struct task_struct *p)
> >>> -{
> >>> -	return list_entry_rcu(p->thread_group.next,
> >>> -			      struct task_struct, thread_group);
> >>> -}
> >>> +/* Avoid #include hell for inlining rcu_read_lock(). */
> >>> +#define next_thread(p) \
> >>> +	list_entry_rcu((p)->thread_group.next, struct task_struct, thread_group)
> >>>  
> >>
> >>
> >> It is strange for me.
> >> The user of the API "next_thread(p)" must has two headers included, sched.h and rculist.h
> >>
> >> I know this is a very popular pattern of user space code, is it OK for kernel?
> >> I think a file(even a header file) uses API(Marco), it should includes the the corresponding
> >> headers, it reduces surprises(example, the name of "next_thread()" has no "rcu",
> >> it is not expected that rcuxxxx.h is required).
> >>
> >> I admit the work will become very much simpler if this pattern is allowed.
> > 
> > The guy who maintains much of sched.h suggested it.  ;-)
> > 
> > 							Thanx, Paul
> > 
> >> man fcntl:
> >>        #include <unistd.h>
> >>        #include <fcntl.h>
> >>
> >>        int fcntl(int fd, int cmd, ... /* arg */ );
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> Hi, Paul
> 
> What is the solution you prefer to?
> 
> I insist on the solution which split rcupdate.h into 2 parts,
> the first part is rcupdate_defs.h which only contains:
> 1) struct rcu_head
> 2) MACRO rcu_dereference*
> 3) MACRO rcu_access_pointer rcu_access_index rcu_assign_pointer RCU_INIT_POINTER
> 4) rcu_*_lock_held() which is required by 2)
> 
> All of these is required by sched.h, it is all about 450 lines of code.
> 
> It does not just separate struct rcu_head out only, because rcu_dereference*()
> and APIs in rculist.h are required by in sched.h or headers included by sched.h.
> 
> Any suggestion?

My belief is that the Linux kernel's include files need to have a designed
approach to reduce the include-file problems.  For example, one approach
would be to split out the data declarations from the access functions --
but it is not clear to me that this is the right approach.  But whatever
approach is chosen, that approach needs to have a clear design behind it,
because otherwise we will end up continually refactoring.  And whatever
approach is chosen, putting simple/small data/type declarations into
types.h is very likely to be part of the approach, given that types.h
has worked well in a great many projects over a long period of time.
I do hope that whatever overall approach we evolve to, that this approach
will allow use of inline functions rather than macros.  But it is easy
to change these back and forth, so I am not too worried about them.

In the meantime, for rcupdate.h, it appears that putting struct rcu_head
into types.h and then converting a few inline functions to macros will
suffice.  Furthermore, this split of the rcupdate.h functionality will
likely hold up for quite some time.

You have been doing a much more thorough job of testing this change than
I have, so it does make sense that you carry out the change.

So, could you please try out this approach?  Put rcu_head into types.h,
re-order rcupdate.h as needed, and convert a few inline functions to
macros?

As I have said before, it will be really cool to allow rcu_read_lock()
and rcu_read_unlock() to be inline functions for preemptible RCU!!!

							Thanx, Paul
