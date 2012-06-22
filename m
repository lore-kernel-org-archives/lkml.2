Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265Ab2FVFmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:42:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47475 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761219Ab2FVFlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:41:25 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-74-4fe405837080
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/8] tools lib traceevent: Make dependency files regeneratable
Date: Fri, 22 Jun 2012 14:37:36 +0900
Message-Id: <1340343462-15556-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Ingo reported that libtraceevent doesn't clean out
dependency (.d) files and it can cause a build error
when the libgcc package upgraded:

 comet:~/tip/tools/perf> make -j
     SUBDIR ../lib/traceevent/
 make[1]: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h',
  needed by `event-parse.o'.  Stop.
 make: *** [../lib/traceevent//libtraceevent.a] Error 2

So this patch makes the .d files depends on the source
and header files also, so that it can be re-generated
as needed.

NOTE: This code is copied from the GNU make manual page
(4.14 Generating Prerequisites Automatically).

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3d69aa9ff51e..68a1d088d77e 100644
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
1.7.10.2

