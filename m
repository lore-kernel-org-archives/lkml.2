Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1H3Sxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:53:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53309 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1H3Sxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:53:45 -0400
Date: Tue, 30 Aug 2011 20:53:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to idle
 enter/exit APIs
Message-ID: <20110830185338.GB15953@somewhere.redhat.com>
References: <20110829171155.GD9748@somewhere.redhat.com>
 <1314640155.2816.117.camel@twins>
 <20110829175954.GF9748@somewhere.redhat.com>
 <1314641160.2816.128.camel@twins>
 <20110829233521.GK9748@somewhere.redhat.com>
 <1314703315.2799.5.camel@twins>
 <20110830143207.GP9748@somewhere.redhat.com>
 <1314717993.5812.11.camel@twins>
 <20110830153343.GW9748@somewhere.redhat.com>
 <1314718952.5812.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314718952.5812.23.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 05:42:32PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 17:33 +0200, Frederic Weisbecker wrote:
> > > See all that is still kernelspace ;-) I think I know what you mean to
> > > say though, but seeing as you note there is even now a known shortcoming
> > > I'm not very confident its a solid construction. What will help us find
> > > such holes?
> > 
> > This: https://lkml.org/lkml/2011/6/23/744
> > 
> > It's in one of Paul's branches and should make it for the next merge window.
> > This should detect any of such holes. I made that on purpose for the nohz cpusets
> > when I saw how much error prone that can be with rcu :)
> 
> OK, good ;-)
> 
> > > I would much rather we not rely on such fragile things too much.. this
> > > RCU stuff wants way more thought, as it stands your patch-set doesn't do
> > > anything useful IMO.
> > 
> > Not sure what you mean. Well that Rcu thing for sure is fragile but we have
> > the tools ready to find the problems. 
> 
> Right that thing you linked above does catch abuse, still your current
> proposal means that due to RCU it will basically never disable the tick.

At least if we are in userspace it does as long as we have no local rcu callbacks
to handle. We have the rcu_pending() check but we can remove it for userspace.

Now for the kernel space I still think it's worth, for example when all other
CPUs are idle, or when they don't queue that much RCU callbacks. In theory if
we have a grace period to complete 100 times per second but HZ=1000 then we
are going to avoid a lot of timer interrupts.
If we can't remove the timer, we can at least minimize it.
