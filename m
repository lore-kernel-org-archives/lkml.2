Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1K0Cpw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:45:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59661 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1K0Cpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:45:50 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de, ryanh@us.ibm.com
Subject: [PATCH 1/5] QEMU Add cpu_phyid_to_cpu() to map cpu phyid to CPUState
Date: Sun, 27 Nov 2011 10:45:33 +0800
Message-Id: <1322361937-22438-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

The guest has different cpu logic id from qemu, but they have the
same phyid. When cpu phyid is told by guest, we need to obtain
the corresponding CPUState.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 target-i386/cpu.h    |    2 ++
 target-i386/helper.c |   12 ++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/target-i386/cpu.h b/target-i386/cpu.h
index abdeb40..251e63b 100644
--- a/target-i386/cpu.h
+++ b/target-i386/cpu.h
@@ -767,6 +767,7 @@ typedef struct CPUX86State {
 } CPUX86State;
 
 CPUX86State *cpu_x86_init(const char *cpu_model);
+CPUX86State *x86_phyid_to_cpu(int phy_id);
 int cpu_x86_exec(CPUX86State *s);
 void cpu_x86_close(CPUX86State *s);
 void x86_cpu_list (FILE *f, fprintf_function cpu_fprintf, const char *optarg);
@@ -1063,4 +1064,5 @@ void svm_check_intercept(CPUState *env1, uint32_t type);
 
 uint32_t cpu_cc_compute_all(CPUState *env1, int op);
 
+#define cpu_phyid_to_cpu  x86_phyid_to_cpu
 #endif /* CPU_I386_H */
diff --git a/target-i386/helper.c b/target-i386/helper.c
index 5df40d4..e35a75e 100644
--- a/target-i386/helper.c
+++ b/target-i386/helper.c
@@ -1263,6 +1263,18 @@ CPUX86State *cpu_x86_init(const char *cpu_model)
     return env;
 }
 
+CPUX86State *x86_phyid_to_cpu(int phy_id)
+{
+    CPUX86State *env = first_cpu;
+    while (env) {
+        if (env->cpuid_apic_id == phy_id) {
+            break;
+        }
+        env = env->next_cpu;
+    }
+    return env;
+}
+
 #if !defined(CONFIG_USER_ONLY)
 void do_cpu_init(CPUState *env)
 {
-- 
1.7.4.4

