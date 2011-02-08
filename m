Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1BHWRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:17:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1BHWRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:21 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=9x9OqnSY49kA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=90kiD33hs-Ks5ULzG28A:9 a=tyOXpw9aDWD-Isi8qUEA:7 a=AvWZG078ClZBc5psvsT5gr8xT3gA:4 a=jeBq3FmKZ4MA:10 a=LK-WTlb07Qpcb0PZ:21 a=bdjB0cZWkPnr1gCF:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221719.309444699@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 02/10] tracing/syscalls: Convert redundant syscall_nr checks into WARN_ON
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-syscalls-Convert-redundant-syscall_nr-checks.patch
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
LKML-Reference: <1296703645-18718-3-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a9ceabd..4230942 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -359,7 +359,7 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
@@ -377,7 +377,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
@@ -393,7 +393,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
@@ -411,7 +411,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
+	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
-- 
1.7.2.3


