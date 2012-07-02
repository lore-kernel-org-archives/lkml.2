Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab2GBUWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:22:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48029 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab2GBUTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:19:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/13] tools lib traceevent: Make dependency files regeneratable
Date: Mon,  2 Jul 2012 17:18:41 -0300
Message-Id: <1341260331-10204-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341260331-10204-1-git-send-email-acme@infradead.org>
References: <1341260331-10204-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Ingo reported that libtraceevent doesn't clean out dependency (.d) files
and it can cause a build error when the libgcc package upgraded:

 comet:~/tip/tools/perf> make -j
     SUBDIR ../lib/traceevent/
 make[1]: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h',
  needed by `event-parse.o'.  Stop.
 make: *** [../lib/traceevent//libtraceevent.a] Error 2

So this patch makes the .d files depends on the source and header files
also, so that it can be re-generated as needed.

NOTE: This code is copied from the GNU make manual page
(4.14 Generating Prerequisites Automatically).

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1340343462-15556-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 34a577e..46c2f6b 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -250,8 +250,12 @@ endef
 all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:%.o=.%.d)
 
+# let .d file also depends on the source and header files
 define check_deps
-		$(CC) -M $(CFLAGS) $< > $@;
+		@set -e; $(RM) $@; \
+		$(CC) -M $(CFLAGS) $< > $@.$$$$; \
+		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
+		$(RM) $@.$$$$
 endef
 
 $(gui_deps): ks_version.h
-- 
1.7.9.2.358.g22243

