Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2DBPP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:15:56 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39874 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2DBPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:15:55 -0400
Date: Mon, 2 Apr 2012 17:15:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] tools: Add a toplevel Makefile
Message-ID: <20120402151546.GA32336@aftab>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
 <20120330052605.GA30508@merkur.ravnborg.org>
 <20120330161526.GE30876@aftab>
 <20120331084908.GA14149@gmail.com>
 <20120331184906.GA25809@merkur.ravnborg.org>
 <20120401084253.GB21108@gmail.com>
 <20120401092236.GA15717@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401092236.GA15717@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 11:22:36AM +0200, Borislav Petkov wrote:
> and the same would work for the rest of the tools in there.

Ok, instead of spamming the ML, I'm sending only the 4th patch which
basically implements what Sam suggested.

Thanks.

--
>From 1ac61da491fa4db8fb4e151b0daa3f4415bfd44d Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 27 Mar 2012 11:50:47 +0200
Subject: [PATCH] tools: Connect to the kernel build system

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

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Makefile       |    7 +++++++
 tools/Makefile |   31 +++++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 1932984478c1..a277c0474500 100644
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
index 25566cd74937..3c850de935f8 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -13,13 +13,23 @@ help:
 	@echo '  virtio     - vhost test module'
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
 
-perf firewire lguest slub usb virtio: FORCE
+firewire lguest perf slub usb virtio: FORCE
 	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
 
 cpupower: FORCE
@@ -28,16 +38,29 @@ cpupower: FORCE
 turbostat x86_energy_perf_policy: FORCE
 	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
 
+firewire_install lguest_install perf_install slub_install usb_install virtio_install:
+	$(QUIET_SUBDIR0)$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+cpupower_install:
+	$(QUIET_SUBDIR0)power/$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+turbostat_install x86_energy_perf_policy_install:
+	$(QUIET_SUBDIR0)power/x86/$(@:_install=)/ $(QUIET_SUBDIR1) install
+
+install: firewire_install lguest_install perf_install slub_install \
+		usb_install virtio_install cpupower_install turbostat_install \
+		x86_energy_perf_policy_install
+
 firewire_clean lguest_clean perf_clean slub_clean usb_clean virtio_clean:
 	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
 
-cp_clean:
+cpupower_clean:
 	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
 
 turbostat_clean x86_energy_perf_policy_clean:
 	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
 
-clean: cp_clean firewire_clean lguest_clean perf_clean slub_clean turbostat_clean \
-		usb_clean virtio_clean x86_energy_perf_policy_clean
+clean: cpupower_clean firewire_clean lguest_clean perf_clean slub_clean \
+		turbostat_clean usb_clean virtio_clean x86_energy_perf_policy_clean
 
 .PHONY: FORCE
-- 
1.7.9.3.362.g71319


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
