Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0FWKGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:06:06 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49623 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0FWKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:44 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 36/40] trace syscalls: Early terminate search for sys_ni_syscall
Date: Wed, 23 Jun 2010 20:03:17 +1000
Message-Id: <1277287401-28571-37-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Many system calls are unimplemented and mapped to sys_ni_syscall, but at
boot ftrace would still search through every syscall metadata entry for
a match which wouldn't be there.

This patch adds causes the search to terminate early if the system call
is not mapped.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/trace/trace_syscalls.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 264441e..58ef002 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -95,6 +95,9 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
 	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
 
+	if (arch_syscall_match_sym_name(str, "sys_ni_syscall"))
+		return NULL;
+
 	for ( ; start < stop; start++) {
 		if (start->name && arch_syscall_match_sym_name(str, start->name))
 			return start;
-- 
1.7.1

