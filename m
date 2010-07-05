Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0GEDu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 23:50:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758098Ab0GEDu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 23:50:58 -0400
Message-ID: <4C3155BA.4070903@cn.fujitsu.com>
Date: Mon, 05 Jul 2010 11:47:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH v2] KVM: IOAPIC: only access APIC registers one dword
 at a time
References: <4C2D6D4B.5060309@cn.fujitsu.com> <4C2D95EA.6080209@np.css.fujitsu.com> <4C2D975A.2050704@cn.fujitsu.com> <4C2D9C8C.8060401@cn.fujitsu.com> <4C2F0CC1.6020808@redhat.com>
In-Reply-To: <4C2F0CC1.6020808@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 07/02/2010 11:00 AM, Xiao Guangrong wrote:
>> The IOAPIC spec says:
>>
>> When accessing these registers, accesses must be done one dword at a
>> time.
>> For example, software should never access byte 2 from the Data
>> register before
>> accessing bytes 0 and 1. The hardware will not attempt to recover from
>> a bad
>> programming model in this case.
>>
>> So, this patch removes other width access
>>
>>    
> 
> The ioapic code also implements the ia64 iosapic.  I'm guessing that
> does support 64-bit accesses.  Please check the iosapic documentation.
> 

The iosapic also using 32-bit to access registers:

All registers are accessed using 32-bit uncacheable loads and stores to a reserved memory location
in system memory. This implies that to modify a field (e.g., a bit or a byte) in any register, the
whole 32-bit register must be read, the field modified, and the 32 bits written back. Partial register
access, or non-aligned register access, are implementation-defined by the I/O xAPIC and will not
be compatible across different implementations. Also, registers that are described as 64 bits wide
are accessed as multiple independent 32-bit registers.

[ From << Intel® Itanium® Processor Family Interrupt Architecture Guide >>, P2-6 ]

> There might be guests that use incorrect access despite the
> documentation; if real hardware supports it, it should work.  So we need
> to start with just a warning, and allow the access.  Later we can drop
> the invalid access.

If the OS contravene the spec, i thinks it's the OS's bug, also, i have tested some versions
windows/linux guests, it's no broken, can we directly drop the other wide access?

> 
>> @@ -288,6 +288,11 @@ static int ioapic_mmio_read(struct kvm_io_device
>> *this, gpa_t addr, int len,
>>       ioapic_debug("addr %lx\n", (unsigned long)addr);
>>       ASSERT(!(addr&  0xf));    /* check alignment */
>>
>> +    if (len != 4) {
>> +        printk(KERN_WARNING "ioapic: wrong length %d\n", len);
>> +        return 0;
>> +    }
>> +
>>    
> 
> Guest triggered, so needs to be rate limited.

Yeah, will using printk_ratelimit cooperate with it.


