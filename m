Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab2DZSqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:46:55 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39337 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2DZSqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:53 -0400
Date: Thu, 26 Apr 2012 11:36:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH] timer: Fix mod_timer_pinned() header commen (was: [PATCH
 RFC tip/core/rcu 4/4] rcu: Ensure that RCU_FAST_NO_HZ timers expire on
 correct CPU)
Message-ID: <20120426183651.GH2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423161539.GA6467@linux.vnet.ibm.com>
 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335197761-6577-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335445496.13683.21.camel@twins>
 <20120426155450.GD2407@linux.vnet.ibm.com>
 <1335456539.28106.185.camel@gandalf.stny.rr.com>
 <20120426175608.GG2407@linux.vnet.ibm.com>
 <1335463819.28106.187.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335463819.28106.187.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042618-7408-0000-0000-00000487C029
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 02:10:19PM -0400, Steven Rostedt wrote:
> 
> > ------------------------------------------------------------------------
> > 
> > timer: Fix mod_timer_pinned() header comment
> > 
> > The mod_timer_pinned() header comment states that it prevents timers
> > from being migrated to a different CPU.  This is not the case, instead,
> > it ensures that the timer is posted to the current CPU, but does nothing
> > to prevent CPU-hotplug operations from migrating the timer.
> > 
> > This commit therefore brings the comment header into alignment with
> > reality.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I'm seeing double :-)

"Bartender, give me a double!"

> > diff --git a/kernel/timer.c b/kernel/timer.c
> > index a297ffc..7114336 100644
> > --- a/kernel/timer.c
> > +++ b/kernel/timer.c
> > @@ -861,7 +861,12 @@ EXPORT_SYMBOL(mod_timer);
> >   *
> >   * mod_timer_pinned() is a way to update the expire field of an
> >   * active timer (if the timer is inactive it will be activated)
> > - * and not allow the timer to be migrated to a different CPU.
> > + * and to ensure that the timer is scheduled on the current CPU.
> 
> Add space here.
> 
>   + *

Good point, done!

> > + * Note that this does not prevent the timer from being migrated
> > + * when the current CPU goes offline.  If this is a problem for
> > + * you, use CPU-hotplug notifiers to handle it correctly, for
> > + * example, cancelling the timer when the corresponding CPU goes
> > + * offline.
> >   *
> >   * mod_timer_pinned(timer, expires) is equivalent to:
> >   *
> 
> Adding a space will make the "Note" stand out more, and more likely seen
> by people who use this function.
> 
> Other than that:
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Got it, thank you!

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
Acked-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..837c552 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -861,7 +861,13 @@ EXPORT_SYMBOL(mod_timer);
  *
  * mod_timer_pinned() is a way to update the expire field of an
  * active timer (if the timer is inactive it will be activated)
- * and not allow the timer to be migrated to a different CPU.
+ * and to ensure that the timer is scheduled on the current CPU.
+ *
+ * Note that this does not prevent the timer from being migrated
+ * when the current CPU goes offline.  If this is a problem for
+ * you, use CPU-hotplug notifiers to handle it correctly, for
+ * example, cancelling the timer when the corresponding CPU goes
+ * offline.
  *
  * mod_timer_pinned(timer, expires) is equivalent to:
  *

