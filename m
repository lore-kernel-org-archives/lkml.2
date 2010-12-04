Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0LDKhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 05:37:50 -0500
Received: from www.tglx.de ([62.245.132.106]:46130 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab0LDKhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 05:37:48 -0500
Date: Sat, 4 Dec 2010 11:37:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/5] KVM&genirq: Enable adaptive IRQ sharing for
 passed-through devices
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
Message-ID: <alpine.LFD.2.00.1012041052450.2653@localhost6.localdomain6>
References: <cover.1291419444.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Dec 2010, Jan Kiszka wrote:

> Besides 3 cleanup patches, this series consists of two major changes.
> The first introduces an interrupt sharing notifier to the genirq
> subsystem. It fires when an interrupt line is about to be use by more
> than one driver or the last but one user called free_irq.
> 
> The second major change makes use of this interface in KVM's PCI pass-
> through subsystem. KVM has to keep the interrupt source disabled while
> calling into the guest to handle the event. This can be done at device
> or line level. The former is required to share the interrupt line, the
> latter is an order of magnitude faster (see patch 3 for details).
> 
> Beside pass-through support of KVM, further users of the IRQ notifier
> could become VFIO (not yet mainline) and uio_pci_generic which have to
> resolve the same conflict.

Hmm. You basically want to have the following functionality:

If interrupt is shared, then you want to keep the current behaviour:

   disable at line level (IRQF_ONESHOT)
   run handler thread (PCI level masking)
   reenable at line level in irq_finalize_oneshot()
   reenable at PCI level when guest is done

If interrupt is not shared:

   disable at line level (IRQF_ONESHOT)
   run handler thread (no PCI level masking)
   no reenable at line level
   reenable at line level when guest is done

I think the whole notifier approach including the extra irq handlers
plus the requirement to call disable_irq_nosync() from the non shared
handler is overkill. We can be more clever.

The genirq code knows whether you have one or more handler
registered. So we can add IRQF_ONESHOT_UNMASK_SHARED and add a status
field to irq_data (which I was going to do anyway for other
reasons). In that status field you get a bit which says IRQ_MASK_DEVICE.

So with IRQF_ONESHOT_UNMASK_SHARED == 0 we keep the current behaviour.

If IRQF_ONESHOT_UNMASK_SHARED== 1 and IRQ_MASK_DEVICE == 1 we keep the
current behaviour.

If IRQF_ONESHOT_UNMASK_SHARED== 1 and IRQ_MASK_DEVICE == 0 then then
irq_finalize_oneshot() simply marks the interrupt disabled (equivalent
to disable_irq_nosync()) and returns.

Now in your primary irq handler you simply check the IRQ_MASK_DEVICE
status flag and decide whether you need to mask at PCI level or not.

Your threaded handler gets the same information via IRQ_MASK_DEVICE so
it can issue the appropriate user space notification depending on that
flag.

This works fully transparent across adding and removing handlers. On
request_irq/free_irq we update the IRQ_MASK_DEVICE flag with the
following logic:

    nr_actions	IRQF_ONESHOT_UNMASK_SHARED	IRQ_MASK_DEVICE
    1		0				1
    1		1				0
    >1		don't care			1

If interrupts are in flight accross request/free then this change
takes effect when the next interrupt comes in.

No notifiers, no disable_irq_nosync() magic, less and simpler code.

Thoughts ?

	 tglx
