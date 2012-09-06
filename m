Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab2IFQtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:49:09 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45859 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2IFQtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:49:05 -0400
Date: Thu, 6 Sep 2012 09:47:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] Add callback-free CPUs
Message-ID: <20120906164745.GF2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120905213945.GA15216@linux.vnet.ibm.com>
 <1346881720.2600.48.camel@twins>
 <20120905234443.GY3308@linux.vnet.ibm.com>
 <1346926417.2600.73.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346926417.2600.73.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090616-5518-0000-0000-0000076D1885
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 12:13:37PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 16:44 -0700, Paul E. McKenney wrote:
> 
> > I was excited by this possibility when you first mentioned it, but
> > the low-OS-jitter fans are going to need the grace-period computation
> > to be offloaded as well. 
> 
> Sure, but it seems to me pulling the grace period machinery out is a
> much harder feat and should be a patch (series) on its own. Also..

Actually, I believe that I can resolve this reasonably simply.

> >  So if I use your (admittedly much simpler)
> > approach, I get to rewrite it when Frederic's adaptive-ticks work goes
> > in. 
> 
> I don't see how Frederic's work affects any of this, that would simple
> put RCU into extended quiescent state (aka. idle) while in userspace. In
> that state the grace period machinery is stopped all together, so it
> doesn't matter who would've ran it. 

The key point is "would simple put RCU into extended quiescent state".
This can only happen if the CPU has no callbacks.  If the CPU does have
callbacks, then RCU will need to do some work to advance the callbacks.
Advancing the callbacks requires that RCU periodically do work on that
CPU, resulting in OS jitter.

> >  Given that this is probably happening relatively soon, it would be
> > better if I just did the implementation that will be needed long-term,
> > rather than rewriting.
> > 
> > Though I am sure that people will be sad about fewer RCU patches.  ;-)
> 
> Always...
> 
> Now thinking about this grace machinery stuff a little more, would it be
> possible to stick the entire state machine in a kthread and replace all
> current hooks, like the tick and rcu_read_unlock_special with a message
> passing construct such that they pass their event on to the kthread?
> 
> That way you could run the entire state thing from a kthread with random
> affinity, all 'per-cpu' data would still be fine since only the one
> kthread will access it, even though locality might suffer somewhat.

Well, the current patch set does move much of the grace-period machinery
to a kthread.  Much of the remaining work needs to remain on the CPUs
(at least those not in an extended quiescent state) in order to keep
the overhead of the read-side primitives and scheduler hooks inexpensive.

> This would also not suffer from the having to keep one cpu special and
> the ugly bouncing etc..

The CPU-0 bounce thing was just a short-term hack to get the prototype
working quickly.  It absolutely will -not- go mainline.  I have not yet
worked out the best thing to replace it, but it will be replaced!

							Thanx, Paul

