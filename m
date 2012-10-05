Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2JEIoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:44:46 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59764 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab2JEIol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:44:41 -0400
X-AuditID: 9c93016f-b7b1eae000000815-5c-506e9df604d5
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Dong Hao <haodong@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] tools lib traceevent: Do not generate dependency for system header files
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
	<20121005081804.GA685@gmail.com>
Date: Fri, 05 Oct 2012 17:35:13 +0900
In-Reply-To: <20121005081804.GA685@gmail.com> (Ingo Molnar's message of "Fri,
	5 Oct 2012 10:18:04 +0200")
Message-ID: <87haq9jozi.fsf_-_@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
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
1.7.11.4

