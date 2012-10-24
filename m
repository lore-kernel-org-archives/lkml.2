Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab2JXUMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:12:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59572 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab2JXUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:12:32 -0400
Date: Wed, 24 Oct 2012 13:11:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lots of suspicious RCU traces
Message-ID: <20121024201117.GJ2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121017034918.GA13295@redhat.com>
 <20121024164235.GA2467@swordfish>
 <20121024180608.GA22840@redhat.com>
 <20121024182111.GA2340@swordfish>
 <20121024185230.GB5025@redhat.com>
 <20121024191716.GB2340@swordfish>
 <20121024194101.GG2465@linux.vnet.ibm.com>
 <20121024195033.GC2340@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024195033.GC2340@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102420-5406-0000-0000-00000164AD2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:50:33PM -0700, Sergey Senozhatsky wrote:
> On (10/24/12 12:41), Paul E. McKenney wrote:
> > On Wed, Oct 24, 2012 at 12:17:16PM -0700, Sergey Senozhatsky wrote:
> > > On (10/24/12 20:52), Oleg Nesterov wrote:
> > > > On 10/24, Sergey Senozhatsky wrote:
> > > > >
> > > > > On (10/24/12 20:06), Oleg Nesterov wrote:
> > > > > > On 10/24, Sergey Senozhatsky wrote:
> > > > > > >
> > > > > > > small question,
> > > > > > >
> > > > > > > ptrace_notify() and forward calls are able to both indirectly and directly call schedule(),
> > > > > > > /* direct call from ptrace_stop()*/,
> > > > > > > should, in this case, rcu_user_enter() be called before tracehook_report_syscall_exit(regs, step)
> > > > > > > and ptrace chain?
> > > > > >
> > > > > > Well, I don't really understand this magic... but why?
> > > > > >
> > > > >
> > > > > My understanding is (I may be wrong)
> > > > 
> > > > Oh, I bet I have much more chances to be wrong ;)
> > > > 
> > > > > that we can schedule() from ptrace chain to
> > > > 
> > > > I don't understand how ptrace chain differs from, say, audit_syscall_exit().
> > > > There is nothing special in ptrace_stop() in this respect.
> > > >
> > > 
> > > hm.
> > > 
> > > > > some arbitrary task, which will continue its execution from the point where RCU assumes
> > > > > CPU as not idle, while CPU in fact still in idle state -- no one said rcu_idle_exit()
> > > > 
> > > > confused... of course it would be wrong if syscall_trace_leave() is
> > > > called when CPU is considered idle,
> > > > 
> > > 
> > > sorry, I meant idle from RCU point of view:
> > > 
> > > int rcu_is_cpu_idle(void)
> > > {
> > >          return !rcu_dynticks_nesting;
> > > }
> > 
> > Hmmm...  This reproduces on UP builds, then?
> 
> I'll compile UP build (will offlining of N-1 CPUs do the trick?).

Oh -- you quoted the Tiny RCU (CONFIG_SMP=n) variant of rcu_is_cpu_idle(),
so I just thought that you were reproducing on CONFIG_SMP=n.  You would
have to actually rebuild the kernel to get the different version.

But never mind!  RCU_USER_QS depends on CONFIG_SMP=y, so my question
was irrelevant.

							Thanx, Paul

> 	-ss
> 
> > > > > if so, does the same apply to in_user?
> > > > 
> > > > Not sure we understand each other. But I believe that ->in_user should be
> > > > already false when syscall_trace_leave() is called.
> > > 
> > > oh, my apology. I was very wrong about this.
> > 
> > Frederic, thoughts?
> > 
> > 							Thanx, Paul
> > 
> 

