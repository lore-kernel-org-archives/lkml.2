Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2GVWU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 18:20:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35775 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2GVWUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 18:20:54 -0400
From: Anthony Liguori <anthony@codemonkey.ws>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v7] kvm: notify host when the guest is panicked
In-Reply-To: <500C604B.3080800@gmail.com>
References: <500A565A.8080403@cn.fujitsu.com> <500A8969.1040300@gmail.com> <87txwzwqgt.fsf@codemonkey.ws> <500C604B.3080800@gmail.com>
User-Agent: Notmuch/0.13.2+60~g7ecf77d (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 22 Jul 2012 17:20:48 -0500
Message-ID: <87zk6rcu9r.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On 07/22/2012 09:22 PM, Anthony Liguori wrote:
>> Sasha Levin <levinsasha928@gmail.com> writes:
>> 
>>> On 07/21/2012 09:12 AM, Wen Congyang wrote:
>>>> +#define KVM_PV_PORT	(0x505UL)
>>>> +
>>>>  #ifdef __KERNEL__
>>>>  #include <asm/processor.h>
>>>>  
>>>> @@ -221,6 +223,11 @@ static inline void kvm_disable_steal_time(void)
>>>>  }
>>>>  #endif
>>>>  
>>>> +static inline unsigned int kvm_arch_pv_features(void)
>>>> +{
>>>> +	return inl(KVM_PV_PORT);
>>>> +}
>>>> +
>>>
>>> Why is this safe?
>>>
>>> I'm not sure you can just pick any ioport you'd like and use it.
>> 
>> There are three ways I/O ports get used on a PC:
>> 
>> 1) Platform devices
>>  - This is well defined since the vast majority of platform devices are
>>    implemented within a single chip.  If you're emulating an i440fx
>>    chipset, the PIIX4 spec has an exhaustive list.
>> 
>> 2) PCI devices
>>  - Typically, PCI only allocates ports starting at 0x0d00 to avoid
>>    conflicts with ISA devices.
>> 
>> 3) ISA devices
>>  - ISA uses subtractive decoding so any ISA device can access.  In
>>    theory, an ISA device could attempt to use port 0x0505 but it's
>>    unlikely.  In a modern guest, there aren't really any ISA devices being
>>    added either.
>> 
>> So yes, picking port 0x0505 is safe for something like this (as long as
>> you check to make sure that you really are under KVM).
>
> Is there anything that actually prevents me from using PCI ports lower
> than 0x0d00? As you said in (3), ISA isn't really used anymore (nor is
> implemented by lkvm for example), so placing PCI below 0x0d00 might
> even make sense in that case.

On modern systems, the OS goes by whatever is in the ACPI table
describing the PCI bus.  In QEMU, we have:

    WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
          0x0000,             // Address Space Granularity
          0x0D00,             // Address Range Minimum
          0xFFFF,             // Address Range Maximum
          0x0000,             // Address Translation Offset
          0xF300,             // Address Length
          ,, , TypeStatic)

So Linux will always use 0x0D00 -> 0xFFFF for the valid
range. Practically speaking, you can't use anything below 0x0D00 because
the PCI bus configuration registers live at 0xCF8-0xCFF.  If you tried
to create the region starting at 0x0500 you'd have to limit it to 0xCF8
to avoid conflicting with the PCI host controller.

That's not a useful amount of space for I/O ports so that would be a
pretty dumb thing to do.

> Furthermore, I can place one of these brand new virtio-mmio devices
> which got introduced recently wherever I want right now - Having a
> device that uses 0x505 would cause a pretty non-obvious failure mode.

I think you're confusing PIO with MMIO.  They are separate address
spaces.

You could certainly argue that relying on PIO is way too architecture
specific since that's only available on x86.  That's a good argument but
the counter is that other architectures have their own interfaces for
this sort of thing.

> Either way, If we are going to grab an ioport, then:
>
>  - It should be documented well somewhere in Documentation/virt/kvm
>  - It should go through request_region() to actually claim those ioports.
>  - It should fail gracefully if that port is taken for some reason,
>  instead of not even checking it.

I agree with the above.

Regards,

Anthony Liguori
