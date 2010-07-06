Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab0GFIhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:37:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:50723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0GFIhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:37:04 -0400
Date: Tue, 6 Jul 2010 08:36:44 GMT
From: tip-bot for Conny Seidel <conny.seidel@amd.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, conny.seidel@amd.com, tglx@linutronix.de,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       acme@redhat.com, conny.seidel@amd.com, tglx@linutronix.de,
       borislav.petkov@amd.com
In-Reply-To: <1277990366-1462-1-git-send-email-conny.seidel@amd.com>
References: <1277990366-1462-1-git-send-email-conny.seidel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available
Message-ID: <tip-167a58f10d9cd1bdf6a911aa1eecbdff596de156@git.kernel.org>
Git-Commit-ID: 167a58f10d9cd1bdf6a911aa1eecbdff596de156
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Jul 2010 08:36:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  167a58f10d9cd1bdf6a911aa1eecbdff596de156
Gitweb:     http://git.kernel.org/tip/167a58f10d9cd1bdf6a911aa1eecbdff596de156
Author:     Conny Seidel <conny.seidel@amd.com>
AuthorDate: Thu, 1 Jul 2010 15:19:26 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 2 Jul 2010 10:01:58 -0300

perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available

make version 3.80 doesn't support "else ifdef" on the same line, also it
doesn't support unindented nested constructs.

Build fails with:
Makefile:608: Extraneous text after `else' directive
Makefile:611: *** only one `else' per conditional.  Stop.

This patch fixes the build for make 3.80.

Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1277990366-1462-1-git-send-email-conny.seidel@amd.com>
Signed-off-by: Conny Seidel <conny.seidel@.amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   48 +++++++++++++++++++++++++-----------------------
 1 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 17a3692..26f626d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -605,33 +605,35 @@ endif
 
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
-else ifdef HAVE_CPLUS_DEMANGLE
-	EXTLIBS += -liberty
-	BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 else
-	FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
-	has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
-	ifeq ($(has_bfd),y)
-		EXTLIBS += -lbfd
-	else
-		FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-		has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
-		ifeq ($(has_bfd_iberty),y)
-			EXTLIBS += -lbfd -liberty
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
