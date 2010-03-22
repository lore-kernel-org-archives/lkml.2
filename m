Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0CVTrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:47:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:38973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab0CVTrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:47:32 -0400
Message-ID: <4BA7C8C3.2040609@kernel.org>
Date: Mon, 22 Mar 2010 12:45:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com
Subject: Re: [PATCH 02/10] x86: fix out of order of gsi - full
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org> <1269221770-9667-3-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1003221131470.3147@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003221131470.3147@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 04:14 AM, Thomas Gleixner wrote:
> On Sun, 21 Mar 2010, Yinghai Lu wrote:
>> +extern int gsi_delta;
> 
>   Is this really necessary ? See below.
> 
>> +int gsi_to_irq(unsigned int gsi);
> 
>   unsigned int please
> 
>> +unsigned int irq_to_gsi(int irq);
> 
>   Ditto

ok

> 
>> @@ -446,11 +448,11 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
>>  
>>  int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
>>  {
>> -	*irq = gsi;
>> +	*irq = gsi_to_irq(gsi);
>>  
>>  #ifdef CONFIG_X86_IO_APIC
>>  	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
>> -		setup_IO_APIC_irq_extra(gsi);
>> +		setup_IO_APIC_irq_extra(gsi, irq);
> 
>   Please do not propagate that pointer.
> 
>     	 *irq = setup_IO_APIC_irq_extra(gsi);
> 
>   Also these changes have a total lack of comments. Why do we modify
>   *irq here depending on the setup_IO_APIC_irq_extra() results ?
> 
looks *irq = gsi_to_irq(gsi) should already do the work for us.
>>  #endif
>>  
>>  	return 0;
>> @@ -914,6 +916,40 @@ static void save_mp_irq(struct mpc_intsrc *m)
>>  		panic("Max # of irq sources exceeded!!\n");
>>  }
>>  
>> +/* By default isa irqs are identity mapped to gsis */
>> +static unsigned int isa_irq_to_gsi[NR_IRQS_LEGACY] = {
>> +	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
>> +};
>> +
>> +int gsi_delta;
> 
>   Please make this static and provide a function to modify it from
>   probe_ioapic_i8259().
> 
>   Also the variable name is horrible. What's the delta here ? It's an
>   offset, right ?

yes. offset for non legacy irq.

> 
>> +int gsi_to_irq(unsigned int gsi)
> 
> unsigned int
> 
>> +{
>> +	unsigned int irq = gsi;
>> +	unsigned int i;
>> +
>> +	irq += gsi_delta;
> 
>   Please make that:
> 
>   	 unsigned int i, irq = gsi + gsi_delta;

ok

> 
>> +	for (i = 0; i < NR_IRQS_LEGACY; i++) {
>> +		if (isa_irq_to_gsi[i] == gsi) {
>> +			irq = i;
>> +			break;
>> +		}
>> +	}
>> +
>> +	return irq;
>> +}
>> +
>> +unsigned int irq_to_gsi(int irq)
> 
>   unsigned int please

ok

> 
>> +{
>> +	unsigned int gsi;
>> +
>> +	if (irq < NR_IRQS_LEGACY)
>> +		gsi = isa_irq_to_gsi[irq];
>> +	else
>> +		gsi = irq - gsi_delta;
>> +
>> +	return gsi;
>> +}
>> +
>>  void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
>>  {
>>  	int ioapic;
>> @@ -945,6 +981,8 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
>>  	mp_irq.dstirq = pin;	/* INTIN# */
>>  
>>  	save_mp_irq(&mp_irq);
>> +
>> +	isa_irq_to_gsi[bus_irq] = gsi;
> 
>>  }
>>  
>>  void __init mp_config_acpi_legacy_irqs(void)
>> @@ -974,7 +1012,7 @@ void __init mp_config_acpi_legacy_irqs(void)
>>  	/*
>>  	 * Locate the IOAPIC that manages the ISA IRQs (0-15).
>>  	 */
>> -	ioapic = mp_find_ioapic(0);
>> +	ioapic = mp_find_ioapic(irq_to_gsi(0));
>>  	if (ioapic < 0)
>>  		return;
>>  	dstapic = mp_ioapics[ioapic].apicid;
>> @@ -1057,6 +1095,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
> 
>   Why is mp_register_gsi global ? It's only used in
>   arch/x86/kernel/acpi/boot.c

