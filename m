Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0FDPMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:12:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325Ab0FDPMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:12:34 -0400
Date: Sat, 5 Jun 2010 01:12:31 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>,
       John Stultz <johnstul@us.ibm.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [patch 2/4] lglock: introduce special lglock and brlock spin
 locks
Message-ID: <20100604151231.GE26335@laptop>
References: <20100604064307.737085373@suse.de>
 <20100604072618.400686656@suse.de>
 <20100604150327.GB2358@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604150327.GB2358@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 08:03:27AM -0700, Paul E. McKenney wrote:
> On Fri, Jun 04, 2010 at 04:43:09PM +1000, Nick Piggin wrote:
> > This patch introduces "local-global" locks (lglocks). These can be used to:
> > 
> > - Provide fast exclusive access to per-CPU data, with exclusive access to
> >   another CPU's data allowed but possibly subject to contention, and to provide
> >   very slow exclusive access to all per-CPU data.
> > - Or to provide very fast and scalable read serialisation, and to provide
> >   very slow exclusive serialisation of data (not necessarily per-CPU data).
> > 
> > Brlocks are also implemented as a short-hand notation for the latter use
> > case.
> > 
> > Thanks to Paul for local/global naming convention.
> 
> ;-)
> 
> One set of questions about how this relates to real-time below.
> 
> (And I agree with Eric's point about for_each_possible_cpu(), FWIW.)
 
...

> > + void name##_lock_init(void) {						\
> > +	int i;								\
> > +	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
> > +	for_each_possible_cpu(i) {					\
> > +		arch_spinlock_t *lock;					\
> > +		lock = &per_cpu(name##_lock, i);			\
> > +		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
> > +	}								\
> > + }									\
> > + EXPORT_SYMBOL(name##_lock_init);					\
> > +									\
> > + void name##_local_lock(void) {						\
> > +	arch_spinlock_t *lock;						\
> > +	preempt_disable();						\
> 
> In a -rt kernel, I believe we would not want the above preempt_disable().
> Of course, in this case the arch_spin_lock() would need to become
> spin_lock() or some such.
> 
> The main point of this approach is to avoid cross-CPU holding of these
> locks, correct?  And then the point of arch_spin_lock() is to avoid the
> redundant preempt_disable(), right?

Yes. Preempt count and possibly lockdep will have issues with taking
so many nested locks in the write path.

The brlock version of this does avoid holding cross-CPU locks in the
fastpath. The lglock version used by files_list locking in the next
patch does need to sometimes take a cross-CPU lock.

