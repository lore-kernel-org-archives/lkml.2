Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1ALRHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:07:25 -0500
Received: from www.tglx.de ([62.245.132.106]:55864 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab1ALRHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:07:22 -0500
Date: Wed, 12 Jan 2011 18:07:07 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 10/15] x86/ioapic: Add OF bindings for IO-APIC
Message-ID: <20110112170707.GA6907@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-11-git-send-email-bigeasy@linutronix.de> <20110111235353.GG2131@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110111235353.GG2131@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-01-11 16:53:53 [-0700]:

>> +void __init ioapic_add_ofnode(struct device_node *np)
>> +{
>> +	int i;
>> +	int ret;
>> +	struct resource r;
>> +
>> +	ret = of_address_to_resource(np, 0, &r);
>> +	if (ret) {
>> +		printk(KERN_ERR "Failed to obtain address for %s\n",
>> +				np->full_name);
>> +		return;
>> +	}
>> +
>> +	for (i = 0; i < nr_ioapics; i++) {
>> +		if (r.start == mp_ioapics[i].apicaddr) {
>> +			struct irq_domain *id;
>> +
>> +			mp_of_ioapic[i].node = np;
>> +			id = kzalloc(sizeof(*id), GFP_KERNEL);
>> +			BUG_ON(!id);
>> +			id->controller = np;
>> +			id->xlate = ioapic_xlate;
>> +			id->priv = (void *)i;
>> +			add_interrupt_host(id);
>> +			return;
>> +		}
>
>I'm confused here.  Are there multiple ioapic's described by a single
>device tree node?

Yes, the CE4100 has two IO-APICs. It looks like the first one is
responsible for the "legacy devices" (like RTC) and the second one is
used for the "extra devices" like SPI controller, USB, ... The UART
however is not on the first IO-APIC but on the second.

Those two IO-APICs are not cascaded. The device tree contains the line
number of device to the io apic. The kernel computes then interrupt
number based on gsi_base + line_number where gsi_base is incremented by
the number of entries[0]. This interrupt number (gsi_base + line) is then
sent via apic bus to lapic which reports it as the active interrupt
source.

Sebastian
