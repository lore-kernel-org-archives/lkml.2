Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2JQODu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:03:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44587 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab2JQODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:03:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] xen/acpi: Prep saved_context cr3 values.
Date: Wed, 17 Oct 2012 09:49:46 -0400
Message-Id: <1350481786-4969-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When save_processor_state is executed it executes a bunch of
pvops calls to save the CPU state values. When it comes back
from Xen's S3 (so acpi_enter_sleep_state, which ends up calling
xen_acpi_notify_hypervisor_state), it ends up back in the
assembler code in wakeup_[32|64].S. It skips the wakeup
calls (so wakeup_pmode_return and wakeup_long64) as that has
been done in the hypervisor. Instead it continues on in
the resume_point (64-bit) or ret_point (32-bit). Most of the
calls in there are safe to be executed except when it comes to
reloading of cr3 (which it only does on 64-bit kernels). Since
they are native assembler calls and Xen expects a PV kernel to
prep those to use machine address for cr3 that is what
we are going to do. Note: that it is not Machine Frame Numbers
(those are used in the MMUEXT_NEW_BASEPTR hypercall for cr3
installation) but the machine physical address.

When the assembler code executes this mov %ebx, cr3 it ends
end up trapped in the hypervisor (traps.c) which properly now
sets the cr3 value.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/acpi.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/acpi.c b/drivers/xen/acpi.c
index 119d42a..25e612c 100644
--- a/drivers/xen/acpi.c
+++ b/drivers/xen/acpi.c
@@ -35,6 +35,13 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
+#include <xen/page.h>
+
+#ifdef CONFIG_X86_64
+#include <asm/suspend_64.h>
+extern struct saved_context saved_context;
+#endif
+
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnt)
 {
@@ -56,7 +63,25 @@ int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 		     pm1a_cnt, pm1b_cnt);
 		return -1;
 	}
+#ifdef CONFIG_X86_64
+	/* We do not need to anything for 32-bit kernels as the
+	 * low-level calls (write to cr3) is done in the wakup code
+	 * which we never execute when running under Xen.
+	 */
+	{
+		unsigned long mfn;
 
+		/* resume_point in wakeup_64.s barrels through and does:
+		 * movq    saved_context_cr3(%rax), %rbx
+		 * movq    %rbx, %cr3
+		 * so lets prep the values so they are OK with the
+		 * hypervisor. */
+		mfn = pfn_to_mfn(PFN_DOWN(saved_context.cr3));
+		/* and back to a physical address */
+		mfn = PFN_PHYS(mfn);
+		saved_context.cr3 = mfn;
+	}
+#endif
 	HYPERVISOR_dom0_op(&op);
 	return 1;
 }
-- 
1.7.7.6

