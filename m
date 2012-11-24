Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2KXAVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:21:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:57918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2KXAVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:21:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/8] tools: Define a Makefile function to do subdir processing
Date: Fri, 23 Nov 2012 21:20:47 -0300
Message-Id: <1353716453-9693-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353716453-9693-1-git-send-email-acme@infradead.org>
References: <1353716453-9693-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Define a Makefile function that can be called with $(call ...) to wrap
the subdir make invocations in tools/Makefile.

This will allow us in the next patch to insert bits in there to honour
O= flags when called from the top-level Makefile.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1378.1352379110@warthog.procyon.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/Makefile                 |   24 ++++++++++++------------
 tools/scripts/Makefile.include |    8 ++++++++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/Makefile b/tools/Makefile
index 3ae4394..1f9a529 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -31,44 +31,44 @@ help:
 	@echo '  clean: a summary clean target to clean _all_ folders'
 
 cpupower: FORCE
-	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
+	$(call descend,power/$@)
 
 firewire lguest perf usb virtio vm: FORCE
-	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
+	$(call descend,$@)
 
 selftests: FORCE
-	$(QUIET_SUBDIR0)testing/$@/ $(QUIET_SUBDIR1)
+	$(call descend,testing/$@)
 
 turbostat x86_energy_perf_policy: FORCE
-	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
+	$(call descend,power/x86/$@)
 
 cpupower_install:
-	$(QUIET_SUBDIR0)power/$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,power/$(@:_install=),install)
 
 firewire_install lguest_install perf_install usb_install virtio_install vm_install:
-	$(QUIET_SUBDIR0)$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,$(@:_install=),install)
 
 selftests_install:
-	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) install
+	$(call descend,testing/$(@:_clean=),install)
 
 turbostat_install x86_energy_perf_policy_install:
-	$(QUIET_SUBDIR0)power/x86/$(@:_install=)/ $(QUIET_SUBDIR1) install
+	$(call descend,power/x86/$(@:_install=),install)
 
 install: cpupower_install firewire_install lguest_install perf_install \
 		selftests_install turbostat_install usb_install virtio_install \
 		vm_install x86_energy_perf_policy_install
 
 cpupower_clean:
-	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
+	$(call descend,power/cpupower,clean)
 
 firewire_clean lguest_clean perf_clean usb_clean virtio_clean vm_clean:
-	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,$(@:_clean=),clean)
 
 selftests_clean:
-	$(QUIET_SUBDIR0)testing/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,testing/$(@:_clean=),clean)
 
 turbostat_clean x86_energy_perf_policy_clean:
-	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
+	$(call descend,power/x86/$(@:_clean=),clean)
 
 clean: cpupower_clean firewire_clean lguest_clean perf_clean selftests_clean \
 		turbostat_clean usb_clean virtio_clean vm_clean \
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 96ce80a..4a9e317 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -41,6 +41,14 @@ else
 NO_SUBDIR = :
 endif
 
+#
+# Define a callable command for descending to a new directory
+#
+# Call by doing: $(call descend,directory[,target])
+#
+descend = \
+	$(QUIET_SUBDIR0)$(1) $(QUIET_SUBDIR1) $(2)
+
 QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
-- 
1.7.9.2.358.g22243

