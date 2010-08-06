Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684Ab0HFT2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:28:49 -0400
Received: from kroah.org ([198.145.64.141]:43613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965587Ab0HFT2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:14 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:16 2010
Message-Id: <20100806192116.876317276@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:20:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [27/36] xen: drop xen_sched_clock in favour of using plain wallclock time
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 8a22b9996b001c88f2bfb54c6de6a05fc39e177a upstream.

xen_sched_clock only counts unstolen time.  In principle this should
be useful to the Linux scheduler so that it knows how much time a process
actually consumed.  But in practice this doesn't work very well as the
scheduler expects the sched_clock time to be synchronized between
cpus.  It also uses sched_clock to measure the time a task spends
sleeping, in which case "unstolen time" isn't meaningful.

So just use plain xen_clocksource_read to return wallclock nanoseconds
for sched_clock.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/enlighten.c |    2 +-
 arch/x86/xen/time.c      |   39 ---------------------------------------
 2 files changed, 1 insertion(+), 40 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -927,7 +927,7 @@ static const struct pv_init_ops xen_init
 };
 
 static const struct pv_time_ops xen_time_ops __initdata = {
-	.sched_clock = xen_sched_clock,
+	.sched_clock = xen_clocksource_read,
 };
 
 static const struct pv_cpu_ops xen_cpu_ops __initdata = {
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -155,45 +155,6 @@ static void do_stolen_accounting(void)
 	account_idle_ticks(ticks);
 }
 
-/*
- * Xen sched_clock implementation.  Returns the number of unstolen
- * nanoseconds, which is nanoseconds the VCPU spent in RUNNING+BLOCKED
- * states.
- */
-unsigned long long xen_sched_clock(void)
-{
-	struct vcpu_runstate_info state;
-	cycle_t now;
-	u64 ret;
-	s64 offset;
-
-	/*
-	 * Ideally sched_clock should be called on a per-cpu basis
-	 * anyway, so preempt should already be disabled, but that's
-	 * not current practice at the moment.
-	 */
-	preempt_disable();
-
-	now = xen_clocksource_read();
-
-	get_runstate_snapshot(&state);
-
-	WARN_ON(state.state != RUNSTATE_running);
-
-	offset = now - state.state_entry_time;
-	if (offset < 0)
-		offset = 0;
-
-	ret = state.time[RUNSTATE_blocked] +
-		state.time[RUNSTATE_running] +
-		offset;
-
-	preempt_enable();
-
-	return ret;
-}
-
-
 /* Get the TSC speed from Xen */
 unsigned long xen_tsc_khz(void)
 {


