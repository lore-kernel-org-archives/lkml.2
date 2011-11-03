Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab1KCTxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:53:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52430 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1KCTxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:53:45 -0400
Date: Thu, 3 Nov 2011 12:53:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 27/28] rcu: Allow dyntick-idle mode
 for CPUs with callbacks
Message-ID: <20111103195300.GI2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-27-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103044743.GG2042@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103044743.GG2042@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110319-3534-0000-0000-0000013C3C64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 09:47:44PM -0700, Josh Triplett wrote:
> On Wed, Nov 02, 2011 at 01:30:48PM -0700, Paul E. McKenney wrote:
> >  /*
> > - * Check to see if any future RCU-related work will need to be done
> > - * by the current CPU, even if none need be done immediately, returning
> > - * 1 if so.  This function is part of the RCU implementation; it is -not-
> > - * an exported member of the RCU API.
> > + * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
> > + * callbacks on this CPU, (2) this CPU has not yet attempted to enter
> > + * dyntick-idle mode, and (3) this CPU is in the process of attempting to
> > + * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
> 
> This sentence doesn't quite work; "if either...and..." should become
> "either...or" or "if...and".

Good eyes -- "or" it is!

> > + * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
> > + * it is better to incur scheduling-clock interrupts than to spin
> > + * continuously for the same time duration!
> > + */
> > +int rcu_needs_cpu(int cpu)
> > +{
> > +	/* If no callbacks, RCU doesn't need the CPU. */
> > +	if (!rcu_cpu_has_callbacks(cpu))
> > +		return 0;
> > +	/* Otherwise, RCU needs the CPU only if it recently tried and failed. */
> > +	return per_cpu(rcu_dyntick_holdoff, cpu) == jiffies;
> 
> Sigh, one more use of jiffies. :(

Your suggested alternative?  I need something cheap, doesn't need to
be accurate to more than a few milliseconds, needs to be synchronized
across all CPUs.

							Thanx, Paul

