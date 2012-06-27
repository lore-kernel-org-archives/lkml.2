Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2F0G6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:58:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8986 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab2F0G57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:57:59 -0400
X-IronPort-AV: E=Sophos;i="4.77,483,1336320000"; 
   d="scan'208";a="5272491"
Message-ID: <4FEAAFFF.40401@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 15:02:23 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 5/6 v5] deal with guest panicked event accoring to -onpanic
 parameter
References: <4FEAAE6E.7070302@cn.fujitsu.com>
In-Reply-To: <4FEAAE6E.7070302@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 14:58:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 14:58:08,
	Serialize complete at 2012/06/27 14:58:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the guest is panicked, it will write 0x1 to the port KVM_PV_PORT.
So if qemu reads 0x1 from this port, we can do the folloing three
things according to the parameter -onpanic:
1. emit QEVENT_GUEST_PANICKED only
2. emit QEVENT_GUEST_PANICKED and pause the guest
3. emit QEVENT_GUEST_PANICKED and poweroff the guest
4. emit QEVENT_GUEST_PANICKED and reset the guest

Note: if we emit QEVENT_GUEST_PANICKED only, and the management
application does not receive this event(the management may not
run when the event is emitted), the management won't know the
guest is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 kvm-all.c       |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kvm-stub.c      |    9 +++++
 kvm.h           |    3 ++
 qemu-options.hx |   15 ++++++++
 vl.c            |   10 +++++
 5 files changed, 138 insertions(+), 0 deletions(-)

diff --git a/kvm-all.c b/kvm-all.c
index f8e4328..9494dd2 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -19,6 +19,8 @@
 #include <stdarg.h>
 
 #include <linux/kvm.h>
+#include <linux/kvm_para.h>
+#include <asm/kvm_para.h>
 
 #include "qemu-common.h"
 #include "qemu-barrier.h"
@@ -32,6 +34,9 @@
 #include "bswap.h"
 #include "memory.h"
 #include "exec-memory.h"
+#include "iorange.h"
+#include "qemu-objects.h"
+#include "monitor.h"
 
 /* This check must be after config-host.h is included */
 #ifdef CONFIG_EVENTFD
@@ -1931,3 +1936,99 @@ int kvm_on_sigbus(int code, void *addr)
 {
     return kvm_arch_on_sigbus(code, addr);
 }
+
+/* Possible values for action parameter. */
+#define PANICKED_REPORT     1   /* emit QEVENT_GUEST_PANICKED only */
+#define PANICKED_PAUSE      2   /* emit QEVENT_GUEST_PANICKED and pause VM */
+#define PANICKED_POWEROFF   3   /* emit QEVENT_GUEST_PANICKED and quit VM */
+#define PANICKED_RESET      4   /* emit QEVENT_GUEST_PANICKED and reset VM */
+
+static int panicked_action = PANICKED_REPORT;
+
+static void kvm_pv_port_read(IORange *iorange, uint64_t offset, unsigned width,
+                             uint64_t *data)
+{
+    *data = (1 << KVM_PV_FEATURE_PANICKED);
+}
+
+static void panicked_mon_event(const char *action)
+{
+    QObject *data;
+
+    data = qobject_from_jsonf("{ 'action': %s }", action);
+    monitor_protocol_event(QEVENT_GUEST_PANICKED, data);
+    qobject_decref(data);
+}
+
+static void panicked_perform_action(void)
+{
+    switch (panicked_action) {
+    case PANICKED_REPORT:
+        panicked_mon_event("report");
+        break;
+
+    case PANICKED_PAUSE:
+        panicked_mon_event("pause");
+        vm_stop(RUN_STATE_GUEST_PANICKED);
+        break;
+
+    case PANICKED_POWEROFF:
+        panicked_mon_event("poweroff");
+        exit(0);
+        break;
+    case PANICKED_RESET:
+        panicked_mon_event("reset");
+        qemu_system_reset_request();
+        break;
+    }
+}
+
+static void kvm_pv_port_write(IORange *iorange, uint64_t offset, unsigned width,
+                              uint64_t data)
+{
+    if (data == KVM_PV_PANICKED) {
+        panicked_perform_action();
+    }
+}
+
+static void kvm_pv_port_destructor(IORange *iorange)
+{
+    g_free(iorange);
+}
+
+static IORangeOps pv_io_range_ops = {
+    .read = kvm_pv_port_read,
+    .write = kvm_pv_port_write,
+    .destructor = kvm_pv_port_destructor,
+};
+
+#if defined(KVM_PV_PORT)
+void kvm_pv_port_init(void)
+{
+    IORange *pv_io_range = g_malloc(sizeof(IORange));
+
+    iorange_init(pv_io_range, &pv_io_range_ops, KVM_PV_PORT, 1);
+    ioport_register(pv_io_range);
+}
+#else
+void kvm_pv_port_init(void)
+{
+}
+#endif
+
+int select_panicked_action(const char *p)
+{
+    if (strcasecmp(p, "none") == 0) {
+        panicked_action = PANICKED_REPORT;
+    } else if (strcasecmp(p, "pause") == 0) {
+        panicked_action = PANICKED_PAUSE;
+    } else if (strcasecmp(p, "poweroff") == 0) {
+        panicked_action = PANICKED_POWEROFF;
+    } else if (strcasecmp(p, "reset") == 0) {
+        panicked_action = PANICKED_RESET;
+    } else {
+        return -1;
+    }
+
+    return 0;
+}
diff --git a/kvm-stub.c b/kvm-stub.c
index ec9a364..318e967 100644
--- a/kvm-stub.c
+++ b/kvm-stub.c
@@ -151,3 +151,12 @@ int kvm_irqchip_remove_irqfd(KVMState *s, int fd, int virq)
 {
     return -ENOSYS;
 }
