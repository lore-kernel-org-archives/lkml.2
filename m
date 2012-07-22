Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab2GVUSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 16:18:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65123 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2GVUSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 16:18:51 -0400
Message-ID: <500C604B.3080800@gmail.com>
Date: Sun, 22 Jul 2012 22:19:23 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v7] kvm: notify host when the guest is panicked
References: <500A565A.8080403@cn.fujitsu.com> <500A8969.1040300@gmail.com> <87txwzwqgt.fsf@codemonkey.ws>
In-Reply-To: <87txwzwqgt.fsf@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2012 09:22 PM, Anthony Liguori wrote:
> Sasha Levin <levinsasha928@gmail.com> writes:
> 
>> On 07/21/2012 09:12 AM, Wen Congyang wrote:
>>> +#define KVM_PV_PORT	(0x505UL)
>>> +
>>>  #ifdef __KERNEL__
>>>  #include <asm/processor.h>
>>>  
>>> @@ -221,6 +223,11 @@ static inline void kvm_disable_steal_time(void)
>>>  }
>>>  #endif
>>>  
>>> +static inline unsigned int kvm_arch_pv_features(void)
>>> +{
>>> +	return inl(KVM_PV_PORT);
>>> +}
>>> +
>>
>> Why is this safe?
>>
>> I'm not sure you can just pick any ioport you'd like and use it.
> 
> There are three ways I/O ports get used on a PC:
> 
> 1) Platform devices
>  - This is well defined since the vast majority of platform devices are
>    implemented within a single chip.  If you're emulating an i440fx
>    chipset, the PIIX4 spec has an exhaustive list.
> 
> 2) PCI devices
>  - Typically, PCI only allocates ports starting at 0x0d00 to avoid
>    conflicts with ISA devices.
> 
> 3) ISA devices
>  - ISA uses subtractive decoding so any ISA device can access.  In
>    theory, an ISA device could attempt to use port 0x0505 but it's
>    unlikely.  In a modern guest, there aren't really any ISA devices being
>    added either.
> 
> So yes, picking port 0x0505 is safe for something like this (as long as
> you check to make sure that you really are under KVM).

Is there anything that actually prevents me from using PCI ports lower than 0x0d00? As you said in (3), ISA isn't really used anymore (nor is implemented by lkvm for example), so placing PCI below 0x0d00 might even make sense in that case.

Furthermore, I can place one of these brand new virtio-mmio devices which got introduced recently wherever I want right now - Having a device that uses 0x505 would cause a pretty non-obvious failure mode.

Either way, If we are going to grab an ioport, then:

 - It should be documented well somewhere in Documentation/virt/kvm
 - It should go through request_region() to actually claim those ioports.
 - It should fail gracefully if that port is taken for some reason, instead of not even checking it.
