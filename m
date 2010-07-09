Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0GIUWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:22:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:52610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab0GIUWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:22:02 -0400
Date: Fri, 9 Jul 2010 20:21:40 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, zeev.tarantov@gmail.com, rostedt@goodmis.org,
       srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       zeev.tarantov@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com>
References: <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Add alignment to syscall metadata declarations
Message-ID: <tip-44a54f787c0abcf75a2ed49b8ec8b2b512468f73@git.kernel.org>
Git-Commit-ID: 44a54f787c0abcf75a2ed49b8ec8b2b512468f73
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Jul 2010 20:21:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44a54f787c0abcf75a2ed49b8ec8b2b512468f73
Gitweb:     http://git.kernel.org/tip/44a54f787c0abcf75a2ed49b8ec8b2b512468f73
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 9 Jul 2010 15:41:44 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 9 Jul 2010 15:53:04 -0400

tracing: Add alignment to syscall metadata declarations

For some reason if we declare a static variable and then assign it
later, and the assignment contains a __attribute__((__aligned__(#))),
some versions of gcc will ignore it.

This caused the syscall meta data to not be compact in its section
and caused a kernel oops when the section was being read.

The fix for these versions of gcc seems to be to add the aligned
attribute to the declaration as well.

This fixes the BZ regression:

  https://bugzilla.kernel.org/show_bug.cgi?id=16353

Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
Tested-by: Zeev Tarantov <zeev.tarantov@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7f614ce..13ebb54 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -124,7 +124,8 @@ extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata					\
+	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
 	static struct ftrace_event_call __used				\
@@ -138,7 +139,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata					\
+	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct ftrace_event_call __used				\
