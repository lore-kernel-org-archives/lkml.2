Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab2KZRE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:04:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47368 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2KZRET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 073/270] xen/bootup: allow {read|write}_cr8 pvops call.
Date: Mon, 26 Nov 2012 14:56:03 -0200
Message-Id: <1353949160-26803-74-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 1a7bbda5b1ab0e02622761305a32dc38735b90b2 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/xen/enlighten.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 93dcfdc..c1656e0 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -952,7 +952,16 @@ static void xen_write_cr4(unsigned long cr4)
 
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
@@ -1121,6 +1130,11 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
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
1.7.9.5

