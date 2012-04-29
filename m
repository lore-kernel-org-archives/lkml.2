Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2D2XeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 19:34:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48070 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2D2XeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 19:34:12 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: hpa@zytor.com, Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/5] x86: Cleanup and simplify cpu-specific data
Date: Sun, 29 Apr 2012 20:33:25 -0300
Message-Id: <1335742410-11569-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com>
References: <1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various per-cpu fields are define in arch/x86/kernel/smpboot.c that are
basically equivalent to the cpu-specific data in struct cpuinfo_x86.
By moving these fields into the structure, a number of codepaths can be
simplified since they no longer need to care about those fields not
existing on !SMP builds.

The size effects on allno (UP) and allyes (MAX_SMP) kernels are as
follows:

    text      data       bss        dec      hex  filename
 1369227    181536   1399180    2949943   2d0337  vmlinux.i386.allno
 1370216    181600   1399012    2950828   2d06ac  vmlinux.i386.allno.after
 1608231    310968    505088    2424287   24fddf  vmlinux.x86_64.allno
 1609232    311032    504896    2425160   250148  vmlinux.x86_64.allno.after
97643748   6891747  34668544  139204039  84c15c7  vmlinux.i386.allyes
97643582   6892011  34668544  139204137  84c1629  vmlinux.i386.allyes.after
85869519  13567071  44511232  143947822  894782e  vmlinux.x86_64.allyes
85869134  13568607  44511232  143948973  8947cad  vmlinux.x86_64.allyes.after

As can be seen, the kernels get slighly larger, but the code reduction/
simplification should be enough to compensate for it.

Changes in v6:
- Rebased series against mainline 3.4-rc5

Changes in v5:
- Reduced the number of files affected in the patchset by keeping helper
functions in arch/x86/include/asm/smp.h
- Rebased to latest tip/master

Kevin Winchester (5):
  x86: Move per cpu cpu_llc_shared_map to a field in struct cpuinfo_x86
  x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
  x86: Move per cpu cpu_sibling_map to a field in struct cpuinfo_x86
  x86: Move per cpu cpu_core_map to a field in struct cpuinfo_x86
  x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings
    into common.c

 arch/x86/include/asm/perf_event_p4.h  |   14 +++---------
 arch/x86/include/asm/processor.h      |   10 +++++++++
 arch/x86/include/asm/smp.h            |   17 ++++----------
 arch/x86/include/asm/topology.h       |    8 +++----
 arch/x86/kernel/apic/apic_numachip.c  |    3 +--
 arch/x86/kernel/cpu/amd.c             |   19 +++++-----------
 arch/x86/kernel/cpu/common.c          |    5 +++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |   11 ++--------
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    2 --
 arch/x86/kernel/cpu/perf_event_p4.c   |    4 ++--
 arch/x86/kernel/cpu/proc.c            |    5 ++---
 arch/x86/kernel/process.c             |    5 ++---
 arch/x86/kernel/smpboot.c             |   39 +++++++--------------------------
 arch/x86/oprofile/nmi_int.c           |    6 -----
 arch/x86/oprofile/op_model_p4.c       |   11 +---------
 arch/x86/xen/smp.c                    |    6 -----
 drivers/cpufreq/p4-clockmod.c         |    2 --
 drivers/cpufreq/powernow-k8.c         |    7 ------
 drivers/cpufreq/speedstep-ich.c       |    2 --
 drivers/hwmon/coretemp.c              |    4 ----
 20 files changed, 48 insertions(+), 132 deletions(-)

-- 
1.7.10

