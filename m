Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab2JZOcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:32:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:44285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384Ab2JZOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Borislav Petkov <bp@amd64.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/9] tools lib traceevent: Do not generate dependency for system header files
Date: Fri, 26 Oct 2012 12:31:45 -0200
Message-Id: <1351261913-28250-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351261913-28250-1-git-send-email-acme@infradead.org>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1351241752-2919-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 04d959f..a20e320 100644
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
1.7.9.2.358.g22243

