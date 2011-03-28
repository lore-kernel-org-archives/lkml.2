Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1C1PMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:12:08 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:55165 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab1C1PMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:12:06 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Mar 2011 11:12:06 EDT
X-AuditID: 1209190d-b7c48ae000004826-6a-4d90a4158ffe
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/6] x86-64: Micro-optimize vclock_gettime
Date: Mon, 28 Mar 2011 11:06:40 -0400
Message-Id: <cover.1301324270.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsUixG6nriu6ZIKvQcNfIYu+K0fZLVrXzme3
	uLxrDpvF5k1TmS1+bHjM6sDqsXPWXXaPTas62TzenTvH7nHuWh+zx+dNcgGsUVw2Kak5mWWp
	Rfp2CVwZ7x9uZis4I17xbPdT1gbGrcJdjJwcEgImEufWHmWHsMUkLtxbz9bFyMUhJLCPUWLn
	lFdgCSGBDYwSCxv1IRLPmCSeNf4CS7AJqEh0LH3A1MXIwSEiICSx9G4dSA2zwCRGiZczesFq
	hAWsJA6eeMEEYrMIqEqs+feKDcTmFdCXeL3lLksXIzvQZjmJ5sAJjDwLGBlWMcqm5Fbp5iZm
	5hSnJusWJyfm5aUW6Rrp5WaW6KWmlG5iBIUNpyTvDsZ3B5UOMQpwMCrx8P4L7/cVYk0sK67M
	PcQoycGkJMr7bNEEXyG+pPyUyozE4oz4otKc1OJDjBIczEoivIcagXK8KYmVValF+TApaQ4W
	JXHemZLqvkIC6YklqdmpqQWpRTBZGQ4OJQneu4uBGgWLUtNTK9Iyc0oQ0kwcnCDDeYCG3wap
	4S0uSMwtzkyHyJ9i1OWYf/HRXkYhlrz8vFQpcd7FIEUCIEUZpXlwc2Dx/opRHOgtYd7zIFU8
	wFQBN+kV0BImoCWBSmBLShIRUlINjEeTGaWbK89lMi5p2SuUmlx5cHb9h6U67KIHurcWBKeo
	GXzdtdqz8q3hgus8sYrtVRLN8Rrb6so2VvzMtBCcbNHkkf2tZP/hJoOwpAb3M98z2zmTNt1N
	anmWyyzz447nxIhrOhs31+iHpbdxHP4rNfXj7Qfieid+XtrAPK2NIbFwolTkqlVZSizFGYmG
	WsxFxYkAsfcXoNICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series speeds up vclock_gettime(CLOCK_MONOTONIC) on by almost 30%
(tested on Sandy Bridge).  They're ordered in roughly decreasing order
of improvement.

These are meant for 2.6.40, but if anyone wants to take some of them
for 2.6.39 I won't object.

The changes and timings (fastest of 20 trials of 100M iters on Sandy
Bridge) are:

Unpatched:

CLOCK_MONOTONIC: 22.09ns
CLOCK_REALTIME_COARSE: 4.23ns
CLOCK_MONOTONIC_COARSE: 5.65ns

x86-64: Optimize vread_tsc's barriers

This replaces lfence;rdtsc;lfence with a faster sequence with similar
ordering guarantees.

CLOCK_MONOTONIC: 18.28ns
CLOCK_REALTIME_COARSE: 4.23ns
CLOCK_MONOTONIC_COARSE: 5.98ns

x86-64: Don't generate cmov in vread_tsc

GCC likes to generate a cmov on a branch that's almost completely
predictable.  Force it to generate a real branch instead.

CLOCK_MONOTONIC: 16.30ns
CLOCK_REALTIME_COARSE: 4.23ns
CLOCK_MONOTONIC_COARSE: 5.95ns

x86-64: Put vsyscall_gtod_data at a fixed virtual address

Because vsyscall_gtod_data's address isn't known until load time, the
code contains unnecessary address calculations.  Hardcode it.  This is
a nice speedup for the _COARSE variants as well.

CLOCK_MONOTONIC: 16.12ns
CLOCK_REALTIME_COARSE: 3.70ns
CLOCK_MONOTONIC_COARSE: 5.31ns

x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0

vset_normalize_timespec was more general than necessary.  Open-code
the appropriate normalization loops.  This is a big win for
CLOCK_MONOTONIC_COARSE

CLOCK_MONOTONIC: 16.09ns
CLOCK_REALTIME_COARSE: 3.70ns
CLOCK_MONOTONIC_COARSE: 4.49ns

x86-64: Omit frame pointers on vread_tsc

This is a bit silly and needs work for gcc < 4.4 (if we even care),
but, rather surprisingly, it's 0.3ns faster.  I guess that the CPU's
stack frame optimizations aren't quite as good as I thought.

CLOCK_MONOTONIC: 15.79ns
CLOCK_REALTIME_COARSE: 3.70ns
CLOCK_MONOTONIC_COARSE: 4.50ns

x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO

We're building the vDSO with optimizations disabled that were meant
for kernel code.  Override that, except for -fno-omit-frame-pointers,
which might make userspace debugging harder.

CLOCK_MONOTONIC: 15.66ns
CLOCK_REALTIME_COARSE: 3.44ns
CLOCK_MONOTONIC_COARSE: 4.23ns


Andy Lutomirski (6):
  x86-64: Optimize vread_tsc's barriers
  x86-64: Don't generate cmov in vread_tsc
  x86-64: Put vsyscall_gtod_data at a fixed virtual address
  x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
  x86-64: Omit frame pointers on vread_tsc
  x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO

 arch/x86/kernel/tsc.c          |   48 ++++++++++++++++++++++++++++++++-------
 arch/x86/kernel/vmlinux.lds.S  |   13 +++++-----
 arch/x86/vdso/Makefile         |   15 +++++++++++-
 arch/x86/vdso/vclock_gettime.c |   40 ++++++++++++++++++---------------
 arch/x86/vdso/vextern.h        |    9 ++++++-
 5 files changed, 90 insertions(+), 35 deletions(-)

-- 
1.7.4

