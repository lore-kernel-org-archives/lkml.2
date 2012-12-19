Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2LSQDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:03:31 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:52860 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2LSQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:03:27 -0500
MIME-Version: 1.0
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F91F2210@G1W3649.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
	<CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
	<92645B27BF79D04FBD2B0F8494FFD0F91F2210@G1W3649.americas.hpqcorp.net>
Date: Wed, 19 Dec 2012 08:03:25 -0800
X-Google-Sender-Auth: PnYlDIwmk1fgvQIsrzuizgg_w6c
Message-ID: <CAE9FiQUK3_vO_A1geKzNMWsRgsuUPrE4DGmwaFwbAhCaPGn8cg@mail.gmail.com>
Subject: Re: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
From: Yinghai Lu <yinghai@kernel.org>
To: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 2:13 AM, Zhang, Lin-Bao (Linux Kernel R&D)
<linbao.zhang@hp.com> wrote:
>> > b) If BIOS feel the system doesn't meet x2apic conditions , it will not set
>> x2apic enablement bit in MSR ,and pass control to OS with xapic mode.
>>
>> kernel will check if cpuid support x2apic, if it supports x2apic, it will check if
>> DMAR/intr-remapping could be enabled, if so kernel will switch to x2apic.
>> otherwise it will stay with xapic.
>>
>> So you need to make cpuid show does not support x2apic --- check with intel
>> they have way to do that.
> My concerns is BIOS creates different ACPI tables in xAPIC mode and X2APIC mode.
> BIOS will auto detect if the system meets x2APIC condition , if no , it will not create right ACPI tables for this mode and don't set MSR bit.
> For this case (BIOS didn't set MSR , but BSP supports x2apic ) , I want to know
> 1, For Linux kernel, which ACPI tables will be used for x2apic and XAPIC ?

two MADT?

why two?

according to Intel, if your apic id < 255, even cpu is in x2apic state
already, you only have xapic entry in MADT.

> 2, why Linux kernel will set x2apic enablement bit in CPU msr ? generally speaking , BIOS set it and OS get it.
> If OS get it , who will read it ? BIOS ?  I consult BIOS designer , he said , their BIOS calling service(just like UEFI run time service)
> will also judge MSR again , so I don't know why Linux kernel will set MSR bit , unless OS has special target .

because os does not trust BIOS.

BIOS ONLY SHOULD only do thing it should do:
1. initialize memory.
2. assign some resource to pci devices bar
3. provide memory mem-map to bootloader and os.

If it don't want OS to use x2apic, disable that in CPUID.

>
>> or you can pass "nox2apic" in boot command line.
> Yeah, I think this would be fine if we really want to use xAPIC mode instead of x2apic mode.
> But I am puzzled why Linux kernel will force to enter x2apic just depends on BSP has supported x2apic ?
> "BSP supports x2apic" condition is enough for judging if OS can enable x2apic ?

if system support x2apic, os will try use x2apic at first, unless BIOS
mess it up.
