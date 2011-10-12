Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1JLStI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:49:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1JLStG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:49:06 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=cbWCuUHGdOkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=meVymXHHAAAA:8 a=8WWpWBZsrg0-NEZsig0A:9 a=vvr6ssrvJLUzIIu-IZ0A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318445342.13262.54.camel@gandalf.stny.rr.com>
Subject: [PATCH][RFC] acpi: Prevent scheduling while atomic warning in early
 boot
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Francois Valenduc <francois.valenduc@tvcablenet.be>,
        Lin Ming <ming.m.lin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 12 Oct 2011 14:49:02 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hit the following bug:

[    0.109053] ACPI: Core revision 20110623
[    0.116130] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.120017] no locks held by swapper/0.
[    0.124016] Modules linked in:
[    0.128199] Pid: 0, comm: swapper Not tainted 3.1.0-rc1-test-00020-gd696b58 #5
[    0.132016] Call Trace:
[    0.134455]  [<ffffffff83ec3be1>] __schedule_bug+0xb4/0xc0
[    0.140038]  [<ffffffff83fdc782>] schedule+0xaf/0x772
[    0.144022]  [<ffffffff810d3d63>] __cond_resched+0x2f/0x41
[    0.148020]  [<ffffffff83fdd197>] _cond_resched+0x2e/0x3e
[    0.152022]  [<ffffffff81b82bff>] acpi_ps_complete_op+0x5b5/0x5f8^M
[    0.156021]  [<ffffffff81b83a41>] acpi_ps_parse_loop+0x5e4/0x69f
[    0.160021]  [<ffffffff81b8b28c>] ? acpi_ut_exit+0x3a/0x49
[    0.164021]  [<ffffffff81b81a88>] acpi_ps_parse_aml+0x1db/0x5fb^M
[    0.168021]  [<ffffffff81b7e1a4>] acpi_ns_one_complete_parse+0x2a8/0x2fa
[    0.172021]  [<ffffffff81b7e279>] acpi_ns_parse_table+0x83/0x17a^M
[    0.176023]  [<ffffffff81b76ed8>] acpi_ns_load_table+0x104/0x234
[    0.180022]  [<ffffffff81b881b8>] acpi_tb_load_namespace+0x110/0x2a0
[    0.184022]  [<ffffffff81b88384>] acpi_load_tables+0x3c/0xa1
[    0.188024]  [<ffffffff8653c21e>] acpi_early_init+0xca/0x1a7
[    0.192023]  [<ffffffff864de1c7>] start_kernel+0x6b2/0x6ea
[    0.196023]  [<ffffffff864dd3dd>] x86_64_start_reservations+0xf5/0x100^M
[    0.200023]  [<ffffffff864dd140>] ? early_idt_handlers+0x140/0x140
[    0.204023]  [<ffffffff864dd521>] x86_64_start_kernel+0x139/0x14f


The commit 0a7992c90828a65 acpi: fix bogus preemption logic

tried again to fix the preempt logic by encapsulating the
ACPI_PREEMPTION_POINT() with a #ifndef CONFIG_PREEMPT and only testing
irqsoff. But when CONFIG_PREEMPT=n and CONFIG_DEBUG_ATOMIC_SLEEP=y, the
preempt count is still active. This code is called at boot up when
preemption is still disabled triggering the above dump.

Ideally, in_atomic() should not be used in general code, but I'm not
sure what should be used. This does silent the warning, and it should
not be an issue while it is still encapsulated in #ifndef CONFIG_PREEMPT

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index f72403c..1730ff8 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -59,6 +59,7 @@
 #include <linux/ctype.h>
 #include <linux/sched.h>
 #include <asm/system.h>
+#include <linux/hardirq.h>
 #include <linux/atomic.h>
 #include <asm/div64.h>
 #include <asm/acpi.h>
@@ -151,10 +152,14 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 /*
  * Used within ACPICA to show where it is safe to preempt execution
  * when CONFIG_PREEMPT=n
+ *
+ * Note we still test for !in_atomic() in case CONFIG_DEBUG_ATOMIC_SLEEP
+ * is set. In that case, preempt_count is still updated and scheduling
+ * here will cause a warning in early boot.
  */
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!irqs_disabled()) \
+		if (!irqs_disabled() && !in_atomic())	\
 			cond_resched(); \
 	} while (0)
 #endif


