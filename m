Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0GFPn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:43:27 -0400
Received: from osrc3.amd.com ([217.9.48.20]:51344 "EHLO hernando.osrc.amd.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754767Ab0GFPnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:43:24 -0400
From: Conny Seidel <conny.seidel@amd.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       borislav.petkov@amd.com, Conny Seidel <conny.seidel@amd.com>
Subject: [PATCH tip/perf/urgent] perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available
Date: Tue,  6 Jul 2010 17:39:43 +0200
Message-Id: <1278430783-17259-1-git-send-email-conny.seidel@amd.com>
X-Mailer: git-send-email 1.7.2.rc0.13.gc9eaa
In-Reply-To: <20100706134348.GC26192@ghostprotocols.net>
References: <20100706134348.GC26192@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make version 3.80 doesn't support "else ifdef" on the same line, also it
doesn't support unindented nested constructs.

Build fails with:
Makefile:608: Extraneous text after `else' directive
Makefile:611: *** only one `else' per conditional.  Stop.

This patch fixes the build for make 3.80.

Signed-off-by: Conny Seidel <conny.seidel@amd.com>
---
 
 This is the version against tip/perf/urgent since my prior patch didn't
 apply against it.


 tools/perf/Makefile |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3d8f31e..772ad08 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -600,30 +600,32 @@ endif
 
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
-else ifdef HAVE_CPLUS_DEMANGLE
-	EXTLIBS += -liberty
-	BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-else
-	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
-
-	ifeq ($(has_bfd),y)
-		EXTLIBS += -lbfd
+else 
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
1.7.2.rc0.13.gc9eaa