+
+void kvm_pv_port_init(void)
+{
+}
+
+int select_panicked_action(const char *p)
+{
+    return -1;
+}
diff --git a/kvm.h b/kvm.h
index 9c7b0ea..d174d5a 100644
--- a/kvm.h
+++ b/kvm.h
@@ -64,6 +64,9 @@ int kvm_has_gsi_routing(void);
 
 int kvm_allows_irq0_override(void);
 
+void kvm_pv_port_init(void);
+int select_panicked_action(const char *p);
+
 #ifdef NEED_CPU_H
 int kvm_init_vcpu(CPUArchState *env);
 
diff --git a/qemu-options.hx b/qemu-options.hx
index 8b66264..4a061bf 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -2743,6 +2743,21 @@ DEF("qtest-log", HAS_ARG, QEMU_OPTION_qtest_log,
     "-qtest-log LOG  specify tracing options\n",
     QEMU_ARCH_ALL)
 
+DEF("onpanic", HAS_ARG, QEMU_OPTION_onpanic, \
+    "-onpanic none|pause|poweroff|reset\n" \
+    "                action when the guest is panicked [default=none]",
+    QEMU_ARCH_ALL)
+STEXI
+@item -onpanic @var{action}
+
+The @var{action} controls what QEmu will do when the guest is panicked.
+The default is @code{none} (emit QEVENT_GUEST_PANICKED only).
+Other possible actions are:
+@code{pause} (emit QEVENT_GUEST_PANICKED and pause the guest),
+@code{poweroff} (emit QEVENT_GUEST_PANICKED and forcefully poweroff the guest),
+@code{reset} (emit QEVENT_GUEST_PANICKED and forcefully reset the guest).
+ETEXI
+
 HXCOMM This is the last statement. Insert new options before this line!
 STEXI
 @end table
diff --git a/vl.c b/vl.c
index c0e5d3c..9164d29 100644
--- a/vl.c
+++ b/vl.c
@@ -3205,6 +3205,12 @@ int main(int argc, char **argv, char **envp)
             case QEMU_OPTION_qtest_log:
                 qtest_log = optarg;
                 break;
+            case QEMU_OPTION_onpanic:
+                if (select_panicked_action(optarg) == -1) {
+                    fprintf(stderr, "Unknown -onpanic parameter\n");
+                    exit(1);
+                }
+                break;
             default:
                 os_parse_cmd_args(popt->index, optarg);
             }
@@ -3641,6 +3647,10 @@ int main(int argc, char **argv, char **envp)
         }
     }
 
+    if (kvm_enabled()) {
+        kvm_pv_port_init();
+    }
+
     if (incoming) {
         Error *errp = NULL;
         int ret = qemu_start_incoming_migration(incoming, &errp);
-- 
1.7.1

