Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1BCD14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 22:27:56 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41646 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1BCD1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 22:27:44 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Dilger <adilger@dilger.ca>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Jason Baron <jbaron@redhat.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Steven Rostedt <rostedt@goodmis.org>, Alexander Graf <agraf@suse.de>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, Nathan Lynch <ntl@pobox.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        David Gibson <dwg@au1.ibm.com>, Andreas Schwab <schwab@linux-m68k.org>,
        Namhyung Kim <namhyung@gmail.com>, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 2/6] ftrace syscalls: Convert redundant syscall_nr checks into WARN_ON
Date: Thu,  3 Feb 2011 14:27:21 +1100
Message-Id: <1296703645-18718-3-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

With the ftrace events now checking if the syscall_nr is valid upon
initialisation it should no longer be possible to register or unregister
a syscall event without a valid syscall_nr since they should not be
created. This adds a WARN_ON_ONCE in the register and unregister
functions to locate potential regressions in the future.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/trace/trace_syscalls.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a66bc13..1a6e8dd 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -358,7 +358,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
@@ -376,7 +376,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
@@ -392,7 +392,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
@@ -410,7 +410,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
-- 
1.7.2.3

