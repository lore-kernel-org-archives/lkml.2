Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1K0Cq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:46:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59661 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1K0CqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:46:24 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de, ryanh@us.ibm.com
Subject: [PATCH 4/5] QEMU Release vcpu and finally exit vcpu thread safely
Date: Sun, 27 Nov 2011 10:45:36 +0800
Message-Id: <1322361937-22438-4-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

When guest driver tell us that the vcpu is no longer needed,
qemu can release the vcpu and finally exit vcpu thread

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 cpu-defs.h        |    5 +++++
 cpus.c            |   21 +++++++++++++++++++++
 hmp-commands.hx   |    2 +-
 hw/acpi_piix4.c   |   19 ++++++++++++++++---
 hw/pci_cpustate.c |   22 ++++++++++++++++++++++
 kvm-all.c         |   11 ++++++++++-
 monitor.c         |   12 +++++++-----
 7 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/cpu-defs.h b/cpu-defs.h
index db48a7a..cb69a07 100644
--- a/cpu-defs.h
+++ b/cpu-defs.h
@@ -153,6 +153,10 @@ typedef struct CPUWatchpoint {
     QTAILQ_ENTRY(CPUWatchpoint) entry;
 } CPUWatchpoint;
 
+#define CPU_STATE_RUNNING 0
+#define CPU_STATE_ZAPREQ 1
+#define CPU_STATE_ZAPPED 2
+
 #define CPU_TEMP_BUF_NLONGS 128
 #define CPU_COMMON                                                      \
     struct TranslationBlock *current_tb; /* currently executing TB  */  \
@@ -210,6 +214,7 @@ typedef struct CPUWatchpoint {
     uint32_t created;                                                   \
     uint32_t stop;   /* Stop request */                                 \
     uint32_t stopped; /* Artificially stopped */                        \
+    uint32_t state; /*state indicator*/                             \
     struct QemuThread *thread;                                          \
     struct QemuCond *halt_cond;                                         \
     int thread_kicked;                                                  \
diff --git a/cpus.c b/cpus.c
index c996ac5..e479476 100644
--- a/cpus.c
+++ b/cpus.c
@@ -33,6 +33,7 @@
 
 #include "qemu-thread.h"
 #include "cpus.h"
+#include "cpu.h"
 
 #ifndef _WIN32
 #include "compatfd.h"
@@ -778,6 +779,7 @@ static void qemu_kvm_wait_io_event(CPUState *env)
 static void *qemu_kvm_cpu_thread_fn(void *arg)
 {
     CPUState *env = arg;
+    CPUState *prev = NULL;
     int r;
 
     qemu_mutex_lock(&qemu_global_mutex);
@@ -808,10 +810,29 @@ static void *qemu_kvm_cpu_thread_fn(void *arg)
                 cpu_handle_guest_debug(env);
             }
         }
+        /*1,try to zap; 2, can safe to destroy*/
+        if (env->state == CPU_STATE_ZAPPED) {
+            goto zapout;
+        }
         qemu_kvm_wait_io_event(env);
     }
 
     return NULL;
+zapout:
+    prev = first_cpu;
+    if (prev == env) {
+        first_cpu = env->next_cpu;
+    } else {
+        while (prev != NULL) {
+            if (prev->next_cpu == env) {
+                break;
+            }
+            prev = prev->next_cpu;
+        }
+        prev->next_cpu = env->next_cpu;
+    }
+    cpu_free(env);
+    return NULL;
 }
 
 static void *qemu_tcg_cpu_thread_fn(void *arg)
diff --git a/hmp-commands.hx b/hmp-commands.hx
index ed5c9b9..b642a34 100644
--- a/hmp-commands.hx
+++ b/hmp-commands.hx
@@ -1218,7 +1218,7 @@ ETEXI
     {
         .name       = "cpu_set",
         .args_type  = "cpu:i,state:s",
-        .params     = "cpu [online|offline]",
+        .params     = "cpu [online|offline|zap]",
         .help       = "change cpu state",
         .mhandler.cmd  = do_cpu_set_nr,
     },
diff --git a/hw/acpi_piix4.c b/hw/acpi_piix4.c
index f585226..1f3ed06 100644
--- a/hw/acpi_piix4.c
+++ b/hw/acpi_piix4.c
@@ -605,10 +605,23 @@ void qemu_system_cpu_hot_add(int cpu, int state)
         env->cpuid_apic_id = cpu;
     }
 
