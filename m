Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab2C2M0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:26:42 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60808 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab2C2M0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:26:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/4] tools: Connect to the kernel build system
Date: Thu, 29 Mar 2012 14:25:57 +0200
Message-Id: <1333023957-22746-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1333023957-22746-1-git-send-email-bp@amd64.org>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Now you can do

$ make tools/<toolname>

from the toplevel kernel directory and have the respective tool built.

If you want to build and install it, do

$ make tools/<toolname> tinstall

The install target is called "tinstall" so that there's no conflict with
the main kernel install target and should mean "tool install".

$ make tools/ <toolname>_clean

should clean the respective tool directories.

If you want to clean all in tools, simply do

$ make  tools/ cleanall

Also, if you want to get what the possible targets are, simply calling

$ make tools/

should give you the short help.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Makefile       |   11 +++++++++++
 tools/Makefile |   31 +++++++++++++++++++++++++++----
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 1932984478c1..9e85648dd745 100644
--- a/Makefile
+++ b/Makefile
@@ -1468,6 +1468,17 @@ kernelrelease:
 kernelversion:
 	@echo $(KERNELVERSION)
 
+# empty targets used in tools/Makefile, defined here to suppress error message
+tinstall:
+cleanall:
+
+# Clear a bunch of variables before executing the submake
+tools/: FORCE
+	$(Q)$(MAKE) LDFLAGS= TOOL=help -C tools/ $(patsubst tools/%,%,$(MAKECMDGOALS))
+
+tools/%: FORCE
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= TOOL=$* -C $(src)/tools/ $(patsubst tools/%,%,$(MAKECMDGOALS))
+
 # Single targets
 # ---------------------------------------------------------------------------
 # Single targets are compatible with:
diff --git a/tools/Makefile b/tools/Makefile
index 25566cd74937..dcc86b42021b 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -1,5 +1,7 @@
 include scripts/Makefile.include
 
+default: $(TOOL)
+
 help:
 	@echo 'Possible targets:'
 	@echo ''
@@ -13,13 +15,19 @@ help:
 	@echo '  virtio     - vhost test module'
 	@echo '  x86_energy_perf_policy - Intel energy policy tool'
 	@echo ''
+	@echo 'You can do:'
+	@echo ' $$ make -C tools/ <tool> tinstall'
+	@echo ''
+	@echo '  from the kernel command line to build and install one of'
+	@echo '  the tools above'
+	@echo ''
 	@echo 'Cleaning targets:'
 	@echo ''
 	@echo '  all of the above with the "_clean" string appended cleans'
 	@echo '    the respective build directory.'
-	@echo '  clean: a summary clean target to clean _all_ folders'
+	@echo '  cleanall: a summary clean target to clean _all_ folders'
 
-perf firewire lguest slub usb virtio: FORCE
+firewire lguest perf slub usb virtio mytest: FORCE
 	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
 
 cpupower: FORCE
@@ -28,16 +36,31 @@ cpupower: FORCE
 turbostat x86_energy_perf_policy: FORCE
 	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
 
+tinstall: $(TOOL)
+ifeq ($(TOOL),cpupower)
+	$(MAKE) -C power/$(TOOL) install
+else
+  ifeq ($(TOOL),turbostat)
+	$(MAKE) -C power/x86/$(TOOL) install
+  else
+    ifeq ($(TOOL),x86_energy_perf_policy)
+	$(MAKE) -C power/x86/$(TOOL) install
+    else
+	$(MAKE) -C $(TOOL)/ install
+    endif
+  endif
+endif
+
 firewire_clean lguest_clean perf_clean slub_clean usb_clean virtio_clean:
 	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
 
-cp_clean:
+cpupower_clean:
 	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
 
 turbostat_clean x86_energy_perf_policy_clean:
 	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
 
-clean: cp_clean firewire_clean lguest_clean perf_clean slub_clean turbostat_clean \
+cleanall: cpupower_clean firewire_clean lguest_clean perf_clean slub_clean turbostat_clean \
 		usb_clean virtio_clean x86_energy_perf_policy_clean
 
 .PHONY: FORCE
-- 
1.7.9.3.362.g71319

