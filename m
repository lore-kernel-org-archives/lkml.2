Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0JEQqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:46:09 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:50706 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0JEQqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:46:08 -0400
X-IronPort-AV: E=Sophos;i="4.57,285,1283731200"; 
   d="scan'208";a="2199858"
Date: Tue, 5 Oct 2010 17:46:13 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 09/22] xen: Find an unbound irq number in reverse order
 (high to low).
In-Reply-To: <1286216015-9710-10-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.00.1010051617160.2440@kaball-desktop>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com> <1286216015-9710-10-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Konrad Rzeszutek Wilk wrote:
> In earlier Xen Linux kernels, the IRQ mapping was a straight 1:1 and the
> find_unbound_irq started looking around 256 for open IRQs and up. IRQs
> from 0 to 255 were reserved for PCI devices.  Previous to this patch,
> the 'find_unbound_irq'  started looking at get_nr_hw_irqs() number.
> For privileged  domain where the ACPI information is available that
> returns the upper-bound of what the GSIs. For non-privileged PV domains,
> where ACPI is no-existent the get_nr_hw_irqs() reports the IRQ_LEGACY (16).
> With PCI passthrough enabled, and with PCI cards that have IRQs pinned
> to a higher number than 16 we collide with previously allocated IRQs.
> Specifically the PCI IRQs collide with the IPI's for Xen functions
> (as they are allocated earlier).
> For example:
> 
> 00:00.11 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
> 	...
> 	Interrupt: pin A routed to IRQ 18
> 
> [root@localhost ~]# cat /proc/interrupts | head
>            CPU0       CPU1       CPU2
>  16:      38186          0          0   xen-dyn-virq      timer0
>  17:        149          0          0   xen-dyn-ipi       spinlock0
>  18:        962          0          0   xen-dyn-ipi       resched0
> 
> and when the USB controller is loaded, the kernel reports:
> IRQ handler type mismatch for IRQ 18
> current handler: resched0
> 
> One way to fix this is to reverse the logic when looking for un-used
> IRQ numbers and start with the highest available number. With that,
> we would get:
> 
>            CPU0       CPU1       CPU2
> ... snip ..
> 292:         35          0          0   xen-dyn-ipi       callfunc0
> 293:       3992          0          0   xen-dyn-ipi       resched0
> 294:        224          0          0   xen-dyn-ipi       spinlock0
> 295:      57183          0          0   xen-dyn-virq      timer0
> NMI:          0          0          0   Non-maskable interrupts
> .. snip ..
> 
> And interrupts for PCI cards are now accessible.
> 

Unfortunately this is the wrong way to fix the issue: Xen has a range of
allowed pirq for each domain and we don't know exactly what is the
maximum pirq (see my patch "xen: get the maximum number of pirqs from
xen" [1]).
Considering that we might use the irq number returned by
find_unbound_irq through xen_allocate_pirq as pirq number in some cases,
starting from the highest value could be unsafe.
In practice it should be impossible to see this issue because it can
only happen if the irq returned by xen_allocate_pirq is higher than the
max pirq in xen. However AFAIK when we call xen_allocate_pirq with the
intention of using the return value as pirq we always fall in the if
(identity_mapped_irq(gsi) || !xen_initial_domain()) that avoid calling
find_unbound_irq.
In any case I still think that it is a good idea to try to avoid the problem.

In order to solve this issue you can:

- add a static offset to get_nr_hw_irqs in case of pv domains;

- use the patch "xen: get the maximum number of pirqs from
xen" [1] to get the highest possible pirq number from xen so that we can be
sure we are using an allowed value;

- if the xen interface allows it, disjoin the concept of pirq from the
concept of linux irq; then you can let xen choose any pirq number it
wants (see my patch "xen: support pirq != irq" [2] and how you can exploit
it in the patch "xen: implement xen_hvm_register_pirq" [3]).
Of course this doesn't help if it must be linux the one that chooses the
pirq number.

Feel free to pick up any of the patches I sent as part of the "PV on
HVM: receive interrupts as xen events" series.


References:
[1] http://lkml.org/lkml/2010/8/30/177
[2] http://lkml.org/lkml/2010/8/30/171
[3] http://lkml.org/lkml/2010/8/30/172