-    if (state)
-        enable_processor(s, cpu);
-    else
+    switch (state) {
+    /*zap vcpu*/
+    case 0:
+        env = qemu_get_cpu(cpu);
+        /*1 means try to zap*/
+        env->state = CPU_STATE_ZAPREQ;
+        disable_processor(s, cpu);
+        break;
+    /*offline vcpu*/
+    case 1:
         disable_processor(s, cpu);
+        break;
+    /*onine vcpu*/
+    case 2:
+        enable_processor(s, cpu);
+        break;
+    }
 
     pm_update_sci(s);
 }
diff --git a/hw/pci_cpustate.c b/hw/pci_cpustate.c
index fd31a1f..18402cf 100644
--- a/hw/pci_cpustate.c
+++ b/hw/pci_cpustate.c
@@ -24,6 +24,8 @@
 #include "loader.h"
 #include "sysemu.h"
 #include "iov.h"
+#include <linux/kvm.h>
+#include "kvm.h"
 
 #define PCI_DEVICE_ID_CPUSTATE  0x1010
 #define CPUSTATE_REGS_SIZE  0x1000
@@ -52,6 +54,26 @@ static void
 cpustate_mmio_write(void *opaque, target_phys_addr_t addr, uint64_t val,
                  unsigned size)
 {
+    CPUState *env;
+    int ret;
+    struct kvm_vcpu_state state;
+    switch (addr) {
+    /*apic id*/
+    case 0:
+        env = cpu_phyid_to_cpu(val);
+        if (env != NULL) {
+            if (env->state == CPU_STATE_ZAPREQ) {
+                state.vcpu_id = env->cpu_index;
+                state.state = 1;
+                ret = kvm_vm_ioctl(env->kvm_state, KVM_SETSTATE_VCPU, &state);
+            }
+        }
+        break;
+    case 4:
+        break;
+    default:
+        break;
+    }
 }
 
 static uint64_t
diff --git a/kvm-all.c b/kvm-all.c
index 8dd354e..b295262 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -64,6 +64,7 @@ struct KVMState
     int vmfd;
     int coalesced_mmio;
     struct kvm_coalesced_mmio_ring *coalesced_mmio_ring;
+    long mmap_size;
     int broken_set_mem_region;
     int migration_log;
     int vcpu_events;
@@ -228,7 +229,7 @@ int kvm_init_vcpu(CPUState *env)
         DPRINTF("KVM_GET_VCPU_MMAP_SIZE failed\n");
         goto err;
     }
-
+    env->kvm_state->mmap_size = mmap_size;
     env->kvm_run = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED,
                         env->kvm_fd, 0);
     if (env->kvm_run == MAP_FAILED) {
@@ -1026,6 +1027,13 @@ int kvm_cpu_exec(CPUState *env)
         case KVM_EXIT_INTERNAL_ERROR:
             ret = kvm_handle_internal_error(env, run);
             break;
+        case KVM_EXIT_VCPU_DEAD:
+            ret = munmap(env->kvm_run, env->kvm_state->mmap_size);
+            ret = close(env->kvm_fd);
+            env->state = CPU_STATE_ZAPPED;
+            qemu_mutex_unlock_iothread();
+            goto out;
+            break;
         default:
             DPRINTF("kvm_arch_handle_exit\n");
             ret = kvm_arch_handle_exit(env, run);
@@ -1033,6 +1041,7 @@ int kvm_cpu_exec(CPUState *env)
         }
     } while (ret == 0);
 
+out:
     if (ret < 0) {
         cpu_dump_state(env, stderr, fprintf, CPU_DUMP_CODE);
         vm_stop(VMSTOP_PANIC);
diff --git a/monitor.c b/monitor.c
index cb485bf..51c8c52 100644
--- a/monitor.c
+++ b/monitor.c
@@ -971,11 +971,13 @@ static void do_cpu_set_nr(Monitor *mon, const QDict *qdict)
     status = qdict_get_str(qdict, "state");
     value = qdict_get_int(qdict, "cpu");
 
-    if (!strcmp(status, "online"))
-       state = 1;
-    else if (!strcmp(status, "offline"))
-       state = 0;
-    else {
+    if (!strcmp(status, "online")) {
+        state = 2;
+    } else if (!strcmp(status, "offline")) {
+        state = 1;
+    } else if (!strcmp(status, "zap")) {
+        state = 0;
+    } else {
         monitor_printf(mon, "invalid status: %s\n", status);
         return;
     }
-- 
1.7.4.4

