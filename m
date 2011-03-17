Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1CQPgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:36:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32201 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1CQPgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:36:38 -0400
Date: Thu, 17 Mar 2011 16:36:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans de Goede <hdegoede@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree 
 (jdelvare-hwmon tree related)
Message-ID: <20110317163621.2a546644@endymion.delvare>
In-Reply-To: <AANLkTin46NLhP+0mmYELkD8zeC5o32H=-jXkySZ4R_dj@mail.gmail.com>
References: <20110315192428.ce74a177.sfr@canb.auug.org.au>
	<4D7F2609.3080508@redhat.com>
	<20110315103228.30233acc@endymion.delvare>
	<20110315212226.7e940b51.sfr@canb.auug.org.au>
	<AANLkTin46NLhP+0mmYELkD8zeC5o32H=-jXkySZ4R_dj@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 13:18:00 +0100, Geert Uytterhoeven wrote:
> On Tue, Mar 15, 2011 at 11:22, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Tue, 15 Mar 2011 10:32:28 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> >> Stephen, sorry for the inconvenience, both Hans and myself build-tested
> >> the new code on an architecture where <linux/delay.h> gets included
> >> implicitly, so we didn't notice it was missing.
> >
> > It happens.  It seems that delay.h is almost always the one that is
> > forgotten.  X86 builds include it implicitly but powerpc doesn't.
> >
> > I wonder if we could concoct a nice checkpatch test for it.
> 
> Or remove the implicit includes on x86...
> 
> $ git grep delay\\.h arch/x86/include/
> arch/x86/include/asm/apic.h:#include <linux/delay.h>
> arch/x86/include/asm/dma.h:#include <linux/delay.h>
> arch/x86/include/asm/i8259.h:#include <linux/delay.h>
> $
> 
> At first sight, apic.h and dmah.h don't seem to need it.

Something like this?

* * * * *

Stop including <linux/delay.h> in x86 header files which don't need
it. This will let the compiler complain when this header is not
included by source files when it should, so that contributors can fix
the problem before building on other architectures starts to fail.

Credits go to Geert for the idea.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/asm/apic.h        |    1 -
 arch/x86/include/asm/dma.h         |    1 -
 arch/x86/kernel/apic/hw_nmi.c      |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 +
 arch/x86/kernel/irq.c              |    1 +
 arch/x86/kernel/reboot.c           |    1 +
 arch/x86/platform/uv/tlb_uv.c      |    1 +
 drivers/scsi/ultrastor.c           |    1 +
 8 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_APIC_H
 
 #include <linux/cpumask.h>
-#include <linux/delay.h>
 #include <linux/pm.h>
 
 #include <asm/alternative.h>
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -10,7 +10,6 @@
 
 #include <linux/spinlock.h>	/* And spinlocks */
 #include <asm/io.h>		/* need byte IO */
-#include <linux/delay.h>
 
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
 #define dma_outb	outb_p
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -16,6 +16,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/kdebug.h>
+#include <linux/delay.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -8,6 +8,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
+#include <linux/delay.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -6,6 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/sched.h>
 #include <linux/tboot.h>
+#include <linux/delay.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -11,6 +11,7 @@
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include <asm/mmu_context.h>
 #include <asm/uv/uv.h>
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -138,6 +138,7 @@
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/system.h>


-- 
Jean Delvare
