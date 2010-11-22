Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0KVQeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:34:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:40605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0KVQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:34:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eugene Teo <eugeneteo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Stephane Eranian <eranian@google.com>, Tejun Heo <tj@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/1] perf record: Handle restrictive permissions in /proc/{kallsyms,modules}
Date: Mon, 22 Nov 2010 14:33:39 -0200
Message-Id: <1290443619-17379-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290443619-17379-1-git-send-email-acme@infradead.org>
References: <1290443619-17379-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The 59365d1 commit, even being reverted by 33e0d57, showed a non robust
behavior in 'perf record': it really should just warn the user that some
functionality will not be available.

The new behavior then becomes:

	[acme@felicio linux]$ ls -la /proc/{kallsyms,modules}
	-r-------- 1 root root 0 Nov 22 12:19 /proc/kallsyms
	-r-------- 1 root root 0 Nov 22 12:19 /proc/modules
	[acme@felicio linux]$ perf record ls -R > /dev/null
	Couldn't record kernel reference relocation symbol
	Symbol resolution may be skewed if relocation was used (e.g. kexec).
	Check /proc/kallsyms permission or run as root.
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.004 MB perf.data (~161 samples) ]
	[acme@felicio linux]$ perf report --stdio
	[kernel.kallsyms] with build id 77b05e00e64e4de1c9347d83879779b540d69f00 not found, continuing without symbols
	# Events: 98  cycles
	#
	# Overhead  Command    Shared Object                Symbol
	# ........  .......  ...............  ....................
	#
	    48.26%       ls  [kernel]         [k] ffffffff8102b92b
	    22.49%       ls  libc-2.12.90.so  [.] __strlen_sse2
	     8.35%       ls  libc-2.12.90.so  [.] __GI___strcoll_l
	     8.17%       ls  ls               [.]            11580
	     3.35%       ls  libc-2.12.90.so  [.] _IO_new_file_xsputn
	     3.33%       ls  libc-2.12.90.so  [.] _int_malloc
	     1.88%       ls  libc-2.12.90.so  [.] _int_free
	     0.84%       ls  libc-2.12.90.so  [.] malloc_consolidate
	     0.84%       ls  libc-2.12.90.so  [.] __readdir64
	     0.83%       ls  ls               [.] strlen@plt
	     0.83%       ls  libc-2.12.90.so  [.] __GI_fwrite_unlocked
	     0.83%       ls  libc-2.12.90.so  [.] __memcpy_sse2

	#
	# (For a higher level overview, try: perf report --sort comm,dso)
	#
[acme@felicio linux]$

It still has the build-ids for DSOs in the maps with hits:

[acme@felicio linux]$ perf buildid-list
77b05e00e64e4de1c9347d83879779b540d69f00 [kernel.kallsyms]
09c4a431a4a8b648fcfc2c2bdda70f56050ddff1 /bin/ls
af75ea9ad951d25e0f038901a11b3846dccb29a4 /lib64/libc-2.12.90.so
[acme@felicio linux]$

That can be used in another machine to resolve kernel symbols.

Cc: Eugene Teo <eugeneteo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcus Meissner <meissner@suse.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 93bd2ff..e2c2de2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -697,17 +697,18 @@ static int __cmd_record(int argc, const char **argv)
 	if (err < 0)
 		err = event__synthesize_kernel_mmap(process_synthesized_event,
 						    session, machine, "_stext");
-	if (err < 0) {
-		pr_err("Couldn't record kernel reference relocation symbol.\n");
-		return err;
-	}
+	if (err < 0)
+		pr_err("Couldn't record kernel reference relocation symbol\n"
+		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
+		       "Check /proc/kallsyms permission or run as root.\n");
 
 	err = event__synthesize_modules(process_synthesized_event,
 					session, machine);
-	if (err < 0) {
-		pr_err("Couldn't record kernel reference relocation symbol.\n");
-		return err;
-	}
+	if (err < 0)
+		pr_err("Couldn't record kernel module information.\n"
+		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
+		       "Check /proc/modules permission or run as root.\n");
+
 	if (perf_guest)
 		perf_session__process_machines(session, event__synthesize_guest_os);
 
-- 
1.6.2.5

