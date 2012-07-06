Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab2GFKwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:52:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab2GFKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:52:50 -0400
Date: Fri, 6 Jul 2012 03:52:31 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-860df5833e461beba4bf9f3304a7919da98fd789@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1340343462-15556-3-git-send-email-namhyung@kernel.org>
References: <1340343462-15556-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Make dependency files regeneratable
Git-Commit-ID: 860df5833e461beba4bf9f3304a7919da98fd789
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:52:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  860df5833e461beba4bf9f3304a7919da98fd789
Gitweb:     http://git.kernel.org/tip/860df5833e461beba4bf9f3304a7919da98fd789
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 22 Jun 2012 14:37:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:28:12 -0300

tools lib traceevent: Make dependency files regeneratable

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
 1 files changed, 5 insertions(+), 1 deletions(-)

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
