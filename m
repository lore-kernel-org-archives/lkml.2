Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030431Ab2JSQ4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:56:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030329Ab2JSQ40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:56:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/5] tools: Define a Makefile function to do subdir processing
To: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net
Cc: dhowells@redhat.com, davem@davemloft.net, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 19 Oct 2012 17:56:07 +0100
Message-ID: <20121019165607.23037.42250.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
References: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a Makefile function that can be called with $(call ...) to wrap the
subdir make invocations in tools/Makefile.

This will allow us in the next patch to insert bits in there to honour O=
flags when called from the top-level Makefile.

Signed-off-by: David Howells <dhowells@redhat.com>
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
 

