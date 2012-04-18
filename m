Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2DRK3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:29:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:32818 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2DRK3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:29:46 -0400
Date: Wed, 18 Apr 2012 12:29:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Andi Kleen <ak@linux.intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [v3.4-rc1] ACPI regression bisected
In-Reply-To: <1334741105.1924.5.camel@x61.thuisdomein>
Message-ID: <alpine.LFD.2.02.1204181216380.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>  <20120402235412.GD16303@tassilo.jf.intel.com>  <alpine.LFD.2.02.1204031001510.2542@ionos>  <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com> 
 <alpine.LFD.2.02.1204121055200.2542@ionos>  <20120412142904.GA4130@srcf.ucam.org>  <alpine.LFD.2.02.1204121903250.2542@ionos>  <alpine.LFD.2.02.1204121907330.2542@ionos>  <4F872C7B.6000106@linux.intel.com>  <alpine.LFD.2.02.1204122241460.2542@ionos>
 <1334741105.1924.5.camel@x61.thuisdomein>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2601;0cOn Wed, 18 Apr 2012, Paul Bolle wrote:
> On Thu, 2012-04-12 at 22:42 +0200, Thomas Gleixner wrote:
> > > For 3.4 I think reverting is the right approach.
> > 
> > Ack.
> 
> A revert of 6fe0d0628245fdcd6fad8b837c81e8f7ebc3364d ("ACPI: Make ACPI
> interrupt threaded") wasn't included in v3.4-rc3. Has it been pushed
> somewhere? Is testing needed before that revert can be pushed?

Seems those who broke it are too busy to care.

Linus, can you please apply directly?

------------>
Subject: ACPI: Revert 6fe0d06 ("ACPI: Make ACPI interrupt threaded")
From: Thomas Gleixner <tglx@linutronix.de>

Paul bisected this regression to 6fe0d06 ("ACPI: Make ACPI interrupt
threaded"). 

The conversion was done blindly and is wrong, as it does not provide a
primary handler to disable the level type irq on the device
level. Neither does it set the IRQF_ONESHOT flag which handles that at
the irq line level. This can't be done as the interrupt might be
shared, though we might extend the core to force it.

So an interrupt on this line will wake up the thread, but immediately
unmask the irq after that. Due to the interrupt being level type the
hardware interrupt is raised over and over and prevents the irq thread
from handling it. Fail.

request_irq() unfortunately does not refuse such a request and the
patch was obviously never tested with real interrupts.

Bisected-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git b/drivers/acpi/osl.c a/drivers/acpi/osl.c
index 02367a8..412a1e0 100644
--- b/drivers/acpi/osl.c
+++ a/drivers/acpi/osl.c
@@ -595,8 +595,7 @@ acpi_os_install_interrupt_handler(u32 gsi, acpi_osd_handler handler,
 
 	acpi_irq_handler = handler;
 	acpi_irq_context = context;
-	if (request_threaded_irq(irq, NULL, acpi_irq, IRQF_SHARED, "acpi",
-				 acpi_irq)) {
+	if (request_irq(irq, acpi_irq, IRQF_SHARED, "acpi", acpi_irq)) {
 		printk(KERN_ERR PREFIX "SCI (IRQ%d) allocation failed\n", irq);
 		acpi_irq_handler = NULL;
 		return AE_NOT_ACQUIRED;

