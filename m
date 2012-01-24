Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2AXSPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:15:25 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:34946 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757304Ab2AXSPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:15:24 -0500
Message-ID: <4F1F02E5.3000605@xenotime.net>
Date: Tue, 24 Jan 2012 11:13:41 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFCv2 01/14] irq_domain: add documentation and MAINTAINERS entry.
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca> <1327352870-14687-2-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327352870-14687-2-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 01:07 PM, Grant Likely wrote:
> Documentation for irq_domain library which will be created in subsequent
> patches.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  Documentation/IRQ-domain.txt |  113 ++++++++++++++++++++++++++++++++++++++++++
>  MAINTAINERS                  |    9 +++
>  2 files changed, 122 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/IRQ-domain.txt
> 
> diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
> new file mode 100644
> index 0000000..247f32a
> --- /dev/null
> +++ b/Documentation/IRQ-domain.txt
> @@ -0,0 +1,113 @@
> +irq_domain interrupt number mapping library
> +
> +The current design of the Linux kernel uses a single large number
> +space where each separate IRQ source is assigned a different number.
> +This is simple when there is only one interrupt controller, but in
> +systems with controllers the kernel must ensure that each one does not

           with multiple interrupt controllers,

> +get assigned overlapping allocations of Linux irq numbers.

                                                 IRQ

> +
> +The irq_alloc_desc*() and irq_free_desc*() API provides allocation of

I would say:                                  APIs provide

> +irq numbers, but it doesn't provide any support for reverse mapping of

   IRQ numbers, but they don't provide


> +the controller-local irq (hwirq) number into the Linux irq number

                        IRQ                               IRQ

> +space.
> +
> +The irq_domain library adds mapping between hwirq and irq numbers on

                                                         IRQ

> +top of the irq_alloc_desc*() API.  An irq_domain to manage mapping is
> +preferred over interrupt controller drivers open coding their own
> +reverse mapping scheme.
> +
> +irq_domain also implements translation from Device Tree interrupt
> +specifiers to hwirq numbers, and can be easily extended to support
> +other irq topology data sources.

         IRQ

> +
> +=== irq_domain usage ===
> +An interrupt controller driver creates and registers an irq_domain by
> +calling one of the irq_domain_add_*() functions (each mapping method
> +has a different allocator function, more on that later).  The function
> +will return a pointer to the irq_domain on success.  It must provide

                                                        "It" ?  The caller ?

> +the allocator function with an irq_domain_ops structure with the .map
> +callback populated as a minimum.
> +
> +In most cases, the irq_domain will begin empty without any mappings
> +between hwirq and irq numbers.  Mappings are added to the irq_domain

                     IRQ

> +by calling irq_create_mapping() which accepts the irq_domain and a
> +hwirq number as arguments.  If a mapping for the hwirq doesn't already
> +exist then it will allocate a new linux irq_desc, associate it with

                                     Linux

> +the hwirq, and call the .map() callback so the driver can perform any
> +required hardware setup.
> +
> +When an interrupt is received, irq_find_mapping() function should
> +be used to find the Linux irq number from the hwirq number.

                             IRQ

> +
> +If the driver has the Linux irq number or the irq_data pointer, and

                               IRQ

> +needs to know the associated hwirq number (such as in the irq_chip
> +callbacks) then it can be directly obtained from irq_data->hwirq.
> +
> +=== Types of irq_domain mappings ===
> +There are several mechanisms available for reverse mapping from hwirq
> +to Linux irq, and each mechanism uses a different allocation function

            IRQ,
.
> +Which reverse map type should be used depends on the use case.  Each
> +of the reverse map types are described below:
> +
> +==== Linear ====
> +irq_domain_add_linear()
> +
> +The linear reverse map maintains a fixed size table indexed by the
> +hwirq number.  When a hwirq is mapped, an irq_desc is allocated for
> +the hwirq, and the irq number is stored in the table.

                      IRQ

> +
> +The Linear map is a good choice when the maximum number of hwirqs is
> +fixed and a relatively small number (~ < 256).  The advantages of this
> +map are fixed time lookup for irq numbers, and irq_descs are only

                                 IRQ

> +allocated for in-use irqs.  The disadvantage is that the table must be
> +as large as the largest possible hwirq number.
> +
> +The majority of drivers should use the linear map.
> +
> +==== Tree ====
> +irq_domain_add_tree()
> +
> +The irq_domain maintains a radix tree map from hwirq numbers to linux

                                                                   Linux

> +irqs.  When an hwirq is mapped, and irq_desc is allocated and the

   IRQs.  When a hwirq             an

> +hwirq is used as the lookup key for the radix tree.
> +
> +The tree map is a good choice if the hwirq number can be very large
> +since it doesn't need to allocate a table as large as the largest
> +hwirq number.  The disadvantage is that hwirq to irq number lookup is

                                                    IRQ

> +dependent on how many entries are in the table.
> +
> +Very few drivers should need this mapping.  At the moment, powerpc
> +iseries is the only user.
> +
> +==== No Map ===-
> +irq_domain_add_nomap()
> +
> +The No Map mapping is to be used when the hwirq number is
> +programmable in the hardware.  In this case it is best to program the
> +Linux irq number into the hardware itself so that no mapping is

         IRQ

> +required.  Calling irq_create_direct_mapping() will allocate a linux

                                                                  Linux

> +irq number and call the .map() callback so that driver can program the

   IRQ

> +Linux irq number into the hardware.

         IRQ

> +
> +Most drivers cannot use this mapping.
> +
> +==== Legacy ====
> +irq_domain_add_legacy()
> +irq_domain_add_legacy_isa()
> +
> +The Legacy mapping is a special case for drivers that already have a
> +range of irq_descs allocated for the hwirqs.  It is used when the
> +driver cannot be immediately converted to use the linear mapping, such
> +as when the driver is used in a system with fixed irq number

                                                     IRQ

> +assignments, as is typical in many embedded system board files.
> +
> +The legacy map assumes a contiguous range of irq numbers has already

                                                IRQ

> +been allocated for the controller and that the irq number can be

                                                  IRQ

> +calculated by adding a fixed offset to the hwirq number, and
> +visa-versa.  The disadvantage is that it requires the interrupt
> +controller to manage irq allocations and it requires an irq_desc to be

                        IRQ

> +allocated for every hwirq, even if it is unused.
> +
> +Drivers should only use the legacy map if they have fixed irq mappings

                                                             IRQ

> +(#define IRQ_* in embedded board files).  For example, ISA controllers
> +mapped to Linux irqs 0-15 would use the legacy map.

                   IRQs


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
