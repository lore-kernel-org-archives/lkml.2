Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1BNXJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:09:13 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42148 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab1BNXJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:09:11 -0500
Date: Mon, 14 Feb 2011 15:09:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Matt Fleming <matt@console-pimps.org>, David Miller <davem@davemloft.net>,
        rostedt@goodmis.org, peterz@infradead.org, will.newton@gmail.com,
        jbaron@redhat.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110214230902.GM2256@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1297707868.5226.189.camel@laptop>
 <1297718964.23343.75.camel@gandalf.stny.rr.com>
 <1297719576.23343.80.camel@gandalf.stny.rr.com>
 <20110214.134600.179933733.davem@davemloft.net>
 <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
 <BLU0-SMTP166A8555C791786059B0FF96D00@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP166A8555C791786059B0FF96D00@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 06:03:01PM -0500, Mathieu Desnoyers wrote:
> * Matt Fleming (matt@console-pimps.org) wrote:
> > On Mon, 14 Feb 2011 13:46:00 -0800 (PST)
> > David Miller <davem@davemloft.net> wrote:
> > 
> > > From: Steven Rostedt <rostedt@goodmis.org>
> > > Date: Mon, 14 Feb 2011 16:39:36 -0500
> > > 
> > > > Thus it is not about global, as global is updated by normal means
> > > > and will update the caches. atomic_t is updated via the ll/sc that
> > > > ignores the cache and causes all this to break down. IOW... broken
> > > > hardware ;)
> > > 
> > > I don't see how cache coherency can possibly work if the hardware
> > > behaves this way.
> > 
> > Cache coherency is still maintained provided writes/reads both go
> > through the cache ;-)
> > 
> > The problem is that for read-modify-write operations the arbitration
> > logic that decides who "wins" and is allowed to actually perform the
> > write, assuming two or more CPUs are competing for a single memory
> > address, is not implemented in the cache controller, I think. I'm not a
> > hardware engineer and I never understood how the arbitration logic
> > worked but I'm guessing that's the reason that the ll/sc instructions
> > bypass the cache.
> > 
> > Which is why the atomic_t functions worked out really well for that
> > arch, such that any accesses to an atomic_t * had to go through the
> > wrapper functions.

???

What CPU family are we talking about here?  For cache coherent CPUs,
cache coherence really is supposed to work, even for mixed atomic and
non-atomic instructions to the same variable.

							Thanx, Paul

> If this is true, then we have bugs in lots of xchg/cmpxchg users (which
> do not reside in atomic.h), e.g.:
> 
> fs/fs_struct.c:
> int current_umask(void)
> {
>         return current->fs->umask;
> }
> EXPORT_SYMBOL(current_umask);
> 
> kernel/sys.c:
> SYSCALL_DEFINE1(umask, int, mask)
> {
>         mask = xchg(&current->fs->umask, mask & S_IRWXUGO);
>         return mask;
> }
> 
> The solution to this would be to force all xchg/cmpxchg users to swap to
> atomic.h variables, which would force the ll semantic on read. But I'd
> really like to see where this is documented first -- or which PowerPC
> engineer we should talk to.
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
