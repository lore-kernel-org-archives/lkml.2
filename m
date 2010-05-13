Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0EMHoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:44:04 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38623 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0EMHoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:44:00 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
       Jason Baron <jbaron@redhat.com>
Subject: ftrace syscalls, PowerPC: Fixes and PowerPC raw syscall tracepoint implementation
Date: Thu, 13 May 2010 17:43:10 +1000
Message-Id: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements raw system call tracepoints on PowerPC that can be
used with ftrace and perf. Some problems with the generic ftrace syscall
tracepoint code have also been addressed.

The patches are based upon Ben's powerpc/next tree merged with tip/tracing/core

Patch #1 removes all ftrace syscall events that fail to map the system call
name from the system call metadata with the system call's number, preventing
the events which will not work from showing up in perf list and removing them
from /sys/kernel/debug/tracing/events/syscalls.

Patches #2 and #3 allow for archs with unusual system call tables (#2) or
unusual symbol names (#3) to override the appropriate functions so that they
can still work with ftrace syscalls.

Patch #4 implements the actual raw system call tracepoints that ftrace syscalls
builds upon, allowing all of the system calls to be used with the raw_syscalls
events category and most to be used with the syscalls category.


Not all the raw_syscalls are currently mapped to ftrace syscalls - the syscalls
defined in /arch/powerpc/include/asm/syscalls.h do not use the SYSCALL_DEFINE
class of macros and as such have no meta data, likewise some of the ppc_*
syscalls have assembly wrappers. These are on their way, but I wanted to put
the work I have done so far out first.

Some of those syscalls have different return types than the __SYSCALL_DEFINE
macro uses (unsigned long, int, time_t) and some have different prefixes (ppc,
ppc64) - I didn't particularly want to change them straight over without asking
the list first, and I certainly don't want to change the return types. I see
that Jason Baron ran into similar issues, but his "add compat syscall support"
patches have yet to be merged, and do not tackle the differing return types.

