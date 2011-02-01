Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1BARaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:30:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58553 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab1BARaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:30:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf tools: Remove verbose build messages for the python binding
Date: Tue,  1 Feb 2011 15:29:54 -0200
Message-Id: <1296581395-30663-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296581395-30663-1-git-send-email-acme@infradead.org>
References: <1296581395-30663-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Also now it builds it in a well known location:

[acme@felicio linux]$ rm -rf ../build/perf/
[acme@felicio linux]$ mkdir ../build/perf
[acme@felicio linux]$ make -j2 O=~acme/git/build/perf -C tools/perf/
<SNIP>
[acme@felicio linux]$ ls -la ../build/perf/python/
total 152
-rwxrwxr-x 1 acme acme 147957 Feb  1 14:56 perf.so
drwxrwxr-x 3 acme acme     17 Feb  1 14:56 temp
[acme@felicio linux]$

[root@felicio ~]# strip ~acme/git/build/perf/python/perf.so
[root@felicio ~]# ls -la ~acme/git/build/perf/python/perf.so
-rwxrwxr-x 1 acme acme 46264 Feb  1 14:58 /home/acme/git/build/perf/python/perf.so

[root@felicio ~]# export PYTHONPATH=~acme/git/build/perf/python/
[root@felicio ~]# ~acme/git/linux/tools/perf/python/twatch.py
cpu:  0, pid: 7751, tid: 7751 { type: exit, pid: 7751, ppid: 7751, tid: 7751, ptid: 7751, time: 54562393512356}
cpu:  0, pid: 13700, tid: 13700 { type: fork, pid: 7756, ppid: 13700, tid: 7756, ptid: 13700, time: 54562393746739}
cpu:  1, pid: 7756, tid: 7756 { type: fork, pid: 7757, ppid: 7756, tid: 7757, ptid: 7756, time: 54562394246152}
cpu:  1, pid: 7757, tid: 7757 { type: comm, pid: 7757, tid: 7757, comm: awk }
cpu:  1, pid: 7757, tid: 7757 { type: exit, pid: 7757, ppid: 7757, tid: 7757, ptid: 7757, time: 54562395456813}

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 67a9f4d..d1984ee 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -325,9 +325,9 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-pyrf: $(PYRF_OBJS)
-	python util/setup.py build --build-base='$(OUTPUT)'
-
+$(OUTPUT)python/perf.so: $(PYRF_OBJS)
+	@python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
+						--build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
 #
@@ -348,12 +348,14 @@ PROGRAMS += $(EXTRA_PROGRAMS)
 #
 PROGRAMS += $(OUTPUT)perf
 
+LANG_BINDINGS = $(OUTPUT)python/perf.so
+
 # List built-in command $C whose implementation cmd_$C() is not in
 # builtin-$C.o but is linked in as part of some other command.
 #
 
 # what 'all' will build and 'install' will install, in perfexecdir
-ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS) pyrf
+ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS) $(LANG_BINDINGS)
 
 # what 'all' will build but not install in perfexecdir
 OTHER_PROGRAMS = $(OUTPUT)perf$X
@@ -1298,6 +1300,8 @@ clean:
 	$(RM) $(htmldocs).tar.gz $(manpages).tar.gz
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-BUILD-OPTIONS
+	@python util/setup.py clean --build-lib='$(OUTPUT)python' \
+				   --build-temp='$(OUTPUT)python/temp'
 
 .PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-- 
1.6.2.5

