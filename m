Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab0I0M4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:56:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44878 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab0I0M4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tAGH6MIHAN2x0+eN5r7vVli6WOs0ZxpdLa/53Lc4RNoRY6E7GfmJ1qLd07HOdLtoWD
         wITEVzDHfntZcH/paiS/MqKTL1/M8Nw4QvVMOcMICnWsU9UuISxDSAAO28GmSZcF0J8O
         4534EgDUMJkd+S3HkBpKn/9fM+WRClFrSDSOU=
MIME-Version: 1.0
In-Reply-To: <20100927104426.GD32222@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	<1285549026-5008-7-git-send-email-ying.huang@intel.com>
	<20100927104426.GD32222@erda.amd.com>
Date: Mon, 27 Sep 2010 20:56:44 +0800
Message-ID: <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
From: huang ying <huang.ying.caritas@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 6:44 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 26.09.10 20:57:06, Huang Ying wrote:
>> do_nmi_callback related logic is removed, because it is useless, just
>> adds code complexity.
>>
>> unknown_nmi_panic sysctl is reserved to keep kernel ABI unchanged.
>
> "unknown_nmi_panic" and "panic_on_unrecovered_nmi" are different. See
> below and also Documentation/sysctl/kernel.txt.
>
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> ---
>>  arch/x86/include/asm/nmi.h    |   10 +++++++++-
>>  arch/x86/kernel/apic/hw_nmi.c |    1 -
>>  arch/x86/kernel/apic/nmi.c    |   29 +----------------------------
>>  arch/x86/kernel/traps.c       |   16 ++++++++++------
>>  4 files changed, 20 insertions(+), 36 deletions(-)
>>
>> --- a/arch/x86/include/asm/nmi.h
>> +++ b/arch/x86/include/asm/nmi.h
>> @@ -30,9 +30,17 @@ extern void setup_apic_nmi_watchdog(void
>>  extern void stop_apic_nmi_watchdog(void *);
>>  extern void disable_timer_nmi_watchdog(void);
>>  extern void enable_timer_nmi_watchdog(void);
>> -extern int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason);
>>  extern void cpu_nmi_set_wd_enabled(void);
>>
>> +#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
>> +extern int nmi_watchdog_tick(struct pt_regs *regs);
>> +#else
>> +static inline int nmi_watchdog_tick(struct pt_regs *regs)
>> +{
>> +     return 0;
>> +}
>> +#endif
>> +
>>  extern atomic_t nmi_active;
>>  extern unsigned int nmi_watchdog;
>>  #define NMI_NONE     0
>> --- a/arch/x86/kernel/apic/hw_nmi.c
>> +++ b/arch/x86/kernel/apic/hw_nmi.c
>> @@ -100,7 +100,6 @@ void acpi_nmi_disable(void) { return; }
>>  #endif
>>  atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
>>  EXPORT_SYMBOL(nmi_active);
>> -int unknown_nmi_panic;
>>  void cpu_nmi_set_wd_enabled(void) { return; }
>>  void stop_apic_nmi_watchdog(void *unused) { return; }
>>  void setup_apic_nmi_watchdog(void *unused) { return; }
>> --- a/arch/x86/kernel/apic/nmi.c
>> +++ b/arch/x86/kernel/apic/nmi.c
>> @@ -37,7 +37,6 @@
>>
>>  #include <asm/mach_traps.h>
>>
>> -int unknown_nmi_panic;
>>  int nmi_watchdog_enabled;
>>
>>  /* For reliability, we're prepared to waste bits here. */
>> @@ -389,7 +388,7 @@ void touch_nmi_watchdog(void)
>>  EXPORT_SYMBOL(touch_nmi_watchdog);
>>
>>  notrace __kprobes int
>> -nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
>> +nmi_watchdog_tick(struct pt_regs *regs)
>>  {
>>       /*
>>        * Since current_thread_info()-> is always on the stack, and we
>> @@ -483,23 +482,6 @@ static void disable_ioapic_nmi_watchdog(
>>       on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
>>  }
>>
>> -static int __init setup_unknown_nmi_panic(char *str)
>> -{
>> -     unknown_nmi_panic = 1;
>> -     return 1;
>> -}
>> -__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
>> -
>> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
>> -{
>> -     unsigned char reason = get_nmi_reason();
>> -     char buf[64];
>> -
>> -     sprintf(buf, "NMI received for unknown reason %02x\n", reason);
>> -     die_nmi(buf, regs, 1); /* Always panic here */
>> -     return 0;
>
> You are dropping this code that is different to panic().

What is the difference? Is it relevant?

Best Regards,
Huang Ying
