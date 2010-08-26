Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0HZTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:09:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47512 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536Ab0HZTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:09:21 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org
Subject: [PATCH 1/4] oprofile: Handle initialisation failure more gracefully
Date: Thu, 26 Aug 2010 20:09:16 +0100
Message-Id: <442a16796990290ca3ebaaa3d0ab317e7b0a30a5.1282848651.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1282848651.git.matt@console-pimps.org>
References: <cover.1282848651.git.matt@console-pimps.org>
In-Reply-To: <cover.1282848651.git.matt@console-pimps.org>
References: <cover.1282848651.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

The current implementation is not entirely safe in the case that
oprofile_arch_init() fails. We need to make sure that we always call
exit_driverfs() if we've called init_driverfs(). Also, avoid a potential
double free when freeing 'counter_config', e.g. don't free
'counter_config' in both oprofile_arch_init() and oprofile_arch_exit().

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/oprofile/common.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..482779c 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -275,10 +275,12 @@ out:
 	return ret;
 }
 
-static void  exit_driverfs(void)
+static void exit_driverfs(void)
 {
-	platform_device_unregister(oprofile_pdev);
-	platform_driver_unregister(&oprofile_driver);
+	if (!IS_ERR_OR_NULL(oprofile_pdev)) {
+		platform_device_unregister(oprofile_pdev);
+		platform_driver_unregister(&oprofile_driver);
+	}
 }
 #else
 static int __init init_driverfs(void) { return 0; }
@@ -363,10 +365,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	}
 
 	ret = init_driverfs();
-	if (ret) {
-		kfree(counter_config);
+	if (ret)
 		return ret;
-	}
 
 	for_each_possible_cpu(cpu) {
 		perf_events[cpu] = kcalloc(perf_num_counters,
@@ -401,8 +401,9 @@ void oprofile_arch_exit(void)
 	int cpu, id;
 	struct perf_event *event;
 
+	exit_driverfs();
+
 	if (*perf_events) {
-		exit_driverfs();
 		for_each_possible_cpu(cpu) {
 			for (id = 0; id < perf_num_counters; ++id) {
 				event = perf_events[cpu][id];
-- 
1.7.1

