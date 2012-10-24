Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab2JXJiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:38:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2JXJiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:38:05 -0400
Date: Wed, 24 Oct 2012 02:36:49 -0700
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Message-ID: <tip-bffd5fc26043cce33158d4e027576e79fab2f7bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, andre.przywara@amd.com,
        tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        andre.przywara@amd.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <1349797115-28346-2-git-send-email-andre.przywara@amd.com>
References: <1349797115-28346-2-git-send-email-andre.przywara@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/perf: Fix virtualization sanity check
Git-Commit-ID: bffd5fc26043cce33158d4e027576e79fab2f7bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:36:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bffd5fc26043cce33158d4e027576e79fab2f7bb
Gitweb:     http://git.kernel.org/tip/bffd5fc26043cce33158d4e027576e79fab2f7bb
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Tue, 9 Oct 2012 17:38:35 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 08:53:13 +0200

x86/perf: Fix virtualization sanity check

In check_hw_exists() we try to detect non-emulated MSR accesses
by writing an arbitrary value into one of the PMU registers
and check if it's value after a readout is still the same.
This algorithm silently assumes that the register does not contain
the magic value already, which is wrong in at least one situation.

Fix the algorithm to really do a read-modify-write cycle. This fixes
a warning under Xen under some circumstances on AMD family 10h CPUs.

The reasons in more details actually sound like a story from
Believe It or Not!:

First you need an AMD family 10h/12h CPU. These do not reset the
PERF_CTR registers on a reboot.
Now you boot bare metal Linux, which goes successfully through this
check, but leaves the magic value of 0xabcd in the register. You
don't use the performance counters, but do a reboot (warm reset).
Then you choose to boot Xen. The check will be triggered with a
recent Linux kernel as Dom0 again, trying to write 0xabcd into the
MSR. Xen silently drops the write (expected), but the subsequent read
will return the value in the register, which just happens to be the
expected magic value. Thus the test misleadingly succeeds, leaving
the kernel in the belief that the PMU is available. This will trigger
the following message:

[    0.020294] ------------[ cut here ]------------
[    0.020311] WARNING: at arch/x86/xen/enlighten.c:730 xen_apic_write+0x15/0x17()
[    0.020318] Hardware name: empty
[    0.020323] Modules linked in:
[    0.020334] Pid: 1, comm: swapper/0 Not tainted 3.3.8 #7
[    0.020340] Call Trace:
[    0.020354]  [<ffffffff81050379>] warn_slowpath_common+0x80/0x98
[    0.020369]  [<ffffffff810503a6>] warn_slowpath_null+0x15/0x17
[    0.020378]  [<ffffffff810034df>] xen_apic_write+0x15/0x17
[    0.020392]  [<ffffffff8101cb2b>] perf_events_lapic_init+0x2e/0x30
[    0.020410]  [<ffffffff81ee4dd0>] init_hw_perf_events+0x250/0x407
[    0.020419]  [<ffffffff81ee4b80>] ? check_bugs+0x2d/0x2d
[    0.020430]  [<ffffffff81002181>] do_one_initcall+0x7a/0x131
[    0.020444]  [<ffffffff81edbbf9>] kernel_init+0x91/0x15d
[    0.020456]  [<ffffffff817caaa4>] kernel_thread_helper+0x4/0x10
[    0.020471]  [<ffffffff817c347c>] ? retint_restore_args+0x5/0x6
[    0.020481]  [<ffffffff817caaa0>] ? gs_change+0x13/0x13
[    0.020500] ---[ end trace a7919e7f17c0a725 ]---

The new code will change every of the 16 low bits read from the
register and tries to write and read-back that modified number
from the MSR.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Link: http://lkml.kernel.org/r/1349797115-28346-2-git-send-email-andre.przywara@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3373f84..4a3374e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -208,12 +208,14 @@ static bool check_hw_exists(void)
 	}
 
 	/*
-	 * Now write a value and read it back to see if it matches,
-	 * this is needed to detect certain hardware emulators (qemu/kvm)
-	 * that don't trap on the MSR access and always return 0s.
+	 * Read the current value, change it and read it back to see if it
+	 * matches, this is needed to detect certain hardware emulators
+	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
 	 */
-	val = 0xabcdUL;
 	reg = x86_pmu_event_addr(0);
+	if (rdmsrl_safe(reg, &val))
+		goto msr_fail;
+	val ^= 0xffffUL;
 	ret = wrmsrl_safe(reg, val);
 	ret |= rdmsrl_safe(reg, &val_new);
 	if (ret || val != val_new)
