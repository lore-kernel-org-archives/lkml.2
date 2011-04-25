Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab1DYKox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:44:53 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:54333 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab1DYKov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uvmUrSMwJ+w/QziVX2Pkf/4Tc6hhdjglY4E0rYXZfvi22INujtlWfExEJxNaE/iC3d
         Cu5VLe3mGoUSby2kGBbHXMHcFG/bcV6JPuCPP64tMNXpTFUtriq7LRL1o81zyZS7U8pS
         L9PhMM7NaeE9VFL+U8etXSExP578BqnnzMOOE=
From: Geunsik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 0/4] munmap: Flexible mem unmap operation interface for scheduling latency
Date: Mon, 25 Apr 2011 19:44:28 +0900
Message-Id: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

    As we all know, the specification of H/W(cpu, memory, i/o bandwidth, etc) is
    different according to their SOC. We can earn a suitable performance(or latency) after
    adjust memory unmap size by selecting an optimal value to consider specified system
    environment in real world.
    In other words, We can get real-fast or real-time using the Linux kernel tunable
    parameter choosingly for flexible memory unmap operation unit.

    For example, we can get the below effectiveness using this patch 
    . Reduce a temporal cpu intension(highest cpu usage) when accessing mass files
    . Improvement of user responsiveness at embedded products like mobile phone, camcorder, dica
    . Get a effective real-time or real-fast at the real world that depend on the physical h/w
    . Support sysctl interface(tunalbe parameter) to find a suitable munmap operation unit 
      at runtime favoringly

    unmap_vmas(=unmap a range of memory covered by a list of vma) is treading
    a delicate and uncomfortable line between hi-performance and lo-latency.
    We have often chosen to improve performance at the expense of latency.

    So although there may be no need to reschedule right now,
    if we keep on gathering more and more without flushing,
    we'll be very unresponsive when a resched is needed later on.

    resched is a routine that is called by the current process when rescheduling is to
    take place. It is called not only when the time quantum of the current process expires
    but also when a blocking(waiting) call such as wait is invoked by the current process
    or when a new process of potentially higher priority becomes eligible for execution.

    Here are some history about ZAP_BLOCK_SIZE content discussed for scheduling latencies
    a long time ago. Hence Ingo's ZAP_BLOCK_SIZE to split it up, small when CONFIG_PREEMPT,
    more reasonable but still limited when not.
    . Patch subject - [patch] sched, mm: fix scheduling latencies in unmap_vmas()
    . LKML archive - http://lkml.org/lkml/2004/9/14/101

    Robert Love submitted to get the better latencies by creating a preemption point
    at Linux 2.5.28 (development version).
    . Patch subject - [PATCH] updated low-latency zap_page_range
    . LKML archive - http://lkml.org/lkml/2002/7/24/273

    Originally, We aim to not hold locks for too long (for scheduling latency reasons).
    So zap pages in ZAP_BLOCK_SIZE byte counts.
    This means we need to return the ending mmu_gather to the caller.

    In general, This is not a critical latency-path on preemption mode
    (PREEMPT_VOLUNTARY / PREEMPT_DESKTOP / PREEMPT_RT)

    . Vanilla's preemption mode (mainline kernel tree)
      - http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git v2.6.38
        1) CONFIG_PREEMPT_NONE: No Forced Preemption (Server)
        2) CONFIG_PREEMPT_VOLUNTARY: Voluntary Kernel Preemption (Desktop)
        3) CONFIG_PREEMPT: Preemptible Kernel (Low-Latency Desktop)

    . Ingo rt patch's preemption mode (-tip kernel tree)
      - http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git v2.6.33.9-rt31
        1) CONFIG_PREEMPT_NONE
        2) CONFIG_PREEMPT_VOLUNTARY
        3) CONFIG_PREEMPT + CONFIG_PREEMPT_DESKTOP
        4) CONFIG_PREEMPT + CONFIG_PREEMPT_RT + CONFIG_PREEMPT_{SOFTIRQS|HARDIRQS}

    This value can be changed at runtime using the
    '/proc/sys/vm/munmap_unit_size' as Linux kernel tunable parameter after boot.

	* Examples: The size of one page is 4,096bytes.
                  2048 => 8,388,608bytes : for straight-line efficiency (performance)
                  1024 => 4,194,304bytes
                   512 => 2,097,152bytes
                   256 => 1,048,576bytes
                   128 =>   524,288bytes
                    64 =>   262,144bytes
                    32 =>   131,072bytes
                    16 =>    65,536bytes
                     8 =>    32,768bytes : for low-latency

    p.s: I checked parsing of this patch file with './linux-2.6/script/checkpatch.pl' script.
         and, I uploaded demo video using youtube about the evaluation result according  
	 to munmap operation unit interface. (http://www.youtube.com/watch?v=PxcgvDTY5F0)

    Thanks for reading.

Geunsik Lim (4):
  munmap operation size handling
  sysctl extension for tunable parameter
  kbuild menu for munmap interface
  documentation of munmap operation interface

 Documentation/sysctl/vm.txt      |   36 +++++++++++++++++++
 MAINTAINERS                      |    7 ++++
 include/linux/munmap_unit_size.h |   24 +++++++++++++
 init/Kconfig                     |   70 ++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                  |   10 +++++
 mm/Makefile                      |    4 ++-
 mm/memory.c                      |   21 +++++++----
 mm/munmap_unit_size.c            |   57 +++++++++++++++++++++++++++++++
 8 files changed, 221 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/munmap_unit_size.h
 create mode 100644 mm/munmap_unit_size.c

-- 
1.7.3.4

