Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2CZOFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:05:11 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:32798 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab2CZOFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:05:10 -0400
Date: Mon, 26 Mar 2012 16:05:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] tools: Add a toplevel Makefile
Message-ID: <20120326140505.GD32090@aftab>
References: <1332513788-9726-1-git-send-email-bp@amd64.org>
 <20120324074412.GE20145@gmail.com>
 <20120326122632.GC32090@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326122632.GC32090@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 02:26:32PM +0200, Borislav Petkov wrote:
> On Sat, Mar 24, 2012 at 08:44:12AM +0100, Ingo Molnar wrote:
> > Could this also be accessible via 'make tools' in the toplevel 
> > Makefile?
> > 
> > I'd love to be able to type:
> > 
> >   make -j tools perf install
> 
> Well,
> 
> you could do
> 
> $ make -j -C tools perf
> 
> which builds perf. I'd need to make it work with the install target too
> so that when you do
> 
> $ make -j -C tools perf install
> 
> it knows that you mean the install target of perf. Let me play with it a
> bit ...

Yep, we can do that, below is a possible version:

This way you can do

$ make -j -C tools <tool> install

for example. It cannot handle multiple tools yet, i.e.

$ make -j -C tools <tool1> <tool2> install

because it doesn't seem make a whole lot of sense to me right now
(besides, make is really clumsy for such stuff :)

help is still the default target when you do

$ make -C tools

with no explicit build target.

Hmm...

--
diff --git a/tools/Makefile b/tools/Makefile
index 25566cd74937..03fa9432d54b 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -1,5 +1,11 @@
 include scripts/Makefile.include
 
+TOOL:=perf
+
+ifeq ($(findstring install,$(MAKECMDGOALS)), install)
+	TOOL:=$(filter-out install, $(MAKECMDGOALS))
+endif
+
 help:
 	@echo 'Possible targets:'
 	@echo ''
@@ -13,13 +19,18 @@ help:
 	@echo '  virtio     - vhost test module'
 	@echo '  x86_energy_perf_policy - Intel energy policy tool'
 	@echo ''
+	@echo 'You can do:'
+	@echo ' $$ make -C tools/ <tool> install'
+	@echo ''
+	@echo '  from the kernel command line to build and install one of the tools above'
+	@echo ''
 	@echo 'Cleaning targets:'
 	@echo ''
 	@echo '  all of the above with the "_clean" string appended cleans'
 	@echo '    the respective build directory.'
-	@echo '  clean: a summary clean target to clean _all_ folders'
+	@echo '  cleanall: a summary clean target to clean _all_ folders'
 
-perf firewire lguest slub usb virtio: FORCE
+firewire lguest perf slub usb virtio: FORCE
 	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
 
 cpupower: FORCE
@@ -28,16 +39,31 @@ cpupower: FORCE
 turbostat x86_energy_perf_policy: FORCE
 	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
 
+install: $(TOOL)
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
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
