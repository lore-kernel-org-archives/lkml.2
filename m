Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab0DSScm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:32:42 -0400
Received: from kroah.org ([198.145.64.141]:45569 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0DSSck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:32:40 -0400
Date: Mon, 19 Apr 2010 11:26:43 -0700
From: Greg KH <greg@kroah.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
Message-ID: <20100419182643.GG32347@kroah.com>
References: <20100327143126.GA25615@Krystal>
 <1269890492.19685.4767.camel@gandalf.stny.rr.com>
 <20100329200946.GA1618@Krystal>
 <20100329210722.GA14993@kroah.com>
 <1269911280.19685.5126.camel@gandalf.stny.rr.com>
 <20100330022238.GA7480@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330022238.GA7480@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 10:22:38PM -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Mon, 2010-03-29 at 14:07 -0700, Greg KH wrote:
> > > On Mon, Mar 29, 2010 at 04:09:46PM -0400, Mathieu Desnoyers wrote:
> > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > This patch does not apply to 2.6.34-rc, and the code in upstream looks
> > > > > to have been fixed. Should this go to stable?
> > > > 
> > > > Yes. 2.6.34-rc does not have this issue anymore, but the patch is needed in
> > > > -stable.
> > > 
> > > Why is this not in .34-rc2?  Can you find the specific patch in Linus's
> > > tree that solves this and let stable@kernel.org know about it?
> > > 
> > 
> > Looks like it was this commit:
> > 
> > commit e1783a240f491fb233f04edc042e16b18a7a79ba
> > Author: Christoph Lameter <cl@linux-foundation.org>
> > Date:   Tue Jan 5 15:34:50 2010 +0900
> > module: Use this_cpu_xx to dynamically allocate counters
> > 
> > Mathieu's fix was:
> > 
> > -   return (local_t *) (mod->refptr + per_cpu_offset(cpu));
> > +   return (local_t *) per_cpu_ptr(mod->refptr, cpu);
> > 
> > As Mathieu states in his change log, the bug is that the mod->refptr is
> > outside the assembly obfuscation of the per_cpu_offset(). This allows
> > the compiler to optimize and cause a NULL pointer dereference with the
> > manipulation of per cpu data.
> > 
> > Christoph Lameter's change fixes this bug as a side effect:
> > 
> > -static inline local_t *__module_ref_addr(struct module *mod, int cpu)
> > -{
> > -#ifdef CONFIG_SMP
> > -       return (local_t *) (mod->refptr + per_cpu_offset(cpu));
> > -#else
> > -       return &mod->ref;
> > -#endif
> > -}
> > -
> >  /* Sometimes we know we already have a refcount, and it's easier not
> >     to handle the error case (which only happens with rmmod --wait). */
> >  static inline void __module_get(struct module *module)
> >  {
> >         if (module) {
> > -               unsigned int cpu = get_cpu();
> > -               local_inc(__module_ref_addr(module, cpu));
> > +               preempt_disable();
> > +               __this_cpu_inc(module->refptr->count);
> >                 trace_module_get(module, _THIS_IP_,
> > -                                local_read(__module_ref_addr(module, cpu)));
> > -               put_cpu();
> > +                                __this_cpu_read(module->refptr->count));
> > +               preempt_enable();
> >         }
> >  }
> > 
> > By removing the buggy code all together.
> 
> Exactly. Steven has beaten me on the start line on this one. ;)

Ok, I'm totally confused now :(

What patch should I apply to a stable release, and which stable release?

thanks,

greg k-h
