Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab2BPEso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:48:44 -0500
Received: from ozlabs.org ([203.10.76.45]:38860 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab2BPEsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:48:42 -0500
Date: Thu, 16 Feb 2012 15:48:22 +1100
From: Anton Blanchard <anton@samba.org>
To: eranian@google.com, paulus@samba.org, peterz@infradead.org, mingo@elte.hu,
        gleb@redhat.com, wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org, emunson@mgebm.net, imunsie@au1.ibm.com,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: perf: power_pmu_start restores incorrect values,
 breaking frequency events
Message-ID: <20120216154822.5bfad11d@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf on POWER stopped working after commit e050e3f0a71b (perf: Fix
broken interrupt rate throttling). That patch exposed a bug in
the POWER perf_events code.

Since the PMCs count upwards and take an exception when the top bit
is set, we want to write 0x80000000 - left in power_pmu_start. We were
instead programming in left which effectively disables the counter
until we eventually hit 0x80000000. This could take seconds or longer.

With the patch applied I get the expected number of samples:

# taskset -c 0 yes > /dev/null &
# perf record -C 0 -a sleep 10
# perf report -D | grep SAMPLE | tail -1
          SAMPLE events:       9948

Signed-off-by: Anton Blanchard <anton@samba.org>
---
Cc: <stable@kernel.org>

Index: linux-build/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-build.orig/arch/powerpc/kernel/perf_event.c	2012-02-16 15:07:57.465384699 +1100
+++ linux-build/arch/powerpc/kernel/perf_event.c	2012-02-16 15:11:48.449579581 +1100
@@ -865,6 +865,7 @@ static void power_pmu_start(struct perf_
 {
 	unsigned long flags;
 	s64 left;
+	unsigned long val;
 
 	if (!event->hw.idx || !event->hw.sample_period)
 		return;
@@ -880,7 +881,12 @@ static void power_pmu_start(struct perf_
 
 	event->hw.state = 0;
 	left = local64_read(&event->hw.period_left);
-	write_pmc(event->hw.idx, left);
+
+	val = 0;
+	if (left < 0x80000000L)
+		val = 0x80000000L - left;
+
+	write_pmc(event->hw.idx, val);
 
 	perf_event_update_userpage(event);
 	perf_pmu_enable(event->pmu);
