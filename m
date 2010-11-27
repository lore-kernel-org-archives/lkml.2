Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0K0UPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 15:15:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:33811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0K0UPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 15:15:11 -0500
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: tmhikaru@gmail.com, Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <1290693807.2145.36.camel@laptop>
References: <1287788622-25860-1-git-send-email-venki@google.com>
	 <1288001573.15336.52.camel@twins> <1288097074.15336.211.camel@twins>
	 <1288101958.15336.284.camel@twins> <1288381343.1988.12.camel@laptop>
	 <20101109185516.GQ8332@bombadil.infradead.org>
	 <1289329348.2191.69.camel@laptop>
	 <20101110034507.GV8332@bombadil.infradead.org>
	 <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll>
	 <20101125133106.GA12914@brouette>  <1290693807.2145.36.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 27 Nov 2010 21:15:20 +0100
Message-ID: <1290888920.32004.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 15:03 +0100, Peter Zijlstra wrote:

> I'll try and get around to it somewhere this week again.

How does this work for you? Its hideous but lets start simple.

---
 kernel/sched.c |    5 +++++
 kernel/timer.c |   14 ++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..2ebb07c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3223,6 +3223,11 @@ static void calc_load_account_active(struct rq *this_rq)
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
diff --git a/kernel/timer.c b/kernel/timer.c
index 68a9ae7..af095c0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1315,11 +1315,21 @@ void run_local_timers(void)
  * jiffies is defined in the linker script...
  */
 
+extern void calc_load_account_this(void);
+
 void do_timer(unsigned long ticks)
 {
-	jiffies_64 += ticks;
+	if (ticks > 1) {
+		while (ticks--) {
+			jiffies_64++;
+			calc_load_account_this();
+			calc_global_load();
+		}
+	} else {
+		jiffies_64 += ticks;
+		calc_global_load();
+	}
 	update_wall_time();
-	calc_global_load();
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM

