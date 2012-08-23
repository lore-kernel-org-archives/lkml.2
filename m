Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2HWC1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:27:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab2HWC1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:27:21 -0400
X-IronPort-AV: E=Sophos;i="4.77,812,1336320000"; 
   d="scan'208";a="5700352"
Message-ID: <50359647.4060100@cn.fujitsu.com>
Date: Thu, 23 Aug 2012 10:32:39 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v9 6/6] allower the user to disable pv event support
References: <50359561.9070001@cn.fujitsu.com>
In-Reply-To: <50359561.9070001@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/23 10:27:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/23 10:27:18,
	Serialize complete at 2012/08/23 10:27:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 hw/pc_piix.c    |    6 +++++-
 qemu-config.c   |    4 ++++
 qemu-options.hx |    3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/hw/pc_piix.c b/hw/pc_piix.c
index f73fb85..76d3de1 100644
--- a/hw/pc_piix.c
+++ b/hw/pc_piix.c
@@ -151,6 +151,8 @@ static void pc_init1(MemoryRegion *system_memory,
     MemoryRegion *pci_memory;
     MemoryRegion *rom_memory;
     void *fw_cfg = NULL;
+    QemuOptsList *list = qemu_find_opts("machine");
+    bool enable_pv_event;
 
     pc_cpus_init(cpu_model);
 
@@ -289,8 +291,10 @@ static void pc_init1(MemoryRegion *system_memory,
         pc_pci_device_init(pci_bus);
     }
 
+    enable_pv_event = qemu_opt_get_bool(QTAILQ_FIRST(&list->head),
+                                        "enable_pv_event", false);
 #ifdef KVM_PV_EVENT_PORT
-    if (kvm_enabled()) {
+    if (kvm_enabled() && enable_pv_event) {
         kvm_pv_event_init(isa_bus);
     }
 #endif
diff --git a/qemu-config.c b/qemu-config.c
index c05ffbc..a58bf71 100644
--- a/qemu-config.c
+++ b/qemu-config.c
@@ -612,6 +612,10 @@ static QemuOptsList qemu_machine_opts = {
             .name = "dump-guest-core",
             .type = QEMU_OPT_BOOL,
             .help = "Include guest memory in  a core dump",
+        }, {
+            .name = "enable_pv_event",
+            .type = QEMU_OPT_BOOL,
+            .help = "handle pv event"
         },
         { /* End of list */ }
     },
diff --git a/qemu-options.hx b/qemu-options.hx
index 3c411c4..c825d66 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -38,7 +38,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                supported accelerators are kvm, xen, tcg (default: tcg)\n"
     "                kernel_irqchip=on|off controls accelerated irqchip support\n"
     "                kvm_shadow_mem=size of KVM shadow MMU\n"
-    "                dump-guest-core=on|off include guest memory in a core dump (default=on)\n",
+    "                dump-guest-core=on|off include guest memory in a core dump (default=on)\n"
+    "                enable_pv_event=on|off controls pv event support\n",
     QEMU_ARCH_ALL)
 STEXI
 @item -machine [type=]@var{name}[,prop=@var{value}[,...]]
-- 
1.7.1

