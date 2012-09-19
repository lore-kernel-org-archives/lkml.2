Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2ISH3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:29:10 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52493 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2ISH3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:29:07 -0400
Date: Wed, 19 Sep 2012 09:29:02 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] Perf: bfd.h/libbfd detection fails with recent binutils
Message-ID: <20120919072902.GA262@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent binutils I get:

 perf % make
Makefile:668: No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demanglin

That happens because bfd.h now contains:

#if !defined PACKAGE && !defined PACKAGE_VERSION
#error config.h must be included before this header
#endif

I've reopened a bug in the hope that this check will be deleted:
http://sourceware.org/bugzilla/show_bug.cgi?id=14243

But in the meantime, the following patch fixes the problem

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 35655c3..5604664 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -644,7 +644,7 @@ else
 		EXTLIBS += -liberty
 		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
         else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
+		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
 		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
 		ifeq ($(has_bfd),y)
 			EXTLIBS += -lbfd
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1fe733a..50a0912 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -26,6 +26,7 @@ static inline char *bfd_demangle(void __used *v, const char __used *c,
 	return NULL;
 }
 #else
+#define PACKAGE 'perf'
 #include <bfd.h>
 #endif
 #endif

-- 
Markus
