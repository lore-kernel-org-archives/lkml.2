Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220Ab2DLI5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:57:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:35911 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2DLI5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:57:51 -0400
Date: Thu, 12 Apr 2012 10:57:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [v3.4-rc1] ACPI regression bisected
In-Reply-To: <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1204121055200.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com> <20120402235412.GD16303@tassilo.jf.intel.com> <alpine.LFD.2.02.1204031001510.2542@ionos> <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-572836832-1334221066=:2542"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-572836832-1334221066=:2542
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 12 Apr 2012, Jörg Otte wrote:

> I tried that patch, for me it works.

> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -607,7 +607,8 @@ acpi_os_install_interrupt_handler(u32 gsi, acpi_osd_handler handler,
> >
> >        acpi_irq_handler = handler;
> >        acpi_irq_context = context;
> > -       if (request_threaded_irq(irq, NULL, acpi_irq, IRQF_SHARED, "acpi",
> > +       if (request_threaded_irq(irq, NULL, acpi_irq,
> > +                                IRQF_SHARED | IRQF_ONESHOT, "acpi",
> >                                 acpi_irq)) {
> >                printk(KERN_ERR PREFIX "SCI (IRQ%d) allocation failed\n", irq);
> >                acpi_irq_handler = NULL;

OK, so now the question is whether the ACPI interrupt can end up being
shared or not.

If it can be shared, then we need a proper primary handler which
silences the interrupt at the device level and the threaded handler
needs to reenable it after finishing the processing.

Len, Andi ???

Thanks,

	tglx
--8323328-572836832-1334221066=:2542--
