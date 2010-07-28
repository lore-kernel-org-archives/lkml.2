Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0G1Ua7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:30:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62063 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0G1Ua4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:30:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=pwWA40/8mCeYEX2TDqQ1RViRdFTM3+FuCTPNZ+GB5Z+szw/lc1UW99JKLcJxlcdV/
	8GPw9FMgLu5tPZ9mhrgxQ==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007280035480.28038@localhost.localdomain>
References: <alpine.LFD.2.00.1007280033370.28038@localhost.localdomain>
	<alpine.LFD.2.00.1007280035480.28038@localhost.localdomain>
Date: Wed, 28 Jul 2010 13:30:47 -0700
Message-ID: <AANLkTimYrRXy8wiaKdUEc1cTCG+B2d8zv5bVs=wrPpXp@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] x86: Prefer TSC Deadline Timer over LAPIC timer
From: Venkatesh Pallipadi <venki@google.com>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 9:37 PM, Len Brown <lenb@kernel.org> wrote:
> From: Len Brown <len.brown@intel.com>
>
> The LOCAL APIC on new processors has a mode where
> its underlying hardware timer can now be accessed
> via the non-serializing IA32_TSC_DEADLINE_MSR in TSC tick units.
>
> If this mode is present, prefer it over the
> traditional LAPIC timer mode.  KERN_DEBUG dmesg
> will print "TSC deadline timer enabled" when TDT is used.
>
> Bootparam "tdt_off" is available to revert to LAPIC timer mode.
>
> This patch is based on original work by Venkatesh Pallipadi.
>
> cc: Venkatesh Pallipadi <venki@google.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    3 ++
>  arch/x86/kernel/apic/apic.c         |   44 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 46 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 2b2407d..73ec308 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2596,6 +2596,9 @@ and is between 256 and 4096 characters. It is defined in the file
>
>        tdfx=           [HW,DRM]
>
> +       tdt_off         [APIC,X86]
> +                       Disable TSC Deadline Timer, default back to LAPIC timer.
> +

How about renaming this to noapictdt or nolapictdt? Not that they are
good, but that would make it similar to other apic params.

>        test_suspend=   [SUSPEND]
>                        Specify "mem" (for Suspend-to-RAM) or "standby" (for
>                        standby suspend) as the system sleep state to briefly
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index a96489e..64069ae 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -53,6 +53,15 @@
>  #include <asm/kvm_para.h>
>  #include <asm/tsc.h>
>
> +#define APIC_TIMER_MODE_ONESHOT                (0 << 17)
> +#define APIC_TIMER_MODE_PERIODIC       (1 << 17)
> +#define APIC_TIMER_MODE_TSC_DEADLINE   (2 << 17)
> +#define APIC_TIMER_MODE_MASK           (3 << 17)
> +
> +static unsigned long tsc_per_apic_clock;
> +static int tdt_enabled;
> +static int tdt_disable;
> +
>  unsigned int num_processors;
>
>  unsigned disabled_cpus __cpuinitdata;
> @@ -355,6 +364,14 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
>        if (!irqen)
>                lvtt_value |= APIC_LVT_MASKED;
>
> +       if (oneshot && !tdt_disable &&
> +           boot_cpu_has(X86_FEATURE_TSC_DEADLINE)) {
> +               printk_once(KERN_DEBUG "TSC deadline timer enabled\n");
> +               tdt_enabled = 1;
> +               lvtt_value &= (~APIC_TIMER_MODE_MASK);
> +               lvtt_value |= APIC_TIMER_MODE_TSC_DEADLINE;
> +       }
> +
>        apic_write(APIC_LVTT, lvtt_value);
>
>        /*
> @@ -409,7 +426,20 @@ EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
>  static int lapic_next_event(unsigned long delta,
>                            struct clock_event_device *evt)
>  {
> -       apic_write(APIC_TMICT, delta);
> +       if (tdt_enabled) {
> +               u64 tsc;
> +               u64 delta_tsc;
> +
> +               delta_tsc = delta * tsc_per_apic_clock;

About this conversion. I think it is cleaner and probably better in
terms of performance to deal with TSC natively in lapic_clockevent.
That would mean having the mult and min/max delta in terms of TSC.
That would also mean we can avoid APIC tick frequency calibration.
Also, having a different ->next_event for TSC deadline timer would be
better than checking this flag on every call.

Thanks,
Venki
