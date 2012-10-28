Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2J1XfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:35:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42145 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756924Ab2J1X2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:12 -0400
Message-Id: <20121028231550.646478511@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 044/105] xen/bootup: allow {read|write}_cr8 pvops call.
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/enlighten.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 668bbfe..4466feb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -987,7 +987,16 @@ static void xen_write_cr4(unsigned long cr4)
 
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
@@ -1156,6 +1165,11 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.read_cr4_safe = native_read_cr4_safe,
 	.write_cr4 = xen_write_cr4,
 
+#ifdef CONFIG_X86_64
+	.read_cr8 = xen_read_cr8,
+	.write_cr8 = xen_write_cr8,
+#endif
+
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,


