Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0ESH5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:57:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:45617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab0ESH5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:57:43 -0400
Date: Wed, 19 May 2010 07:57:03 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, gorcunov@openvz.org, a.p.zijlstra@chello.nl,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100518212439.004503600@openvz.org>
References: <20100518212439.004503600@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: P4 PMU -- do a real check for ESCR address being in hash
Message-ID: <tip-623aab896ee1a532cb540bcf0d5ae8a88275afd5@git.kernel.org>
Git-Commit-ID: 623aab896ee1a532cb540bcf0d5ae8a88275afd5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 07:57:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  623aab896ee1a532cb540bcf0d5ae8a88275afd5
Gitweb:     http://git.kernel.org/tip/623aab896ee1a532cb540bcf0d5ae8a88275afd5
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 19 May 2010 01:19:17 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 May 2010 09:41:05 +0200

perf, x86: P4 PMU -- do a real check for ESCR address being in hash

To prevent from clashes in future code modifications
do a real check for ESCR address being in hash. At
moment the callers are known to pass sane values but
better to be on a safe side.

And comment fix.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100518212439.004503600@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 87e1803..5f8e36d 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -670,7 +670,7 @@ static void p4_pmu_swap_config_ts(struct hw_perf_event *hwc, int cpu)
 
 /*
  * ESCR address hashing is tricky, ESCRs are not sequential
- * in memory but all starts from MSR_P4_BSU_ESCR0 (0x03e0) and
+ * in memory but all starts from MSR_P4_BSU_ESCR0 (0x03a0) and
  * the metric between any ESCRs is laid in range [0xa0,0xe1]
  *
  * so we make ~70% filled hashtable
@@ -735,8 +735,9 @@ static int p4_get_escr_idx(unsigned int addr)
 {
 	unsigned int idx = P4_ESCR_MSR_IDX(addr);
 
-	if (unlikely(idx >= P4_ESCR_MSR_TABLE_SIZE ||
-			!p4_escr_table[idx])) {
+	if (unlikely(idx >= P4_ESCR_MSR_TABLE_SIZE	||
+			!p4_escr_table[idx]		||
+			p4_escr_table[idx] != addr)) {
 		WARN_ONCE(1, "P4 PMU: Wrong address passed: %x\n", addr);
 		return -1;
 	}
