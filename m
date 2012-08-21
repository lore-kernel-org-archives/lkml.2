Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab2HUQ2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:28:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32922 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2HUQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:28:46 -0400
Date: Tue, 21 Aug 2012 09:28:22 -0700
From: tip-bot for Will Deacon <will.deacon@arm.com>
Message-ID: <tip-60916a9382e88fbf5e54fd36a3e658efd7ab7bed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, wade_farnsworth@mentor.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, wade_farnsworth@mentor.com, fweisbec@gmail.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de
In-Reply-To: <1345137254-7377-1-git-send-email-will.deacon@arm.com>
References: <1345137254-7377-1-git-send-email-will.deacon@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing/syscalls:
  Fix perf syscall tracing when syscall_nr == -1
Git-Commit-ID: 60916a9382e88fbf5e54fd36a3e658efd7ab7bed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:28:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60916a9382e88fbf5e54fd36a3e658efd7ab7bed
Gitweb:     http://git.kernel.org/tip/60916a9382e88fbf5e54fd36a3e658efd7ab7bed
Author:     Will Deacon <will.deacon@arm.com>
AuthorDate: Thu, 16 Aug 2012 18:14:14 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 17 Aug 2012 15:19:46 -0400

tracing/syscalls: Fix perf syscall tracing when syscall_nr == -1

syscall_get_nr can return -1 in the case that the task is not executing
a system call.

This patch fixes perf_syscall_{enter,exit} to check that the syscall
number is valid before using it as an index into a bitmap.

Link: http://lkml.kernel.org/r/1345137254-7377-1-git-send-email-will.deacon@arm.com

Cc: Jason Baron <jbaron@redhat.com>
Cc: Wade Farnsworth <wade_farnsworth@mentor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 60e4d78..6b245f64 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -506,6 +506,8 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
@@ -580,6 +582,8 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 
