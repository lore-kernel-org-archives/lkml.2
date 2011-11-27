Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1K0CqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:46:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59661 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1K0CqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:46:00 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de, ryanh@us.ibm.com
Subject: [PATCH 2/5] QEMU Add cpu_free() to support arch related CPUState release
Date: Sun, 27 Nov 2011 10:45:34 +0800
Message-Id: <1322361937-22438-2-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

When exiting from vcpu thread, the CPUState must be freed firstly.
And the handling process is an arch related.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 hw/apic.c            |    4 ++++
 target-i386/cpu.h    |    3 +++
 target-i386/helper.c |    8 ++++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/hw/apic.c b/hw/apic.c
index 34fa1dd..6472045 100644
--- a/hw/apic.c
+++ b/hw/apic.c
@@ -511,6 +511,10 @@ static void apic_get_delivery_bitmask(uint32_t *deliver_bitmask,
         }
     }
 }
+void apic_free(DeviceState *d)
+{
+    qdev_free(d);
+}
 
 void apic_init_reset(DeviceState *d)
 {
diff --git a/target-i386/cpu.h b/target-i386/cpu.h
index 251e63b..da07781 100644
--- a/target-i386/cpu.h
+++ b/target-i386/cpu.h
@@ -767,6 +767,7 @@ typedef struct CPUX86State {
 } CPUX86State;
 
 CPUX86State *cpu_x86_init(const char *cpu_model);
+void cpu_x86_free(CPUState *env);
 CPUX86State *x86_phyid_to_cpu(int phy_id);
 int cpu_x86_exec(CPUX86State *s);
 void cpu_x86_close(CPUX86State *s);
@@ -950,6 +951,7 @@ CPUState *pc_new_cpu(const char *cpu_model);
 #define cpu_list_id x86_cpu_list
 #define cpudef_setup	x86_cpudef_setup
 
+#define cpu_free cpu_x86_free
 #define CPU_SAVE_VERSION 12
 
 /* MMU modes definitions */
@@ -1064,5 +1066,6 @@ void svm_check_intercept(CPUState *env1, uint32_t type);
 
 uint32_t cpu_cc_compute_all(CPUState *env1, int op);
 
+void apic_free(DeviceState *d);
 #define cpu_phyid_to_cpu  x86_phyid_to_cpu
 #endif /* CPU_I386_H */
diff --git a/target-i386/helper.c b/target-i386/helper.c
index e35a75e..c9fadc3 100644
--- a/target-i386/helper.c
+++ b/target-i386/helper.c
@@ -1263,6 +1263,14 @@ CPUX86State *cpu_x86_init(const char *cpu_model)
     return env;
 }
 
+void cpu_x86_free(CPUState *env)
+{
+    if (env->apic_state != NULL) {
+        apic_free(env->apic_state);
+    }
+    g_free(env);
+}
+
 CPUX86State *x86_phyid_to_cpu(int phy_id)
 {
     CPUX86State *env = first_cpu;
-- 
1.7.4.4

