Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab0JIArb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:47:31 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44547 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760041Ab0JIAq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:46:28 -0400
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
Subject: [PATCH 5/7] ARM: oprofile: Move non-ARM code into separate init/exit
Date: Sat,  9 Oct 2010 01:46:20 +0100
Message-Id: <0de9eda11dbfe9c21348da07b57f04f35cd9effc.1286584677.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
In-Reply-To: <cover.1286584677.git.matt@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving the majority of this oprofile code into an
architecture-neutral place separate the architecture-independent code
into oprofile_perf_init() and oprofile_perf_exit().

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Tested-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/oprofile/common.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index fd6e323..8718311 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -349,7 +349,7 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 		tail = user_backtrace(tail);
 }
 
-int __init oprofile_arch_init(struct oprofile_operations *ops)
+int __init oprofile_perf_init(struct oprofile_operations *ops)
 {
 	int cpu, ret = 0;
 
@@ -387,12 +387,11 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 		}
 	}
 
-	ops->backtrace		= arm_backtrace;
-	ops->create_files	= op_arm_create_files;
-	ops->setup		= op_arm_setup;
-	ops->start		= op_arm_start;
-	ops->stop		= op_arm_stop;
-	ops->shutdown		= op_arm_stop;
+	ops->create_files	= oprofile_perf_create_files;
+	ops->setup		= oprofile_perf_setup;
+	ops->start		= oprofile_perf_start;
+	ops->stop		= oprofile_perf_stop;
+	ops->shutdown		= oprofile_perf_stop;
 	ops->cpu_type		= op_name_from_perf_id();
 
 	if (!ops->cpu_type)
@@ -410,7 +409,14 @@ out:
 	return ret;
 }
 
-void __exit oprofile_arch_exit(void)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	ops->backtrace		= arm_backtrace;
+
+	return oprofile_perf_init(ops);
+}
+
+void __exit oprofile_perf_exit(void)
 {
 	int cpu, id;
 	struct perf_event *event;
@@ -428,6 +434,11 @@ void __exit oprofile_arch_exit(void)
 	kfree(counter_config);
 	exit_driverfs();
 }
+
+void __exit oprofile_arch_exit(void)
+{
+	oprofile_perf_exit();
+}
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
-- 
1.7.1

