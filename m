Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1K2MWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:22:43 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52140 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1K2MWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:22:42 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC PATCH 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW definition
Date: Tue, 29 Nov 2011 12:22:26 +0000
Message-Id: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
X-OriginalArrivalTime: 29 Nov 2011 12:22:38.0082 (UTC) FILETIME=[95097E20:01CCAE91]
X-MC-Unique: 111112912223901501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pATCMpLb007570

Hi,

This set of patches removes the use of __ARCH_WANT_INTERRUPTS_ON_CTXSW
on ARM.

As a background, the ARM architecture versions consist of two main sets
with regards to the MMU switching needs:

1. ARMv5 and earlier have VIVT caches and they require a full cache and
   TLB flush at every context switch.
2. ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
   (application specific ID). The number of ASIDs is limited to 256 and
   the allocation algorithm requires IPIs when all the ASIDs have been
   used.

Both cases above require interrupts enabled during context switch for
latency reasons (1) or deadlock avoidance (2).

The first patch in the series introduces a new scheduler hook invoked
after the rq->lock is released and interrupts enabled. The subsequent
two patches change the ARM context switching code (for processors in
category 2 above) to use a reserved TTBR value instead of a reserved
ASID. The 4th patch removes the __ARCH_WANT_INTERRUPTS_ON_CTXSW
definition for ASID-capable processors by deferring the new ASID
allocation to the post-lock switch hook.

The last patch also removes __ARCH_WANT_INTERRUPTS_ON_CTXSW for ARMv5
and earlier processors. It defers the cpu_switch_mm call to the
post-lock switch hook. Since this is only running on UP systems and the
preemption is disabled during context switching, it assumes that the old
mm is still valid until the post-lock switch hook.

The series has been tested on Cortex-A9 (vexpress) and ARM926
(versatile). Comments are welcome.

Thanks,

Catalin


Catalin Marinas (4):
  sched: Introduce the finish_arch_post_lock_switch() scheduler hook
  ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW on ASID-capable CPUs
  ARM: Remove current_mm per-cpu variable
  ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW on pre-ARMv6 CPUs

Will Deacon (2):
  ARM: Use TTBR1 instead of reserved context ID
  ARM: Allow ASID 0 to be allocated to tasks

 arch/arm/include/asm/mmu_context.h |  106 +++++++++++++++++++++++++++---------
 arch/arm/include/asm/system.h      |    7 ---
 arch/arm/include/asm/thread_info.h |    1 +
 arch/arm/mm/context.c              |   42 +++++++--------
 arch/arm/mm/proc-v7.S              |    9 +---
 kernel/sched.c                     |    4 ++
 6 files changed, 107 insertions(+), 62 deletions(-)


