Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2LLGOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:14:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2LLGN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:13:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,264,1355068800"; 
   d="scan'208";a="6380978"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v12 7/8] allower the user to disable pv event support
Date: Wed, 12 Dec 2012 14:13:50 +0800
Message-Id: <214177b6e6e6734269dd1fd50a710d68ce8b37e1.1355290850.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1355290850.git.hutao@cn.fujitsu.com>
References: <cover.1355290850.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:07,
	Serialize complete at 2012/12/12 14:13:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 hw/pc_piix.c    | 8 +++++++-
 qemu-config.c   | 4 ++++
 qemu-options.hx | 3 ++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/hw/pc_piix.c b/hw/pc_piix.c
index 8380702..bf31b96 100644
--- a/hw/pc_piix.c
+++ b/hw/pc_piix.c
@@ -150,6 +150,8 @@ static void pc_init1(MemoryRegion *system_memory,
     MemoryRegion *pci_memory;
     MemoryRegion *rom_memory;
     void *fw_cfg = NULL;
+    QemuOptsList *list = qemu_find_opts("machine");
+    bool enable_pv_event = false;
 
     pc_cpus_init(cpu_model);
 
@@ -288,7 +290,11 @@ static void pc_init1(MemoryRegion *system_memory,
         pc_pci_device_init(pci_bus);
     }
 
-    if (kvm_enabled()) {
+    if (list && !QTAILQ_EMPTY(&list->head)) {
+        enable_pv_event = qemu_opt_get_bool(QTAILQ_FIRST(&list->head),
+                                            "enable_pv_event", false);
+    }
+    if (kvm_enabled() && enable_pv_event) {
         kvm_pv_event_init(isa_bus);
     }
 }
diff --git a/qemu-config.c b/qemu-config.c
index 10d1ba4..6682276 100644
--- a/qemu-config.c
+++ b/qemu-config.c
@@ -627,6 +627,10 @@ static QemuOptsList qemu_machine_opts = {
             .name = "usb",
             .type = QEMU_OPT_BOOL,
             .help = "Set on/off to enable/disable usb",
+        }, {
+            .name = "enable_pv_event",
+            .type = QEMU_OPT_BOOL,
+            .help = "handle pv event"
         },
         { /* End of list */ }
     },
diff --git a/qemu-options.hx b/qemu-options.hx
index dd86bfe..44c7760 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -35,7 +35,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                kernel_irqchip=on|off controls accelerated irqchip support\n"
     "                kvm_shadow_mem=size of KVM shadow MMU\n"
     "                dump-guest-core=on|off include guest memory in a core dump (default=on)\n"
-    "                mem-merge=on|off controls memory merge support (default: on)\n",
+    "                mem-merge=on|off controls memory merge support (default: on)\n"
+    "                enable_pv_event=on|off controls pv event support (default: off)\n",
     QEMU_ARCH_ALL)
 STEXI
 @item -machine [type=]@var{name}[,prop=@var{value}[,...]]
-- 
1.8.0.1.240.ge8a1f5a

