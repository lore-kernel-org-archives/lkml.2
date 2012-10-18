Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2JRKzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:55:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab2JRKzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:55:44 -0400
Message-ID: <507FE020.7040805@redhat.com>
Date: Thu, 18 Oct 2012 12:55:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
CC: x86@kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [PATCH 0/3] x86: clear vmcss on all cpus when doing kdump if
 necessary
References: <5077BB7B.4030203@cn.fujitsu.com> <507C2F18.8080904@redhat.com> <507E17C0.9070305@cn.fujitsu.com> <507E8575.4040908@redhat.com> <507F5762.3060208@cn.fujitsu.com>
In-Reply-To: <507F5762.3060208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 03:12 AM, Zhang Yanfei wrote:
> 于 2012年10月17日 18:16, Avi Kivity 写道:
>> On 10/17/2012 04:28 AM, Zhang Yanfei wrote:
>>> 于 2012年10月15日 23:43, Avi Kivity 写道:
>>>> On 10/12/2012 08:40 AM, Zhang Yanfei wrote:
>>>>> Currently, kdump just makes all the logical processors leave VMX operation by
>>>>> executing VMXOFF instruction, so any VMCSs active on the logical processors may
>>>>> be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
>>>>> in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
>>>>> executing the VMXOFF instruction.
>>>>
>>>> How have you verified that VMXOFF doesn't flush cached VMCSs already?
>>>>
>>>
>>> I tried some tests, for example, I made copies for every vmcs, and in the kdump
>>> path, I backed up all the loaded vmcs into the copies before vmxoff.
>>> After generating the vmcore, I retrieve the vmcss and their copies, and compare them,
>>> no differences.
>>>
>>> Another test is using VMCLEAR to clear all the loaded vmcs before VMXOFF,
>>> and compare the vmcss and their copies, there are indeed differences between the
>>> vmcs and its copy.
>>>
>>> I know the tests may be not so convincing, for example, I used memcpy to back up
>>> the vmcss and it is an ordinary memory operation. But to ensure the non-corruption
>>> of the vmcss in the vmcore, I think we should VMCLEAR the vmcss before VMXOFF just
>>> as the Intel spec says.
>> 
>> Sorry, I was unclear -- I was referring to the spec, I wasn't sure
>> whether VMXOFF is defined to flush VMCSes or whether it just invalidates
>> on-chip caches so that it won't flush them out in the future, corrupting
>> memory.  We don't want to depend on actual behaviour as it may change
>> with future version.
>> 
>> Copying some Intel folk, maybe they can clarify it.
>> 
> 
> Yes, the Intel spec says "may be" about the VMCS-corruption thing. From
> chapter 24.10.1 in Intel® 64 and IA-32 Architectures Software Developer’s
> Manual Volume 3C:System Programming Guide, Part 3, there is the description:
> 
> "If a logical processor leaves VMX operation, any VMCSs active on that logical
> processor may be corrupted (see below). To prevent such corruption of a VMCS that
> may be used either after a return to VMX operation or on another logical processor,
> software should VMCLEAR that VMCS before executing the VMXOFF instruction or
> removing power from the processor (e.g., as part of a transition to the S3 and S4
> power states)."
> 
> Our purpose is to make sure the VMCSs in the vmcore are updated and non-corrupted. So
> according to the description above, no matter whether VMXOFF is defined to flush
> VMCSs or whether it just invalidates on-chip caches, we'd better VMCLEAR the
> VMCSs before executing the VMXOFF.

Ok, that's clear then.  So all we need is to remove the sysctl and clear
VMCSs unconditionally.



-- 
error compiling committee.c: too many arguments to function
