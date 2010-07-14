Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab0GNVFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:05:14 -0400
Received: from www.tglx.de ([62.245.132.106]:38055 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab0GNVFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:05:12 -0400
Date: Wed, 14 Jul 2010 23:04:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <borislav.petkov@amd.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephan Wolf <stephan@letzte-bankreihe.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00, kernel
 2.6.35_rc5
In-Reply-To: <20100714183216.GC15651@aftab>
Message-ID: <alpine.LFD.2.00.1007142134140.3321@localhost.localdomain>
References: <4C3DDDFF.5040302@letzte-bankreihe.de> <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com> <20100714181152.GB15651@aftab> <AANLkTin71FbM5Eh7TDUHN0WvYHA5RubycflTxM5EWlvj@mail.gmail.com> <20100714183216.GC15651@aftab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Borislav Petkov wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, Jul 14, 2010 at 02:17:27PM -0400
> 
> > > I'll try to find out which chipsets are actually affected but in the
> > > meantime we might want to do a temporary fix by enabling the readback
> > > back(!) on all ATI chipsets so that we don't uncover anymore bugs like
> > > the one above, hmmm?
> > 
> > That sounds like the right solution for now, yes.  Rather than make
> > the readback quirk depend on one particular SMBUS revision, make it
> > happen unconditionally for an AMD northbridge (or is the HPET in the
> > SB?
> 
> Yeah, its in the southbridge which is part of the chipset. Actually
> we'll have to somehow match ATI chipsets only since we have also nVidia
> chipsets with AMD cpus in them.
> 
> /me goes to meditate a little about it.
> 
> > I forget - somebody who knows the details and can test it on a
> > machine or two should do the actual patch).
> 
> I'll try to cook up something unless someone beats me to it.

The patch below works on my collection of ATI chipset based machines.

Stefan, does it solve your problem too ?

Thanks,

	tglx
-----

Subject: x86-ati-chipsets-hpet-force-readback.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Jul 2010 21:36:27 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Index: linux-2.6/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early-quirks.c
+++ linux-2.6/arch/x86/kernel/early-quirks.c
@@ -18,6 +18,7 @@
 #include <asm/apic.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/hpet.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
@@ -191,6 +192,21 @@ static void __init ati_bugs_contd(int nu
 }
 #endif
 
+/*
+ * Force the read back of the CMP register in hpet_next_event()
+ * to work around the problem that the CMP register write seems to be
+ * delayed. See hpet_next_event() for details.
+ *
+ * We do this on all SMBUS incarnations for now until we have more
+ * information about the affected chipsets.
+ */
+static void __init ati_hpet_bugs(int num, int slot, int func)
+{
+#ifdef CONFIG_HPET_TIMER
+	hpet_readback_cmp = 1;
+#endif
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -220,6 +236,8 @@ static struct chipset early_qrk[] __init
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
+	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_hpet_bugs },
 	{}
 };
 
Index: linux-2.6/arch/x86/kernel/quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/quirks.c
+++ linux-2.6/arch/x86/kernel/quirks.c
@@ -498,15 +498,10 @@ void force_hpet_resume(void)
  * See erratum #27 (Misinterpreted MSI Requests May Result in
  * Corrupted LPC DMA Data) in AMD Publication #46837,
  * "SB700 Family Product Errata", Rev. 1.0, March 2010.
- *
- * Also force the read back of the CMP register in hpet_next_event()
- * to work around the problem that the CMP register write seems to be
- * delayed. See hpet_next_event() for details.
  */
 static void force_disable_hpet_msi(struct pci_dev *unused)
 {
 	hpet_msi_disable = 1;
-	hpet_readback_cmp = 1;
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
