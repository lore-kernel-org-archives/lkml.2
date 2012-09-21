Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2IUWHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:07:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51290 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2IUWHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:07:47 -0400
Date: Fri, 21 Sep 2012 15:07:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, "Bruce, Becky" <bbruce@ti.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>, snijsure@grid-net.com
Subject: Re: [PATCH] Documentation: RCU: update the stall warning message
 "timer=-1" to match reality
Message-ID: <20120921220741.GG2454@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1209211610280.30239@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209211610280.30239@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092122-2876-0000-0000-00000061DF20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 04:13:29PM +0000, Paul Walmsley wrote:
> 
> The CONFIG_RCU_FAST_NO_HZ stall warning messages can never emit
> "timer=-1".  This is because the printf() format specifier to generate
> that number is '%lu'.  So, update the documentation to use the
> unsigned long equivalent instead, "timer=4294967295".  This is what
> actually shows up in traces.
> 
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>

Good catch!  Even worse, it gives "timer=18446744073709551615" on
64-bit systems, which is no easier on the eyes.  I therefore changed
the code to print a nicer message in this case, patch below.

The meaning of the "timer=4294967295" was that the corresponding CPU
was either non-idle or idle with no RCU callbacks, FWIW.

							Thanx, Paul

-------------------------------------------------------------------------

rcu: Fix CONFIG_RCU_FAST_NO_HZ stall warning message

The print_cpu_stall_fast_no_hz() function attempts to print -1 when
the ->idle_gp_timer is not pending, but unsigned arithmetic causes it
to instead print ULONG_MAX, which is 4294967295 on 32-bit systems and
18446744073709551615 on 64-bit systems.  Neither of these are the most
reader-friendly values, so this commit instead causes "timer not pending"
to be printed when ->idle_gp_timer is not pending.

Reported-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 523364e..1927151 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -99,7 +99,7 @@ In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
 printed:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer=-1
+	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer not pending
 	   (t=65000 jiffies)
 
 The "(64628 ticks this GP)" indicates that this CPU has taken more
@@ -116,13 +116,13 @@ number between the two "/"s is the value of the nesting, which will
 be a small positive number if in the idle loop and a very large positive
 number (as shown above) otherwise.
 
-For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the
-CPU is not in the process of trying to force itself into dyntick-idle
-state, the "." indicates that the CPU has not given up forcing RCU
-into dyntick-idle mode (it would be "H" otherwise), and the "timer=-1"
-indicates that the CPU has not recented forced RCU into dyntick-idle
-mode (it would otherwise indicate the number of microseconds remaining
-in this forced state).
+For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the CPU is
+not in the process of trying to force itself into dyntick-idle state, the
+"." indicates that the CPU has not given up forcing RCU into dyntick-idle
+mode (it would be "H" otherwise), and the "timer not pending" indicates
+that the CPU has not recently forced RCU into dyntick-idle mode (it
+would otherwise indicate the number of microseconds remaining in this
+forced state).
 
 
 Multiple Warnings From One Stall
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3b1a11e..be822f0 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2245,11 +2245,15 @@ static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 	struct timer_list *tltp = &rdtp->idle_gp_timer;
+	char c;
 
-	sprintf(cp, "drain=%d %c timer=%lu",
-		rdtp->dyntick_drain,
-		rdtp->dyntick_holdoff == jiffies ? 'H' : '.',
-		timer_pending(tltp) ? tltp->expires - jiffies : -1);
+	c = rdtp->dyntick_holdoff == jiffies ? 'H' : '.';
+	if (timer_pending(tltp))
+		sprintf(cp, "drain=%d %c timer=%lu",
+			rdtp->dyntick_drain, c, tltp->expires - jiffies);
+	else
+		sprintf(cp, "drain=%d %c timer not pending",
+			rdtp->dyntick_drain, c);
 }
 
 #else /* #ifdef CONFIG_RCU_FAST_NO_HZ */

