Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab0HRWSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:18:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0HRWSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:18:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Bernd Petrovitsch <bernd@sysprog.at>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf tools: Fix build error on read only source.
Date: Wed, 18 Aug 2010 19:18:18 -0300
Message-Id: <1282169898-28321-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282169898-28321-1-git-send-email-acme@infradead.org>
References: <1282169898-28321-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kusanagi Kouichi <slash@ac.auone-net.jp>

Parts of the build process were generating files outside the specified
O= directory, causing the build to fail on systems where the sources are
in a read only file system.

Fix it by using $(OUTPUT) on these locations.

Also check that $(OUTPUT) actually exists, just like the top level
kernel Makefile does. Otherwise the failure message emitted is
completely misleading.

Cc: Bernd Petrovitsch <bernd@sysprog.at>
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
-- 
1.6.2.5

