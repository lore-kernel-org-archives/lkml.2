Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2GYRl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:41:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55663 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2GYRlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/19] tools lib traceevent: Detect build environment changes
Date: Wed, 25 Jul 2012 14:41:32 -0300
Message-Id: <1343238094-12481-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Cross compiling perf requires setting ARCH and CROSS_COMPILE variables,
but libtraceevent couldn't detect the changes so it ends up believing no
recompiling is required. Thus the linker failed like:

     LINK perf
 ../lib/traceevent//libtraceevent.a: member ../lib/traceevent//libtraceevent.a(event-parse.o) in archive is not an object
 collect2: ld returned 1 exit status
 make: *** [perf] Error 1

This patch fixes this by adding TRACEEVENT-CFLAGS file like
PERF-CFLAGS to track those changes.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1341559297-25725-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 46c2f6b..14131cb 100644
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
 	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
@@ -297,7 +307,7 @@ install: install_lib
 
 clean:
 	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d
-	$(RM) tags TAGS
+	$(RM) TRACEEVENT-CFLAGS tags TAGS
 
 endif # skip-makefile
 
-- 
1.7.1

