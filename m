Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0ERVYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:24:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59069 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0ERVYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=dMVl9kC6DkmcbWAK17zUH9TEtOMp6EZGdVLLgc6zjnCpM1kDDi7V75yWQJANUhRYtu
         DX6x3+Fmh5jPEJVr+SJGfLDP2A+fNMsRofksPHJ53zBCmgz844MRX63cGMccEmVv1pRG
         ypq3vvXpGlp8qi83hRfThl3dK578tIbewv8ts=
Message-Id: <20100518212439.004503600@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 19 May 2010 01:19:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 1/4] x86,perf: P4 PMU -- do a real check for ESCR address being in hash
References: <20100518211916.407689068@openvz.org>
Content-Disposition: inline; filename=x86-perf-p4-escr-check-hash
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent from clashes in future code modifications do a real
check for ESCR address being in hash. At moment the callers
are known to pass sane values but better to be on a safe side.

And comment fix.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -670,7 +670,7 @@ static void p4_pmu_swap_config_ts(struct
 
 /*
  * ESCR address hashing is tricky, ESCRs are not sequential
- * in memory but all starts from MSR_P4_BSU_ESCR0 (0x03e0) and
+ * in memory but all starts from MSR_P4_BSU_ESCR0 (0x03a0) and
  * the metric between any ESCRs is laid in range [0xa0,0xe1]
  *
  * so we make ~70% filled hashtable
@@ -735,8 +735,9 @@ static int p4_get_escr_idx(unsigned int 
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

