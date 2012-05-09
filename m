Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab2EII04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab2EII0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:26:53 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, imammedo@redhat.com, a.p.zijlstra@chello.nl,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: [PATCH 3/5] Do not wait till next cpu online and abort early if lead cpu do not wait for us anymore
Date: Wed,  9 May 2012 12:25:00 +0200
Message-Id: <1336559102-28103-4-git-send-email-imammedo@redhat.com>
In-Reply-To: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu_callout_mask for checking if boot cpu is still waiting on us

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/tsc_sync.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 5f06138..1741385 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -188,10 +188,13 @@ void __cpuinit check_tsc_sync_target(void)
 	/*
 	 * Wait for the source CPU to start the measurement
 	 */
-	while (!atomic_read(&start_tsc_sync))
+	while (!atomic_read(&start_tsc_sync)) {
+		if (!cpumask_test_cpu(smp_processor_id(), cpu_callout_mask))
+			return;
 		cpu_relax();
+	}
 
-	if (!cpumask_test_cpu(smp_processor_id(), cpu_initialized_mask))
+	if (!cpumask_test_cpu(smp_processor_id(), cpu_callout_mask))
 		return;
 
 	atomic_set(&start_tsc_sync, 0);
-- 
1.7.1

