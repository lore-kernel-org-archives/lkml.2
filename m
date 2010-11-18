Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0KRKsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:48:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42116 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab0KRKrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:47:48 -0500
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: eranian@google.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] x86: set cpu masks before calling CPU_STARTING notifiers
Date: Thu, 18 Nov 2010 11:47:31 +0100
Message-Id: <1290077254-12165-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When booting up a CPU set the various topology masks before
calling the CPU_STARTING notifier. This way the notifier
can actually use the masks.

This is needed for a perf change.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/smpboot.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 083e99d..9d2980e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -281,6 +281,10 @@ static void __cpuinit smp_callin(void)
 	 */
 	smp_store_cpu_info(cpuid);
 
+	/* This must be done before setting cpu_online_mask */
+	set_cpu_sibling_map(raw_smp_processor_id());
+	wmb();
+
 	notify_cpu_starting(cpuid);
 
 	/*
@@ -322,10 +326,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 		legacy_pic->unmask(0);
 	}
 
-	/* This must be done before setting cpu_online_mask */
-	set_cpu_sibling_map(raw_smp_processor_id());
-	wmb();
-
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
-- 
1.7.1

