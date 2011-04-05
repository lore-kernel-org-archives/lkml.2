Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1DEI4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:56:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60044 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752700Ab1DEI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:56:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19YAqdf4VVYTsPwRyV6oQZmT21rjbQyIfQJ8vhXoJ
	ld7x6d4uUwe6Qg
Subject: Re: [PATCH] posix-timers: RCU conversion
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, ben@iagu.net,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>
In-Reply-To: <1301993300.2225.26.camel@twins>
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>
	 <20110318123031.GB6066@8bytes.org>
	 <AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>
	 <4D871F6C.40207@redhat.com>
	 <AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>
	 <AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>
	 <4D875842.9050308@redhat.com>
	 <AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
	 <4D8773AA.8030408@redhat.com>
	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	 <1300726498.2884.493.camel@edumazet-laptop>	<4D8784A9.8040303@redhat.com>
	 <1300727545.2884.513.camel@edumazet-laptop>
	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	 <1300746429.2837.20.camel@edumazet-laptop>
	 <1300777760.2837.38.camel@edumazet-laptop>
	 <AANLkTik-Rt-Fy-2fKQTr2JBB9f7U2cbc0FmTZOoXc1+5@mail.gmail.com>
	 <4D887B6A.2020102@redhat.com>  <1301993300.2225.26.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 10:56:22 +0200
Message-ID: <1301993782.11410.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 10:48 +0200, Peter Zijlstra wrote:
> On Tue, 2011-03-22 at 12:35 +0200, Avi Kivity wrote:
> >> Here's top with 96 idle guests running:
> 
> On some hacked up 2.6.38 kernel...
> 
> > > Start of perf report -g
> > >      55.26%            kvm  [kernel.kallsyms]     [k] __ticket_spin_lock
> > >                        |
> > >                        --- __ticket_spin_lock
> > >                           |
> > >                           |--94.68%-- _raw_spin_lock
> > >                           |          |
> > >                           |          |--97.55%-- double_rq_lock
> > >                           |          |          load_balance
> > >                           |          |          idle_balance
> > >                           |          |          schedule
> > >                           |          |          |
> > >                           |          |          |--60.56%-- schedule_hrtimeout_range_clock
> > >                           |          |          |          schedule_hrtimeout_range
> > >                           |          |          |          poll_schedule_timeout
> > >                           |          |          |          do_select
> > >                           |          |          |          core_sys_select
> > >                           |          |          |          sys_select
> > >                           |          |          |          system_call_fastpath
> 
> Looks like your workload and idle balancing don't much like each-other.
> 
> What I think is happening is that all your 'idle' qemu thingies keep
> waking up frequently and because you've got like twice the number of
> qemu instances as you've got cpus there's a fair chance you'll have a
> cpu with a pending task while another one goes idle.
> 
> (Why does qemu keep waking if its idle? broken NOHZ?)
> 
> So idle balancing is called when the cpu goes idle (context switch to
> the idle thread) and tries to steal a pending task from another cpu,
> clearly it keeps finding these tasks otherwise it wouldn't try to take
> that lock.
> 
> Mike, you build in some idle balance throttle logic, but that seems
> defeated here (possible because it keeps finding pending tasks to
> migrate? still need morning juice).

Hm.  Maybe someone set sysctl_sched_migration_cost to 0, or wakeups
aren't arriving that frequently is all that pops to mind atm.

	-Mike


