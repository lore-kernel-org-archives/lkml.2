Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0GVLwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:52:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:40485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab0GVLwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:52:04 -0400
Date: Thu, 22 Jul 2010 11:51:39 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        zeev.tarantov@gmail.com, sam@ravnborg.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, zeev.tarantov@gmail.com, rostedt@goodmis.org,
        sam@ravnborg.org, tglx@linutronix.de
In-Reply-To: <20100710063459.GA14596@merkur.ravnborg.org>
References: <20100710063459.GA14596@merkur.ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Properly align linker defined symbols
Message-ID: <tip-07fca0e57fca925032526349f4370f97ed580cc9@git.kernel.org>
Git-Commit-ID: 07fca0e57fca925032526349f4370f97ed580cc9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 11:51:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07fca0e57fca925032526349f4370f97ed580cc9
Gitweb:     http://git.kernel.org/tip/07fca0e57fca925032526349f4370f97ed580cc9
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Sat, 10 Jul 2010 08:35:00 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 20 Jul 2010 19:02:52 -0400

tracing: Properly align linker defined symbols

We define a number of symbols in the linker scipt like this:

    __start_syscalls_metadata = .;
    *(__syscalls_metadata)

But we do not know the alignment of "." when we assign
the __start_syscalls_metadata symbol.
gcc started to uses bigger alignment for structs (32 bytes),
so we saw situations where the linker due to alignment
constraints increased the value of "." after the symbol assignment.

This resulted in boot fails.

Fix this by forcing a 32 byte alignment of "." before the
assignment.

This patch introduces the forced alignment for
ftrace_events and syscalls_metadata.
It may be required in more places.

Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <20100710063459.GA14596@merkur.ravnborg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..4b5902a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -63,6 +63,12 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
+/*
+ * Align to a 32 byte boundary equal to the
+ * alignment gcc 4.5 uses for a struct
+ */
+#define STRUCT_ALIGN() . = ALIGN(32)
+
 /* The actual configuration determine if the init/exit sections
  * are handled as text/data or they can be discarded (which
  * often happens at runtime)
@@ -166,7 +172,11 @@
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
+									\
+	STRUCT_ALIGN();							\
 	FTRACE_EVENTS()							\
+									\
+	STRUCT_ALIGN();							\
 	TRACE_SYSCALLS()
 
 /*
