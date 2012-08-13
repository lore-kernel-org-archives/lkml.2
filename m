Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2HMRNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:13:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2HMRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:13:34 -0400
Date: Mon, 13 Aug 2012 10:13:17 -0700
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-26a4f3c08de49c1437a7b7f97693cf22d8c31656@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <20120809085234.GI3341@redhat.com>
References: <20120809085234.GI3341@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: disable PEBS on a guest entry.
Git-Commit-ID: 26a4f3c08de49c1437a7b7f97693cf22d8c31656
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 10:13:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26a4f3c08de49c1437a7b7f97693cf22d8c31656
Gitweb:     http://git.kernel.org/tip/26a4f3c08de49c1437a7b7f97693cf22d8c31656
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Thu, 9 Aug 2012 11:52:34 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 19:01:04 +0200

perf/x86: disable PEBS on a guest entry.

If PMU counter has PEBS enabled it is not enough to disable counter
on a guest entry since PEBS memory write can overshoot guest entry
and corrupt guest memory. Disabling PEBS during guest entry solves
the problem.

Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120809085234.GI3341@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3823669..7f2739e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1522,8 +1522,16 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
+	/*
+	 * If PMU counter has PEBS enabled it is not enough to disable counter
+	 * on a guest entry since PEBS memory write can overshoot guest entry
+	 * and corrupt guest memory. Disabling PEBS solves the problem.
+	 */
+	arr[1].msr = MSR_IA32_PEBS_ENABLE;
+	arr[1].host = cpuc->pebs_enabled;
+	arr[1].guest = 0;
 
-	*nr = 1;
+	*nr = 2;
 	return arr;
 }
 
