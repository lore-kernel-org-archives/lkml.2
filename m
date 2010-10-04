Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab0JDUpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:45:44 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46786 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757175Ab0JDUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:44:30 -0400
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
Subject: [PATCH 4/7] ARM: oprofile: Move non-ARM code into separate init/exit
Date: Mon,  4 Oct 2010 21:44:22 +0100
Message-Id: <74092b0d162aafc21e408033cec6146e227363b5.1286222593.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1286222593.git.matt@console-pimps.org>
References: <cover.1286222593.git.matt@console-pimps.org>
In-Reply-To: <cover.1286222593.git.matt@console-pimps.org>
References: <cover.1286222593.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving the majority of this oprofile code into an
architecture-neutral place separate the architecture-independent code
into oprofile_perf_init() and oprofile_perf_exit().

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Tested-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/oprofile/common.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 86df75f..e4cd332 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -327,7 +327,7 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 		tail = user_backtrace(tail);
 }
 
-int __init oprofile_arch_init(struct oprofile_operations *ops)
+int __init oprofile_perf_init(struct oprofile_operations *ops)
 {
 	int cpu, ret = 0;
 
@@ -365,7 +365,6 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 		}
 	}
 
-	ops->backtrace		= arm_backtrace;
 	ops->create_files	= oprofile_perf_create_files;
 	ops->setup		= oprofile_perf_setup;
 	ops->start		= oprofile_perf_start;
@@ -388,7 +387,14 @@ out:
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
@@ -406,6 +412,11 @@ void __exit oprofile_arch_exit(void)
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

