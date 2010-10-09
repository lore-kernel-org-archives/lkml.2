Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab0JIAsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:48:04 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44534 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760027Ab0JIAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:46:26 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3/7] oprofile: Make op_name_from_perf_id() global
Date: Sat,  9 Oct 2010 01:46:18 +0100
Message-Id: <7b803da1bb48b15e29c966ff925cfb21f9015e6c.1286584677.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make op_name_from_perf_id() global so that we have a way for each
architecture to construct an oprofile name for op->cpu_type. We need to
remove the argument from the function prototype so that we can hide all
implementation details inside the function.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 arch/arm/oprofile/common.c |    6 ++++--
 include/linux/oprofile.h   |    4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 1e971a7..4f67cfa 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -155,8 +155,10 @@ static void op_perf_stop(void)
 }
 
 
-static char *op_name_from_perf_id(enum arm_perf_pmu_ids id)
+char *op_name_from_perf_id(void)
 {
+	enum arm_perf_pmu_ids id = armpmu_get_pmu_id();
+
 	switch (id) {
 	case ARM_PERF_PMU_ID_XSCALE1:
 		return "arm/xscale1";
@@ -391,7 +393,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	ops->start		= op_arm_start;
 	ops->stop		= op_arm_stop;
 	ops->shutdown		= op_arm_stop;
-	ops->cpu_type		= op_name_from_perf_id(armpmu_get_pmu_id());
+	ops->cpu_type		= op_name_from_perf_id();
 
 	if (!ops->cpu_type)
 		ret = -ENODEV;
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 5171639..1574d4a 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -185,4 +185,8 @@ int oprofile_add_data(struct op_entry *entry, unsigned long val);
 int oprofile_add_data64(struct op_entry *entry, u64 val);
 int oprofile_write_commit(struct op_entry *entry);
 
+#ifdef CONFIG_PERF_EVENTS
+char *op_name_from_perf_id(void);
+#endif /* CONFIG_PERF_EVENTS */
+
 #endif /* OPROFILE_H */
-- 
1.7.1

