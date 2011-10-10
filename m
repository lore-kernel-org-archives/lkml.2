Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1JJMbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:31:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38168 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1JJMbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:31:43 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 0/3] Freezer, CPU hotplug,
 x86 Microcode: Fix task freezing failures
To: rjw@sisk.pl
Cc: srivatsa.bhat@linux.vnet.ibm.com, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, tj@kernel.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date: Mon, 10 Oct 2011 18:01:30 +0530
Message-ID: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11101003-3568-0000-0000-000000801C1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU hotplug is run along with suspend/hibernate tests using
the pm_test framework, even at the freezer level, we hit task freezing
failures. One such failure was reported here:
https://lkml.org/lkml/2011/9/5/28

An excerpt of the log:

  Freezing of tasks failed after 20.01 seconds (2 tasks refusing to
  freeze, wq_busy=0):
  invert_cpu_stat D 0000000000000000  5304 20435  17329 0x00000084
   ffff8801f367bab8 0000000000000046 ffff8801f367bfd8 00000000001d3a00
   ffff8801f367a010 00000000001d3a00 00000000001d3a00 00000000001d3a00
   ffff8801f367bfd8 00000000001d3a00 ffff880414cc6840 ffff8801f36783c0
  Call Trace:
   [<ffffffff81532de5>] schedule_timeout+0x235/0x320
   [<ffffffff81532a0b>] wait_for_common+0x11b/0x170
   [<ffffffff81532b3d>] wait_for_completion+0x1d/0x20
   [<ffffffff81364486>] _request_firmware+0x156/0x2c0
   [<ffffffff81364686>] request_firmware+0x16/0x20
   [<ffffffffa01f0da0>] request_microcode_fw+0x70/0xf0 [microcode]
   [<ffffffffa01f0390>] microcode_init_cpu+0xc0/0x100 [microcode]
   [<ffffffffa01f14b4>] mc_cpu_callback+0x7c/0x11f [microcode]
   [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
   [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
   [<ffffffff8106d000>] __cpu_notify+0x20/0x40
   [<ffffffff8152cf5b>] _cpu_up+0xc7/0x10e
   [<ffffffff8152d07b>] cpu_up+0xd9/0xec
   [<ffffffff8151e599>] store_online+0x99/0xd0
   [<ffffffff81355eb0>] sysdev_store+0x20/0x30
   [<ffffffff811f3096>] sysfs_write_file+0xe6/0x170
   [<ffffffff8117ee50>] vfs_write+0xd0/0x1a0
   [<ffffffff8117f024>] sys_write+0x54/0xa0
   [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b


The reason behind this failure is explained below:

The x86 microcode update driver has callbacks registered for CPU hotplug
events such as a CPU getting offlined or onlined. Things go wrong when a
CPU hotplug stress test is carried out along with a suspend/resume operation
running simultaneously. Upon getting a CPU_DEAD notification (for example,
when a CPU offline occurs with tasks not frozen), the microcode callback
frees up the microcode and invalidates it. Later, when that CPU gets onlined
with tasks being frozen, the microcode callback (for the CPU_ONLINE_FROZEN
event) tries to apply the microcode to the CPU; doesn't find it and hence
depends on the (currently frozen) userspace to get the microcode again. This
leads to the numerous "WARNING"s at drivers/base/firmware_class.c which
eventually leads to task freezing failures in the suspend code path, as has
been reported.

So, this patch series addresses this issue by ensuring that CPU hotplug and
suspend/hibernate don't run in parallel, thereby fixing the task freezing
failures.

v2: Implemented mutual exclusion between CPU hotplug and suspend/hibernate.

Srivatsa S. Bhat (3):
      Introduce helper functions
      Mutually exclude cpu online and suspend/hibernate
      Update documentation

 Documentation/power/freezing-of-tasks.txt |   22 ++++++++++++++++++++++
 include/linux/suspend.h                   |   21 +++++++++++++++++++--
 kernel/cpu.c                              |   10 ++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)


