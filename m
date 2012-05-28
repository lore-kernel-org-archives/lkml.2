Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2E1DjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:39:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52126 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab2E1D3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:42 -0400
Message-Id: <20120528031211.437412364@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [ 062/117] perf/x86: Update event scheduling constraints for AMD family 15h
 models
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit 5bcdf5e4fee3c45e1281c25e4941f2163cb28c65 upstream.

This update is for newer family 15h cpu models from 0x02 to 0x1f.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1337337642-1621-1-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   11 ++++++++++-
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


