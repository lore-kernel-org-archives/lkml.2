Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab1FAOhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:37:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55742 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab1FAOhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:37:50 -0400
Date: Wed, 1 Jun 2011 07:37:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Very high CPU load when idle with 3.0-rc1
Message-ID: <20110601143743.GA2274@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110530055924.GA9169@brouette>
 <1306755291.1200.2872.camel@twins>
 <20110530162354.GQ2668@linux.vnet.ibm.com>
 <1306775989.2497.527.camel@laptop>
 <20110530212833.GS2668@linux.vnet.ibm.com>
 <1306791219.23844.12.camel@twins>
 <20110531014543.GU2668@linux.vnet.ibm.com>
 <1306926339.2353.191.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306926339.2353.191.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 01:05:39PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-05-30 at 18:45 -0700, Paul E. McKenney wrote:
> > > > Because priority boosting doesn't help unless the callbacks also run
> > > > RT priority.
> > > > 
> > > > I could make it so that they ran as normal tasks if !RCU_BOOST, but
> > > > they would still need to run as RT tasks for RCU_BOOST.  I figured
> > > > running them the same way in both cases would be simpler.
> > > 
> > > Ah, I thought you'd boost the threads along with the waiters, to the
> > > same prio so that they wouldn't disturb higher priority tasks for no
> > > reason.
> > 
> > I considered that, but working out when it is OK to deboost them is
> > decidedly non-trivial. 
> 
> Where exactly is the problem there? The boost lasts for as long as it
> takes to finish the grace period, right? There's a distinct set of
> callbacks associated with each grace-period, right? In which case you
> can de-boost your thread the moment you're done processing that set.
> 
> Or am I simply confused about how all this is supposed to work?

The main complications are: (1) the fact that it is hard to tell exactly
which grace period to wait for, this one or the next one, and (2) the
fact that callbacks get shuffled when CPUs go offline.

That said, it might be possible if we are willing to live with some
approximate behavior.  For example, always waiting for the next grace
period (rather than the current one) to finish, and boosting through the
extra callbacks in case where a given CPU "adopts" callbacks that must
be boosted when that CPU also has some callbacks whose priority must be
boosted and some that need not be.

The reason I am not all that excited about taking this approach is that
it doesn't help worst-case latency.

Plus the current implementation is just a less-precise approximation.
(Sorry, couldn't resist!)

							Thanx, Paul
