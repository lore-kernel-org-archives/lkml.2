Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2ECAPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:15:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47314 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2ECAPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:15:48 -0400
Date: Wed, 2 May 2012 17:14:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
Message-ID: <20120503001433.GO2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
 <1335832418.20866.95.camel@pasglop>
 <alpine.LSU.2.00.1204302142310.27208@eggly.anvils>
 <20120501142208.GA2441@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
 <20120501232516.GR2441@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1205021324430.24246@eggly.anvils>
 <1335993615.4088.1.camel@pasglop>
 <20120502215406.GL2450@linux.vnet.ibm.com>
 <CANsGZ6bw4JwMRgUriooDvFB=g-HkpyL8XJa9s47RPfOEPCMcpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsGZ6bw4JwMRgUriooDvFB=g-HkpyL8XJa9s47RPfOEPCMcpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050300-3270-0000-0000-00000603E113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 03:54:24PM -0700, Hugh Dickins wrote:
> On Wed, May 2, 2012 at 2:54 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, May 03, 2012 at 07:20:15AM +1000, Benjamin Herrenschmidt wrote:
> >> On Wed, 2012-05-02 at 13:25 -0700, Hugh Dickins wrote:
> >> > Got it at last.  Embarrassingly obvious.  __rcu_read_lock() and
> >> > __rcu_read_unlock() are not safe to be using __this_cpu operations,
> >> > the cpu may change in between the rmw's read and write: they should
> >> > be using this_cpu operations (or, I put preempt_disable/enable in the
> >> > __rcu_read_unlock below).  __this_cpus there work out fine on x86,
> >> > which was given good instructions to use; but not so well on PowerPC.
> >> >
> >> > I've been running successfully for an hour now with the patch below;
> >> > but I expect you'll want to consider the tradeoffs, and may choose a
> >> > different solution.
> >>
> >> Didn't Linus recently rant about these __this_cpu vs this_cpu nonsense ?
> >>
> >> I thought that was going out..
> >
> > Linus did rant about __raw_get_cpu_var() because it cannot use the x86
> > %fs segement overrides a bit more than a month ago.  The __this_cpu
> > stuff is useful if you have preemption disabled -- avoids the extra
> > layer of preempt_disable().
> >
> > Or was this a different rant?
> 
> https://lkml.org/lkml/2011/11/29/321
> 
> I think it ended up with Christoph removing the more egregious
> variants, but this_cpu_that and __this_cpu_the_other remaining.

Ah, thank you for the pointer.

It would be nice to have the CPU transparency of x86 on other
architectures, but from what I can see, that would require dedicating
a register to this purpose -- and even then requires that the arch
have indexed addressing modes.  There are some other approaches, for
example, having __this_cpu_that() be located at a special address that
the scheduler treated as implicitly preempt_disable().  Or I suppose
that the arch-specific trap-handling code could fake it.  A little
bit messy, but the ability to access a given CPU's per-CPU variable
while running on that CPU does appear to have at least a couple of
uses -- inlining RCU and also making preempt_disable() use per-CPU
variables.

In any case, I must confess that I feel quite silly about my series
of patches.  I have reverted them aside from a couple that did useful
optimizations, and they should show up in -next shortly.

							Thanx, Paul

