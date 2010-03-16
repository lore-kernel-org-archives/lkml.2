Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966124Ab0CPKer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:34:47 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:53492 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0CPKeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:34:46 -0400
X-IronPort-AV: E=Sophos;i="4.49,649,1262581200"; 
   d="scan'208";a="14130921"
Subject: [PATCH] Timekeeping: Fix dead lock in update_wall_time by correct
	shift convertion.
From: sonic zhang <sonic.adi@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 16 Mar 2010 18:43:45 +0800
Message-ID: <1268736225.5075.10.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_wall_time() runs into dead lock after kernel traps into kgdb and exits
per user's request some seconds layer. This is root caused to be wrong
calculation of maxshift in update_wall_time().

The shift in update_wall_time() and logarithmic_accumulation() is
clock shift. In order to generate ntp_error and maxshift correctly,
shift convertion between clock and ntp should be done properly.


Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 kernel/time/timekeeping.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1673637..5b47c9e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -770,10 +770,14 @@ static cycle_t logarithmic_accumulation(cycle_t
offset, int shift)
                raw_time.tv_sec++;
        }
 
-       /* Accumulate error between NTP and clock interval */
-       timekeeper.ntp_error += tick_length << shift;
-       timekeeper.ntp_error -= timekeeper.xtime_interval <<
-                               (timekeeper.ntp_error_shift + shift);
+       /*
+        * Accumulate error between NTP and clock interval.
+        * Paramter shift is clock shift. It should minus shift
+        * conversion between clock and ntp to generate ntp shift.
+        */
+       timekeeper.ntp_error += tick_length <<
+                               (shift - timekeeper.ntp_error_shift);
+       timekeeper.ntp_error -= timekeeper.xtime_interval << shift;
 
        return offset;
 }
@@ -813,8 +817,12 @@ void update_wall_time(void)
         */
        shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
        shift = max(0, shift);
-       /* Bound shift to one less then what overflows tick_length */
-       maxshift = (8*sizeof(tick_length) - (ilog2(tick_length)+1)) - 1;
+       /*
+        * Bound shift to one less then what overflows tick_length.
+        * Should plus shift conversion between clock and ntp.
+        */
+       maxshift = (8*sizeof(tick_length) - (ilog2(tick_length)+1)) - 1
+                       + timekeeper.ntp_error_shift;
        shift = min(shift, maxshift);
        while (offset >= timekeeper.cycle_interval) {
                offset = logarithmic_accumulation(offset, shift);
-- 
1.6.0




