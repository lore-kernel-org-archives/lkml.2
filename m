Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2BBRus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:50:48 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53053 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab2BBRur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:50:47 -0500
Date: Thu, 2 Feb 2012 09:50:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 24/41] rcu: Check for idle-loop entry
 while in RCU read-side critical section
Message-ID: <20120202175005.GU2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-24-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202051337.GP29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202051337.GP29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020217-9360-0000-0000-0000030A0956
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 09:13:37PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:42AM -0800, Paul E. McKenney wrote:
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -366,6 +366,20 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
> >  	atomic_inc(&rdtp->dynticks);
> >  	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
> >  	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
> > +
> > +	/*
> > +	 * The idle task is not permitted to enter the idle loop while
> > +	 * in an RCU read-side critical section.
> > +	 */
> > +	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
> > +			   "Illegal idle entry in RCU read-side "
> > +			   "critical section.");
> > +	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
> > +			   "Illegal idle entry in RCU-bh read-side "
> > +			   "critical section.");
> > +	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
> > +			   "Illegal idle entry in RCU-sched read-side "
> > +			   "critical section.");
> 
> Quoting a paragraph I added to Documentation/CodingStyle:
> 
> > Statements longer than 80 columns will be broken into sensible chunks, unless
> > exceeding 80 columns significantly increases readability and does not hide
> > information. Descendants are always substantially shorter than the parent and
> > are placed substantially to the right. The same applies to function headers
> > with a long argument list. However, never break user-visible strings such as
> > printk messages, because that breaks the ability to grep for them.
> 
> So, please don't break those strings across multiple lines.  The same
> goes for the similar rcu_lockdep_assert strings added in a previous
> patch in this series.

Fixed!

Again, I leave it to you to get checkpatch.pl to complain about this.  ;-)

							Thanx, Paul

