Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422676Ab2JXVuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:50:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:40935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161325Ab2JXVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:50:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/12] perf tools: Try to build Documentation when installing
Date: Wed, 24 Oct 2012 19:50:23 -0200
Message-Id: <1351115423-9025-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351115423-9025-1-git-send-email-acme@infradead.org>
References: <1351115423-9025-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

There's a portion in the "perf list" output refering to the exact
specification of raw hardware events.

Since this description is in the perf-list manpage, try to build and
install the man pages, warning the user when that is not possible
due to missing packages (xmlto and asciidoc).

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/tip-ij71ysszkdvz3fy3wr331bke@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile |   31 +++++++++++++++++++++++++++++--
 tools/perf/Makefile               |    5 ++++-
 tools/perf/util/parse-events.c    |    2 +-
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 9f2e44f..ef6d22e 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -1,3 +1,5 @@
+include ../config/utilities.mak
+
 OUTPUT := ./
 ifeq ("$(origin O)", "command line")
   ifneq ($(O),)
@@ -64,6 +66,7 @@ MAKEINFO=makeinfo
 INSTALL_INFO=install-info
 DOCBOOK2X_TEXI=docbook2x-texi
 DBLATEX=dblatex
+XMLTO=xmlto
 ifndef PERL_PATH
 	PERL_PATH = /usr/bin/perl
 endif
@@ -71,6 +74,16 @@ endif
 -include ../config.mak.autogen
 -include ../config.mak
 
+_tmp_tool_path := $(call get-executable,$(ASCIIDOC))
+ifeq ($(_tmp_tool_path),)
+	missing_tools = $(ASCIIDOC)
+endif
+
+_tmp_tool_path := $(call get-executable,$(XMLTO))
+ifeq ($(_tmp_tool_path),)
+	missing_tools += $(XMLTO)
+endif
+
 #
 # For asciidoc ...
 #	-7.1.2,	no extra settings are needed.
@@ -170,7 +183,12 @@ pdf: $(OUTPUT)user-manual.pdf
 
 install: install-man
 
-install-man: man
+check-man-tools:
+ifdef missing_tools
+	$(error "You need to install $(missing_tools) for man pages")
+endif
+
+do-install-man: man
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man1dir)
 #	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
 #	$(INSTALL) -d -m 755 $(DESTDIR)$(man7dir)
@@ -178,6 +196,15 @@ install-man: man
 #	$(INSTALL) -m 644 $(DOC_MAN5) $(DESTDIR)$(man5dir)
 #	$(INSTALL) -m 644 $(DOC_MAN7) $(DESTDIR)$(man7dir)
 
+install-man: check-man-tools man
+
+try-install-man:
+ifdef missing_tools
+	$(warning Please install $(missing_tools) to have the man pages installed)
+else
+	$(MAKE) do-install-man
+endif
+
 install-info: info
 	$(INSTALL) -d -m 755 $(DESTDIR)$(infodir)
 	$(INSTALL) -m 644 $(OUTPUT)perf.info $(OUTPUT)perfman.info $(DESTDIR)$(infodir)
@@ -246,7 +273,7 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
 
 $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
-	xmlto -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+	$(XMLTO) -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
 
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 78a81ed..b14eeb8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1041,7 +1041,7 @@ perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
 perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
 
-install: all
+install: all try-install-man
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
@@ -1067,6 +1067,9 @@ install-doc:
 install-man:
 	$(MAKE) -C Documentation install-man
 
+try-install-man:
+	$(MAKE) -C Documentation try-install-man
+
 install-html:
 	$(MAKE) -C Documentation install-html
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2fe1587..3a3efcf 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1081,7 +1081,7 @@ void print_events(const char *event_glob, bool name_only)
 		printf("  %-50s [%s]\n",
 		       "cpu/t1=v1[,t2=v2,t3 ...]/modifier",
 		       event_type_descriptors[PERF_TYPE_RAW]);
-		printf("   (see 'perf list --help' on how to encode it)\n");
+		printf("   (see 'man perf-list' on how to encode it)\n");
 		printf("\n");
 
 		printf("  %-50s [%s]\n",
-- 
1.7.9.2.358.g22243

