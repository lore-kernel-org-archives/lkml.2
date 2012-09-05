Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2IESzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:55:45 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49099 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2IESzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:55:44 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 173.246.103.110
Date: Wed, 5 Sep 2012 11:55:34 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 16/23] rcu: Prevent initialization-time
 quiescent-state race
Message-ID: <20120905185534.GA4976@jtriplet-mobl1>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-16-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120903093742.GE5574@leaf>
 <20120905181920.GN3308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905181920.GN3308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 11:19:20AM -0700, Paul E. McKenney wrote:
> On Mon, Sep 03, 2012 at 02:37:42AM -0700, Josh Triplett wrote:
> > On Thu, Aug 30, 2012 at 11:18:31AM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Now the the grace-period initialization procedure is preemptible, it is
> > > subject to the following race on systems whose rcu_node tree contains
> > > more than one node:
> > > 
> > > 1.	CPU 31 starts initializing the grace period, including the
> > > 	first leaf rcu_node structures, and is then preempted.
> > > 
> > > 2.	CPU 0 refers to the first leaf rcu_node structure, and notes
> > > 	that a new grace period has started.  It passes through a
> > > 	quiescent state shortly thereafter, and informs the RCU core
> > > 	of this rite of passage.
> > > 
> > > 3.	CPU 0 enters an RCU read-side critical section, acquiring
> > > 	a pointer to an RCU-protected data item.
> > > 
> > > 4.	CPU 31 removes the data item referenced by CPU 0 from the
> > > 	data structure, and registers an RCU callback in order to
> > > 	free it.
> > > 
> > > 5.	CPU 31 resumes initializing the grace period, including its
> > > 	own rcu_node structure.  In invokes rcu_start_gp_per_cpu(),
> > > 	which advances all callbacks, including the one registered
> > > 	in #4 above, to be handled by the current grace period.
> > > 
> > > 6.	The remaining CPUs pass through quiescent states and inform
> > > 	the RCU core, but CPU 0 remains in its RCU read-side critical
> > > 	section, still referencing the now-removed data item.
> > > 
> > > 7.	The grace period completes and all the callbacks are invoked,
> > > 	including the one that frees the data item that CPU 0 is still
> > > 	referencing.  Oops!!!
> > > 
> > > This commit therefore moves the callback handling to precede initialization
> > > of any of the rcu_node structures, thus avoiding this race.
> > 
> > I don't think it makes sense to introduce and subsequently fix a race in
> > the same patch series. :)
> > 
> > Could you squash this patch into the one moving grace-period
> > initialization into a kthread?
> 
> I tried that, and got a surprisingly large set of conflicts.  Ah, OK,
> the problem is that breaking up rcu_gp_kthread() into subfunctions
> did enough code motion to defeat straightforward rebasing.  Is there
> some way to tell "git rebase" about such code motion, or would this
> need to be carried out carefully by hand?

To the extent rebase knows how to handle that, I think it does so
automatically as part of merge attempts.  Fortunately, in this case, the
change consists of moving two lines of code and their attached comment,
which seems easy enough to change in the original code; you'll then get
a conflict on the commit that moves the newly fixed code (easily
resolved by moving the change to the new code), and conflicts on any
changes next to the change in the new code (hopefully handled by
three-way merge, and if not then easily fixed by keeping the new lines).

- Josh Triplett
