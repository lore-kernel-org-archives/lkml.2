Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2HCVVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:21:31 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:38727 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2HCVV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:21:27 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Correct the Atari ALLOWINT definition
Date: Fri,  3 Aug 2012 23:21:17 +0200
Message-Id: <1344028877-18838-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>

commit c663600584a596b5e66258cc10716fb781a5c2c9 upstream.

Booting a 3.2, 3.3, or 3.4-rc4 kernel on an Atari using the
`nfeth' ethernet device triggers a WARN_ONCE() in generic irq
handling code on the first irq for that device:

WARNING: at kernel/irq/handle.c:146 handle_irq_event_percpu+0x134/0x142()
irq 3 handler nfeth_interrupt+0x0/0x194 enabled interrupts
Modules linked in:
Call Trace: [<000299b2>] warn_slowpath_common+0x48/0x6a
 [<000299c0>] warn_slowpath_common+0x56/0x6a
 [<00029a4c>] warn_slowpath_fmt+0x2a/0x32
 [<0005b34c>] handle_irq_event_percpu+0x134/0x142
 [<0005b34c>] handle_irq_event_percpu+0x134/0x142
 [<0000a584>] nfeth_interrupt+0x0/0x194
 [<001ba0a8>] schedule_preempt_disabled+0x0/0xc
 [<0005b37a>] handle_irq_event+0x20/0x2c
 [<0005add4>] generic_handle_irq+0x2c/0x3a
 [<00002ab6>] do_IRQ+0x20/0x32
 [<0000289e>] auto_irqhandler_fixup+0x4/0x6
 [<00003144>] cpu_idle+0x22/0x2e
 [<001b8a78>] printk+0x0/0x18
 [<0024d112>] start_kernel+0x37a/0x386
 [<0003021d>] __do_proc_dointvec+0xb1/0x366
 [<0003021d>] __do_proc_dointvec+0xb1/0x366
 [<0024c31e>] _sinittext+0x31e/0x9c0

After invoking the irq's handler the kernel sees !irqs_disabled()
and concludes that the handler erroneously enabled interrupts.

However, debugging shows that !irqs_disabled() is true even before
the handler is invoked, which indicates a problem in the platform
code rather than the specific driver.

The warning does not occur in 3.1 or older kernels.

It turns out that the ALLOWINT definition for Atari is incorrect.

The Atari definition of ALLOWINT is ~0x400, the stated purpose of
that is to avoid taking HSYNC interrupts.  irqs_disabled() returns
true if the 3-bit ipl & 4 is non-zero.  The nfeth interrupt runs at
ipl 3 (it's autovector 3), but 3 & 4 is zero so irqs_disabled() is
false, and the warning above is generated.

When interrupts are explicitly disabled, ipl is set to 7.  When they
are enabled, ipl is masked with ALLOWINT.  On Atari this will result
in ipl = 3, which blocks interrupts at ipl 3 and below.  So how come
nfeth interrupts at ipl 3 are received at all?  That's because ipl
is reset to 2 by Atari-specific code in default_idle(), again with
the stated purpose of blocking HSYNC interrupts.  This discrepancy
means that ipl 3 can remain blocked for longer than intended.

Both default_idle() and falcon_hblhandler() identify HSYNC with
ipl 2, and the "Atari ST/.../F030 Hardware Register Listing" agrees,
but ALLOWINT is defined as if HSYNC was ipl 3.

[As an experiment I modified default_idle() to reset ipl to 3, and
as expected that resulted in all nfeth interrupts being blocked.]

The fix is simple: define ALLOWINT as ~0x500 instead.  This makes
arch_local_irq_enable() consistent with default_idle(), and prevents
the !irqs_disabled() problems for ipl 3 interrupts.

Tested on Atari running in an Aranym VM.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Tested-by: Michael Schmitz <schmitzmic@googlemail.com> (on Falcon/CT60)
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This version applies to v3.2..v3.4.
For v2.6.29..v3.1, it should be applied to arch/m68k/include/asm/entry_mm.h
instead

 arch/m68k/include/asm/entry.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/entry.h b/arch/m68k/include/asm/entry.h
index c3c5a86..8798ebc 100644
--- a/arch/m68k/include/asm/entry.h
+++ b/arch/m68k/include/asm/entry.h
@@ -33,8 +33,8 @@
 
 /* the following macro is used when enabling interrupts */
 #if defined(MACH_ATARI_ONLY)
-	/* block out HSYNC on the atari */
-#define ALLOWINT	(~0x400)
+	/* block out HSYNC = ipl 2 on the atari */
+#define ALLOWINT	(~0x500)
 #define	MAX_NOINT_IPL	3
 #else
 	/* portable version */
-- 
1.7.0.4

