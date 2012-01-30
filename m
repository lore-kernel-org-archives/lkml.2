Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2A3V2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:28:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59653 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2A3V2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:28:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.236.117.231 as permitted sender) smtp.mail=glikely@secretlab.ca
Date: Mon, 30 Jan 2012 12:58:42 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 22/25] irq_domain/x86: Convert x86 (embedded) to use
 common irq_domain
Message-ID: <20120130195842.GT28397@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-23-git-send-email-grant.likely@secretlab.ca>
 <20120128164405.GA20763@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120128164405.GA20763@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 05:44:05PM +0100, Sebastian Andrzej Siewior wrote:
> * Grant Likely | 2012-01-27 14:36:16 [-0700]:
> 
> >This patch removes the x86-specific definition of irq_domain and replaces
> >it with the common implementation.
> 
> I pulled your devicetree/next tree. After this patch I get:
> 
> |Hierarchical RCU implementation.
> |NR_IRQS:2304 nr_irqs:256 16
> |------------[ cut here ]------------
> |WARNING: at /home/bigeasy/work/shiva/git/linux-2.6-tip/kernel/irq/irqdomain.c:114 irq_domain_add_legacy+0x75/0x150()
> |Modules linked in:
> |Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc1+ #65
> |Call Trace:
> | [<c15044e0>] ? printk+0x18/0x1a
> | [<c102cdbd>] warn_slowpath_common+0x6d/0xa0
> | [<c1095575>] ? irq_domain_add_legacy+0x75/0x150
> | [<c1095575>] ? irq_domain_add_legacy+0x75/0x150
> | [<c102ce0d>] warn_slowpath_null+0x1d/0x20
> | [<c1095575>] irq_domain_add_legacy+0x75/0x150
> | [<c1714824>] x86_add_irq_domains+0x96/0xd6
> | [<c1708df2>] init_IRQ+0x8/0x33
> | [<c170557f>] start_kernel+0x191/0x2e1
> | [<c170517f>] ? loglevel+0x2b/0x2b
> | [<c1705081>] i386_start_kernel+0x81/0x86
> |---[ end trace 4eaa2a86a8e2da22 ]---
> |------------[ cut here ]------------
> |kernel BUG at /home/bigeasy/work/shiva/git/linux-2.6-tip/arch/x86/kernel/devicetree.c:367!
> 
> The warning is comming from this piece in irq_domain_add_legacy()
> |for (i = 0; i < size; i++) {
> |                 int irq = first_irq + i;
> |                 struct irq_data *irq_data = irq_get_irq_data(irq);
> | 
> |                 if (WARN_ON(!irq_data || irq_data->domain)) {
> 
> irq_data is NULL here.
> 
> |                         mutex_unlock(&irq_domain_mutex);
> |                         of_node_put(domain->of_node);
> |                         kfree(domain);
> |                         return NULL;
> |                 }
> |         }
> | 
> 
> This is not always the case. arch_early_irq_init() in [0] sets up the
> first 16 entries. The reminaing few (there is a toal of 24 irqs for
> first ioapic and a second ioapic) are not initialized. This happens
> later via ->xlate, ioapic_xlate() => io_apic_setup_irq_pin() =>
> alloc_irq_and_cfg_at() calls irq_set_chip_data() on demand.
> 
> [0] arch/x86/kernel/apic/io_apic.c

Ugh.  This isn't easy.  The legacy mapping really needs all the
irq_desc structures to be allocated.  You could call irq_alloc_descs()
before calling irq_domain_add_legacy(), but that causes all the
irq_descs to be allocated (regardless of whether they are used), and
it will break io_apic_setup_irq_pin() which also wants to call
irq_alloc_desc().

Ideally irq_domain support would be rolled directly into ioapic.
That's more work though, and a greater change of breaking x86 on
non-embedded.  Looking at the ioapic code, it seems to me that it
could be simplified quite a bit by switching to irq_domain instead of
using the custom irq_cfg linked list.  Faster too since it could use
the irq_data->hwirq to go from linux irq to the hw irq number.  It
doesn't look like it would be even that hard, but of course the devil
is in the details and I don't have sufficient time right now to dig
into the guts of the ioapic.  Maybe after connect, but it would help
if you can find time to look at it.

If integrated into the ioapic code, then the irq_domain linear map is
probably the type of irq_domain to use.

g.

