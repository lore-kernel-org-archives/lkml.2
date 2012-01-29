Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2A2AkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 19:40:05 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40488 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab2A2AkD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 19:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120129003550.GA21385@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-23-git-send-email-grant.likely@secretlab.ca>
 <20120128164405.GA20763@linutronix.de> <20120129003550.GA21385@ponder.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 28 Jan 2012 17:39:43 -0700
X-Google-Sender-Auth: SdGm26ZbWt5vygW76swVvcgkbvc
Message-ID: <CACxGe6veC5RLETn3n866a07TGKLj5MKd=hLHN=HkWcH8Ah7rnw@mail.gmail.com>
Subject: Re: [PATCH v3 22/25] irq_domain/x86: Convert x86 (embedded) to use
 common irq_domain
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 5:35 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sat, Jan 28, 2012 at 05:44:05PM +0100, Sebastian Andrzej Siewior wrote:
>> * Grant Likely | 2012-01-27 14:36:16 [-0700]:
>>
>> >This patch removes the x86-specific definition of irq_domain and replaces
>> >it with the common implementation.
>>
>> I pulled your devicetree/next tree. After this patch I get:
>>
>> |Hierarchical RCU implementation.
>> |NR_IRQS:2304 nr_irqs:256 16
>> |------------[ cut here ]------------
>> |WARNING: at /home/bigeasy/work/shiva/git/linux-2.6-tip/kernel/irq/irqdomain.c:114 irq_domain_add_legacy+0x75/0x150()
>> |Modules linked in:
>> |Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc1+ #65
>> |Call Trace:
>> | [<c15044e0>] ? printk+0x18/0x1a
>> | [<c102cdbd>] warn_slowpath_common+0x6d/0xa0
>> | [<c1095575>] ? irq_domain_add_legacy+0x75/0x150
>> | [<c1095575>] ? irq_domain_add_legacy+0x75/0x150
>> | [<c102ce0d>] warn_slowpath_null+0x1d/0x20
>> | [<c1095575>] irq_domain_add_legacy+0x75/0x150
>> | [<c1714824>] x86_add_irq_domains+0x96/0xd6
>> | [<c1708df2>] init_IRQ+0x8/0x33
>> | [<c170557f>] start_kernel+0x191/0x2e1
>> | [<c170517f>] ? loglevel+0x2b/0x2b
>> | [<c1705081>] i386_start_kernel+0x81/0x86
>> |---[ end trace 4eaa2a86a8e2da22 ]---
>> |------------[ cut here ]------------
>> |kernel BUG at /home/bigeasy/work/shiva/git/linux-2.6-tip/arch/x86/kernel/devicetree.c:367!
>>
>> The warning is comming from this piece in irq_domain_add_legacy()
>> |for (i = 0; i < size; i++) {
>> |                 int irq = first_irq + i;
>> |                 struct irq_data *irq_data = irq_get_irq_data(irq);
>> |
>> |                 if (WARN_ON(!irq_data || irq_data->domain)) {
>>
>> irq_data is NULL here.
>>
>> |                         mutex_unlock(&irq_domain_mutex);
>> |                         of_node_put(domain->of_node);
>> |                         kfree(domain);
>> |                         return NULL;
>> |                 }
>> |         }
>> |
>>
>> This is not always the case. arch_early_irq_init() in [0] sets up the
>> first 16 entries. The reminaing few (there is a toal of 24 irqs for
>> first ioapic and a second ioapic) are not initialized. This happens
>> later via ->xlate, ioapic_xlate() => io_apic_setup_irq_pin() =>
>> alloc_irq_and_cfg_at() calls irq_set_chip_data() on demand.
>>
>> [0] arch/x86/kernel/apic/io_apic.c
>
> That's not going to work then.  The irqs must not be set up in ->xlate.
> They need to be set up either before creating the irq_domain, or in the
> .map hook.  Inside the map hook is preferred, but having some
> configured and some not at initialization time does make it difficult

Actually, that's still not right.  irq_set_chip_data() (sets
desc->irq_data.chip_data) has nothing to do with irq_get_irq_data()
(which returns desc->irq_data).  It's the   allocation of the irq_desc
that is at issue here.  Where does the allocation occur?  (I haven't
dug in to find it yet)

g.
