Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab0FWKEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:04 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47669 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0FWKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:00 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>
Subject: ftrace syscalls, PowerPC: Various fixes, Compat Syscall support and PowerPC implementation, V2
Date: Wed, 23 Jun 2010 20:02:41 +1000
Message-Id: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements ftrace syscall tracing on PowerPC. All PPC 32bit,
64bit and 32bit compat syscalls are supported along with all the missing
generic compat syscalls.

This patch series includes Jason Baron's Compat Syscall Support v3 patches
rebased atop the current tip tree as patches 05 through 18 inclusive - refer to
http://lkml.org/lkml/2010/3/16/308 for their discussion. Any alterations I have
made other than what was necessary to rebase them are in separate later
commits. In particular, patch #38 removes the test for unmapped syscalls as
patch #1 prevents the events from being created if the mapping failed. Patch
#39 also undoes an ABI change from Jason's patches.

Some of the PowerPC syscalls have been renamed in this series - particularly
any with a ppc_ prefix or similar that did not use an assembly wrapper - most
of these now have a sys_ppc_ prefix or similar.

Those syscalls with assembly wrappers are now rigidly named such that only the
first three characters differ from the function name (i.e. ppc_fork is the
wrapper for sys_fork) so that the arch_syscall_match_sym_name function will
still match them to their metadata (it ignores the 3 character prefix).

I have avoided changing the return types of any of the syscalls as I was
concerned about the affect of doing so, rather adding the infrastructure to
allow their metadata to be recorded as well (patches #33 through #35).

If the system is booted with loglevel=8, any system calls that have not mapped
to their metadata will be printed, which can help track down any further
unmapped syscalls. This could be useful for other archs adding ftrace syscall
tracing support.


The patches base is tip/master.

Changes since v1:
 * Add Jason's compat syscall support as part of the series
 * Convert all the PPC syscalls to use the SYSCALL_DEFINE macros
 * Remaining generic syscalls supported
 * Handle PPC syscalls with register access through 7th parameter
 * Support for syscalls with !long return types
 * Support for syscalls using their own syscall wrappers
 * Clean up some of the metadata recording preprocessor code
 * Some other general cleanups

