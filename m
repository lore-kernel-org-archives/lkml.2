Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1DWQ3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:29:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35085 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab1DWQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:30 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 06/18] tools: Add a toplevel Makefile
Date: Sat, 23 Apr 2011 18:28:08 +0200
Message-Id: <1303576100-425-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a Makefile with all the targets under tools/. Make perf the default
one and add a minimalistic Makefile to slub/ for completeness.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile             |   42 ++++++++++++++++++++++++++++++++++++++++++
 tools/scripts/Makefile.lib |   14 ++++++++++++--
 tools/slub/Makefile        |    4 ++++
 3 files changed, 58 insertions(+), 2 deletions(-)
 create mode 100644 tools/Makefile
 create mode 100644 tools/slub/Makefile

diff --git a/tools/Makefile b/tools/Makefile
new file mode 100644
index 0000000..74b20a9
--- /dev/null
+++ b/tools/Makefile
@@ -0,0 +1,42 @@
+include scripts/Makefile.lib
+
+PERF_TOP_DIR := $(CURDIR)
+export PERF_TOP_DIR
+
+BASIC_CFLAGS = -I$(CURDIR)/lib
+
+# temporary for lib/trace/
+BASIC_CFLAGS += -I$(CURDIR)/perf/util/include
+export BASIC_CFLAGS
+
+perf: .FORCE
+	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
+
+firewire: .FORCE
+	$(QUIET_SUBDIR0)firewire/ $(QUIET_SUBDIR1)
+
+slabinfo: .FORCE
+	$(QUIET_SUBDIR0)slub/ $(QUIET_SUBDIR1)
+
+turbostat: .FORCE
+	$(QUIET_SUBDIR0)power/x86/turbostat/ $(QUIET_SUBDIR1)
+
+usb: .FORCE
+	$(QUIET_SUBDIR0)usb/ $(QUIET_SUBDIR1)
+
+virtio: .FORCE
+	$(QUIET_SUBDIR0)virtio/ $(QUIET_SUBDIR1)
+
+x86_energy: .FORCE
+	$(QUIET_SUBDIR0)power/x86/x86_energy_perf_policy/ $(QUIET_SUBDIR1)
+
+clean:
+	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)firewire/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)slub/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)power/x86/turbostat/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)usb/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)virtio/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)power/x86/x86_energy_perf_policy/ $(QUIET_SUBDIR1) clean
+
+.PHONY: clean .FORCE
diff --git a/tools/scripts/Makefile.lib b/tools/scripts/Makefile.lib
index 854fefb..9dfa0f9 100644
--- a/tools/scripts/Makefile.lib
+++ b/tools/scripts/Makefile.lib
@@ -33,6 +33,15 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
+QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR1  =
+
+ifneq ($(findstring $(MAKEFLAGS),w),w)
+PRINT_DIR = --no-print-directory
+else # "make -w"
+NO_SUBDIR = :
+endif
+
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
 	QUIET_CC       = @echo '   ' CC $@;
@@ -40,7 +49,8 @@ ifndef V
 	QUIET_LINK     = @echo '   ' LINK $@;
 	QUIET_MKDIR    = @echo '   ' MKDIR $@;
 	QUIET_GEN      = @echo '   ' GEN $@;
+	QUIET_SUBDIR0  = +@subdir=
+	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+			$(MAKE) $(PRINT_DIR) -C $$subdir
 endif
 endif
-
-
diff --git a/tools/slub/Makefile b/tools/slub/Makefile
new file mode 100644
index 0000000..b2cf6b4
--- /dev/null
+++ b/tools/slub/Makefile
@@ -0,0 +1,4 @@
+slabinfo: slabinfo.c
+
+clean:
+	rm -rf slabinfo
-- 
1.7.4.rc2

