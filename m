Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab0GESLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:11:31 -0400
Received: from osrc3.amd.com ([217.9.48.20]:48744 "EHLO hernando.osrc.amd.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754051Ab0GESLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:11:30 -0400
From: Conny Seidel <conny.seidel@amd.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
       Conny Seidel <conny.seidel@amd.com>
Subject: [PATCH] perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available
Date: Mon,  5 Jul 2010 20:07:30 +0200
Message-Id: <1278353250-28490-1-git-send-email-conny.seidel@amd.com>
X-Mailer: git-send-email 1.7.2.rc0.13.gc9eaa
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
 tools/perf/Makefile |   50 ++++++++++++++++++++++++++------------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 17a3692..74fa34f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -605,33 +605,35 @@ endif
 
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
-else ifdef HAVE_CPLUS_DEMANGLE
-	EXTLIBS += -liberty
-	BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-else
-	FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
-	has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
-	ifeq ($(has_bfd),y)
-		EXTLIBS += -lbfd
-	else
-		FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-		has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
-		ifeq ($(has_bfd_iberty),y)
-			EXTLIBS += -lbfd -liberty
+else 
+        ifdef HAVE_CPLUS_DEMANGLE
+		EXTLIBS += -liberty
+		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+        else
+		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
+		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
+		ifeq ($(has_bfd),y)
+			EXTLIBS += -lbfd
 		else
-			FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
-			has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z))
-			ifeq ($(has_bfd_iberty_z),y)
-				EXTLIBS += -lbfd -liberty -lz
+			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
+			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
+			ifeq ($(has_bfd_iberty),y)
+				EXTLIBS += -lbfd -liberty
 			else
-				FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
-				has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE))
-				ifeq ($(has_cplus_demangle),y)
-					EXTLIBS += -liberty
-					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
+				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z))
+				ifeq ($(has_bfd_iberty_z),y)
+					EXTLIBS += -lbfd -liberty -lz
 				else
-					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-					BASIC_CFLAGS += -DNO_DEMANGLE
+					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
+					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE))
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

