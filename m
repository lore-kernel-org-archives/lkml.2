Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1LYQvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 11:51:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57032 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1LYQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 11:51:08 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/4] clock_gettime_ns and x86-64 optimizations
Date: Sun, 25 Dec 2011 08:50:59 -0800
Message-Id: <cover.1324831829.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-64, clock_gettime is so fast that the overhead converting to and
from nanoseconds is non-negligible.  clock_gettime_ns is a different and
faster interface.

Patch 1 adds the syscall and wires it up on x86-64.  Patch 2 implements
the corresponding vdso entry on x86-64.  Patch 3 optimizes the vdso
call, and patch 4 is a trivial change that speeds up the vdso
clock_gettime and clock_gettime_ns implementations.

The vdso timings are (on an 800MHz Sandy Bridge mobile):

Basic implementation:

realtime 77.4ns
monotonic 79.2ns
realtime_coarse 18.1ns
monotonic_coarse 22.0ns

realtime_ns 84.9ns
monotonic_ns 85.1ns
realtime_coarse_ns 19.49
monotonic_coarse_ns 27.32

Optimized implementation:

realtime 78.5ns
monotonic 77.4ns [a little faster -- maybe significant]
realtime_coarse 18.4ns
monotonic_coarse 19.4ns

realtime_ns 77.85ns [a nice improvement]
monotonic_ns 77.75ns [ditto]
realtime_coarse_ns 18.2ns
monotonic_coarse_ns 18.2ns [a lot faster]

Inlined (patch 4): [everything is improved]

realtime 73.4ns
monotonic 72.1ns
realtime_coarse 13.2ns
monotonic_coarse 15.8ns

realtime_ns 73.15ns
monotonic_ns 72.1ns
realtime_coarse_ns 14.1ns
monotonic_coarse_ns 15.6ns

This being the middle of the holidays, I reserve the right to have made
mistakes.

For the git-inclined, this series is at
https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/timing/clock_gettime_ns/patch_v1

Andy Lutomirski (4):
  Add clock_gettime_ns syscall
  x86-64: Add __vdso_clock_gettime_ns vsyscall
  x86-64: Optimize vdso clock_gettime
  x86-64: Inline vdso clock_gettime helpers

 arch/x86/include/asm/unistd_64.h |    2 +
 arch/x86/include/asm/vgtod.h     |   21 ++++--
 arch/x86/kernel/vsyscall_64.c    |   25 +++++++-
 arch/x86/vdso/vclock_gettime.c   |  136 ++++++++++++++++++++++++++------------
 arch/x86/vdso/vdso.lds.S         |    7 ++
 include/linux/syscalls.h         |    3 +
 include/linux/time.h             |    5 ++
 kernel/posix-timers.c            |   30 ++++++++
 8 files changed, 179 insertions(+), 50 deletions(-)

-- 
1.7.7.4

