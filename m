Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab0JDU1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:27:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:39838 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932457Ab0JDU1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:27:12 -0400
Date: Mon, 4 Oct 2010 20:26:55 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100930124156.GF20545@loge.amd.com>
References: <20100930124156.GF20545@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd: Use compute unit information to determine thread siblings
Message-ID: <tip-d4fbe4f03557e1fd4d9bbb3a1957aad560f39e96@git.kernel.org>
Git-Commit-ID: d4fbe4f03557e1fd4d9bbb3a1957aad560f39e96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:26:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4fbe4f03557e1fd4d9bbb3a1957aad560f39e96
Gitweb:     http://git.kernel.org/tip/d4fbe4f03557e1fd4d9bbb3a1957aad560f39e96
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 30 Sep 2010 14:41:56 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 1 Oct 2010 16:18:32 -0700

x86, amd: Use compute unit information to determine thread siblings

This information is vital for different load balancing policies.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100930124156.GF20545@loge.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/smpboot.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8b3bfc4..bc2cc44 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -397,6 +397,19 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
+static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
+{
+	struct cpuinfo_x86 *c1 = &cpu_data(cpu1);
+	struct cpuinfo_x86 *c2 = &cpu_data(cpu2);
+
+	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
+	cpumask_set_cpu(cpu2, cpu_sibling_mask(cpu1));
+	cpumask_set_cpu(cpu1, cpu_core_mask(cpu2));
+	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
+	cpumask_set_cpu(cpu1, c2->llc_shared_map);
+	cpumask_set_cpu(cpu2, c1->llc_shared_map);
+}
+
 
 void __cpuinit set_cpu_sibling_map(int cpu)
 {
@@ -409,14 +422,13 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		for_each_cpu(i, cpu_sibling_setup_mask) {
 			struct cpuinfo_x86 *o = &cpu_data(i);
 
-			if (c->phys_proc_id == o->phys_proc_id &&
-			    c->cpu_core_id == o->cpu_core_id) {
-				cpumask_set_cpu(i, cpu_sibling_mask(cpu));
-				cpumask_set_cpu(cpu, cpu_sibling_mask(i));
-				cpumask_set_cpu(i, cpu_core_mask(cpu));
-				cpumask_set_cpu(cpu, cpu_core_mask(i));
-				cpumask_set_cpu(i, c->llc_shared_map);
-				cpumask_set_cpu(cpu, o->llc_shared_map);
+			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+				if (c->phys_proc_id == o->phys_proc_id &&
+				    c->compute_unit_id == o->compute_unit_id)
+					link_thread_siblings(cpu, i);
+			} else if (c->phys_proc_id == o->phys_proc_id &&
+				   c->cpu_core_id == o->cpu_core_id) {
+				link_thread_siblings(cpu, i);
 			}
 		}
 	} else {
