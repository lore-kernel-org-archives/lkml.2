Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2BDQwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:52:11 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41699 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2BDQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:52:09 -0500
Date: Sat, 4 Feb 2012 08:52:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: rcu warnings cause stack overflow
Message-ID: <20120204165202.GC2467@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201100652.GA2922@osiris.boeblingen.de.ibm.com>
 <20120201151445.GA6731@somewhere.redhat.com>
 <20120202122742.GA2745@osiris.boeblingen.de.ibm.com>
 <20120202145219.GD9071@somewhere.redhat.com>
 <20120202191116.GF2518@linux.vnet.ibm.com>
 <20120203093214.GA2471@osiris.boeblingen.de.ibm.com>
 <20120203183334.GG2382@linux.vnet.ibm.com>
 <20120204131333.GB13382@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120204131333.GB13382@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020416-1780-0000-0000-000002DF0F9C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110886; UDB=6.00027520; UTC=2012-02-04
 16:52:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 02:13:35PM +0100, Frederic Weisbecker wrote:
> On Fri, Feb 03, 2012 at 10:33:35AM -0800, Paul E. McKenney wrote:
> > On Fri, Feb 03, 2012 at 10:32:14AM +0100, Heiko Carstens wrote:
> > > On Thu, Feb 02, 2012 at 11:11:16AM -0800, Paul E. McKenney wrote:
> > > > On Thu, Feb 02, 2012 at 03:52:20PM +0100, Frederic Weisbecker wrote:
> > > > > On Thu, Feb 02, 2012 at 01:27:42PM +0100, Heiko Carstens wrote:
> > > > > > On Wed, Feb 01, 2012 at 04:14:48PM +0100, Frederic Weisbecker wrote:
> > > > > > > > Removing the WARN_ON_ONCE will fix this and, if lockdep is turned on, still
> > > > > > > > will find illegal uses. But it won't work for lockdep off configs...
> > > > > > > > So we probably want something better than the patch below.
> > > > > > > 
> > > > > > > Ah ok. Hmm, but why are you using an exception to implement WARN_ON()
> > > > > > > in s390? Is it to have a whole new stack for the warning path in order
> > > > > > > to avoid stack overflow from the place that called the WARN_ON() ?
> > > > > > 
> > > > > > The reason was to reduce the code footprint of the WARN_ON() and also
> > > > > > be able to print the register contents at the time the warning happened.
> > > > > 
> > > > > Ah ok, makes sense.
> > > > 
> > > > So Frederic should push his anti-recursion patch, then?
> > > 
> > > Yes, please.
> > > 
> > > Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > 
> > > It still generates recursive warnings because the WARNON_ONCE is inlined and
> > > every different usage will generate an exception, but it didn't produce a
> > > stack overflow anymore.
> > > To avoid the recursive warning the patch below would help. Not sure if it's
> > > worth it...
> > > 
> > > Subject: [PATCH] rcu: move rcu_is_cpu_idle() check warning into C file
> > > 
> > > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > 
> > > rcu_read_lock() and rcu_read_unlock() generate a warning if a cpu is in
> > > extended quiescant state. Since these functions are inlined this can cause
> > > a lot of warnings if in the processing of the WARN_ON_ONCE() there is
> > > another usage of e.g. rcu_read_lock(). To make sure we only get one
> > > warning (and avoid possible stack overflows) uninline the check.
> > > 
> > > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > ---
> > >  include/linux/rcupdate.h |    9 +++++++--
> > >  kernel/rcupdate.c        |    6 ++++++
> > >  2 files changed, 13 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > index 81c04f4..9fe7be5 100644
> > > --- a/include/linux/rcupdate.h
> > > +++ b/include/linux/rcupdate.h
> > > @@ -230,22 +230,27 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
> > > 
> > >  #ifdef CONFIG_PROVE_RCU
> > >  extern int rcu_is_cpu_idle(void);
> > > +extern void rcu_warn_if_is_cpu_idle(void);
> > >  #else /* !CONFIG_PROVE_RCU */
> > >  static inline int rcu_is_cpu_idle(void)
> > >  {
> > >  	return 0;
> > >  }
> > > +
> > > +static inline void rcu_warn_if_is_cpu_idle(void)
> > > +{
> > > +}
> > >  #endif /* else !CONFIG_PROVE_RCU */
> > > 
> > >  static inline void rcu_lock_acquire(struct lockdep_map *map)
> > >  {
> > > -	WARN_ON_ONCE(rcu_is_cpu_idle());
> > > +	rcu_warn_if_is_cpu_idle();
> > 
> > Thank you for the patch, but this WARN_ON_ONCE() has now been removed
> > in favor of lockdep-RCU checks elsewhere.  This has the advantage of
> > leveraging lockdep's splat-once and anti-recursion facilities.
> > 
> > So I believe that current -rcu covers this.  (And yes, I do need to
> > push my most recent changes out.)
> 
> This still uncovers cases where we call rcu_read_lock() without matching
> rcu_dereference(). Amongst this we have rcu_dereference_raw(), conditional
> rcu_dereference() and may be cases where we simply have no rcu_dereference*
> but we use rcu_read_lock() alone for some reason...

Ah!  I moved the !rcu_is_cpu_idle() check to the read-side primitives,
for example:

	static inline void rcu_read_lock(void)
	{
		__rcu_read_lock();
		__acquire(RCU);
		rcu_lock_acquire(&rcu_lock_map);
		rcu_lockdep_assert(!rcu_is_cpu_idle(),
				   "rcu_read_lock() used illegally while idle");
	}

The reason I did this is that there is a good chance that it will be
necessary to allow SRCU readers on CPUs that the other flavors of RCU
believe to be idle.  One reason for this is that the KVM guys want your
tickless idle to apply to KVM guest processes, but they need the guest
to be in an SRCU read-side critical section during that same time.

Now, this would break given current synchronize_srcu(), but Peter
Zijlstra's recent SRCU patches might get us to a point where it would work.

Then of course there will be the challenge of making it scale, but one
thing at a time.  ;-)

							Thanx, Paul

