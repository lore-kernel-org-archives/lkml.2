Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab2GFGcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:32:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GFGcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:32:39 -0400
Date: Thu, 5 Jul 2012 23:32:15 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-42089697244ba8e64fa43fb5e6d50d47a8e4cb00@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acooks@gmail.com, zheng.z.yan@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acooks@gmail.com, a.p.zijlstra@chello.nl, zheng.z.yan@intel.com,
        tglx@linutronix.de
In-Reply-To: <1341381616-12229-4-git-send-email-zheng.z.yan@intel.com>
References: <1341381616-12229-4-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Detect number of instances of uncore CBox
Git-Commit-ID: 42089697244ba8e64fa43fb5e6d50d47a8e4cb00
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:32:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42089697244ba8e64fa43fb5e6d50d47a8e4cb00
Gitweb:     http://git.kernel.org/tip/42089697244ba8e64fa43fb5e6d50d47a8e4cb00
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Wed, 4 Jul 2012 14:00:14 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 21:56:00 +0200

perf/x86: Detect number of instances of uncore CBox

The CBox manages the interface between the core and the LLC, so
the instances of uncore CBox is equal to number of cores.

Reported-by: Andrew Cooks <acooks@gmail.com>
Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1341381616-12229-4-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 7d755d2..4fecbd0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1605,8 +1605,9 @@ static void __init uncore_cpu_setup(void *dummy)
 
 static int __init uncore_cpu_init(void)
 {
-	int ret, cpu;
+	int ret, cpu, max_cores;
 
+	max_cores = boot_cpu_data.x86_max_cores;
 	switch (boot_cpu_data.x86_model) {
 	case 26: /* Nehalem */
 	case 30:
@@ -1615,9 +1616,13 @@ static int __init uncore_cpu_init(void)
 		msr_uncores = nhm_msr_uncores;
 		break;
 	case 42: /* Sandy Bridge */
+		if (snb_uncore_cbox.num_boxes > max_cores)
+			snb_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snb_msr_uncores;
 		break;
 	case 45: /* Sandy Birdge-EP */
+		if (snbep_uncore_cbox.num_boxes > max_cores)
+			snbep_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snbep_msr_uncores;
 		break;
 	default:
