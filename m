Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab2GUHOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:14:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17043 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2GUHO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:14:29 -0400
X-IronPort-AV: E=Sophos;i="4.77,628,1336320000"; 
   d="scan'208";a="5450302"
Message-ID: <500A57F8.2070008@cn.fujitsu.com>
Date: Sat, 21 Jul 2012 15:19:20 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 6/6 v7] allow the user to disable pv event support
References: <500A565A.8080403@cn.fujitsu.com>
In-Reply-To: <500A565A.8080403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 15:15:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/21 15:15:07,
	Serialize complete at 2012/07/21 15:15:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The qom device uses a fixed PIO port that might conflict
with (non-Linux) guest expectations and/or future device models.
So allow the user to disable it.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 hw/pc_piix.c    |    6 +++++-
 qemu-config.c   |    4 ++++
 qemu-options.hx |    3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/hw/pc_piix.c b/hw/pc_piix.c
index 7ec2853..48fae72 100644
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
 #ifdef KVM_PV_PORT
-    if (kvm_enabled()) {
+    if (kvm_enabled() && enable_pv_event) {
         kvm_pv_event_init(isa_bus);
     }
 #endif
diff --git a/qemu-config.c b/qemu-config.c
index 5c3296b..5ec5aa9 100644
--- a/qemu-config.c
+++ b/qemu-config.c
@@ -595,6 +595,10 @@ static QemuOptsList qemu_machine_opts = {
             .name = "dt_compatible",
             .type = QEMU_OPT_STRING,
             .help = "Overrides the \"compatible\" property of the dt root node",
+        }, {
+            .name = "enable_pv_event",
+            .type = QEMU_OPT_BOOL,
+            .help = "handle pv event"
         },
         { /* End of list */ }
     },
diff --git a/qemu-options.hx b/qemu-options.hx
index 97245a3..5661918 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -33,7 +33,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                property accel=accel1[:accel2[:...]] selects accelerator\n"
     "                supported accelerators are kvm, xen, tcg (default: tcg)\n"
     "                kernel_irqchip=on|off controls accelerated irqchip support\n"
-    "                kvm_shadow_mem=size of KVM shadow MMU\n",
+    "                kvm_shadow_mem=size of KVM shadow MMU\n"
+    "                enable_pv_event=on|off controls pv event support\n",
     QEMU_ARCH_ALL)
 STEXI
 @item -machine [type=]@var{name}[,prop=@var{value}[,...]]
-- 
1.7.1

