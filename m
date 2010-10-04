Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab0JDUob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:44:31 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46731 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757131Ab0JDUo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:44:28 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH V4 0/7] Generalise ARM perf-events backend for oprofile
Date: Mon,  4 Oct 2010 21:44:18 +0100
Message-Id: <cover.1286222593.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf-events backend for OProfile that Will Deacon wrote in
8c1fc96f6fd1f361428ba805103af0d0eee65179 ("ARM: 6072/1: oprofile: use
perf-events framework as backend") is of use to more architectures
than just ARM. Move the code into drivers/oprofile/ so that SH can use
it instead of the nearly identical copy of its OProfile code.

The benefit of the backend is that it becomes necessary to only
maintain one copy of the PMU accessor functions for each architecture,
with bug fixes and new features benefiting both OProfile and perf.

Note that I haven't been able to test these patches on an ARM board to
see if I've caused any regressions. If anyone else could do that I'd
appreciate it. Though, I have been able to compile this version of the
series.

This patch series is based on,

    git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

These patches can also be found at,

    git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/sh-2.6.git perf-oprofile


Robert, I haven't rebased this work on your oprofile updates for
2.6.37. If you need me to do that, just shout.


Changes from v3:
 - New perf_pmu_name() function
 - Sprinkled an EXPORT_SYMBOL_GPL()
 - Don't repeatedly call perf_num_counters()
 - Change name of oprofile_driver to "oprofile-perf"
 - Hard overwrite the oprofile_operations in oprofile_perf_init()
 - Dropped the patch that made oprofile depend on HW_PERF_EVENTS for ARM

Changes from v2:
 - Rebased against Robert's oprofile core branch
 - Moved even more of the ARM code into the generic oprofile code
 - Broke the patches up into more logical steps

Changes from v1:
 - Prefix the new functons with "oprofile_" instead of "op_".
 - Fix ARM compilation errors
 - Move all the oprofile-perf logic into oprofile_perf.c
 - Include cleanup patch from Will

Matt Fleming (7):
  perf: Add helper function to return number of counters
  perf: New helper function for pmu name
  ARM: oprofile: Rename op_arm to oprofile_perf
  ARM: oprofile: Move non-ARM code into separate init/exit
  oprofile: Abstract the perf-events backend
  sh: oprofile: Use perf-events oprofile backend
  sh: Annotate oprofile_arch_exit() with __exit marker

 arch/arm/kernel/perf_event.c     |   29 ++++
 arch/arm/oprofile/Makefile       |    4 +
 arch/arm/oprofile/common.c       |  327 +-------------------------------------
 arch/sh/Kconfig                  |   13 ++
 arch/sh/kernel/perf_event.c      |   23 +++
 arch/sh/oprofile/Makefile        |    4 +
 arch/sh/oprofile/common.c        |  109 ++------------
 arch/sh/oprofile/op_impl.h       |   33 ----
 drivers/oprofile/oprofile_perf.c |  326 +++++++++++++++++++++++++++++++++++++
 include/linux/oprofile.h         |    6 +
 include/linux/perf_event.h       |    2 +
 kernel/perf_event.c              |    5 +
 12 files changed, 425 insertions(+), 456 deletions(-)
 delete mode 100644 arch/sh/oprofile/op_impl.h
 create mode 100644 drivers/oprofile/oprofile_perf.c

