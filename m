Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1KCNhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:37:18 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37883 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1KCNhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:37:14 -0400
Date: Thu, 3 Nov 2011 06:34:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference
 count
Message-ID: <20111103133435.GB2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103043441.GF2042@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103043441.GF2042@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110313-1976-0000-0000-000000B22A6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 09:34:41PM -0700, Josh Triplett wrote:
> On Wed, Nov 02, 2011 at 01:30:45PM -0700, Paul E. McKenney wrote:
> > The RCU implementations, including SRCU, are designed to be used in a
> > lock-like fashion, so that the read-side lock and unlock primitives must
> > execute in the same context for any given read-side critical section.
> > This constraint is enforced by lockdep-RCU.  However, there is a need for
> > something that acts more like a reference count than a lock, in order
> > to allow (for example) the reference to be acquired within the context
> > of an exception, while that same reference is released in the context of
> > the task that encountered the exception.  The cost of this capability is
> > that the read-side operations incur the overhead of disabling interrupts.
> > Some optimization is possible, and will be carried out if warranted.
> > 
> > Note that although the current implementation allows a given reference to
> > be acquired by one task and then released by another, all known possible
> > implementations that allow this have scalability problems.  Therefore,
> > a given reference must be released by the same task that acquired it,
> > though perhaps from an interrupt or exception handler running within
> > that task's context.
> 
> This new bulkref API seems in dire need of documentation. :)
> 
> > --- a/include/linux/srcu.h
> > +++ b/include/linux/srcu.h
> > @@ -181,4 +181,54 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
> >  	__srcu_read_unlock(sp, idx);
> >  }
> >  
> > +/* Definitions for bulkref_t, currently defined in terms of SRCU. */
> > +
> > +typedef struct srcu_struct bulkref_t;
> > +int init_srcu_struct_fields(struct srcu_struct *sp);
> > +
> > +static inline int init_bulkref(bulkref_t *brp)
> > +{
> > +	return init_srcu_struct_fields(brp);
> > +}
> 
> Why can't this call init_srcu_struct and avoid the need to use the
> previously unexported internal function?

Seems reasonable now that you mention it.  ;-)

							Thanx, Paul

