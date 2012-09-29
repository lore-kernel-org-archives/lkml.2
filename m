Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2I2SNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 14:13:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:11229 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab2I2SNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 14:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,508,1344236400"; 
   d="scan'208";a="198768493"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Add library dependencies for static perf link
Date: Sat, 29 Sep 2012 11:13:48 -0700
Message-Id: <1348942428-29688-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When linking perf statically some of the library dependencies are always
rejected, so libdwarf and libbfd do not work.  The problem is that these
libraries (at least on my system) require other libraries. But unlike
a shared link the static link doesn't find those by itself, and they
have to be explicitely specified.

In my case I needed -ldl -lz for libbfd and -lslang for -lnewt

Add those to the probe statements.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 35655c3..a79c702 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -491,7 +491,7 @@ endif # NO_DWARF
 ifdef NO_NEWT
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 else
-	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
+	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt -lslang
 	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
 		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
 		BASIC_CFLAGS += -DNO_NEWT_SUPPORT
@@ -644,20 +644,20 @@ else
 		EXTLIBS += -liberty
 		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
         else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
+		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -ldl
 		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
 		ifeq ($(has_bfd),y)
-			EXTLIBS += -lbfd
+			EXTLIBS += -lbfd -ldl
 		else
-			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
+			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty -ldl
 			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
 			ifeq ($(has_bfd_iberty),y)
-				EXTLIBS += -lbfd -liberty
+				EXTLIBS += -lbfd -liberty -ldl
 			else
-				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
+				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz -ldl
 				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z))
 				ifeq ($(has_bfd_iberty_z),y)
-					EXTLIBS += -lbfd -liberty -lz
+					EXTLIBS += -lbfd -liberty -lz -ldl
 				else
 					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
 					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE))
-- 
1.7.7.6

