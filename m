Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab2DZR46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:56:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60909 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2DZR45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:56:57 -0400
Date: Thu, 26 Apr 2012 10:56:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 4/4] rcu: Ensure that RCU_FAST_NO_HZ
 timers expire on correct CPU
Message-ID: <20120426175608.GG2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423161539.GA6467@linux.vnet.ibm.com>
 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335197761-6577-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335445496.13683.21.camel@twins>
 <20120426155450.GD2407@linux.vnet.ibm.com>
 <1335456539.28106.185.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335456539.28106.185.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042617-2398-0000-0000-000006230825
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 12:08:59PM -0400, Steven Rostedt wrote:
> On Thu, 2012-04-26 at 08:54 -0700, Paul E. McKenney wrote:
> 
> > > The simpler change looks to use mod_timer_pinned()
> > 
> > Good point!
> > 
> > Except...  Now that you mention it, I don't see how mod_timer_pinned()
> > actually helps.  It looks to me like a CPU-hotplug operation will
> > migrate the timers anyway.
> > 
> > This is actually (in theory) harmless in the RCU_FAST_NO_HZ case, because
> > the CPU_DYING stuff will force a wakeup of the CPU in question, which
> > will cancel the timer.  But still, mod_timer_pinned() has a rather
> > misleading name.  ;-)
> > 
> > But a line is a line, so I made this change.
> 
> It's expected that if you use this (or anything else pinned to a CPU)
> that you add the hotplug hooks to handle a CPU going down.
> 
> There's only two users of this that I see. One is
> arch/x86/kernel/apic/x2apic_uv_x.c, that has the hotplug handling. The
> other is drivers/net/ethernet/tile/tilepro.c, that does not have hotplug
> handling, but the tile arch does not support hotplug anyway:
> 
> arch/tile/kernel/process.c: cpu_idle()
> 
> 			if (cpu_is_offline(cpu))
> 				BUG();  /* no HOTPLUG_CPU */

So what mod_timer_pinned() is really doing is ensuring that the timer
is registered on the current CPU instead of being registered on some
other CPU due to idleness considerations.  As you say, unless you do
something in CPU-hotplug notifiers, the timer -will- be migrated
at CPU-hotplug time.

Given that, wouldn't it make sense for the mod_timer_pinned() block
comment to say that?

							Thanx, Paul

------------------------------------------------------------------------

timer: Fix mod_timer_pinned() header comment

The mod_timer_pinned() header comment states that it prevents timers
from being migrated to a different CPU.  This is not the case, instead,
it ensures that the timer is posted to the current CPU, but does nothing
to prevent CPU-hotplug operations from migrating the timer.

This commit therefore brings the comment header into alignment with
reality.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..7114336 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -861,7 +861,12 @@ EXPORT_SYMBOL(mod_timer);
  *
  * mod_timer_pinned() is a way to update the expire field of an
  * active timer (if the timer is inactive it will be activated)
- * and not allow the timer to be migrated to a different CPU.
+ * and to ensure that the timer is scheduled on the current CPU.
+ * Note that this does not prevent the timer from being migrated
+ * when the current CPU goes offline.  If this is a problem for
+ * you, use CPU-hotplug notifiers to handle it correctly, for
+ * example, cancelling the timer when the corresponding CPU goes
+ * offline.
  *
  * mod_timer_pinned(timer, expires) is equivalent to:
  *

