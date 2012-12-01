Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2LALQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:16:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42971 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2LALQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:16:43 -0500
Date: Sat, 1 Dec 2012 03:16:14 -0800
From: tip-bot for David Howells <dhowells@redhat.com>
Message-ID: <tip-bf35182ffcd00d8b36d56210ffdac110e5624d7d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        namhyung@gmail.com, bp@amd64.org, dhowells@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, bp@amd64.org, namhyung@gmail.com,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <1378.1352379110@warthog.procyon.org.uk>
References: <1378.1352379110@warthog.procyon.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Honour the O=
  flag when tool build called from a higher Makefile
Git-Commit-ID: bf35182ffcd00d8b36d56210ffdac110e5624d7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 01 Dec 2012 03:16:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf35182ffcd00d8b36d56210ffdac110e5624d7d
Gitweb:     http://git.kernel.org/tip/bf35182ffcd00d8b36d56210ffdac110e5624d7d
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Mon, 5 Nov 2012 21:02:08 +0000
Committer:  David Howells <dhowells@redhat.com>
CommitDate: Mon, 19 Nov 2012 22:10:30 +0000

tools: Honour the O= flag when tool build called from a higher Makefile

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
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1378.1352379110@warthog.procyon.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile                       |  6 ++++--
 tools/scripts/Makefile.include | 17 +++++++++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 42d0e56..71dc31e 100644
--- a/Makefile
+++ b/Makefile
@@ -1321,10 +1321,12 @@ kernelversion:
 
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
index 4a9e317..87467b1 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,8 +1,11 @@
-ifeq ("$(origin O)", "command line")
+ifeq ($(origin O), command line)
 	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
 	ABSOLUTE_O := $(shell cd $(O) ; pwd)
-	OUTPUT := $(ABSOLUTE_O)/
+	OUTPUT := $(ABSOLUTE_O)/$(if $(subdir),$(subdir)/)
 	COMMAND_O := O=$(ABSOLUTE_O)
+ifeq ($(objtree),)
+	objtree := $(O)
+endif
 endif
 
 ifneq ($(OUTPUT),)
@@ -47,9 +50,10 @@ endif
 # Call by doing: $(call descend,directory[,target])
 #
 descend = \
-	$(QUIET_SUBDIR0)$(1) $(QUIET_SUBDIR1) $(2)
+	+mkdir -p $(OUTPUT)$(1) && \
+	$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1)
 
-QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
@@ -64,5 +68,10 @@ ifndef V
 			 $(MAKE) $(PRINT_DIR) -C $$subdir
 	QUIET_FLEX     = @echo '   ' FLEX $@;
 	QUIET_BISON    = @echo '   ' BISON $@;
+
+	descend = \
+		@echo '   ' DESCEND $(1); \
+		mkdir -p $(OUTPUT)$(1) && \
+		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1)
 endif
 endif
