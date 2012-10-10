Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2JJRwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:52:44 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16905 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2JJRwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:52:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] xen/bootup: allow {read|write}_cr8 pvops call.
Date: Wed, 10 Oct 2012 13:40:48 -0400
Message-Id: <1349890849-17471-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
References: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We actually do not do anything about it. Just return a default
value of zero and if the kernel tries to write anything but 0
we BUG_ON.

This fixes the case when an user tries to suspend the machine
and it blows up in save_processor_state b/c 'read_cr8' is set
to NULL and we get:

kernel BUG at /home/konrad/ssd/linux/arch/x86/include/asm/paravirt.h:100!
invalid opcode: 0000 [#1] SMP
Pid: 2687, comm: init.late Tainted: G           O 3.6.0upstream-00002-gac264ac-dirty #4 Bochs Bochs
RIP: e030:[<ffffffff814d5f42>]  [<ffffffff814d5f42>] save_processor_state+0x212/0x270

.. snip..
Call Trace:
 [<ffffffff810733bf>] do_suspend_lowlevel+0xf/0xac
 [<ffffffff8107330c>] ? x86_acpi_suspend_lowlevel+0x10c/0x150
 [<ffffffff81342ee2>] acpi_suspend_enter+0x57/0xd5

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1fbe75a..e1e4636 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -984,7 +984,16 @@ static void xen_write_cr4(unsigned long cr4)
 
 	native_write_cr4(cr4);
 }
-
+#ifdef CONFIG_X86_64
+static inline unsigned long xen_read_cr8(void)
+{
+	return 0;
+}
+static inline void xen_write_cr8(unsigned long val)
+{
+	BUG_ON(val);
+}
+#endif
 static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 {
 	int ret;
@@ -1153,6 +1162,11 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.read_cr4_safe = native_read_cr4_safe,
 	.write_cr4 = xen_write_cr4,
 
+#ifdef CONFIG_X86_64
+	.read_cr8 = xen_read_cr8,
+	.write_cr8 = xen_write_cr8,
+#endif
+
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
-- 
1.7.7.6

