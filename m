Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2JZI4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:56:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61903 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab2JZI4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:56:32 -0400
X-AuditID: 9c930179-b7c8bae000003559-4f-508a503e4d6f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH RESEND 1/5] tools lib traceevent: Do not generate dependency for system header files
Date: Fri, 26 Oct 2012 17:55:48 +0900
Message-Id: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo reported (again!) that 'make clean' on perf/traceevent does not
work due to some reason with system header file. Quotes Ingo:

 "Note that the old dependency related build failure thought to be
  fixed in commit 860df5833e46 is back:

   make[1]: *** No rule to make target
   `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', needed by `.trace-seq.d'.  Stop.

  'make clean' itself does not work in libtraceevent:

   comet:~/tip/tools/lib/traceevent> make clean
   make: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', needed by `.trace-seq.d'.  Stop.

  So I had to clean it out manually:

   comet:~/tip/tools/lib/traceevent> git ls-files --others | xargs rm
   comet:~/tip/tools/lib/traceevent>

  and then things build fine."

Try to fix it by excluding system headers from dependency generation.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@amd64.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 04d959fa0226..a20e32033431 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -253,7 +253,7 @@ all_deps := $(all_objs:%.o=.%.d)
 # let .d file also depends on the source and header files
 define check_deps
 		@set -e; $(RM) $@; \
-		$(CC) -M $(CFLAGS) $< > $@.$$$$; \
+		$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
 		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
 		$(RM) $@.$$$$
 endef
-- 
1.7.11.7

