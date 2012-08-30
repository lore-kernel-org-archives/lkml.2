Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2H3KX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 06:23:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41732 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2H3KW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 06:22:56 -0400
Message-ID: <503F3F19.2070001@gmail.com>
Date: Thu, 30 Aug 2012 12:23:21 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120826 Thunderbird/14.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v10] kvm: notify host when the guest is panicked
References: <503DA63E.40608@cn.fujitsu.com> <503E0377.6000107@gmail.com> <503EC9FE.90000@cn.fujitsu.com>
In-Reply-To: <503EC9FE.90000@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 04:03 AM, Wen Congyang wrote:
> At 08/29/2012 07:56 PM, Sasha Levin Wrote:
>> On 08/29/2012 07:18 AM, Wen Congyang wrote:
>>> diff --git a/Documentation/virtual/kvm/pv_event.txt b/Documentation/virtual/kvm/pv_event.txt
>>> new file mode 100644
>>> index 0000000..bb04de0
>>> --- /dev/null
>>> +++ b/Documentation/virtual/kvm/pv_event.txt
>>> @@ -0,0 +1,32 @@
>>> +The KVM paravirtual event interface
>>> +=================================
>>> +
>>> +Initializing the paravirtual event interface
>>> +======================
>>> +kvm_pv_event_init()
>>> +Argiments:
>>> +	None
>>> +
>>> +Return Value:
>>> +	0: The guest kernel can use paravirtual event interface.
>>> +	1: The guest kernel can't use paravirtual event interface.
>>> +
>>> +Querying whether the event can be ejected
>>> +======================
>>> +kvm_pv_has_feature()
>>> +Arguments:
>>> +	feature: The bit value of this paravirtual event to query
>>> +
>>> +Return Value:
>>> +	0 : The guest kernel can't eject this paravirtual event.
>>> +	-1: The guest kernel can eject this paravirtual event.
>>> +
>>> +
>>> +Ejecting paravirtual event
>>> +======================
>>> +kvm_pv_eject_event()
>>> +Arguments:
>>> +	event: The event to be ejected.
>>> +
>>> +Return Value:
>>> +	None
>>
>> What's the protocol for communicating with the hypervisor? What is it supposed
>> to do on reads/writes to that ioport?
> 
> Not only ioport, the other arch can use some other ways. We can use
> these APIs to eject event to hypervisor. The caller does not care how
> to communicate with the hypervisor.

Right, it can work in several ways, but the protocol (whatever it may be)
between the hypervisor and the guest kernel should be documented here as well.

>>> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
>>> index 2f7712e..7d297f0 100644
>>> --- a/arch/x86/include/asm/kvm_para.h
>>> +++ b/arch/x86/include/asm/kvm_para.h
>>> @@ -96,8 +96,11 @@ struct kvm_vcpu_pv_apf_data {
>>>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>>>  #define KVM_PV_EOI_DISABLED 0x0
>>>  
>>> +#define KVM_PV_EVENT_PORT	(0x505UL)
>>> +
>>>  #ifdef __KERNEL__
>>>  #include <asm/processor.h>
>>> +#include <linux/ioport.h>
>>>  
>>>  extern void kvmclock_init(void);
>>>  extern int kvm_register_clock(char *txt);
>>> @@ -228,6 +231,30 @@ static inline void kvm_disable_steal_time(void)
>>>  }
>>>  #endif
>>>  
>>> +static inline int kvm_arch_pv_event_init(void)
>>> +{
>>> +	if (!request_region(KVM_PV_EVENT_PORT, 1, "KVM_PV_EVENT"))
>>
>> Only one byte is requested here, but the rest of the code is reading/writing longs?
>>
>> The struct resource * returned from request_region is simply being leaked here?
>>
>> What happens if we go ahead with adding another event (let's say OOM event)?
>> request_region() is going to fail for anything but the first call.
> 
> For x86, we use ioport to communicate with hypervisor. We can read a 32bit value
> from the hypervisor. If the bit0 is setted, it means the hypervisor supports
> panicked event. If you want add another event, you can use another unused bit.
> I think 32 events are enough now.
> 
> You can write a value to the ioport to eject the event. Only one event can be
> ejected at a time.

I was trying to point out that kvm_pv_event_init() would fail on anything but
the first call, while the API suggests it should be called to verify we can
write events.

>>> +static inline unsigned int kvm_arch_pv_features(void)
>>> +{
>>> +	unsigned int features = inl(KVM_PV_EVENT_PORT);
>>> +
>>> +	/* Reading from an invalid I/O port will return -1 */
>>
>> Just wondering, where is that documented? For lkvm for example the return value
>> from an ioport without a device on the other side is undefined, so it's possible
>> we're doing something wrong there.
> 
> Hmm, how to use lkvm? Can you give me a example. So I can test this patch on lkvm.

You can grab lkvm from https://github.com/penberg/linux-kvm , it lives under
tools/kvm/ in the kernel tree.

> For qemu, it returns -1. I don't know which is right now. I will investigate it.

Thing is, unless x86 arch suggests it should return something specific in this
case, we can't assume a return value either from lkvm or qemu.


Thanks,
Sasha

