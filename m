Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979Ab1ETAOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:14:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33916 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659Ab1ETAO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hh9uBLg4VxNIz2jpq5D8fe1t2SBrXftFkJB4rYT+lQJoRWVBa+tuSqz2h8AePdIr2p
         GNBBHtzYEntoY2H0GMa2c/OUh6EnLECjAh+ISD/XzOuYBHETSE/TadMEJmg+EOPaNHRi
         86Ky/jUnraQXblaC8lkLx6s71bg+d0XrsGgWo=
Date: Fri, 20 May 2011 02:14:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110520001421.GH1956@nowhere>
References: <20110516122329.GA29356@elte.hu>
 <20110516212449.GJ2573@linux.vnet.ibm.com>
 <20110517024000.GA5026@nowhere>
 <4DD435C2.6040305@kernel.org>
 <20110518231314.GA1723@nowhere>
 <4DD49DAF.5080605@kernel.org>
 <20110519144740.GC1956@nowhere>
 <4DD574BE.7050709@kernel.org>
 <20110519211458.GG1956@nowhere>
 <4DD58F90.4090506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD58F90.4090506@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 02:45:52PM -0700, Yinghai Lu wrote:
> On 05/19/2011 02:15 PM, Frederic Weisbecker wrote:
> > On Thu, May 19, 2011 at 12:51:26PM -0700, Yinghai Lu wrote:
> >> [   85.194797]   <idle>-0       0d... 85152953us : rcu_irq_enter: 1 49
> >> [   85.194808]   <idle>-0       0dN.. 85153081us : <stack trace>
> >> [   85.194809]  => rcu_irq_exit
> >> [   85.194810]  => irq_exit
> >> [   85.194811]  => smp_apic_timer_interrupt
> >> [   85.194812]  => apic_timer_interrupt
> >> [   85.194813]  => cpu_idle
> >> [   85.194813]  => rest_init
> >> [   85.194814]  => start_kernel
> >> [   85.194815]  => x86_64_start_reservations
> > 
> > So it's the dynticks_nesting going crazy. As if we had rcu_irq_enter()
> > without rcu_irq_exit().
> > 
> > I see you have CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> > and the locking api selftest is doing a strange thing: if we look
> > at HARDIRQ_ENTER(), it calls irq_enter(), but HARDIRQ_EXIT() only
> > calls __irq_exit(). Which means it lacks the rcu_irq_exit().
> > 
> > So, if I understood correctly the thing there, some selftests simulating
> > the hardirq context are unbalancing the rcu state.
> > 
> > Does that help if you unset CONFIG_DEBUG_LOCKING_API_SELFTESTS ?
> 
> 
> yes, after unset that, no warning and delay...

Thanks a lot for all your testing! I've just proposed a fix, let's see
how that goes.
