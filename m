Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0KZPFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:05:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:40500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab0KZPFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:05:38 -0500
Date: Fri, 26 Nov 2010 15:05:17 GMT
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1290077254-12165-2-git-send-email-andi@firstfloor.org>
References: <1290077254-12165-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Set cpu masks before calling CPU_STARTING notifiers
Message-ID: <tip-5ef428c4b5950dddce7311e84321abb3aff7ebb0@git.kernel.org>
Git-Commit-ID: 5ef428c4b5950dddce7311e84321abb3aff7ebb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:05:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ef428c4b5950dddce7311e84321abb3aff7ebb0
Gitweb:     http://git.kernel.org/tip/5ef428c4b5950dddce7311e84321abb3aff7ebb0
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 18 Nov 2010 11:47:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:14:56 +0100

x86: Set cpu masks before calling CPU_STARTING notifiers

When booting up a CPU set the various topology masks before
calling the CPU_STARTING notifier. This way the notifier
can actually use the masks.

This is needed for a perf change.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290077254-12165-2-git-send-email-andi@firstfloor.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f0a0624..68f61ac 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -281,6 +281,13 @@ static void __cpuinit smp_callin(void)
 	 */
 	smp_store_cpu_info(cpuid);
 
+	/*
+	 * This must be done before setting cpu_online_mask
+	 * or calling notify_cpu_starting.
+	 */
+	set_cpu_sibling_map(raw_smp_processor_id());
+	wmb();
+
 	notify_cpu_starting(cpuid);
 
 	/*
@@ -316,10 +323,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 */
 	check_tsc_sync_target();
 
-	/* This must be done before setting cpu_online_mask */
-	set_cpu_sibling_map(raw_smp_processor_id());
-	wmb();
-
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
