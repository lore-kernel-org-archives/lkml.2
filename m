Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab2BJBd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 20:33:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:37617 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab2BJBdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 20:33:55 -0500
Date: Thu, 9 Feb 2012 15:41:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
Message-ID: <20120209234144.GC2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120202153437.GD2518@linux.vnet.ibm.com>
 <4F2AB66C.2030309@redhat.com>
 <20120202170134.GM2518@linux.vnet.ibm.com>
 <4F2AC69B.7000704@redhat.com>
 <20120202175155.GV2518@linux.vnet.ibm.com>
 <4F2E7311.8060808@redhat.com>
 <20120205165927.GH2467@linux.vnet.ibm.com>
 <20120209152155.GA22552@somewhere.redhat.com>
 <4F33EEB3.4080807@redhat.com>
 <20120209182216.GG22552@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209182216.GG22552@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021001-3270-0000-0000-000003E1B053
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 07:22:19PM +0100, Frederic Weisbecker wrote:
> On Thu, Feb 09, 2012 at 06:05:07PM +0200, Avi Kivity wrote:
> > On 02/09/2012 05:22 PM, Frederic Weisbecker wrote:
> > > > > 
> > > > > Looks like there are new rcu_user_enter() and rcu_user_exit() APIs which
> > > > > we can use.  Hopefully they subsume rcu_virt_note_context_switch() so we
> > > > > only need one set of APIs.
> > > > 
> > > > Now that you mention it, that is a good goal.  However, it requires
> > > > coordination with Frederic's code as well, so some investigation
> > > > is required.  Bad things happen if you tell RCU you are idle when you
> > > > really are not and vice versa!
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > >
> > > Right. Avi I need to know more about what you need. rcu_virt_note_context_switch()
> > > notes a quiescent state while rcu_user_enter() shuts down RCU (it's in fact the same
> > > thing than rcu_idle_enter() minus the is_idle_cpu() checks).
> > 
> > I don't know enough about RCU to say if it's okay or not (I typically
> > peek at the quick quiz answers).  However, switching to guest mode is
> > very similar to exiting to user mode: we're guaranteed not to be in an
> > rcu critical section, and to remain so until the guest exits back to
> > us.
> 
> Awesome!
> 
> > What guarantees does rcu_user_enter() provide?  With luck guest
> > entry satisifies them all.
> 
> So rcu_user_enter() puts the CPU into RCU idle mode, which means the CPU
> won't need to be part of the global RCU grace period completion. This
> prevents it to depend on the timer tick (although for now you keep it)
> and to complete some RCU specific work during the tick.
> 
> Paul, do you think that would be a win?

As long as the code doesn't enter RCU read-side critical sections in
the time between rcu_idle_enter() and rcu_idle_exit(), this should
work fine.

							Thanx, Paul

