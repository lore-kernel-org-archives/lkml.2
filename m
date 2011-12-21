Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1LUBtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:49:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37612 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1LUBtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:49:20 -0500
MIME-Version: 1.0
In-Reply-To: <1324363882.2286.23.camel@sbsiddha-mobl2>
References: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
	<1324363882.2286.23.camel@sbsiddha-mobl2>
Date: Tue, 20 Dec 2011 17:49:20 -0800
X-Google-Sender-Auth: GiVxitsD2817vn6Y4WYHqek822U
Message-ID: <CAE9FiQU__U0CCiyzF9kDC1Z=PUEoTe1Jm-M97EbCO440Vm9P_A@mail.gmail.com>
Subject: Re: [PATCH -v8] x86: Disable x2apic if nox2apic is specified or
 intr-remap can not be enabled
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 10:51 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> Yinghai, Here is the detailed review of your patch:
>
> On Fri, 2011-12-16 at 16:59 -0800, Yinghai Lu wrote:
>> Index: linux-2.6/arch/x86/include/asm/apic.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/apic.h
>> +++ linux-2.6/arch/x86/include/asm/apic.h
>> @@ -176,6 +176,8 @@ static inline u64 native_x2apic_icr_read
>>  }
>>
>>  extern int x2apic_phys;
>> +extern int x2apic_preenabled;
>> +extern int x2apic_disabled;
>>  extern void check_x2apic(void);
>>  extern void enable_x2apic(void);
>>  extern void x2apic_icr_write(u32 low, u32 id);
>> @@ -183,7 +185,7 @@ static inline int x2apic_enabled(void)
>>  {
>>       u64 msr;
>>
>> -     if (!cpu_has_x2apic)
>> +     if (!cpu_has_x2apic || x2apic_disabled)
>>               return 0;
>>
>>       rdmsrl(MSR_IA32_APICBASE, msr);
>
> Not sure why we need x2apic_disabled check here.

skip the extra msr reading, because cpu x2apic feature is kept.

>
>> @@ -192,12 +194,15 @@ static inline int x2apic_enabled(void)
>>       return 0;
>>  }
>>
>> -#define x2apic_supported()   (cpu_has_x2apic)
>> +#define x2apic_supported()   (cpu_has_x2apic && !x2apic_disabled)
>
> Here also not sure why we need this. Right thing is to clear the x2apic
> capability from the cpuid features when the user selects nox2apic.

just want to leave that feature alone.

