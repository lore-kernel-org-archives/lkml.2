Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2ESKaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:30:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526Ab2ESK3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:29:44 -0400
Date: Sat, 19 May 2012 03:29:17 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-5bcdf5e4fee3c45e1281c25e4941f2163cb28c65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1337337642-1621-1-git-send-email-robert.richter@amd.com>
References: <1337337642-1621-1-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Update event scheduling constraints for AMD family 15h models
Git-Commit-ID: 5bcdf5e4fee3c45e1281c25e4941f2163cb28c65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 19 May 2012 03:29:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bcdf5e4fee3c45e1281c25e4941f2163cb28c65
Gitweb:     http://git.kernel.org/tip/5bcdf5e4fee3c45e1281c25e4941f2163cb28c65
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Fri, 18 May 2012 12:40:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 14:07:46 +0200

perf/x86: Update event scheduling constraints for AMD family 15h models

This update is for newer family 15h cpu models from 0x02 to 0x1f.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: stable@vger.kernel.org # v2.6.39+
Link: http://lkml.kernel.org/r/1337337642-1621-1-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

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
