Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab0JFXAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:00:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28725 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244Ab0JFXAm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 6 Oct 2010 19:00:42 -0400
Date: Wed, 6 Oct 2010 18:59:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 09/22] xen: Find an unbound irq number in reverse order
 (high to low).
Message-ID: <20101006225956.GB20211@dumpdata.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
 <1286216015-9710-10-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1010051617160.2440@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010051617160.2440@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Unfortunately this is the wrong way to fix the issue: Xen has a range of
> allowed pirq for each domain and we don't know exactly what is the
> maximum pirq (see my patch "xen: get the maximum number of pirqs from
> xen" [1]).

> Considering that we might use the irq number returned by
> find_unbound_irq through xen_allocate_pirq as pirq number in some cases,

Ah, but we wouldn't! We would end up only using the 'find_unbound_irq' for
event channels. For IRQs that are for physical devices (either being
real devices passed in or QEMU PCI devices) we end up requesting an IRQ that
matches whatever the device has defined in dev->irq (or whatever the
vectors values for MSI/MSI-X devices that is provided) via the Xen PCI frontend
driver (in case of QEMU whatever its emulation provides).

> starting from the highest value could be unsafe.
> In practice it should be impossible to see this issue because it can
> only happen if the irq returned by xen_allocate_pirq is higher than the
> max pirq in xen. However AFAIK when we call xen_allocate_pirq with the
> intention of using the return value as pirq we always fall in the if
> (identity_mapped_irq(gsi) || !xen_initial_domain()) that avoid calling
> find_unbound_irq.

Right, and we end up using an the pirq/gsi number at that point. This
patch would not touch that logic.

> In any case I still think that it is a good idea to try to avoid the problem.
> 
> In order to solve this issue you can:
> 
> - add a static offset to get_nr_hw_irqs in case of pv domains;
> 
> - use the patch "xen: get the maximum number of pirqs from
> xen" [1] to get the highest possible pirq number from xen so that we can be
> sure we are using an allowed value;
> 
> - if the xen interface allows it, disjoin the concept of pirq from the
> concept of linux irq; then you can let xen choose any pirq number it
> wants (see my patch "xen: support pirq != irq" [2] and how you can exploit
> it in the patch "xen: implement xen_hvm_register_pirq" [3]).
> Of course this doesn't help if it must be linux the one that chooses the
> pirq number.

All of those deal with PCI devices. This patch is intended for the bug 
where we want to deal with event channels and we don't want them to
usurp the irq_desc that are above NR_IRQs and where we get a PCI device for
which its IRQ falls within what info_for_irq(irq) would return: IRQT_VIRQ or
 IRQT_IPI or IRQT_EVTCHN.

In other words, avoid colliding with event channels b/c those are allocated
earlier than the PCI devices.

FYI, the reason this is not triggered under HVM is that it has an IOAPIC.
But under PV no such beast. Here is an output from /proc/interrupts:

A) HVM guest (2.6.36-rc6 w/ PCI passthrough):
            CPU0       CPU1       
   0:        191          0   IO-APIC-edge      timer
   1:          4          3   IO-APIC-edge      i8042
   4:         46         25   IO-APIC-edge      serial
   8:          0          1   IO-APIC-edge      rtc0
   9:          0          0   IO-APIC-fasteoi   acpi
  12:         54         45   IO-APIC-edge      i8042
  14:          0          0   IO-APIC-edge      ata_piix
  15:         20         17   IO-APIC-edge      ata_piix
  16:      10670          0  xen-percpu-virq      timer0
  17:          0       9252  xen-percpu-virq      timer1
  18:        138          0   xen-dyn-event     xenbus
  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
  21:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
  40:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
  45:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
  64:         30         31   PCI-MSI-edge      eth1
..snip..

B) PV guest (2.6.36-rc6 w/ PCI passthrough)
           CPU0       CPU1       CPU2       CPU3       
  0:       1760          0          0          0  xen-percpu-virq      timer0
  1:          2          0          0          0  xen-percpu-ipi       spinlock0
  2:       2481          0          0          0  xen-percpu-ipi       resched0
  3:         23          0          0          0  xen-percpu-ipi       callfunc0
  4:          0          0          0          0  xen-percpu-virq      debug0
  5:         94          0          0          0  xen-percpu-ipi       callfuncsingle0
  6:          0       3474          0          0  xen-percpu-virq      timer1
..snip..

C) PV guest (2.6.36-rc6 devel/xen-pcifront-0.8 with PCI devices.):

 18:          0          0          0          0  xen-pirq-pcifront  uhci_hcd:usb4
 19:          0          0          0          0  xen-pirq-pcifront  uhci_hcd:usb3
 23:          0          0          0          0  xen-pirq-pcifront  ehci_hcd:usb1, uhci_hcd:usb2
103:         38          0          0          0  xen-pirq-pcifront-msi  eth1
276:         24          0          0          0   xen-dyn-event     eth0
277:        188          0          0          0   xen-dyn-event     hvc_console
278:         69          0          0          0   xen-dyn-event     pcifront
279:        259          0          0          0   xen-dyn-event     xenbus
280:          0          0          0        101  xen-percpu-ipi       callfuncsingle3
... snip..

D) HVM 2.6.36-rc6 (devel/xen-pcifront-0.8)
   0:        223          0   IO-APIC-edge      timer
   1:          3          4   IO-APIC-edge      i8042
   4:         44         53   IO-APIC-edge      serial
   8:          0          1   IO-APIC-edge      rtc0
   9:          0          0   IO-APIC-fasteoi   acpi
  12:         47         50   IO-APIC-edge      i8042
  14:          0          0   IO-APIC-edge      ata_piix
  15:         17         20   IO-APIC-edge      ata_piix
  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
  21:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
  40:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
  45:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
  64:         30         30   PCI-MSI-edge      eth1
1149:        137          0   xen-dyn-event     xenbus
1150:          0       8920  xen-percpu-virq      timer1
1151:      11156          0  xen-percpu-virq      timer0

 ..snip..

As you can see from B), the IRQs would be allocated from the start and inhibit
PCI devices from using them.

A) and D) show just the different off what this patch does.
> 
> Feel free to pick up any of the patches I sent as part of the "PV on
> HVM: receive interrupts as xen events" series.
> 
> 
> References:
> [1] http://lkml.org/lkml/2010/8/30/177
> [2] http://lkml.org/lkml/2010/8/30/171
> [3] http://lkml.org/lkml/2010/8/30/172
