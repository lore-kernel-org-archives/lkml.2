Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2DJPVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:21:36 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39017 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159Ab2DJPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:20:56 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v4 4/4] tools: Connect to the kernel build system
Date: Tue, 10 Apr 2012 17:20:40 +0200
Message-Id: <1334071240-28692-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1334071240-28692-1-git-send-email-bp@amd64.org>
References: <1334071240-28692-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Now you can do

$ make tools/<toolname>

from the toplevel kernel directory and have the respective tool built.

If you want to build and install it, do

$ make tools/<toolname>_install

$ make tools/<toolname>_clean

should clean the respective tool directories.

If you want to clean all in tools, simply do

$ make tools/clean

Also, if you want to get what the possible targets are, simply calling

$ make tools/

should give you the short help.

$ make tools/install

installs all tools, of course. Doh.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Makefile       |    7 +++++++
 tools/Makefile |   25 ++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0df3d003a079..e24ce7104f63 100644
--- a/Makefile
+++ b/Makefile
@@ -1468,6 +1468,13 @@ kernelrelease:
 kernelversion:
 	@echo $(KERNELVERSION)
 
+# Clear a bunch of variables before executing the submake
+tools/: FORCE
+	$(Q)$(MAKE) LDFLAGS= -C $(src)/tools/
+
+tools/%: FORCE
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
+
 # Single targets
 # ---------------------------------------------------------------------------
 # Single targets are compatible with:
diff --git a/tools/Makefile b/tools/Makefile
index c7ed814e12cf..b2f3bd567ce3 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -14,13 +14,23 @@ help:
 	@echo '  vm         - misc vm tools'
 	@echo '  x86_energy_perf_policy - Intel energy policy tool'
 	@echo ''
+	@echo 'You can do:'
+	@echo ' $$ make -C tools/<tool>_install'
+	@echo ''
+	@echo '  from the kernel command line to build and install one of'
+	@echo '  the tools above'
+	@echo ''
+	@echo '  $$ make tools/install'
+	@echo ''
+	@echo '  installs all tools.'
+	@echo ''
 	@echo 'Cleaning targets:'
 	@echo ''
 	@echo '  all of the above with the "_clean" string appended cleans'
 	@echo '    the respective build directory.'
 	@echo '  clean: a summary clean target to clean _all_ folders'
 
-perf firewire lguest usb virtio vm: FORCE
+firewire lguest perf usb virtio vm: FORCE
 	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
 
 cpupower: FORCE
@@ -32,6 +42,19 @@ turbostat x86_energy_perf_policy: FORCE
 selftests: FORCE
 	$(QUIET_SUBDIR0)testing/$@/ $(QUIET_SUBDIR1)
 
+firewire_install lguest_install perf_install usb_install virtio_install vm_install:
+	$(QUIET_SUBDIR0)$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+cpupower_install:
+	$(QUIET_SUBDIR0)power/$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+turbostat_install x86_energy_perf_policy_install:
+	$(QUIET_SUBDIR0)power/x86/$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+install: firewire_install lguest_install perf_install usb_install \
+		virtio_install vm_install cpupower_install turbostat_install \
+		x86_energy_perf_policy_install
+
 firewire_clean lguest_clean perf_clean vm_clean usb_clean virtio_clean:
 	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
 
-- 
1.7.9.3.362.g71319

