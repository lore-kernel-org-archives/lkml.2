Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0HCI1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:27:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44616 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab0HCI12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:27:28 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>
	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>
	<4C57CCBB.1010608@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 01:27:23 -0700
In-Reply-To: <4C57CCBB.1010608@kernel.org> (Yinghai Lu's message of "Tue\, 03 Aug 2010 01\:00\:59 -0700")
Message-ID: <m1ocdkt82c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 08/03/2010 12:19 AM, Yinghai Lu wrote:
>> On 08/02/2010 08:13 PM, Eric W. Biederman wrote:
>>> Yinghai Lu <yinghai@kernel.org> writes:

>>>> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
>>>> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
>>>> @@ -1029,10 +1029,7 @@ static int pin_2_irq(int idx, int apic,
>>>>  	} else {
>>>>  		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
>>>>  
>>>> -		if (gsi >= NR_IRQS_LEGACY)
>>>> -			irq = gsi;
>>>> -		else
>>>> -			irq = gsi_top + gsi;
>>>> +		irq = gsi_to_irq(gsi);
>>>>  	}
>>>>  
>>>>  #ifdef CONFIG_X86_32
>> 
>> what is the point for making irq = gsi_top + gsi when mptable is used instead of acpi?
>> 
>
> just tried those blind shifting gsi cause kernel with acpi crash in virtual box.

What configuration did you try and had problems with?

> [    5.536000] querying PCI -> IRQ mapping bus:0, slot:11, pin:0.
> [    5.540000] ehci_hcd 0000:00:0b.0: can't find IRQ for PCI INT A; probably buggy MP table
> [

I don't have a clue what the mpptable looks like in virtual box.  My guess is that it
is buggy and untested like so many mptables these days.

> and on kvm it got:
> [    4.352280] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
> [    4.356012] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    4.360120] querying PCI -> IRQ mapping bus:0, slot:3, pin:0.
> [    4.364006] PCI BIOS passed nonexistent PCI bus 0!
> [    4.368007] e1000 0000:00:03.0: can't find IRQ for PCI INT A; probably buggy MP table
> [    4.372049] e1000 0000:00:03.0: setting latency timer to 64


This example failed because mpparse said bus 0 was ISA.  Which is a
pretty bizarre thing to do, especially when bus 0 is pretty clearly
PCI.  That does sound like a buggy MP table.

Eric
