Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1ARO5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 09:57:05 -0500
Received: from www.tglx.de ([62.245.132.106]:35176 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1ARO5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:57:03 -0500
Message-ID: <4D35AA2F.3000503@linutronix.de>
Date: Tue, 18 Jan 2011 15:56:47 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 05/15] x86/dtb: add early parsing of APIC and IO APIC
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-6-git-send-email-bigeasy@linutronix.de> <20101230085451.GF11721@angua.secretlab.ca> <20110104132302.GB21359@www.tglx.de> <20110111221401.GB2131@angua.secretlab.ca>
In-Reply-To: <20110111221401.GB2131@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> Hi Sebastian,
Hi Grant,

>> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
>> index 9076ae4..3bc8ed5 100644
>> --- a/arch/x86/include/asm/prom.h
>> +++ b/arch/x86/include/asm/prom.h
>> @@ -22,10 +22,17 @@
>>  #include <asm/irq_controller.h>
>>  
>>  #ifdef CONFIG_OF
>> +extern int of_ioapic;
>> +extern u64 initial_dtb;
>>  extern void add_dtb(u64 data);
>> +void x86_dtb_find_config(void);
>> +void x86_dtb_get_config(unsigned int unused);
>>  void add_interrupt_host(struct irq_domain *ih);
>>  #else
>>  static inline void add_dtb(u64 data) { }
>> +#define x86_dtb_find_config x86_init_noop
>> +#define x86_dtb_get_config x86_init_uint_noop
>> +#define of_ioapic 0
> 
> Nit: Personally, I prefer static inlines over preprocessor macros, but
> that isn't anything that will block this patch.

Right. x86 does similar for ioapic function callbacks for CONFIG_IOAPIC
case. So I keep this unless x86 folks want it different.

>> +#ifdef CONFIG_X86_IO_APIC
>> +static void __init dtb_add_ioapic(struct device_node *dn)
>> +{
>> +	unsigned int ioapic_id;
>> +	const __be32 *cell;
>> +	int len;
>> +	struct resource r;
>> +	int ret;
>> +
>> +	cell = of_get_property(dn, "id", &len);
>> +	if (!cell) {
>> +		printk(KERN_ERR "Node %s is missing id property.\n",
>> +				dn->full_name);
>> +		return;
>> +	}
>> +	ioapic_id = of_read_ulong(cell, len / 4);
> 
> This looks like poor usage practise for the device tree.  'id' or any
> kind of enumeration property in a device tree node is strongly
> discouraged.  As much as possible, let Linux dynamically enumerate
> devices rather than trying to explicitly specify the numbering.  Since
> you can explicitly describe the relationship between device nodes in
> the tree, you should find that explicitly specifying numbers is almost
> never required.

Good point. I removed the id property and let linux statically enumerate
it. I don't see any relationship and spec. says only to keep it unique.

Sebastian
