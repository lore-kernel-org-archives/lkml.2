Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0K2XBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:01:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:45473 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0K2XBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:01:08 -0500
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: tmhikaru@gmail.com
Cc: Damien Wyart <damien.wyart@free.fr>,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <20101129194041.GA8280@roll>
References: <20101109185516.GQ8332@bombadil.infradead.org>
	 <1289329348.2191.69.camel@laptop>
	 <20101110034507.GV8332@bombadil.infradead.org>
	 <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll>
	 <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop>
	 <1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette>
	 <1291030726.32004.4.camel@laptop>  <20101129194041.GA8280@roll>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 00:01:17 +0100
Message-ID: <1291071677.32004.527.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 14:40 -0500, tmhikaru@gmail.com wrote:
> On Mon, Nov 29, 2010 at 12:38:46PM +0100, Peter Zijlstra wrote:
> > On Sun, 2010-11-28 at 12:40 +0100, Damien Wyart wrote:
> > > Hi,
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> [2010-11-27 21:15]:
> > > > How does this work for you? Its hideous but lets start simple.
> > > > [...]
> > > 
> > > Doesn't give wrong numbers like initial bug and tentative patches, but
> > > feels a bit too slow when numbers go up and down. Correct values are
> > > reached when waiting long enough, but it feels slow.
> > > 
> > > As I've tested many combinations, maybe this is an impression because
> > > I do not remember about "normal" delays for the load to rise and fall,
> > > but this still feels slow.
> > 
> > You can test this by either booting with nohz=off, or builting with
> > CONFIG_NO_HZ=n and then comparing the result, something like
> > 
> > make O=defconfig clean; while sleep 10; do uptime >> load.log; done &
> > make -j32 O=defconfig; kill %1
> > 
> > And comparing the curves between the NO_HZ and !NO_HZ kernels.
> > 
> > I'll try and make the patch less hideous ;-)
> 
> I've tested this patch on my own use case, and it seems to work for the most
> part - it's still not settling as low as the previous implementation used
> to, nor is it settling as low as CONFIG_NO_HZ=N (that is to say, 0.00 across
> the board when not being used) however, this is definitely an improvement:
> 
> 14:26:04 up  9:08,  5 users,  load average: 0.05, 0.01, 0.00
> 
> This is the result of running uptime on a checked out version of
> [74f5187ac873042f502227701ed1727e7c5fbfa9] sched: Cure load average vs NO_HZ woes
> 
> with the patch applied, starting X, and simply letting the machine sit idle
> for nine hours. For the brief period I spent watching it after boot, it
> quickly began settling down to a reasonable value, I only let it sit idle
> this long to verify the loadavg was consistently low. (the loadavg was
> consistently erratic, anywhere from 0.6 to 1.2 with the machine idle without
> this patch)

Ok, that's good testing.. so its still not quite the same as NO_HZ=n,
how about this one?

(it seems to drop down to 0.00 if I wait a few minutes with top -d5)

---
 kernel/sched.c           |    5 +++++
 kernel/time/tick-sched.c |    4 +++-
 kernel/timer.c           |   12 ++++++++++++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 864040c..a859158 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3082,6 +3082,11 @@ static void calc_load_account_active(struct rq *this_rq)
 	this_rq->calc_load_update += LOAD_FREQ;
 }
 
+void calc_load_account_this(void)
+{
+	calc_load_account_active(this_rq());
+}
+
 /*
  * The exact cpuload at various idx values, calculated at every tick would be
  * load = (2^idx - 1) / 2^idx * load + 1 / 2^idx * cur_load
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..1e6d384 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -41,6 +41,8 @@ struct tick_sched *tick_get_tick_sched(int cpu)
 	return &per_cpu(tick_cpu_sched, cpu);
 }
 
+extern void do_timer_nohz(unsigned long ticks);
+
 /*
  * Must be called with interrupts disabled !
  */
@@ -75,7 +77,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 			last_jiffies_update = ktime_add_ns(last_jiffies_update,
 							   incr * ticks);
 		}
-		do_timer(++ticks);
+		do_timer_nohz(++ticks);
 
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
diff --git a/kernel/timer.c b/kernel/timer.c
index d6ccb90..eb2646f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1300,6 +1300,18 @@ void do_timer(unsigned long ticks)
 	calc_global_load();
 }
 
+extern void calc_load_account_this(void);
+
+void do_timer_nohz(unsigned long ticks)
+{
+	while (ticks--) {
+		jiffies_64++;
+		calc_load_account_this();
+		calc_global_load();
+	}
+	update_wall_time();
+}
+
 #ifdef __ARCH_WANT_SYS_ALARM
 
 /*

