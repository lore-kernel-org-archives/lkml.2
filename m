Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2ECAac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:30:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45311 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab2ECAa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:30:29 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 20:30:29 EDT
Date: Wed, 2 May 2012 17:24:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
In-Reply-To: <20120503001433.GO2450@linux.vnet.ibm.com>
Message-ID: <alpine.LSU.2.00.1205021721350.24869@eggly.anvils>
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils> <1335832418.20866.95.camel@pasglop> <alpine.LSU.2.00.1204302142310.27208@eggly.anvils> <20120501142208.GA2441@linux.vnet.ibm.com> <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
 <20120501232516.GR2441@linux.vnet.ibm.com> <alpine.LSU.2.00.1205021324430.24246@eggly.anvils> <1335993615.4088.1.camel@pasglop> <20120502215406.GL2450@linux.vnet.ibm.com> <CANsGZ6bw4JwMRgUriooDvFB=g-HkpyL8XJa9s47RPfOEPCMcpw@mail.gmail.com>
 <20120503001433.GO2450@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-985873367-1336004652=:24869"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-985873367-1336004652=:24869
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 2 May 2012, Paul E. McKenney wrote:
> On Wed, May 02, 2012 at 03:54:24PM -0700, Hugh Dickins wrote:
> > On Wed, May 2, 2012 at 2:54 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Thu, May 03, 2012 at 07:20:15AM +1000, Benjamin Herrenschmidt wrot=
e:
> > >> On Wed, 2012-05-02 at 13:25 -0700, Hugh Dickins wrote:
> > >> > Got it at last. =A0Embarrassingly obvious. =A0__rcu_read_lock() an=
d
> > >> > __rcu_read_unlock() are not safe to be using __this_cpu operations=
,
> > >> > the cpu may change in between the rmw's read and write: they shoul=
d
> > >> > be using this_cpu operations (or, I put preempt_disable/enable in =
the
> > >> > __rcu_read_unlock below). =A0__this_cpus there work out fine on x8=
6,
> > >> > which was given good instructions to use; but not so well on Power=
PC.
> > >> >
> > >> > I've been running successfully for an hour now with the patch belo=
w;
> > >> > but I expect you'll want to consider the tradeoffs, and may choose=
 a
> > >> > different solution.
> > >>
> > >> Didn't Linus recently rant about these __this_cpu vs this_cpu nonsen=
se ?
> > >>
> > >> I thought that was going out..
> > >
> > > Linus did rant about __raw_get_cpu_var() because it cannot use the x8=
6
> > > %fs segement overrides a bit more than a month ago. =A0The __this_cpu
> > > stuff is useful if you have preemption disabled -- avoids the extra
> > > layer of preempt_disable().
> > >
> > > Or was this a different rant?
> >=20
> > https://lkml.org/lkml/2011/11/29/321
> >=20
> > I think it ended up with Christoph removing the more egregious
> > variants, but this_cpu_that and __this_cpu_the_other remaining.
>=20
> Ah, thank you for the pointer.
>=20
> It would be nice to have the CPU transparency of x86 on other
> architectures, but from what I can see, that would require dedicating
> a register to this purpose -- and even then requires that the arch
> have indexed addressing modes.  There are some other approaches, for
> example, having __this_cpu_that() be located at a special address that
> the scheduler treated as implicitly preempt_disable().  Or I suppose
> that the arch-specific trap-handling code could fake it.  A little
> bit messy, but the ability to access a given CPU's per-CPU variable
> while running on that CPU does appear to have at least a couple of
> uses -- inlining RCU and also making preempt_disable() use per-CPU
> variables.
>=20
> In any case, I must confess that I feel quite silly about my series
> of patches.  I have reverted them aside from a couple that did useful
> optimizations, and they should show up in -next shortly.

A wee bit sad, but thank you - it was an experiment worth trying,
and perhaps there will be reason to come back to it future.

Hugh
--8323584-985873367-1336004652=:24869--
