Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1DFWbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:31:01 -0400
Received: from mail.digium.com ([216.207.245.2]:39046 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab1DFWa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:30:59 -0400
Date: Wed, 6 Apr 2011 17:30:36 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper
	MSR register to catch" and NMIs
Message-ID: <20110406223036.GA15721@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Don,

With 2.6.39-rc2 I was seeing the following NMIs when building the kernel:

[  191.647131] Uhhuh. NMI received for unknown reason 21 on CPU 3.
[  191.650068] Do you have a strange power saving mode enabled?
[  191.650068] Dazed and confused, but trying to continue
[  676.020001] Uhhuh. NMI received for unknown reason 21 on CPU 1.
[  676.020001] Do you have a strange power saving mode enabled?
[  676.020001] Dazed and confused, but trying to continue
[  892.520335] Starting new kernel

I'm running on a Dell PowerEdge 2600 with the following processor:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 3.06GHz
stepping        : 7
...

I was able to bisect it down to commit 242214f9c1eeaae40, but I'm not
certain where to go from here.  Is this something that is already known
or is there more information I should try to collect? 

Here is the commit for reference:

commit 242214f9c1eeaae40eca11e3b4d37bfce960a7cd
Author: Don Zickus <dzickus@redhat.com>
Date:   Thu Mar 24 23:36:25 2011 +0300

    perf, x86: P4 PMU - Read proper MSR register to catch unflagged overflows
    
    The read of a proper MSR register was missed and instead of
    counter the configration register was tested (it has
    ARCH_P4_UNFLAGGED_BIT always cleared) leading to unknown NMI
    hitting the system. As result the user may obtain "Dazed and
    confused, but trying to continue" message. Fix it by reading a
    proper MSR register.
    
    When an NMI happens on a P4, the perf nmi handler checks the
    configuration register to see if the overflow bit is set or not
    before taking appropriate action.  Unfortunately, various P4
    machines had a broken overflow bit, so a backup mechanism was
    implemented.  This mechanism checked to see if the counter
    rolled over or not.
    
    A previous commit that implemented this backup mechanism was
    broken. Instead of reading the counter register, it used the
    configuration register to determine if the counter rolled over
    or not. Reading that bit would give incorrect results.
    
    This would lead to 'Dazed and confused' messages for the end
    user when using the perf tool (or if the nmi watchdog is
    running).
    
    The fix is to read the counter register before determining if
    the counter rolled over or not.
    
    Signed-off-by: Don Zickus <dzickus@redhat.com>
    Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
    Cc: Lin Ming <ming.m.lin@intel.com>
    LKML-Reference: <4D8BAB49.3080701@openvz.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3769ac8..d3d7b59 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -777,6 +777,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 	 * the counter has reached zero value and continued counting before
 	 * real NMI signal was received:
 	 */
+	rdmsrl(hwc->event_base, v);
 	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;

