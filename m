Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0LGE3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 23:29:51 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47651 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0LGE33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 23:29:29 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>, Ian Munsie <imunsie@au1.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] trace syscalls: Early terminate search for sys_ni_syscall
Date: Tue,  7 Dec 2010 15:29:11 +1100
Message-Id: <1291696151-4336-7-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
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
index 85983fd..6e17886 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -80,6 +80,9 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
 	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
 
+	if (arch_syscall_match_sym_name(str, "sys_ni_syscall"))
+		return NULL;
+
 	for ( ; start < stop; start++) {
 		if (start->name && arch_syscall_match_sym_name(str, start->name))
 			return start;
-- 
1.7.2.3

