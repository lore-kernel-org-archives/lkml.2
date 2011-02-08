Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1BHWSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:18:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1BHWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:23 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=gLg6x_zP4vUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=7enPJPt5mC7gaRCchMIA:9 a=-JdBgREuWHIgjY3zMANXE2Hr0qYA:4 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221720.077315754@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 05/10] tracing/syscalls: Early terminate search for sys_ni_syscall
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-syscalls-Early-terminate-search-for-sys_ni_s.patch
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
-- 
1.7.2.3


