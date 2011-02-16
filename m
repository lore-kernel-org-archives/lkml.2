Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1BPPAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:00:05 -0500
Received: from smtp.citrix.com ([66.165.176.89]:56717 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab1BPPAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:00:03 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291611600"; 
   d="scan'208";a="12585695"
Subject: Xen and incorporating event channels in to nr_irqs
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 16 Feb 2011 14:59:59 +0000
Message-ID: <1297868399.16356.180.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I wonder if you have any advice on the following.

Under Xen we have 1024 event channels per-VM which can be injected into
any VCPU. We map these into IRQs and inject them into the system through
the generic IRQ mechanisms.

Event channels are independent from the normal x86 concept of a vector,
although these can also exist e.g. in an HVM guest with PV extensions
you get both 256 vectors per CPU and 1024 event channels.

In some cases there is some rough equivalence between event channels and
x86 vectors. Specifically in domain 0 or HVM guests with the right PV
extensions host GSIs or emulated GSIs respectively can be bound to an
event channel as a "pirq". In this case we allocate IRQs such that
GSI==IRQ for consistency with the same kernel running natively.

For all other event channels we allocate the IRQs dynamically. Since
both event channels and x86 vectors can exist simultaneously we always
allocate an IRQ for dynamic event channels from above nr_irqs_gsi
(somewhat similar to MSIs on native I guess). Since nr_irqs_gsi under
Xen is always an overestimate compared with the actual number of host
GSIs (or accurate in the HVM with PV extensions case) there is no
problem with clashes between the 1-1 GSI==IRQ range and the dynamic
range.

However because nr_irqs on x86, including when running under Xen, is
derived from NR_VECTORS * nr_cpu_ids it is often the case that we can
run out of available IRQ numbers above the nr_irqs_gsi limit, in fact it
is sometimes the case that nr_irqs_gsi >= nr_irqs in which case no
dynamic event channels can be allocated at all!

To work around this Xen currently tries to allocate an IRQ from
nr_irqs_gsi..nr_irqs but if that doesn't work it will fall back to to
using the IRQ space below nr_irqs_gsi. This risks clashing with
allocation in the 1-1 GSI<->IRQ region.

I'd very much like to remove this workaround (better described as a hack
I think) but in order to do so I need to make sure there are plenty of
IRQs between nr_irqs_gsi and nr_irqs. Effectively what we would like to
do is:
	nr_irqs += NR_EVENT_CHANNELS;
somewhere, except obviously we don't want to just drop that into generic
code!

Do you have any hints as to an appropriate existing interface which
could Xen use here?

If not any suggestions for what sort of interface might be acceptable to
add?

For example I was wondering about adding x86_info.irqs.probe_nr_irqs,
which returns a platform specific additional number of IRQs, and having
arch_probe_nr_irqs += that value into its calculations.

Ian.


