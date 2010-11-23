Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab0KWTwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:52:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:56278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab0KWTwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:52:34 -0500
Date: Tue, 23 Nov 2010 19:51:44 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: eranian@google.com, acme@redhat.com, mingo@redhat.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        jj@chaosbits.net, tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        sarah.a.sharp@linux.intel.com, eugeneteo@kernel.org, tj@kernel.org,
        meissner@suse.de, mingo@elte.hu
Reply-To: mingo@redhat.com, acme@redhat.com, eranian@google.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, jj@chaosbits.net,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        sarah.a.sharp@linux.intel.com, eugeneteo@kernel.org, tj@kernel.org,
        meissner@suse.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Handle restrictive permissions in /proc/{kallsyms,modules}
Message-ID: <tip-c1a3a4b90a5a47adcca0e587f5d7e9ea61329b26@git.kernel.org>
Git-Commit-ID: c1a3a4b90a5a47adcca0e587f5d7e9ea61329b26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Nov 2010 19:51:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1a3a4b90a5a47adcca0e587f5d7e9ea61329b26
Gitweb:     http://git.kernel.org/tip/c1a3a4b90a5a47adcca0e587f5d7e9ea61329b26
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 22 Nov 2010 14:01:55 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Nov 2010 14:01:55 -0200

perf record: Handle restrictive permissions in /proc/{kallsyms,modules}

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
 
