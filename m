Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2GWSiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:38:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39690 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab2GWShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:37:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/5] xen/perf: Define .glob for the different hypercalls.
Date: Mon, 23 Jul 2012 14:28:23 -0400
Message-Id: <1343068103-13579-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343068103-13579-1-git-send-email-konrad.wilk@oracle.com>
References: <1343068103-13579-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us in perf to have this:

 99.67%  [kernel]             [k] xen_hypercall_sched_op
  0.11%  [kernel]             [k] xen_hypercall_xen_version

instead of the borring ever-encompassing:

 99.13%  [kernel]              [k] hypercall_page

[v2: Use a macro to define the name and skip]
[v3: Use balign per Jan's suggestion]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/xen-head.S |   56 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index aaa7291..7faed58 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -28,9 +28,61 @@ ENTRY(startup_xen)
 	__FINIT
 
 .pushsection .text
-	.align PAGE_SIZE
+	.balign PAGE_SIZE
 ENTRY(hypercall_page)
-	.skip PAGE_SIZE
+#define NEXT_HYPERCALL(x) \
+	ENTRY(xen_hypercall_##x) \
+	.skip 32
+
+NEXT_HYPERCALL(set_trap_table)
+NEXT_HYPERCALL(mmu_update)
+NEXT_HYPERCALL(set_gdt)
+NEXT_HYPERCALL(stack_switch)
+NEXT_HYPERCALL(set_callbacks)
+NEXT_HYPERCALL(fpu_taskswitch)
+NEXT_HYPERCALL(sched_op_compat)
+NEXT_HYPERCALL(platform_op)
+NEXT_HYPERCALL(set_debugreg)
+NEXT_HYPERCALL(get_debugreg)
+NEXT_HYPERCALL(update_descriptor)
+NEXT_HYPERCALL(ni)
+NEXT_HYPERCALL(memory_op)
+NEXT_HYPERCALL(multicall)
+NEXT_HYPERCALL(update_va_mapping)
+NEXT_HYPERCALL(set_timer_op)
+NEXT_HYPERCALL(event_channel_op_compat)
+NEXT_HYPERCALL(xen_version)
+NEXT_HYPERCALL(console_io)
+NEXT_HYPERCALL(physdev_op_compat)
+NEXT_HYPERCALL(grant_table_op)
+NEXT_HYPERCALL(vm_assist)
+NEXT_HYPERCALL(update_va_mapping_otherdomain)
+NEXT_HYPERCALL(iret)
+NEXT_HYPERCALL(vcpu_op)
+NEXT_HYPERCALL(set_segment_base)
+NEXT_HYPERCALL(mmuext_op)
+NEXT_HYPERCALL(xsm_op)
+NEXT_HYPERCALL(nmi_op)
+NEXT_HYPERCALL(sched_op)
+NEXT_HYPERCALL(callback_op)
+NEXT_HYPERCALL(xenoprof_op)
+NEXT_HYPERCALL(event_channel_op)
+NEXT_HYPERCALL(physdev_op)
+NEXT_HYPERCALL(hvm_op)
+NEXT_HYPERCALL(sysctl)
+NEXT_HYPERCALL(domctl)
+NEXT_HYPERCALL(kexec_op)
+NEXT_HYPERCALL(tmem_op) /* 38 */
+ENTRY(xen_hypercall_rsvr)
+	.skip 320
+NEXT_HYPERCALL(mca) /* 48 */
+NEXT_HYPERCALL(arch_1)
+NEXT_HYPERCALL(arch_2)
+NEXT_HYPERCALL(arch_3)
+NEXT_HYPERCALL(arch_4)
+NEXT_HYPERCALL(arch_5)
+NEXT_HYPERCALL(arch_6)
+	.balign PAGE_SIZE
 .popsection
 
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
-- 
1.7.7.6