yes.

should adjust that function position.

arch/x86/kernel/acpi/boot.c:            plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
arch/x86/kernel/acpi/boot.c:int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)


> 
>>  {
>>  	int ioapic;
>>  	int ioapic_pin;
>> +	int irq;
> 
>   irq is unsigned int.
> 
>>  	struct io_apic_irq_attr irq_attr;
>>  
>>  	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
>> @@ -1079,11 +1118,12 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
>>  		gsi = ioapic_renumber_irq(ioapic, gsi);
>>  #endif
>>  
>> +	irq = gsi_to_irq(gsi);
>>  	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
>>  		printk(KERN_ERR "Invalid reference to IOAPIC pin "
>>  		       "%d-%d\n", mp_ioapics[ioapic].apicid,
>>  		       ioapic_pin);
>> -		return gsi;
>> +		return irq;
>>  	}
>>  
>>  	if (enable_update_mptable)
>> @@ -1092,9 +1132,9 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
>>  	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
>>  			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
>>  			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
>> -	io_apic_set_pci_routing(dev, gsi, &irq_attr);
>> +	io_apic_set_pci_routing(dev, irq, &irq_attr);
>>  
>> -	return gsi;
>> +	return irq;
>>  }
>>  
>>  /*
>> @@ -1151,8 +1191,10 @@ static int __init acpi_parse_madt_ioapic_entries(void)
>>  	 * If BIOS did not supply an INT_SRC_OVR for the SCI
>>  	 * pretend we got one so we can set the SCI flags.
>>  	 */
>> -	if (!acpi_sci_override_gsi)
>> -		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);
>> +	if (!acpi_sci_override_gsi) {
>> +		int irq = gsi_to_irq(acpi_gbl_FADT.sci_interrupt);
> 
>   unsigned int. New line between variable declaration and code.
> 
>> +		acpi_sci_ioapic_setup(irq, acpi_gbl_FADT.sci_interrupt, 0, 0);
>> +	}
>>  
>>  	/* Fill in identity legacy mappings where no override */
>>  	mp_config_acpi_legacy_irqs();
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index a917fdf..61b59ef 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -97,6 +97,8 @@ int mp_irq_entries;
>>  /* GSI interrupts */
>>  static int nr_irqs_gsi = NR_IRQS_LEGACY;
>>  
>> +static int boot_ioapic_idx;
>> +
>>  #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
>>  int mp_bus_id_to_type[MAX_MP_BUSSES];
>>  #endif
>> @@ -1032,7 +1034,7 @@ static inline int irq_trigger(int idx)
>>  int (*ioapic_renumber_irq)(int ioapic, int irq);
>>  static int pin_2_irq(int idx, int apic, int pin)
>>  {
>> -	int irq, i;
>> +	int irq;
> 
>   Can we please do a cleanup of irq variables to use unsigned
>   int. That should be done as a separate patch.

ok

> 
>>  	int bus = mp_irqs[idx].srcbus;
>>  
>>  	/*
>> @@ -1044,18 +1046,28 @@ static int pin_2_irq(int idx, int apic, int pin)
>>  	if (test_bit(bus, mp_bus_not_pci)) {
>>  		irq = mp_irqs[idx].srcbusirq;
> 
>   Can we simply return mp_irqs[idx].srcbusirq here and get rid of the
>   else path ident level ?
> 
>>  	} else {
>> -		/*
>> -		 * PCI IRQs are mapped in order
>> -		 */
>> -		i = irq = 0;
>> -		while (i < apic)
>> -			irq += nr_ioapic_registers[i++];
>> -		irq += pin;
>> +		unsigned int gsi;
> 
>   New line please
> 
>> +		if (!acpi_ioapic) {
>> +			int i;
> 
>   
> 
>> +			/*
>> +			 * PCI IRQs are mapped in order
>> +			 */
>> +			i = gsi = 0;
>> +			while (i < apic)
>> +				gsi += nr_ioapic_registers[i++];
>> +			gsi += pin;
>> +		} else
>> +			gsi = pin + mp_gsi_routing[apic].gsi_base;
>> +
>> +#ifdef CONFIG_X86_32
>>  		/*
>>                   * For MPS mode, so far only needed by ES7000 platform
>>                   */
>>  		if (ioapic_renumber_irq)
>> -			irq = ioapic_renumber_irq(apic, irq);
>> +			gsi = ioapic_renumber_irq(apic, gsi);
>> +#endif
>> +
>> +		irq = gsi_to_irq(gsi);
>>  	}
>>  
>>  #ifdef CONFIG_X86_32
>> @@ -1505,9 +1517,10 @@ static void __init setup_IO_APIC_irqs(void)
>>  	struct irq_cfg *cfg;
>>  	int node = cpu_to_node(boot_cpu_id);
>>  
>> +	apic_id = boot_ioapic_idx;
>> +
>>  	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
>>  
>> -	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
>>  	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
>>  		idx = find_irq_entry(apic_id, pin, mp_INT);
>>  		if (idx == -1) {
>> @@ -1529,9 +1542,6 @@ static void __init setup_IO_APIC_irqs(void)
>>  
>>  		irq = pin_2_irq(idx, apic_id, pin);
>>  
>> -		if ((apic_id > 0) && (irq > 16))
>> -			continue;
>> -
>>  		/*
>>  		 * Skip the timer IRQ if there's a quirk handler
>>  		 * installed and if it returns 1:
>> @@ -1565,7 +1575,7 @@ static void __init setup_IO_APIC_irqs(void)
>>   * but could not use acpi_register_gsi()
>>   * like some special sci in IBM x3330
>>   */
>> -void setup_IO_APIC_irq_extra(u32 gsi)
>> +void setup_IO_APIC_irq_extra(u32 gsi, unsigned int *pirq)
>>  {
>>  	int apic_id = 0, pin, idx, irq;
>>  	int node = cpu_to_node(boot_cpu_id);
>> @@ -1585,6 +1595,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
>>  		return;
>>  
>>  	irq = pin_2_irq(idx, apic_id, pin);
>> +	*pirq = irq;
>>  #ifdef CONFIG_SPARSE_IRQ
>>  	desc = irq_to_desc(irq);
>>  	if (desc)
>> @@ -2028,6 +2039,30 @@ void __init enable_IO_APIC(void)
>>  	clear_IO_APIC();
>>  }
>>  
>> +static void __init probe_ioapic_i8259(void)
>> +{
>> +	/* probe boot ioapic idx */
>> +	boot_ioapic_idx = ioapic_i8259.apic;
> 
>   boot_ioapic_idx is an apic id. Why is the variable name suggesting
>   it's an index ?

it is an index.

> 
>> +	if (boot_ioapic_idx < 0)
>> +		boot_ioapic_idx = find_isa_irq_apic(0, mp_INT);
>> +#ifdef CONFIG_ACPI
>> +	if (!acpi_disabled && acpi_ioapic && boot_ioapic_idx < 0)
>> +		boot_ioapic_idx = mp_find_ioapic(irq_to_gsi(0));
>> +#endif
>> +	if (boot_ioapic_idx < 0)
>> +		boot_ioapic_idx = 0;
>> +
>> +#ifdef CONFIG_ACPI
>> +	if (mp_gsi_routing[boot_ioapic_idx].gsi_base) {
>> +		gsi_delta = NR_IRQS_LEGACY;
>> +		nr_irqs_gsi += NR_IRQS_LEGACY;
>> +		printk(KERN_DEBUG "new nr_irqs_gsi: %d\n", nr_irqs_gsi);
>> +	}
>> +#endif
>> +
>> +	printk(KERN_INFO "boot_ioapic_idx: %d\n", boot_ioapic_idx);
>> +}
>> +
>>  /*
>>   * Not an __init, needed by the reboot code
>>   */
>> @@ -3045,7 +3080,7 @@ static inline void __init check_timer(void)
>>  				legacy_pic->chip->unmask(0);
>>  			}
>>  			if (disable_timer_pin_1 > 0)
>> -				clear_IO_APIC_pin(0, pin1);
>> +				clear_IO_APIC_pin(apic1, pin1);
> 
>   How is this change related to this patch ? It looks more like an
>   independent fix.

ok another patch.

YH
