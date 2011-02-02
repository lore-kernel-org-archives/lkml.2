Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1BBHNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:13:17 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56500 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1BBHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:12:23 -0500
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
Subject: [PATCH 6/6] trace syscalls: Early terminate search for sys_ni_syscall
Date: Wed,  2 Feb 2011 18:11:58 +1100
Message-Id: <1296630718-17537-7-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296630718-17537-1-git-send-email-imunsie@au1.ibm.com>
References: <1296630718-17537-1-git-send-email-imunsie@au1.ibm.com>
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
index 76bffba..ff070aa 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -71,6 +71,9 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
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

