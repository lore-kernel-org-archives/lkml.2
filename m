Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2CPCIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 22:08:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57337 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2CPCIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 22:08:32 -0400
MIME-Version: 1.0
In-Reply-To: <1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com>
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>
	<1331834583-16070-1-git-send-email-sp@numascale.com>
	<CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>
	<1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com>
Date: Thu, 15 Mar 2012 19:08:32 -0700
X-Google-Sender-Auth: srVan11q3zdcaVORQl_szQrA6l0
Message-ID: <CAE9FiQXXy3UDFpm5uCmpnn7Q53FhQN6h-BSAizgk_Sqkg+d4bA@mail.gmail.com>
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid() function.
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Steffen Persvold <sp@numascale.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 2:21 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Thu, 2012-03-15 at 13:23 -0700, Yinghai Lu wrote:
>> On Thu, Mar 15, 2012 at 11:03 AM, Steffen Persvold <sp@numascale.com> wrote:
>> > Use x2apic_supported() in the default_apic_id_valid() function. If x2apic mode is disabled (via nox2apic for example), x2apic_supported() will return false.
>> >
>> > This allows us to substitute the check in arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic and avoid feigning the x2apic cpu feature in the NumaChip apic code.
>> >
>> > Signed-off-by: Steffen Persvold <sp@numascale.com>
>> > Reviewed-by: Daniel J Blueman <daniel@numascale-asia.com>
>>
>> I double checked on system with x2apic preenabled,
>> nox2apic in boot command line still works well and it
>> skips starting APs with apic id > 255.
>>
>> Acked-by: Yinghai Lu <yinghai@kernel.org>
>
> This breaks the smpboot check if enabling interrupt-remapping/x2apic
> fails on a platform. We will be in xapic mode and we don't clear the
> x2apic cpufeature bit in this case and as such smpboot check will fail.

two cases:
A: x2apic is pre-enabled, and some apic id > 255
B: x2apic is not pre-enabled, but x2apic capable, suppose all apic id < 255.

in case A: if nox2apic is passed, or dmar table is not there or
intr-remap can not be enabled.
   that feature bit will be cleared. So check cpu_has_x2apic is enough there.

in case B: if can not enable x2apic, the feature is not cleared, but
apic id already < 255.
   so that check will pass too.

So it should not break the smpboot check.

>
> So this change breaks the commit
> c284b42abadbb22083bfde24d308899c08d44ffa.
>
> I think the right thing is to have two different apid_id_valid checks
> one for xapic driver (apic_flat_64.c) and another for x2apic driver
> (x2apic_phys/cluster.c) and that way, x2apic MADT entries will be parsed
> only if bios has handed over the OS in x2apic mode or if we have
> selected the numachip model.

that looks like more clear.

Thanks

Yinghai
