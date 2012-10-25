Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2JYDnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:43:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933902Ab2JYDmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:42:45 -0400
X-IronPort-AV: E=Sophos;i="4.80,645,1344182400"; 
   d="scan'208";a="6064363"
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
Subject: [PATCH v11 6/6] allower the user to disable pv event support
Date: Thu, 25 Oct 2012 11:42:38 +0800
Message-Id: <1351136563-15073-6-git-send-email-hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:42:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:42:02,
	Serialize complete at 2012/10/25 11:42:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 hw/pc_piix.c    |    6 +++++-
 qemu-config.c   |    4 ++++
 qemu-options.hx |    3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/hw/pc_piix.c b/hw/pc_piix.c
index fb67dc1..864d356 100644
--- a/hw/pc_piix.c
+++ b/hw/pc_piix.c
@@ -149,6 +149,8 @@ static void pc_init1(MemoryRegion *system_memory,
     MemoryRegion *pci_memory;
     MemoryRegion *rom_memory;
     void *fw_cfg = NULL;
+    QemuOptsList *list = qemu_find_opts("machine");
+    bool enable_pv_event;
 
     pc_cpus_init(cpu_model);
 
@@ -287,7 +289,9 @@ static void pc_init1(MemoryRegion *system_memory,
         pc_pci_device_init(pci_bus);
     }
 
-    if (kvm_enabled()) {
+    enable_pv_event = qemu_opt_get_bool(QTAILQ_FIRST(&list->head),
+                                        "enable_pv_event", false);
+    if (kvm_enabled() && enable_pv_event) {
         kvm_pv_event_init(isa_bus);
     }
 }
diff --git a/qemu-config.c b/qemu-config.c
index cd1ec21..db8f828 100644
--- a/qemu-config.c
+++ b/qemu-config.c
@@ -619,6 +619,10 @@ static QemuOptsList qemu_machine_opts = {
             .name = "mem-merge",
             .type = QEMU_OPT_BOOL,
             .help = "enable/disable memory merge support",
+        }, {
+            .name = "enable_pv_event",
+            .type = QEMU_OPT_BOOL,
+            .help = "handle pv event"
         },
         { /* End of list */ }
     },
diff --git a/qemu-options.hx b/qemu-options.hx
index 46f0539..de667d6 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -35,7 +35,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
     "                kernel_irqchip=on|off controls accelerated irqchip support\n"
     "                kvm_shadow_mem=size of KVM shadow MMU\n"
     "                dump-guest-core=on|off include guest memory in a core dump (default=on)\n"
-    "                mem-merge=on|off controls memory merge support (default: on)\n",
+    "                mem-merge=on|off controls memory merge support (default: on)\n"
+    "                enable_pv_event=on|off controls pv event support\n",
     QEMU_ARCH_ALL)
 STEXI
 @item -machine [type=]@var{name}[,prop=@var{value}[,...]]
-- 
1.7.10.2

