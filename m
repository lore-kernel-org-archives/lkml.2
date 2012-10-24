Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab2JXTw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:52:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42461 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2JXTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:52:57 -0400
Date: Wed, 24 Oct 2012 12:50:33 -0700
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lots of suspicious RCU traces
Message-ID: <20121024195033.GC2340@swordfish>
References: <20121017034918.GA13295@redhat.com>
 <20121024164235.GA2467@swordfish>
 <20121024180608.GA22840@redhat.com>
 <20121024182111.GA2340@swordfish>
 <20121024185230.GB5025@redhat.com>
 <20121024191716.GB2340@swordfish>
 <20121024194101.GG2465@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024194101.GG2465@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/24/12 12:41), Paul E. McKenney wrote:
> On Wed, Oct 24, 2012 at 12:17:16PM -0700, Sergey Senozhatsky wrote:
> > On (10/24/12 20:52), Oleg Nesterov wrote:
> > > On 10/24, Sergey Senozhatsky wrote:
> > > >
> > > > On (10/24/12 20:06), Oleg Nesterov wrote:
> > > > > On 10/24, Sergey Senozhatsky wrote:
> > > > > >
> > > > > > small question,
> > > > > >
> > > > > > ptrace_notify() and forward calls are able to both indirectly and directly call schedule(),
> > > > > > /* direct call from ptrace_stop()*/,
> > > > > > should, in this case, rcu_user_enter() be called before tracehook_report_syscall_exit(regs, step)
> > > > > > and ptrace chain?
> > > > >
> > > > > Well, I don't really understand this magic... but why?
> > > > >
> > > >
> > > > My understanding is (I may be wrong)
> > > 
> > > Oh, I bet I have much more chances to be wrong ;)
> > > 
> > > > that we can schedule() from ptrace chain to
> > > 
> > > I don't understand how ptrace chain differs from, say, audit_syscall_exit().
> > > There is nothing special in ptrace_stop() in this respect.
> > >
> > 
> > hm.
> > 
> > > > some arbitrary task, which will continue its execution from the point where RCU assumes
> > > > CPU as not idle, while CPU in fact still in idle state -- no one said rcu_idle_exit()
> > > 
> > > confused... of course it would be wrong if syscall_trace_leave() is
> > > called when CPU is considered idle,
> > > 
> > 
> > sorry, I meant idle from RCU point of view:
> > 
> > int rcu_is_cpu_idle(void)
> > {
> >          return !rcu_dynticks_nesting;
> > }
> 
> Hmmm...  This reproduces on UP builds, then?
> 

I'll compile UP build (will offlining of N-1 CPUs do the trick?).

	-ss

> > > > if so, does the same apply to in_user?
> > > 
> > > Not sure we understand each other. But I believe that ->in_user should be
> > > already false when syscall_trace_leave() is called.
> > 
> > oh, my apology. I was very wrong about this.
> 
> Frederic, thoughts?
> 
> 							Thanx, Paul
> 
