Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0GVUhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:37:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0GVUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:37:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Conny Seidel <conny.seidel@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <borislav.petkov@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available
Date: Thu, 22 Jul 2010 17:36:57 -0300
Message-Id: <1279831017-26967-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279831017-26967-1-git-send-email-acme@infradead.org>
References: <1279831017-26967-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Conny Seidel <conny.seidel@amd.com>

make version 3.80 doesn't support "else ifdef" on the same line, also it
doesn't support unindented nested constructs.

Build fails with:
Makefile:608: Extraneous text after `else' directive
Makefile:611: *** only one `else' per conditional.  Stop.

This patch fixes the build for make 3.80.

Cc: Ingo Molnar <mingo@elte.hu>,
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1278430783-17259-1-git-send-email-conny.seidel@amd.com>
Signed-off-by: Conny Seidel <conny.seidel@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3d8f31e..d75c28a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -600,30 +600,32 @@ endif
 
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
-else ifdef HAVE_CPLUS_DEMANGLE
-	EXTLIBS += -liberty
-	BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 else
-	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
-
-	ifeq ($(has_bfd),y)
-		EXTLIBS += -lbfd
+	ifdef HAVE_CPLUS_DEMANGLE
+		EXTLIBS += -liberty
+		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 	else
-		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty "$(QUIET_STDERR)" && echo y")
-		ifeq ($(has_bfd_iberty),y)
-			EXTLIBS += -lbfd -liberty
+		has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
+
+		ifeq ($(has_bfd),y)
+			EXTLIBS += -lbfd
 		else
-			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty -lz "$(QUIET_STDERR)" && echo y")
-			ifeq ($(has_bfd_iberty_z),y)
-				EXTLIBS += -lbfd -liberty -lz
+			has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty "$(QUIET_STDERR)" && echo y")
+			ifeq ($(has_bfd_iberty),y)
+				EXTLIBS += -lbfd -liberty
 			else
-				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -liberty "$(QUIET_STDERR)" && echo y")
-				ifeq ($(has_cplus_demangle),y)
-					EXTLIBS += -liberty
-					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+				has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty -lz "$(QUIET_STDERR)" && echo y")
+				ifeq ($(has_bfd_iberty_z),y)
+					EXTLIBS += -lbfd -liberty -lz
 				else
-					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-					BASIC_CFLAGS += -DNO_DEMANGLE
+					has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -liberty "$(QUIET_STDERR)" && echo y")
+					ifeq ($(has_cplus_demangle),y)
+						EXTLIBS += -liberty
+						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+					else
+						msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
+						BASIC_CFLAGS += -DNO_DEMANGLE
+					endif
 				endif
 			endif
 		endif
-- 
1.6.2.5

