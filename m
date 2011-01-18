Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab1ARPsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 10:48:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1ARPsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:48:52 -0500
Message-ID: <4D35B61C.1060302@redhat.com>
Date: Tue, 18 Jan 2011 10:47:40 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: quintela@redhat.com
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com>	<1294308645-31113-3-git-send-email-zamsden@redhat.com>	<20110107104859.GA12056@amt.cnet> <4D277B24.5000409@redhat.com>	<20110110135053.GA12991@amt.cnet> <m3bp3jwy19.fsf@trasno.org>
In-Reply-To: <m3bp3jwy19.fsf@trasno.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 06:00 AM, Juan Quintela wrote:
> Marcelo Tosatti<mtosatti@redhat.com>  wrote:
>    
>> On Fri, Jan 07, 2011 at 10:44:20AM -1000, Zachary Amsden wrote:
>>      
>>> On 01/07/2011 12:48 AM, Marcelo Tosatti wrote:
>>>        
>>>> On Thu, Jan 06, 2011 at 12:10:45AM -1000, Zachary Amsden wrote:
>>>>          
>>>>> Use an MSR to allow "soft" migration to hosts which do not support
>>>>> TSC trapping.  Rather than make this a required element of any
>>>>> migration protocol, we allow the TSC rate to be exported as a data
>>>>> field (useful in its own right), but we also allow a one time write
>>>>> of the MSR during VM creation.  The result is that for the common
>>>>> use case, no protocol change is required to communicate TSC rate
>>>>> to the receiving host.
>>>>>            
>>>> Migration to hosts which do not support the feature can be achieved by
>>>> saving/restoring the TSC rate + flags in a subsection. A subsection
>>>> seems more appropriate than an MSR for this.
>>>>          
>>> Yes, I looked at that, but it looked to me like a subsection was
>>> intended for an optional feature which MUST be present on the
>>> destination if the source is using the feature.  This way, newer
>>> hosts without the feature enabled can migrate to older hosts which
>>> do not support the feature.
>>>        
>> Right. But you can use a subsection to achieve the same effect. Just
>> consider that the source is not using the feature if you want to migrate
>> to an older host without support for it. Juan, is there a problem to
>> use subsections in this fashion?
>>
>> With the MSR scheme, there is no way for management to enforce support
>> of the feature on the destination (at least not that i can see). And
>> you create an MSR that does not exist on real hardware.
>>
>>      
>>> The TSC rate migration is slightly different; we may wish to migrate
>>> from a host with the TSC rate feature enabled to a host which does
>>> not support the TSC rate feature.  This is exactly the current
>>> behavior, the TSC rate will change on that migration, and I wanted
>>> to preserve that behavior.  I don't advise that mode of usage, but
>>> there may be use cases for it and it should be decided by policy,
>>> not dictated by our feature set.
>>>
>>> That said, I'm happy to remove the MSR if we truly don't want to
>>> support that mode of usage.
>>>        
> Ok, I chime it late.
>
> We are adding a new MSR to the comunication with userspace.  So far so
> good, but this new field, need to be transmited to the "other end" of
> the migration.  This means a new field for migration (notice that this
> is independtly if this is an MSR or not).
>
>          VMSTATE_UINT64_V(system_time_msr, CPUState, 11),
>          VMSTATE_UINT64_V(wall_clock_msr, CPUState, 11),
>    

Oh, wow.  I thought the MSRs were sent automatically by qemu based on 
what MSRs the kvm module told it were available.  It looks like EFER and 
STAR and friends are all special cased as part of CPUstate.

So my approach has been doomed from the beginning.

> This are the values that we are sending now.
> We are getting now, a new value, the problem is how to migrate it.
>
> Solutions:
> - create a new field in a new field in CPUState, and up the version.
>    That would make backward migration impossible.
> - create a new field, and sent it only it is has been used with a
>    subsection.  This makes migration backwards if this was not used.
>
> - but, it appears that there if this features is not "known" on
>    destination, we can use the old way to migrate information.
>
>    BIG WARNING HERE: I don't claim to understand how clocks work at all
>
>    There is not a way to convince old qemu/kernels to ignore new fields
>    for good reason.  So the only solution here is to encode this new
>    vcpu->kvm->arch.virtual_tsc_khz in the two previous fields, in a way
>    that is understable for old qemu/new qemu.  old qemu will use old
>    method, new qemu will use a new method.
>
>    If there is not a common encoding that will work for both old/new
>    method, I can't really think of a way to make things work here :(
>
> And as per the warning, I can't think of a way to encode
> "virtual_tsc_khz" into "system_time_msr" and "wall_clock_msr" off-hand.
>
> To make things clearer about optional features, after "lots" of
> discussions, it was decided that target of migration will never ignore
> anything sent, that means that the only one that can decide not to sent
> a feature/value is the "source" of the migration.  There is no way to
> express:
>
> - try this method, if you don't know
> - try this other second best, ...
>    

That decides it then, the feature is migrated in the state it is set if 
it is enabled.

This makes things much simpler all around.

Cheers,

Zach

