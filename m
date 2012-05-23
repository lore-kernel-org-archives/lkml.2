Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab2EWSvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:51:02 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54237 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2EWSvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:51:00 -0400
Date: Wed, 23 May 2012 20:50:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fix
Message-ID: <20120523185054.GA17700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 5bcdf5e4fee3c45e1281c25e4941f2163cb28c65 perf/x86: Update event scheduling constraints for AMD family 15h models

Leftover AMD PMU driver fix fix from the end of the v3.4 
stabilization cycle.

 Thanks,

	Ingo

------------------>
Robert Richter (1):
      perf/x86: Update event scheduling constraints for AMD family 15h models


 arch/x86/kernel/cpu/perf_event_amd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 95e7fe1..9edc786 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -493,6 +493,7 @@ static __initconst const struct x86_pmu amd_pmu = {
  * 0x023	DE	PERF_CTL[2:0]
  * 0x02D	LS	PERF_CTL[3]
  * 0x02E	LS	PERF_CTL[3,0]
+ * 0x031	LS	PERF_CTL[2:0] (**)
  * 0x043	CU	PERF_CTL[2:0]
  * 0x045	CU	PERF_CTL[2:0]
  * 0x046	CU	PERF_CTL[2:0]
@@ -506,10 +507,12 @@ static __initconst const struct x86_pmu amd_pmu = {
  * 0x0DD	LS	PERF_CTL[5:0]
  * 0x0DE	LS	PERF_CTL[5:0]
  * 0x0DF	LS	PERF_CTL[5:0]
+ * 0x1C0	EX	PERF_CTL[5:3]
  * 0x1D6	EX	PERF_CTL[5:0]
  * 0x1D8	EX	PERF_CTL[5:0]
  *
- * (*) depending on the umask all FPU counters may be used
+ * (*)  depending on the umask all FPU counters may be used
+ * (**) only one unitmask enabled at a time
  */
 
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
@@ -559,6 +562,12 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 			return &amd_f15_PMC3;
 		case 0x02E:
 			return &amd_f15_PMC30;
+		case 0x031:
+			if (hweight_long(hwc->config & ARCH_PERFMON_EVENTSEL_UMASK) <= 1)
+				return &amd_f15_PMC20;
+			return &emptyconstraint;
+		case 0x1C0:
+			return &amd_f15_PMC53;
 		default:
 			return &amd_f15_PMC50;
 		}
