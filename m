Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0HSLXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:23:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:51912 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0HSLXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:23:05 -0400
Date: Thu, 19 Aug 2010 11:22:11 GMT
From: tip-bot for Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        slash@ac.auone-net.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, slash@ac.auone-net.jp,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100817140841.0859362C03A@msa106.auone-net.jp>
References: <20100817140841.0859362C03A@msa106.auone-net.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix build error on read only source.
Message-ID: <tip-ecafda60e88031bcc4271c446f984ee883d69ea8@git.kernel.org>
Git-Commit-ID: ecafda60e88031bcc4271c446f984ee883d69ea8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 11:22:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ecafda60e88031bcc4271c446f984ee883d69ea8
Gitweb:     http://git.kernel.org/tip/ecafda60e88031bcc4271c446f984ee883d69ea8
Author:     Kusanagi Kouichi <slash@ac.auone-net.jp>
AuthorDate: Wed, 18 Aug 2010 13:32:37 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 18 Aug 2010 13:32:37 -0300

perf tools: Fix build error on read only source.

Parts of the build process were generating files outside the specified
O= directory, causing the build to fail on systems where the sources are
in a read only file system.

Fix it by using $(OUTPUT) on these locations.

Also check that $(OUTPUT) actually exists, just like the top level
kernel Makefile does. Otherwise the failure message emitted is
completely misleading.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20100817140841.0859362C03A@msa106.auone-net.jp>
Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |   14 ++++++++++----
 tools/perf/feature-tests.mak |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dcb9700..4f1fa77 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -5,6 +5,12 @@ endif
 # The default target of this Makefile is...
 all::
 
+ifneq ($(OUTPUT),)
+# check that the output directory actually exists
+OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
+$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
+endif
+
 # Define V=1 to have a more verbose compile.
 # Define V=2 to have an even more verbose compile.
 #
@@ -931,15 +937,15 @@ $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
 	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
 
 $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
-	$(QUIET_GEN)$(RM) $@ $@+ && \
+	$(QUIET_GEN)$(RM) $(OUTPUT)$@ $(OUTPUT)$@+ && \
 	sed -e '1s|#!.*/sh|#!$(SHELL_PATH_SQ)|' \
 	    -e 's|@SHELL_PATH@|$(SHELL_PATH_SQ)|' \
 	    -e 's|@@PERL@@|$(PERL_PATH_SQ)|g' \
 	    -e 's/@@PERF_VERSION@@/$(PERF_VERSION)/g' \
 	    -e 's/@@NO_CURL@@/$(NO_CURL)/g' \
-	    $@.sh >$@+ && \
-	chmod +x $@+ && \
-	mv $@+ $(OUTPUT)$@
+	    $@.sh > $(OUTPUT)$@+ && \
+	chmod +x $(OUTPUT)$@+ && \
+	mv $(OUTPUT)$@+ $(OUTPUT)$@
 
 configure: configure.ac
 	$(QUIET_GEN)$(RM) $@ $<+ && \
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index ddb68e6..7a7b608 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -113,7 +113,7 @@ endef
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options)
 try-cc = $(shell sh -c						  \
-	'TMP="$(TMPOUT).$$$$";			 		  \
+	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
 	 echo "$(1)" |						  \
 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
 	 rm -f "$$TMP"')
