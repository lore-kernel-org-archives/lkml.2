Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509Ab2CPPq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:46:27 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57512 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965332Ab2CPPqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:46:25 -0400
Date: Fri, 16 Mar 2012 10:46:23 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have
 been online
Message-ID: <20120316154623.GA28403@sgi.com>
References: <20120314002414.GA21561@linux.vnet.ibm.com>
 <1331717099.5752.15.camel@marge.simpson.net>
 <1331728841.7465.7.camel@marge.simpson.net>
 <20120314130801.GA11722@sgi.com>
 <20120314151717.GA2435@linux.vnet.ibm.com>
 <20120314165657.GA19117@linux.vnet.ibm.com>
 <20120315175857.GA8705@sgi.com>
 <20120315182314.GK2381@linux.vnet.ibm.com>
 <20120315210753.GA8807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315210753.GA8807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 02:07:53PM -0700, Paul E. McKenney wrote:
> On Thu, Mar 15, 2012 at 11:23:14AM -0700, Paul E. McKenney wrote:
> > On Thu, Mar 15, 2012 at 12:58:57PM -0500, Dimitri Sivanich wrote:
> > > On Wed, Mar 14, 2012 at 09:56:57AM -0700, Paul E. McKenney wrote:
> > > > On Wed, Mar 14, 2012 at 08:17:17AM -0700, Paul E. McKenney wrote:
> > > > > On Wed, Mar 14, 2012 at 08:08:01AM -0500, Dimitri Sivanich wrote:
> > > > > > On Wed, Mar 14, 2012 at 01:40:41PM +0100, Mike Galbraith wrote:
> > > > > > > On Wed, 2012-03-14 at 10:24 +0100, Mike Galbraith wrote: 
> > > > > > > > On Tue, 2012-03-13 at 17:24 -0700, Paul E. McKenney wrote: 
> > > > > > > > > The following builds, but is only very lightly tested.  Probably full
> > > > > > > > > of bug, especially when exercising CPU hotplug.
> > > > > > > > 
> > > > > > > > You didn't say RFT, but...
> > > > > > > > 
> > > > > > > > To beat on this in a rotund 3.0 kernel, the equivalent patch would be
> > > > > > > > the below?  My box may well answer that before you can.. hope not ;-)
> > > > > > > 
> > > > > > > (Darn, it did.  Box says boot stall with virgin patch in tip too though.
> > > > > > > Wedging it straight into 3.0 was perhaps a tad premature;)
> > > > > > 
> > > > > > I saw the same thing with 3.3.0-rc7+ and virgin patch on UV.  Boots fine without the patch.
> > > > > 
> > > > > Right...  Bozo here forgot to set the kernel parameters for large-system
> > > > > emulation during testing.  Apologies for the busted patch, will fix.
> > > > > 
> > > > > And thank you both for the testing!!!
> > > > > 
> > > > > Hey, at least I labeled it "RFC".  ;-)
> > > > 
> > > > Does the following work better?  It does pass my fake-big-system tests
> > > > (more testing in the works).
> > > 
> > > This one stalls for me at the same place the other one did.  Once again,
> > > if I remove the patch and rebuild, it boots just fine.
> > > 
> > > Is there some debug/trace information that you would like me to provide?
> > 
> > Very strange.
> > 
> > Could you please send your dmesg and .config?
> 
> Hmmm...  Memory ordering could be a problem, though in that case I would
> have expected the hand during the onlining process.  However, the memory
> ordering does need to be cleaned up in any case, please see below.
>
After testing this on 3.3.0-rc7+ I can say that this very much improves the
latency in the two rcu_for_each_node_breadth_first() loops.

Without the patch, under moderate load and while running an interrupt latency
test, I see the majority of loops taking 100-200 usec.

With the patch there are a few that take between 20-30, the rest are below
that.

Not that everything is OK latency-wise in RCU land.  There is still an
interrupt holdoff in force_quiescent_state() that is taking > 100usec,
with or without the patch.  I'm having difficulty finding exactly where
the other holdoff is happening because the kernel isn't accepting my nmi
handler.

That said, this fix is a nice improvement in those two loops.
