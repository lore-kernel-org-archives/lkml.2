Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1BQPAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:00:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:37960 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1BQPAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:00:36 -0500
Date: Thu, 17 Feb 2011 15:00:17 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
In-Reply-To: <1296703645-18718-7-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-7-git-send-email-imunsie@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/syscalls: Early terminate search for sys_ni_syscall
Message-ID: <tip-ae07f551c42d6e4162436ca452a199deac9dab4d@git.kernel.org>
Git-Commit-ID: ae07f551c42d6e4162436ca452a199deac9dab4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 15:00:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae07f551c42d6e4162436ca452a199deac9dab4d
Gitweb:     http://git.kernel.org/tip/ae07f551c42d6e4162436ca452a199deac9dab4d
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Thu, 3 Feb 2011 14:27:25 +1100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Feb 2011 21:30:14 -0500

tracing/syscalls: Early terminate search for sys_ni_syscall

Many system calls are unimplemented and mapped to sys_ni_syscall, but at
boot ftrace would still search through every syscall metadata entry for
a match which wouldn't be there.

This patch adds causes the search to terminate early if the system call
is not mapped.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
LKML-Reference: <1296703645-18718-7-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 86a23e7..ee7b5a0 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -85,6 +85,9 @@ find_syscall_meta(unsigned long syscall)
 	stop = __stop_syscalls_metadata;
 	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
 
+	if (arch_syscall_match_sym_name(str, "sys_ni_syscall"))
+		return NULL;
+
 	for ( ; start < stop; start++) {
 		if ((*start)->name && arch_syscall_match_sym_name(str, (*start)->name))
 			return *start;
