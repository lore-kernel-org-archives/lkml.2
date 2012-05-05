Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2EEITw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:19:52 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:16436 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2EEISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:18:48 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/8] kbuild: refactor final link of sparc32
Date: Sat,  5 May 2012 10:18:40 +0200
Message-Id: <1336205926-13946-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20120505080640.GA13773@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc32 uses an additional final link to support btfix.
Introduce a new set of exported variables in the top-level Makefile
to make the extra linking step simpler.

sparc32 has hardcoded knowledge of kallsyms support. This fix
include support for EXTRA_KALLSYM_PASS=1.
The ugly part is that it is hardcoded in the arch/sparc/boot
Makefile.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 Makefile                 |    5 +++++
 arch/sparc/Makefile      |   11 -----------
 arch/sparc/boot/Makefile |   14 +++++++++-----
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index 1af1b7a..20b0232 100644
--- a/Makefile
+++ b/Makefile
@@ -727,6 +727,11 @@ libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
 libs-y2		:= $(patsubst %/, %/built-in.o, $(libs-y))
 libs-y		:= $(libs-y1) $(libs-y2)
 
+# externally visible symbols
+export KBUILD_VMLINUX_INIT := $(head-y) $(init-y)
+export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y)
+export KBUILD_LDS          := arch/$(SRCARCH)/kernel/vmlinux.lds
+
 # Build vmlinux
 # ---------------------------------------------------------------------------
 # vmlinux is built from the objects selected by $(vmlinux-init) and
diff --git a/arch/sparc/Makefile b/arch/sparc/Makefile
index eddcfb3..3195f77 100644
--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -72,17 +72,6 @@ libs-y                 += arch/sparc/lib/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/sparc/oprofile/
 
-# Export what is needed by arch/sparc/boot/Makefile
-export VMLINUX_INIT VMLINUX_MAIN
-VMLINUX_INIT := $(head-y) $(init-y)
-VMLINUX_MAIN := $(core-y) kernel/ mm/ fs/ ipc/ security/ crypto/ block/
-VMLINUX_MAIN += $(patsubst %/, %/lib.a, $(libs-y)) $(libs-y)
-VMLINUX_MAIN += $(drivers-y) $(net-y)
-
-ifdef CONFIG_KALLSYMS
-export kallsyms.o := .tmp_kallsyms2.o
-endif
-
 boot := arch/sparc/boot
 
 # Default target
diff --git a/arch/sparc/boot/Makefile b/arch/sparc/boot/Makefile
index d56d199..78f1994 100644
--- a/arch/sparc/boot/Makefile
+++ b/arch/sparc/boot/Makefile
@@ -39,11 +39,15 @@ define rule_image
 	echo 'cmd_$@ := $(cmd_image)' > $(@D)/.$(@F).cmd
 endef
 
-BTOBJS := $(patsubst %/, %/built-in.o, $(VMLINUX_INIT))
-BTLIBS := $(patsubst %/, %/built-in.o, $(VMLINUX_MAIN))
-LDFLAGS_image := -T arch/sparc/kernel/vmlinux.lds $(BTOBJS) \
-                  --start-group $(BTLIBS) --end-group \
-                  $(kallsyms.o) $(obj)/btfix.o
+# Support for kallsyms
+kallsyms-$(CONFIG_KALLSYMS) := .tmp_kallsyms2.o
+ifdef KALLSYMS_EXTRA_PASS
+        kallsyms-$(CONFIG_KALLSYMS) := .tmp_kallsyms3.o
+endif
+
+LDFLAGS_image := -T $(KBUILD_LDS) $(KBUILD_VMLINUX_INIT)           \
+                  --start-group $(KBUILD_VMLINUX_MAIN) --end-group \
+                  $(kallsyms-y) $(obj)/btfix.o
 
 # Link the final image including btfixup'ed symbols.
 # This is a replacement for the link done in the top-level Makefile.
-- 
1.6.0.6

