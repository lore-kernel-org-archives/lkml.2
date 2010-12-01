Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0LAICZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:02:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:29654 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0LAICY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:02:24 -0500
Message-ID: <4CF60095.1020900@kernel.org>
Date: Wed, 01 Dec 2010 00:00:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: perf hw  in kexeced kernel broken in tip
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First kernel:
[    1.139418] calling  init_hw_perf_events+0x0/0xb77 @ 1
[    1.159111] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU
driver.
[    1.159567] ... version:                3
[    1.179121] ... bit width:              48
[    1.179353] ... generic registers:      4
[    1.179593] ... value mask:             0000ffffffffffff
[    1.199211] ... max period:             000000007fffffff
[    1.199554] ... fixed-purpose events:   3
[    1.219108] ... event mask:             000000070000000f
[    1.219454] initcall init_hw_perf_events+0x0/0xb77 returned 0 after
11719 usecs

.....
[   20.220997] checking TSC synchronization [CPU#0 -> CPU#11]: passed.
[   20.260818] NMI watchdog enabled, takes one hw-pmu counter.

kexeced kernel.


[    1.169470] calling  init_hw_perf_events+0x0/0xb77 @ 1
[    1.189265] Performance Events: PEBS fmt1+, Nehalem events, Broken
PMU hardware detected, software events only.
...
[   21.010407] NMI watchdog failed to create perf event on cpu14:
fffffffffffffffe

caused by:

commit 33c6d6a7ad0ffab9b1b15f8e4107a2af072a05a0
Author: Don Zickus <dzickus@redhat.com>
Date:   Mon Nov 22 16:55:23 2010 -0500

    x86, perf, nmi: Disable perf if counters are not accessible
   
    In a kvm virt guests, the perf counters are not emulated.  Instead they
    return zero on a rdmsrl. The perf nmi handler uses the fact that
crossing
    a zero means the counter overflowed (for those counters that do not have
    specific interrupt bits). Therefore on kvm guests, perf will swallow all
    NMIs thinking the counters overflowed.
   
    This causes problems for subsystems like kgdb which needs NMIs to do its
    magic. This problem was discovered by running kgdb tests.
   
    The solution is to write garbage into a perf counter during the
    initialization and hopefully reading back the same number.  On kvm
    guests, the value will be read back as zero and we disable perf as
    a result.
   
    Reported-by: Jason Wessel <jason.wessel@windriver.com>
    Patch-inspired-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Don Zickus <dzickus@redhat.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Stephane Eranian <eranian@google.com>
    LKML-Reference: <1290462923-30734-1-git-send-email-dzickus@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/cpu/perf_event.c
b/arch/x86/kernel/cpu/perf_event.c
index ed63101..6d75b91 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -381,6 +381,20 @@ static void release_pmc_hardware(void) {}
 
 #endif
 
+static bool check_hw_exists(void)
+{
+       u64 val, val_new = 0;
+       int ret = 0;
+
+       val = 0xabcdUL;
+       ret |= checking_wrmsrl(x86_pmu.perfctr, val);
+       ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
+       if (ret || val != val_new)
+               return false;
+
+       return true;
+}
+
 static void reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
@@ -1372,6 +1386,12 @@ void __init init_hw_perf_events(void)
 
        pmu_check_apic();
 
+       /* sanity check that the hardware exists or is emulated */
+       if (!check_hw_exists()) {
+               pr_cont("Broken PMU hardware detected, software events
only.\n");
+               return;
+       }
+
        pr_cont("%s PMU driver.\n", x86_pmu.name);
 
        if (x86_pmu.quirks)


