Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2DXTnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:43:47 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:42011 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab2DXTnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:43:46 -0400
Date: Tue, 24 Apr 2012 21:43:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/4] kbuild: refactor final link of sparc32
Message-ID: <20120424194345.GB2311@merkur.ravnborg.org>
References: <20120424194148.GA2216@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424194148.GA2216@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8716c7f473ec65c57811bb21095354b813b48898 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 23 Apr 2012 20:29:07 +0200
Subject: [PATCH 2/4] kbuild: refactor final link of sparc32

sparc32 uses an additional final link to support btfix.
Introduce a new set of exported variables in the top-level Makefile
to make the extra linking step simpler.

sparc32 have hardcoded knowledge of kallsyms support. This fix
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
index 287aee4..00bf5b1 100644
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
1.7.10

