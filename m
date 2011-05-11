Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1EKQE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab1EKPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:55:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v1 0/5] KVM in-guest performance monitoring
Date: Wed, 11 May 2011 11:55:28 -0400
Message-Id: <1305129333-7456-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This not-for-merging patchset exposes an emulated version 1 architectural
performance monitoring unit to KVM guests.  The PMU is emulated using
perf_events, so the host kernel can multiplex host-wide, host-user, and the
guest on available resources.

Caveats:
- counters that have PMI (interrupt) enabled stop counting after the
  interrupt is signalled.  This is because we need one-shot samples
  that keep counting, which perf doesn't support yet
- some combinations of INV and CMASK are not supported
- counters keep on counting in the host as well as the guest
- the RDPMC instruction and CR4.PCE bit are not yet emulated
- there is likely a bug in the implementation; running 'perf top' in
  a guest that spends 80% of its time in userspace shows perf itself
  as consuming almost all cpu

perf maintainers: please consider the first three patches for merging (the
first two make sense even without the rest).  If you're familiar with the Intel
PMU, please review patch 5 as well - it effectively undoes all your work
of abstracting the PMU into perf_events by unabstracting perf_events into what
is hoped is a very similar PMU.

Avi Kivity (5):
  perf: add context parameter to perf_event overflow handler
  x86, perf: add constraints for architectural PMU v1
  perf: export perf_event_refresh() to modules
  KVM: Expose kvm_lapic_local_deliver()
  KVM: Expose a version 1 architectural PMU to guests

 arch/arm/kernel/ptrace.c                |   10 +-
 arch/powerpc/kernel/ptrace.c            |    4 +-
 arch/sh/kernel/ptrace_32.c              |    5 +-
 arch/x86/include/asm/kvm_host.h         |   29 ++++
 arch/x86/kernel/cpu/perf_event_intel.c  |   23 +++-
 arch/x86/kernel/kgdb.c                  |    2 +-
 arch/x86/kernel/ptrace.c                |    5 +-
 arch/x86/kvm/Makefile                   |    2 +-
 arch/x86/kvm/lapic.c                    |    2 +-
 arch/x86/kvm/lapic.h                    |    1 +
 arch/x86/kvm/pmu.c                      |  248 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                      |   16 +-
 drivers/oprofile/oprofile_perf.c        |    5 +-
 include/linux/hw_breakpoint.h           |   10 +-
 include/linux/perf_event.h              |   13 ++-
 kernel/events/core.c                    |   27 +++-
 kernel/events/hw_breakpoint.c           |   10 +-
 kernel/watchdog.c                       |    7 +-
 samples/hw_breakpoint/data_breakpoint.c |    5 +-
 19 files changed, 377 insertions(+), 47 deletions(-)
 create mode 100644 arch/x86/kvm/pmu.c

-- 
1.7.4.3

