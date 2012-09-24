Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2IXQAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:00:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59048 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2IXQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ingo Molnar <mingo@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/30] perf tools: bfd.h/libbfd detection fails with recent binutils
Date: Mon, 24 Sep 2012 12:59:36 -0300
Message-Id: <1348502384-14442-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Trippelsdorf <markus@trippelsdorf.de>

With recent binutils I get:

 perf % make
Makefile:668: No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demanglin

That happens because bfd.h now contains:

I've reopened a bug in the hope that this check will be deleted:
http://sourceware.org/bugzilla/show_bug.cgi?id=14243

But in the meantime, the following patch fixes the problem

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mackerras <paulus@samba.org>
Link: http://lkml.kernel.org/r/20120919072902.GA262@x4
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    2 +-
 tools/perf/util/symbol.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3ae6a59..251dcd7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -715,7 +715,7 @@ else
 		EXTLIBS += -liberty
 		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
         else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
+		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
 		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
 		ifeq ($(has_bfd),y)
 			EXTLIBS += -lbfd
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 4ff45e3..b441b07 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -34,6 +34,7 @@ static inline char *bfd_demangle(void __maybe_unused *v,
 	return NULL;
 }
 #else
+#define PACKAGE 'perf'
 #include <bfd.h>
 #endif
 #endif
-- 
1.7.1