>
>> @@ -235,8 +239,10 @@ acpi_parse_x2apic(struct acpi_subtable_h
>>        * to not preallocating memory for all NR_CPUS
>>        * when we use CPU hotplug.
>>        */
>> -     acpi_register_lapic(processor->local_apic_id,   /* APIC ID */
>> -                         processor->lapic_flags & ACPI_MADT_ENABLED);
>> +     if (x2apic_disabled && (apic_id >= 0xff) && enabled)
>> +             printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
>
> x2apic MADT entries are specifically for apic-id's >= 255. So no need to
> check for the value again. We can ignore all the x2apic entries. Also
> print once indicating why all x2apic entries are being ignored should be
> enough.

no, some vendor still keep x2apic entries even apic id < 255.
they have different understanding of x2apic entries.

>
> Also when we disable x2apic in the case not initiated by the user (like
> no dmar tables etc), we would have already parsed the MADT entries but
> we need to skip those entries with id >= 255 duing smp boot. I don't
> think I see that code in this patch.

it will panic.

>
>
>>  static __init int setup_nox2apic(char *str)
>>  {
>> -     if (x2apic_enabled()) {
>> -             pr_warning("Bios already enabled x2apic, "
>> -                        "can't enforce nox2apic");
>> -             return 0;
>> -     }
>> +     if (x2apic_enabled())
>> +             pr_warning("Bios already enabled x2apic, will disable it");
>> +
>> +     x2apic_disabled = 1;
>>
>> -     setup_clear_cpu_cap(X86_FEATURE_X2APIC);
>>       return 0;
>>  }
>
> Not sure why you removed this clear_cpu_cap here. Right thing to do here
> is to delay the clearing when x2apic is pre-enabled by the bios and
> clear it here when x2apic is not pre-enabled by the bios.

that param (nox2apic) is analyzed earlier than check_x2apic()

so can not x2apic_preenabled to check clear the x2apic cpuid features.

>
>> +
>> +static void disable_x2apic(void)
>> +{
>> +     int msr, msr2;
>> +
>> +     if (!cpu_has_x2apic)
>> +             return;
>> +
>> +     rdmsr(MSR_IA32_APICBASE, msr, msr2);
>> +     if (msr & X2APIC_ENABLE) {
>> +             u32 x2apic_id = x2apic_cpuid_initial_apicid();
>
> I think we should be able to do read_apic_id() here and thus avoid the
> need for getting apicid from cpuid.

during BP enable_IR_x2apic and later apic ops could be change back to xapic...

that may not read out whole x2apic id.

>
>> +
>> +             if (x2apic_id > 255)
>> +                     panic("Can not disable x2apic, id: %08x\n", x2apic_id);
>> +
>> +             pr_info("Disabling x2apic\n");
>> +             /*
>> +              * Need to disable xapic and x2apic at the same time at first
>> +              *  then enable xapic
>> +              */
>> +             wrmsr(MSR_IA32_APICBASE, msr & ~(X2APIC_ENABLE | XAPIC_ENABLE),
>> +                      0);
>> +             wrmsr(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE, 0);
>> +
>> +             x2apic_disabled = 1;
>> +     }
>> +}
>>  void check_x2apic(void)
>>  {
>> +     if (x2apic_disabled) {
>> +             disable_x2apic();
>> +             return;
>> +     }
>
> We shouldn't call disable_x2apic() from here. We should be following the
> same sequence, like masking interrupts at the cpu, pic, io-apic level
> before we disable x2apic and re-enable xapic. So the right place to do
> this disable is at enable_IR_x2apic().

Disabling early as possible looks like more cleanly.

>
>> @@ -1449,6 +1480,11 @@ void enable_x2apic(void)
>>  {
>>       int msr, msr2;
>>
>> +     if (x2apic_disabled) {
>> +             disable_x2apic();
>
> enable_x2apic() gets called from both BP and AP. AP's need not do the
> apic-id being >= 255 checks etc. As that is done during smp bringup
> (which is missing currently from the current patch) or during MADT
> parsing. So all we need to do is a simple x2apic->xapic conversion.

yes, that is intended for APs too, so it will panic the system. go
back to clean up process_info could be extra work.

>
>>
>>  #ifdef CONFIG_X86_64
>> Index: linux-2.6/arch/x86/mm/srat.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/srat.c
>> +++ linux-2.6/arch/x86/mm/srat.c
>> @@ -69,6 +69,12 @@ acpi_numa_x2apic_affinity_init(struct ac
>>       if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
>>               return;
>>       pxm = pa->proximity_domain;
>> +     apic_id = pa->apic_id;
>> +     if (x2apic_disabled && (apic_id >= 0xff)) {
>
> Same comments like in the above MADT parsing.
>
>>
>> Index: linux-2.6/arch/x86/kernel/cpu/topology.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/cpu/topology.c
>> +++ linux-2.6/arch/x86/kernel/cpu/topology.c
>> @@ -21,6 +21,27 @@
>>  #define BITS_SHIFT_NEXT_LEVEL(eax)   ((eax) & 0x1f)
>>  #define LEVEL_MAX_SIBLINGS(ebx)              ((ebx) & 0xffff)
>>
>> +u32 x2apic_cpuid_initial_apicid(void)
>> +{
>
> I think we can do with out this function.
>
> While reviewing the code, I ended up doing some of this cleanup of your
> patch. I have appended the modified version. Can you please incorporate
> the smpboot checks before the AP bringup (apic-id should be less than
> 255 in !x2apic_mode etc) and split the patch into couple of patches
> (apic_probe etc) along with other needed cleanups.

We could handle AP's apic id > 255 panic problem later if needed in
another patch.

Actually on system with apic id > 255, intr-remapping aka DMAR must be
working, otherwise those big box can not be sold.

And in this case, nox2apic must be passed to disable x2apic, because
dmar is correct in both case kexec or first boot.

when nox2apic is passed,  those entries will be skipped early. and BSP
x2apic get disabled early.
and code path is more like bios enable xapic only.

Can we let this patch get into tip and have test cycle at first?
at least we should not let it break any working set up.

Thanks

Yinghai Lu
