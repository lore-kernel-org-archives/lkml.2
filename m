Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2FKWGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:06:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56075 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2FKWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:06:13 -0400
Date: Tue, 12 Jun 2012 00:06:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] rcu: Allow calls to rcu_exit_user_irq from nesting
 irqs
Message-ID: <20120611220600.GA29503@somewhere.redhat.com>
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
 <20120604181313.GL2490@linux.vnet.ibm.com>
 <CAFTL4hzqa1z4icSBwEqZXLjCrVsG+axm2TaGSaaMXkjazT0Qfw@mail.gmail.com>
 <20120604210709.GO2490@linux.vnet.ibm.com>
 <20120605103055.GA4553@somewhere.redhat.com>
 <20120605234640.GY2388@linux.vnet.ibm.com>
 <20120609225550.GB31957@somewhere.redhat.com>
 <20120610180659.GD2425@linux.vnet.ibm.com>
 <20120610214722.GE31957@somewhere.redhat.com>
 <20120611215546.GH2521@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611215546.GH2521@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 02:55:46PM -0700, Paul E. McKenney wrote:
> On Sun, Jun 10, 2012 at 11:47:26PM +0200, Frederic Weisbecker wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Date: Sat, 9 Jun 2012 14:06:30 +0200
> > Subject: [PATCH] rcu: Allow calls to rcu_exit_user_irq from nesting irqs
> > 
> > rcu_exit_user_irq() which exits RCU idle mode after the current
> > irq returns has been designed to be called from non nesting irqs
> > only.
> > 
> > However the IPI that restarts the tick and exits RCU user-idle mode
> > in nohz cpusets can happen anytime. For example it can be a nesting
> > irq by interrupting a softirq. In this case the stack of RCU API
> > calls becomes:
> > 
> > ==> IRQ
> >     rcu_irq_enter()
> >     ....
> >     do_softirq {
> > ===== > IRQ (restart tick IPI)
> >         rcu_irq_enter()
> >         rcu_exit_user_irq()
> >         rcu_irq_exit()
> > <=====
> >     }
> >     rcu_irq_exit();
> > 
> > Hence we need to make rcu_exit_user_irq() callable from any nesting
> > level of interrupt.
> > 
> > v2: rcu_user_enter_irq() is only called from non nesting irqs though so
> > the change doesn't need to be propagated to it.
> 
> I have queued this on -rcu on branch rcu/idle.  I have also removed
> the TINY_RCU commits as discussed.  If you ever need them back, the
> magic branch name is idle.2012.06.06a.

Thanks a lot!
