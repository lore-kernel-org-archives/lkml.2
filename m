Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0DTOiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:38:14 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46318 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754808Ab0DTOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:38:12 -0400
Date: Tue, 20 Apr 2010 10:38:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable <stable@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH 2.6.29.x - 2.6.31.1] module: fix
	__module_ref_addr()
Message-ID: <20100420143810.GC14622@Krystal>
References: <20100327143126.GA25615@Krystal> <1269890492.19685.4767.camel@gandalf.stny.rr.com> <20100329200946.GA1618@Krystal> <20100329210722.GA14993@kroah.com> <1269911280.19685.5126.camel@gandalf.stny.rr.com> <20100330022238.GA7480@Krystal> <20100419182643.GG32347@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419182643.GG32347@kroah.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:35:10 up 87 days, 17:12,  7 users,  load average: 0.00, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Mon, Mar 29, 2010 at 10:22:38PM -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > On Mon, 2010-03-29 at 14:07 -0700, Greg KH wrote:
> > > > On Mon, Mar 29, 2010 at 04:09:46PM -0400, Mathieu Desnoyers wrote:
> > > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > > This patch does not apply to 2.6.34-rc, and the code in upstream looks
> > > > > > to have been fixed. Should this go to stable?
> > > > > 
> > > > > Yes. 2.6.34-rc does not have this issue anymore, but the patch is needed in
> > > > > -stable.
> > > > 
> > > > Why is this not in .34-rc2?  Can you find the specific patch in Linus's
> > > > tree that solves this and let stable@kernel.org know about it?
> > > > 
> > > 
> > > Looks like it was this commit:
> > > 
> > > commit e1783a240f491fb233f04edc042e16b18a7a79ba
> > > Author: Christoph Lameter <cl@linux-foundation.org>
> > > Date:   Tue Jan 5 15:34:50 2010 +0900
> > > module: Use this_cpu_xx to dynamically allocate counters
> > > 
> > > Mathieu's fix was:
> > > 
> > > -   return (local_t *) (mod->refptr + per_cpu_offset(cpu));
> > > +   return (local_t *) per_cpu_ptr(mod->refptr, cpu);
> > > 
> > > As Mathieu states in his change log, the bug is that the mod->refptr is
> > > outside the assembly obfuscation of the per_cpu_offset(). This allows
> > > the compiler to optimize and cause a NULL pointer dereference with the
> > > manipulation of per cpu data.
> > > 
> > > Christoph Lameter's change fixes this bug as a side effect:
> > > 
> > > -static inline local_t *__module_ref_addr(struct module *mod, int cpu)
> > > -{
> > > -#ifdef CONFIG_SMP
> > > -       return (local_t *) (mod->refptr + per_cpu_offset(cpu));
> > > -#else
> > > -       return &mod->ref;
> > > -#endif
> > > -}
> > > -
> > >  /* Sometimes we know we already have a refcount, and it's easier not
> > >     to handle the error case (which only happens with rmmod --wait). */
> > >  static inline void __module_get(struct module *module)
> > >  {
> > >         if (module) {
> > > -               unsigned int cpu = get_cpu();
> > > -               local_inc(__module_ref_addr(module, cpu));
> > > +               preempt_disable();
> > > +               __this_cpu_inc(module->refptr->count);
> > >                 trace_module_get(module, _THIS_IP_,
> > > -                                local_read(__module_ref_addr(module, cpu)));
> > > -               put_cpu();
> > > +                                __this_cpu_read(module->refptr->count));
> > > +               preempt_enable();
> > >         }
> > >  }
> > > 
> > > By removing the buggy code all together.
> > 
> > Exactly. Steven has beaten me on the start line on this one. ;)
> 
> Ok, I'm totally confused now :(
> 
> What patch should I apply to a stable release, and which stable release?
> 
> thanks,
> 
> greg k-h

Unless you take all the per cpu refactoring from 2.6.34-rc, the following patch
should be taken into -stable. Please see the changelog for the list of stable
releases that need it.


module: fix __module_ref_addr()

__module_ref_addr() should use per_cpu_ptr() to obfuscate the pointer
(RELOC_HIDE is needed for per cpu pointers).

This non-standard per-cpu pointer use has been introduced by commit
720eba31f47aeade8ec130ca7f4353223c49170f

It causes a NULL pointer exception on some configurations when CONFIG_TRACING is
enabled on 2.6.33. This patch fixes the problem (acknowledged by Randy who
reported the bug).

It did not appear to hurt previously because most of the accesses were done
through local_inc, which probably obfuscated the access enough that no compiler
optimizations were done. But with local_read() done when CONFIG_TRACING is
active, this becomes a problem. Non-CONFIG_TRACING is probably affected as well
(module.c contains local_set and local_read that use __module_ref_addr()), but I
guess nobody noticed because we've been lucky enough that the compiler did not
generate the inappropriate optimization pattern there.

This patch should be queued for the 2.6.29.x through 2.6.33.x stable branches.
(tested on 2.6.33.1 x86_64)

The __module_ref_addr() problem disappears in 2.6.34-rc kernels because these
percpu accesses were re-factored.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/module.h |    2 +-
 kernel/module.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2010-03-25 11:01:53.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2010-03-25 11:01:59.000000000 -0400
@@ -467,7 +467,7 @@ void symbol_put_addr(void *addr);
 static inline local_t *__module_ref_addr(struct module *mod, int cpu)
 {
 #ifdef CONFIG_SMP
-	return (local_t *) (mod->refptr + per_cpu_offset(cpu));
+	return (local_t *) per_cpu_ptr(mod->refptr, cpu);
 #else
 	return &mod->ref;
 #endif


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
