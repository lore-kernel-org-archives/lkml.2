Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab0G3S0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:26:01 -0400
Received: from kroah.org ([198.145.64.141]:58491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759956Ab0G3Rzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:37 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:41 2010
Message-Id: <20100730175140.967667541@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jamie Iles <jamie.iles@picochip.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [081/205] ARM: 6205/1: perf: ensure counter delta is treated as unsigned
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 446a5a8b1eb91a6990e5c8fe29f14e7a95b69132 upstream.

Hardware performance counters on ARM are 32-bits wide but atomic64_t
variables are used to represent counter data in the hw_perf_event structure.

The armpmu_event_update function right-shifts a signed 64-bit delta variable
and adds the result to the event count. This can lead to shifting in sign-bits
if the MSB of the 32-bit counter value is set. This results in perf output
such as:

 Performance counter stats for 'sleep 20':

 18446744073460670464  cycles             <-- 0xFFFFFFFFF12A6000
        7783773  instructions             #      0.000 IPC
            465  context-switches
            161  page-faults
        1172393  branches

   20.154242147  seconds time elapsed

This patch ensures that the delta value is treated as unsigned so that the
right shift sets the upper bits to zero.

Acked-by: Jamie Iles <jamie.iles@picochip.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -165,7 +165,7 @@ armpmu_event_update(struct perf_event *e
 {
 	int shift = 64 - 32;
 	s64 prev_raw_count, new_raw_count;
-	s64 delta;
+	u64 delta;
 
 again:
 	prev_raw_count = atomic64_read(&hwc->prev_count);


