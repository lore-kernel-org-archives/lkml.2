Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282Ab2FVFm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:42:58 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43654 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761217Ab2FVFlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:41:25 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-75-4fe40583574d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/8] tools lib traceevent: Detect build environment changes
Date: Fri, 22 Jun 2012 14:37:37 +0900
Message-Id: <1340343462-15556-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Cross compiling perf requires setting ARCH and
CROSS_COMPILE variables, but libtraceevent couldn't
detect the changes so it ends up believing no
recompiling is required. Thus the linker failed like:

     LINK perf
 ../lib/traceevent//libtraceevent.a: member ../lib/traceevent//libtraceevent.a(event-parse.o) in archive is not an object
 collect2: ld returned 1 exit status
 make: *** [perf] Error 1

This patch fixes this by adding TRACEEVENT-CFLAGS
file like PERF-CFLAGS to track those changes.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 68a1d088d77e..56daa768b9e3 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -207,7 +207,7 @@ libtraceevent.so: $(PEVENT_LIB_OBJS)
 libtraceevent.a: $(PEVENT_LIB_OBJS)
 	$(Q)$(do_build_static_lib)
 
-$(PEVENT_LIB_OBJS): %.o: $(src)/%.c
+$(PEVENT_LIB_OBJS): %.o: $(src)/%.c TRACEEVENT-CFLAGS
 	$(Q)$(do_fpic_compile)
 
 define make_version.h
@@ -272,6 +272,16 @@ ifneq ($(dep_includes),)
  include $(dep_includes)
 endif
 
+### Detect environment changes
+TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
+
+TRACEEVENT-CFLAGS: force
+	@FLAGS='$(TRACK_CFLAGS)'; \
+	    if test x"$$FLAGS" != x"`cat TRACEEVENT-CFLAGS 2>/dev/null`" ; then \
+		echo 1>&2 "    * new build flags or cross compiler"; \
+		echo "$$FLAGS" >TRACEEVENT-CFLAGS; \
+            fi
+
 tags:	force
 	$(RM) tags
 	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px
-- 
1.7.10.2

