Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1H3OcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:32:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41014 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1H3OcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:32:14 -0400
Date: Tue, 30 Aug 2011 16:32:09 +0200
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
Message-ID: <20110830143207.GP9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
 <1314627922.2816.65.camel@twins>
 <20110829171155.GD9748@somewhere.redhat.com>
 <1314640155.2816.117.camel@twins>
 <20110829175954.GF9748@somewhere.redhat.com>
 <1314641160.2816.128.camel@twins>
 <20110829233521.GK9748@somewhere.redhat.com>
 <1314703315.2799.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314703315.2799.5.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 01:21:55PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 01:35 +0200, Frederic Weisbecker wrote:
> > > That means it has to be in an extended grace period when we stop the
> > > tick.
> > 
> > You mean extended quiescent state?
> 
> Yeah that :-)
> 
> > As a summary here is what we do:
> > 
> > - if we are in the kernel, we can't run into extended quiescent state because
> > we may make use of rcu anytime there. But if we run nohz we don't have the tick
> > to notice quiescent states to the RCU machinery and help completing grace periods
> > so as soon as we receive an rcu IPI from another CPU (due to the grace period
> > beeing extended because our nohz CPU doesn't report quiescent states), we restart
> > the tick. We are optimistic enough to consider that we may avoid a lot of ticks
> > even if there are some risks to be disturbed in some random rates.
> > So even with the IPI we consider it as an upside.
> > 
> > - if we are in userspace we can run in extended quiescent state.
> 
> But you can only disable the tick/enter extended quiescent state while
> in kernel-space. Thus the second clause is precluded from ever being
> true.

No, we have a specific stacking in the irq:

	rcu_irq_enter()

	disable tick...
	if (user)
		rcu_enter_nohz();

	rcu_irq_exit() <-- extended quiescent state entry effective only there

And by the time we call rcu_irq_exit() and we resume to userspace, we are
not supposed to have rcu read side critical section (minus the case of
a signal with do_notify_resume() which I have yet to handle).
