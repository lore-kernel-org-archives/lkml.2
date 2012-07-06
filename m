Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab2GFG2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:28:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GFG2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:28:03 -0400
Date: Thu, 5 Jul 2012 23:27:46 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-f285f92f7e4c9af20149130c8fd5027131b39b0e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1340217996-2254-5-git-send-email-robert.richter@amd.com>
References: <1340217996-2254-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Improve debug output in check_hw_exists(
 )
Git-Commit-ID: f285f92f7e4c9af20149130c8fd5027131b39b0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:27:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f285f92f7e4c9af20149130c8fd5027131b39b0e
Gitweb:     http://git.kernel.org/tip/f285f92f7e4c9af20149130c8fd5027131b39b0e
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 20 Jun 2012 20:46:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 21:19:42 +0200

perf/x86: Improve debug output in check_hw_exists()

It might be of interest which perfctr msr failed.

Signed-off-by: Robert Richter <robert.richter@amd.com>
[ added hunk to avoid GCC warn ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1340217996-2254-5-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7b4f1e8..3eb88eb 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -178,7 +178,7 @@ static void release_pmc_hardware(void) {}
 
 static bool check_hw_exists(void)
 {
-	u64 val, val_new = 0;
+	u64 val, val_new = ~0;
 	int i, reg, ret = 0;
 
 	/*
@@ -211,8 +211,9 @@ static bool check_hw_exists(void)
 	 * that don't trap on the MSR access and always return 0s.
 	 */
 	val = 0xabcdUL;
-	ret = wrmsrl_safe(x86_pmu_event_addr(0), val);
-	ret |= rdmsrl_safe(x86_pmu_event_addr(0), &val_new);
+	reg = x86_pmu_event_addr(0);
+	ret = wrmsrl_safe(reg, val);
+	ret |= rdmsrl_safe(reg, &val_new);
 	if (ret || val != val_new)
 		goto msr_fail;
 
@@ -229,6 +230,7 @@ bios_fail:
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
+	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
 
 	return false;
 }
