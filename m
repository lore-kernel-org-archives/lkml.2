Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0GEHy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 03:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab0GEHy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 03:54:26 -0400
Message-ID: <4C318FAC.8010605@redhat.com>
Date: Mon, 05 Jul 2010 10:54:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH v2] KVM: IOAPIC: only access APIC registers one dword
 at a time
References: <4C2D6D4B.5060309@cn.fujitsu.com> <4C2D95EA.6080209@np.css.fujitsu.com> <4C2D975A.2050704@cn.fujitsu.com> <4C2D9C8C.8060401@cn.fujitsu.com> <4C2F0CC1.6020808@redhat.com> <4C3155BA.4070903@cn.fujitsu.com>
In-Reply-To: <4C3155BA.4070903@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 06:47 AM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>    
>> On 07/02/2010 11:00 AM, Xiao Guangrong wrote:
>>      
>>> The IOAPIC spec says:
>>>
>>> When accessing these registers, accesses must be done one dword at a
>>> time.
>>> For example, software should never access byte 2 from the Data
>>> register before
>>> accessing bytes 0 and 1. The hardware will not attempt to recover from
>>> a bad
>>> programming model in this case.
>>>
>>> So, this patch removes other width access
>>>
>>>
>>>        
>> The ioapic code also implements the ia64 iosapic.  I'm guessing that
>> does support 64-bit accesses.  Please check the iosapic documentation.
>>
>>      
> The iosapic also using 32-bit to access registers:
>
> All registers are accessed using 32-bit uncacheable loads and stores to a reserved memory location
> in system memory. This implies that to modify a field (e.g., a bit or a byte) in any register, the
> whole 32-bit register must be read, the field modified, and the 32 bits written back. Partial register
> access, or non-aligned register access, are implementation-defined by the I/O xAPIC and will not
> be compatible across different implementations. Also, registers that are described as 64 bits wide
> are accessed as multiple independent 32-bit registers.
>
> [ From<<  Intel® Itanium® Processor Family Interrupt Architecture Guide>>, P2-6 ]
>    

Ok.

>> There might be guests that use incorrect access despite the
>> documentation; if real hardware supports it, it should work.  So we need
>> to start with just a warning, and allow the access.  Later we can drop
>> the invalid access.
>>      
> If the OS contravene the spec, i thinks it's the OS's bug, also, i have tested some versions
> windows/linux guests, it's no broken, can we directly drop the other wide access?
>    

Well, there's the spec and there's real life, but in this case we can 
try and if we see a problem we'll re-add the other access length.


-- 
error compiling committee.c: too many arguments to function

