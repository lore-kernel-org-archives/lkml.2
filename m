Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0DWFNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:13:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34681 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0DWFNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=xBi9WIm2dn/cNArgKWxZzAGpLge6AqBZ0223aswomcceVDQAjHD7AnXCQEWuLdtw9r
         uyhg+L+ucrRZRAZIY5QsvwAqQRk4aevkbVKmXyH5vLdrBKWsDfYf9wIdk/zP781WEu/p
         bRESRFnvO+Ua3O7E/hGHrQn7m92xyeGrmI0QE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 0/6] hw-breakpoints updates
Date: Fri, 23 Apr 2010 07:13:53 +0200
Message-Id: <1271999639-23605-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Paul, there are some sh changes in this set. I couldn't test them
by myself, do you think you could give it a try?

You can pull the set from this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/hw-breakpoints

This new shot brings the following features:

- You can now profile userspace memory accesses from perf, whenever
  you are profiling cpu wide or task wide

- You can profile kernel memory accesses from perf if you are
  doing a task bound profiling (previously you could do it only for
  cpu wide profiling). That requires admin privileges though.
  So if you want to profile the global variable "A" in your "test"
  application. Get the address of "A" and do:

	perf record -e mem:addr_of_A:rw ./test

- Separate constraint space between data and instruction breakpoints.
  If you have separate addr registers for your instruction and data
  breakpoints, one type won't eat the remaining slot constraints of
  the other in the constraint table.

- Handle the weight of a breakpoint. Simple breakpoints only consume
  one register but range breakpoints or other complicated things
  may eat more. Handle this case in the constraint table.

- Handle the fact we don't always know at build time the total number
  of available breakpoint registers. For example Arm needs to get this
  information dynamically on runtime.

TODO:

- ptrace usually get breakpoint informations through virtual arch
  regs provided by the user. This requires a wasteful level of indirection
  where we need to translate the arch info to generic info, and to translate
  back again to arch info. I need to implement a shortcut for the ptrace
  case. Not only is it wasteful, but we may lose some information in the
  process as the generic interface will never be able to integrate 100%
  of the subtleties that archs can implement for their breakpoints which
  can be expressed through arch register images in ptrace.
  We only want the most common features in the generic interface.

- breakpoints are interesting with perf but only for addresses we
  know in advance (global variables). We need a trick to get dynamically
  allocated memory addresses. May be we could think about a generic
  solution with kprobes (which could then be usable later with uprobes) so
  that could get every instances of a given structure as they are allocated
  (or get these addresses later from a given point, still with kprobes).
  Once we get that, we could have a watchpoint based profiling tool that
  really rocks.



Frederic Weisbecker (6):
  hw-breakpoints: Tag ptrace breakpoint as exclude_kernel
  hw-breakpoints: Check disabled breakpoints again
  hw-breakpoints: Change/Enforce some breakpoints policies
  hw-breakpoints: Separate constraint space for data and instruction
    breakpoints
  hw-breakpoints: Handle breakpoint weight in allocation constraints
  hw-breakpoints: Get the number of available registers on boot
    dynamically

 arch/Kconfig                         |   11 ++
 arch/sh/Kconfig                      |    1 +
 arch/sh/include/asm/hw_breakpoint.h  |    8 ++-
 arch/sh/kernel/hw_breakpoint.c       |   31 +-----
 arch/sh/kernel/ptrace_32.c           |    2 +-
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/hw_breakpoint.h |   10 ++-
 arch/x86/kernel/hw_breakpoint.c      |   41 +------
 arch/x86/kernel/ptrace.c             |    2 +-
 include/linux/hw_breakpoint.h        |   25 ++++-
 kernel/hw_breakpoint.c               |  196 +++++++++++++++++++++++++--------
 kernel/trace/trace_functions_graph.c |    2 +
 kernel/trace/trace_ksym.c            |   26 ++----
 13 files changed, 220 insertions(+), 136 deletions(-)

