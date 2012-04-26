Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab2DZSfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:35:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44757 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758840Ab2DZSfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:35:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] xen/enlighten: Disable MWAIT_LEAF so that acpi-pad won't be loaded.
Date: Thu, 26 Apr 2012 14:29:22 -0400
Message-Id: <1335464965-24767-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1335464965-24767-1-git-send-email-konrad.wilk@oracle.com>
References: <1335464965-24767-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are exactly four users of __monitor and __mwait:

 - cstate.c (which allows acpi_processor_ffh_cstate_enter to be called
   when the cpuidle API drivers are used. However patch
   "cpuidle: replace xen access to x86 pm_idle and default_idle"
   provides a mechanism to disable the cpuidle and use safe_halt.
 - smpboot (which allows mwait_play_dead to be called). However
   safe_halt is always used so we skip that.
 - intel_idle (same deal as above).
 - acpi_pad.c. This the one that we do not want to run as we
   will hit the below crash.

Why do we want to expose MWAIT_LEAF in the first place?
We want it for the xen-acpi-processor driver - which uploads
C-states to the hypervisor. If MWAIT_LEAF is set, the cstate.c
sets the proper address in the C-states so that the hypervisor
can benefit from using the MWAIT functionality. And that is
the sole reason for using it.

Without this patch, if a module performs mwait or monitor we
get this:

invalid opcode: 0000 [#1] SMP
CPU 2
.. snip..
Pid: 5036, comm: insmod Tainted: G           O 3.4.0-rc2upstream-dirty #2 Intel Corporation S2600CP/S2600CP
RIP: e030:[<ffffffffa000a017>]  [<ffffffffa000a017>] mwait_check_init+0x17/0x1000 [mwait_check]
RSP: e02b:ffff8801c298bf18  EFLAGS: 00010282
RAX: ffff8801c298a010 RBX: ffffffffa03b2000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8801c29800d8 RDI: ffff8801ff097200
RBP: ffff8801c298bf18 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffffffffa000a000 R14: 0000005148db7294 R15: 0000000000000003
FS:  00007fbb364f2700(0000) GS:ffff8801ff08c000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000179f038 CR3: 00000001c9469000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process insmod (pid: 5036, threadinfo ffff8801c298a000, task ffff8801c29cd7e0)
Stack:
 ffff8801c298bf48 ffffffff81002124 ffffffffa03b2000 00000000000081fd
 000000000178f010 000000000178f030 ffff8801c298bf78 ffffffff810c41e6
 00007fff3fb30db9 00007fff3fb30db9 00000000000081fd 0000000000010000
Call Trace:
 [<ffffffff81002124>] do_one_initcall+0x124/0x170
 [<ffffffff810c41e6>] sys_init_module+0xc6/0x220
 [<ffffffff815b15b9>] system_call_fastpath+0x16/0x1b
Code: <0f> 01 c8 31 c0 0f 01 c9 c9 c3 00 00 00 00 00 00 00 00 00 00 00 00
RIP  [<ffffffffa000a017>] mwait_check_init+0x17/0x1000 [mwait_check]
 RSP <ffff8801c298bf18>
---[ end trace 16582fc8a3d1e29a ]---
Kernel panic - not syncing: Fatal exception

With this module (which is what acpi_pad.c would hit):

MODULE_AUTHOR("Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>");
MODULE_DESCRIPTION("mwait_check_and_back");
MODULE_LICENSE("GPL");
MODULE_VERSION();

static int __init mwait_check_init(void)
{
	__monitor((void *)&current_thread_info()->flags, 0, 0);
	__mwait(0, 0);
	return 0;
}
static void __exit mwait_check_exit(void)
{
}
module_init(mwait_check_init);
module_exit(mwait_check_exit);

Reported-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4f51beb..407008d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -349,9 +349,11 @@ static void __init xen_init_cpuid_mask(void)
 	/* Xen will set CR4.OSXSAVE if supported and not disabled by force */
 	if ((cx & xsave_mask) != xsave_mask)
 		cpuid_leaf1_ecx_mask &= ~xsave_mask; /* disable XSAVE & OSXSAVE */
-
+#if !defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) && \
+    !defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)
 	if (xen_check_mwait())
 		cpuid_leaf1_ecx_set_mask = (1 << (X86_FEATURE_MWAIT % 32));
+#endif
 }
 
 static void xen_set_debugreg(int reg, unsigned long val)
-- 
1.7.7.5

