Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1DSMEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:04:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:44957 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab1DSMEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:04:44 -0400
Date: Tue, 19 Apr 2011 12:04:25 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-855357a21744e488cbee23a47d2b124035160a87@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eranian@googlemail.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1302913676-14352-3-git-send-email-robert.richter@amd.com>
References: <1302913676-14352-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix AMD family 15h FPU event constraints
Git-Commit-ID: 855357a21744e488cbee23a47d2b124035160a87
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 12:04:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  855357a21744e488cbee23a47d2b124035160a87
Gitweb:     http://git.kernel.org/tip/855357a21744e488cbee23a47d2b124035160a87
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Sat, 16 Apr 2011 02:27:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 Apr 2011 10:07:55 +0200

perf, x86: Fix AMD family 15h FPU event constraints

Depending on the unit mask settings some FPU events may be scheduled
only on cpu counter #3. This patch fixes this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@googlemail.com>
Link: http://lkml.kernel.org/r/1302913676-14352-3-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 4e16138..cf4e369 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -427,7 +427,9 @@ static __initconst const struct x86_pmu amd_pmu = {
  *
  * Exceptions:
  *
+ * 0x000	FP	PERF_CTL[3], PERF_CTL[5:3] (*)
  * 0x003	FP	PERF_CTL[3]
+ * 0x004	FP	PERF_CTL[3], PERF_CTL[5:3] (*)
  * 0x00B	FP	PERF_CTL[3]
  * 0x00D	FP	PERF_CTL[3]
  * 0x023	DE	PERF_CTL[2:0]
@@ -448,6 +450,8 @@ static __initconst const struct x86_pmu amd_pmu = {
  * 0x0DF	LS	PERF_CTL[5:0]
  * 0x1D6	EX	PERF_CTL[5:0]
  * 0x1D8	EX	PERF_CTL[5:0]
+ *
+ * (*) depending on the umask all FPU counters may be used
  */
 
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
@@ -460,18 +464,28 @@ static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 static struct event_constraint *
 amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	unsigned int event_code = amd_get_event_code(&event->hw);
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned int event_code = amd_get_event_code(hwc);
 
 	switch (event_code & AMD_EVENT_TYPE_MASK) {
 	case AMD_EVENT_FP:
 		switch (event_code) {
+		case 0x000:
+			if (!(hwc->config & 0x0000F000ULL))
+				break;
+			if (!(hwc->config & 0x00000F00ULL))
+				break;
+			return &amd_f15_PMC3;
+		case 0x004:
+			if (hweight_long(hwc->config & ARCH_PERFMON_EVENTSEL_UMASK) <= 1)
+				break;
+			return &amd_f15_PMC3;
 		case 0x003:
 		case 0x00B:
 		case 0x00D:
 			return &amd_f15_PMC3;
-		default:
-			return &amd_f15_PMC53;
 		}
+		return &amd_f15_PMC53;
 	case AMD_EVENT_LS:
 	case AMD_EVENT_DC:
 	case AMD_EVENT_EX_LS:
