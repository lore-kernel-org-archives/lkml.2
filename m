Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3ACV6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:58:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3ACV6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:58:52 -0500
Date: Thu, 3 Jan 2013 13:58:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Decotigny <decot@googlers.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
Message-Id: <20130103135851.8cc58899.akpm@linux-foundation.org>
In-Reply-To: <1357170406.3652.66.camel@bwh-desktop.uk.solarflarecom.com>
References: <cover.1357163124.git.decot@googlers.com>
	<bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
	<20130102151242.fc6f1bee.akpm@linux-foundation.org>
	<1357170406.3652.66.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2013 23:46:46 +0000
Ben Hutchings <bhutchings@solarflare.com> wrote:

> On Wed, 2013-01-02 at 15:12 -0800, Andrew Morton wrote:
> > On Wed,  2 Jan 2013 13:52:25 -0800
> > David Decotigny <decot@googlers.com> wrote:
> > 
> > > In some cases, free_irq_cpu_rmap() is called while holding a lock
> > > (eg. rtnl). This can lead to deadlocks, because it invokes
> > > flush_scheduled_work() which ends up waiting for whole system
> > > workqueue to flush, but some pending works might try to acquire the
> > > lock we are already holding.
> > > 
> > > This commit uses reference-counting to replace
> > > irq_run_affinity_notifiers(). It also removes
> > > irq_run_affinity_notifiers() altogether.
> > 
> > I can't say that I've ever noticed cpu_rmap.c before :( Is is too late
> > to review it?
> > 
> > - The naming is chaotic.  At least these:
> > 
> > 	EXPORT_SYMBOL(alloc_cpu_rmap);
> > 	EXPORT_SYMBOL(free_cpu_rmap);
> > 	EXPORT_SYMBOL(cpu_rmap_add);
> > 	EXPORT_SYMBOL(cpu_rmap_update);
> > 	EXPORT_SYMBOL(free_irq_cpu_rmap);
> > 	EXPORT_SYMBOL(irq_cpu_rmap_add);
> > 
> >   should be consistently named cpu_rmap_foo()
> 
> There is a common practice of defining alloc_foo() and free_foo()
> alongside foo_do_this() and foo_do_that().  I deliberately chose to
> follow that.  If this is deprecated then it should be documented
> somewhere.

I don't think anyone has thought about it to that extent.  I always
recommend that the exported identifiers be named as
subsysid_functionname() and cannot think of any reason for
special-casing alloc and free.

> > - What's the locking model?  It appears to be caller-provided, but
> >   it is undocumented.
> 
> I think caller-provided can be assumed as the default for library code.

Nope, a lot of library code does internal locking.  And boy, does that
cause problems!  Experience tells us that caller-provided locking is
better.  But to avoid nasty problems, the library should clearly
document its locking requirements!

Bear in mind that spinlocks and mutexes aren't the only form of locks. 
A caller may wish to use an rwsem or rwlock, either to get parallelism
in cpu_rmap_lookup_index() and cpu_rmap_lookup_obj(), or because they
were already using such a lock.  The cpu_rmap() locking documentation
should describe which interface calls are OK with read-side locking. 
Not only to instruct users, but also to act as a constraint upon future
developers of the cpu_rmap code.  It becomes a contract saying "if you
use read_lock() for this, we won't later break your stuff".

> And IRQ setup and teardown need to be properly serialised in the driver
> already.
> 
> >   drivers/net/ethernet/mellanox/mlx4/ appears to be using
> >   msix_ctl.pool_lock for exclusion, but I didn't check for coverage.
> >
> >   drivers/net/ethernet/sfc/efx.c seems to not need locking because
> >   all its cpu_rmap operations are at module_init() time.
> >
> >   The cpu_rmap code would be less of a hand grenade if each of its
> >   interface functions documented the caller's locking requirements.
> 
> This particular 'hand grenade' *was* documented.  So I don't think
> documentation is the problem.

Dunno what you're referring to here.  There is no cpu_rmap() locking
documentation.

> > As for this patch: there's no cc:stable here but it does appear that
> > the problem is sufficiently serious to justify a backport, agree?
> [...]
> 
> Not sure.  So far as I can see, nothing called free_irq_cpu_rmap() while
> holding the RTNL lock before v3.8-rc1.  If there can be work items on a
> global workqueue that lock a PCI device (perhaps EEH?) then stable
> versions may also be affected.

OK.  The patch is rather non-trivial so I guess we aim for 3.8-only
for now.
