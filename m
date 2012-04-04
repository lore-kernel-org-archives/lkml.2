Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2DDPLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab2DDPLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:11:40 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Salman Qazi <sqazi@google.com>,
        stable@kernel.org
Subject: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
Date: Wed,  4 Apr 2012 11:11:00 -0400
Message-Id: <1333552260-1170-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource code has a watchdog which runs once a minute.  The
clocksource watchdog calculates the number of nanoseconds since the last
time the watchdog ran and compares that value to the number of nanoseconds
that have passed on another clocksource.  If these values do not match (to
within .0625s) then the watchdog marks the current clocksource as unstable
and switches to another clocksource.

This works so long as the delta between calls of the watchdog is small
(maximum delta is ~18 seconds with the tsc).  After that, the
clocksource_cyc2ns() calculation will overflow and the calculated number
of ns returned is incorrect.

This causes the watchdog to erroneously mark the tsc as unstable and
switch to the hpet.

A long delay on the system is not usual, however, it can be reproduced
simply by doing

echo 1 > /proc/sys/kernel/sysrq
for i in `seq 10000`; do sleep 1000 & done
echo t > /proc/sysrq-trigger

on a 32-cpu system (which is not an unusual number of processes for this
size of system).  This floods the printk buffer and results in a
pause of approximately 600 seconds which prevents the clocksource watchdog
from running during that time.  On the next call, the watchdog erroneously
marks the tsc as unstable and switches to the hpet because the checked
values for the tsc overflow.

Fixing this is simple -- use mult_frac() in clocksource_cyc2ns().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Salman Qazi <sqazi@google.com>
Cc: stable@kernel.org
---
 include/linux/clocksource.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index fbe89e1..1625ddb 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -273,7 +273,7 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
  */
 static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 {
-	return ((u64) cycles * mult) >> shift;
+	return mult_frac(cycles, mult, (1UL << shift));
 }
 
 
-- 
1.7.1

