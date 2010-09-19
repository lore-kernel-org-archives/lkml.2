Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0ISCGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 22:06:18 -0400
Received: from mx1.orcon.net.nz ([219.88.242.51]:34063 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab0ISCGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 22:06:17 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: mattst88@gmail.com
Cc: Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, mingo@redhat.com,
        a.p.zijlstra@chello.nl, linux-alpha@vger.kernel.org
Subject: [PATCH] alpha: Shift perf event pending work earlier in timer interrupt
Date: Sun, 19 Sep 2010 14:05:40 +1200
Message-Id: <1284861940-6571-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.1
X-DSPAM-Check: by mx1.orcon.net.nz on Sun, 19 Sep 2010 14:06:17 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Sep 19 14:06:17 2010
X-DSPAM-Confidence: 0.7625
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pending work from the performance event subsystem is executed in
the timer interrupt.  This patch shifts the call to
perf_event_do_pending() before the call to update_process_times()
as the latter may call back into the perf event subsystem and it
is prudent to have the pending work executed first.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/kernel/time.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index eacceb2..396af17 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -191,16 +191,16 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 
 	write_sequnlock(&xtime_lock);
 
-#ifndef CONFIG_SMP
-	while (nticks--)
-		update_process_times(user_mode(get_irq_regs()));
-#endif
-
 	if (test_perf_event_pending()) {
 		clear_perf_event_pending();
 		perf_event_do_pending();
 	}
 
+#ifndef CONFIG_SMP
+	while (nticks--)
+		update_process_times(user_mode(get_irq_regs()));
+#endif
+
 	return IRQ_HANDLED;
 }
 
-- 
1.7.1

