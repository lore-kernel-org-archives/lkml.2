Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1K2NyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:54:00 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64742 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1K2Nx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:53:59 -0500
Date: Tue, 29 Nov 2011 14:53:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4 RFC] rcu: New rcu_user_enter_irq() and
 rcu_user_exit_irq() APIs
Message-ID: <20111129135344.GA20387@somewhere>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
 <1322515487-18690-5-git-send-email-fweisbec@gmail.com>
 <20111128215323.GF30852@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128215323.GF30852@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 01:53:23PM -0800, Josh Triplett wrote:
> On Mon, Nov 28, 2011 at 10:24:47PM +0100, Frederic Weisbecker wrote:
> > A CPU running in adaptive tickless mode wants to enter into
> > RCU extended quiescent state while running in userspace. This
> > way we can shut down the tick that is usually needed on each
> > CPU for the needs of RCU.
> 
> Very awesome.  I've wanted to see this change for a long time.  Thanks!

:-)

> 
> > Typically, RCU enters the extended quiescent state when we resume
> > to userspace through a syscall or exception exit, this is done
> > using rcu_user_enter(). Then RCU exit this state by calling
> > rcu_user_exit() from syscall or exception entry.
> > 
> > However there are two other points where we may want to enter
> > or exit this state. Some remote CPU may require a tickless CPU
> > to restart its tick for any reason and send it an IPI for
> > this purpose. As we restart the tick, we don't want to resume
> > from the IPI in RCU extended quiescent state anymore.
> > Similarly we may stop the tick from an interrupt in userspace and
> > we need to be able to enter RCU extended quiescent state when we
> > resume from this interrupt to userspace.
> > 
> > To these ends, we provide two new APIs:
> > 
> > - rcu_user_enter_irq(). This must be called from a non-nesting
> > interrupt betwenn rcu_irq_enter() and rcu_irq_exit().
> > After the irq calls rcu_irq_exit(), we'll run into RCU extended
> > quiescent state.
> > 
> > - rcu_user_exit_irq(). This must be called from a non-nesting
> > interrupt, interrupting an RCU extended quiescent state, and
> > between rcu_irq_enter() and rcu_irq_exit(). After the irq calls
> > rcu_irq_exit(), we'll prevent from resuming the RCU extended
> > quiescent.
> 
> It would help to see the corresponding patches making use of this new
> API.

Right, so I plan to use it in my nohz cpuset patchset that can be found at:

	git://github.com/fweisbec/linux-dynticks.git
		nohz/cpuset-v1

I haven't yet integrated these patches to this tree. I first need to do a big
rebase against all the changes made against dynticks API in -rcu.

I'll do that soon.
