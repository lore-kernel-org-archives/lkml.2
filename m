Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030531Ab2JSQ4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030406Ab2JSQ4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:56:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/5] tools: Honour the O= flag when tool build called from a
 higher Makefile
To: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net
Cc: dhowells@redhat.com, davem@davemloft.net, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Fri, 19 Oct 2012 17:56:16 +0100
Message-ID: <20121019165616.23037.35557.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
References: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Honour the O= flag that was passed to a higher level Makefile and then passed
down as part of a tool build.

To make this work, the top-level Makefile passes the original O= flag and
subdir=tools to the tools/Makefile, and that in turn passes
subdir=$(O)/$(subdir)/foodir when building tool foo in directory
$(O)/$(subdir)/foodir (where the intervening slashes aren't added if an
element is missing).

For example, take perf.  This is found in tools/perf/.  Assume we're building
into directory ~/zebra/, so we pass O=~/zebra to make.  Dependening on where
we run the build from, we see:

	make run in dir		$(OUTPUT) dir
	=======================	==================
	linux			~/zebra/tools/perf/
	linux/tools		~/zebra/perf/
	linux/tools/perf	~/zebra/

and if O= is not set, we get:

	make run in dir		$(OUTPUT) dir
	=======================	==================
	linux			linux/tools/perf/
	linux/tools		linux/tools/perf/
	linux/tools/perf	linux/tools/perf/

The output directories are created by the descend function if they don't
already exist.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Makefile                       |    6 ++++--
 tools/scripts/Makefile.include |   12 +++++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 366d0ab..e93ac4d 100644
--- a/Makefile
+++ b/Makefile
@@ -1310,10 +1310,12 @@ kernelversion:
 
 # Clear a bunch of variables before executing the submake
 tools/: FORCE
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
+	$(Q)mkdir -p $(objtree)/tools
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/
 
 tools/%: FORCE
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
+	$(Q)mkdir -p $(objtree)/tools
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/ $*
 
 # Single targets
 # ---------------------------------------------------------------------------
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 4a9e317..357cfea 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,7 +1,7 @@
 ifeq ("$(origin O)", "command line")
 	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
 	ABSOLUTE_O := $(shell cd $(O) ; pwd)
-	OUTPUT := $(ABSOLUTE_O)/
+	OUTPUT := $(ABSOLUTE_O)/$(if $(subdir),$(subdir)/)
 	COMMAND_O := O=$(ABSOLUTE_O)
 endif
 
@@ -47,9 +47,10 @@ endif
 # Call by doing: $(call descend,directory[,target])
 #
 descend = \
-	$(QUIET_SUBDIR0)$(1) $(QUIET_SUBDIR1) $(2)
+	+mkdir -p $(OUTPUT)$(1) && \
+	$(MAKE) $(COMMAND_O) $(if $(subdir),subdir=$(subdir)/$(1)) $(PRINT_DIR) -C $(1)
 
-QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
@@ -64,5 +65,10 @@ ifndef V
 			 $(MAKE) $(PRINT_DIR) -C $$subdir
 	QUIET_FLEX     = @echo '   ' FLEX $@;
 	QUIET_BISON    = @echo '   ' BISON $@;
+
+	descend = \
+		@echo '   ' DESCEND $(1); \
+		mkdir -p $(OUTPUT)$(1) && \
+		$(MAKE) $(COMMAND_O) $(if $(subdir),subdir=$(subdir)/$(1)) $(PRINT_DIR) -C $(1)
 endif
 endif

