Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1BUV0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:26:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1BUV0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:26:01 -0500
Message-ID: <4D62D866.807@redhat.com>
Date: Mon, 21 Feb 2011 16:25:58 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] KVM support for TSC scaling
References: <4D57F677.3090004@redhat.com> <20110221172807.GD16508@amd.com>
In-Reply-To: <20110221172807.GD16508@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 12:28 PM, Roedel, Joerg wrote:
> On Sun, Feb 13, 2011 at 10:19:19AM -0500, Avi Kivity wrote:
>    
>> On 02/09/2011 07:29 PM, Joerg Roedel wrote:
>>      
>>> Hi Avi, Marcelo,
>>>
>>> here is the patch-set to implement the TSC-scaling feature of upcoming
>>> AMD CPUs. When this feature is supported the CPU provides a new MSR
>>> which holds a multiplier for the hardware TSC which is applied on the
>>> value rdtsc[p] and reads of MSR 0x10. This feature can be used to
>>> emulate a given tsc frequency for the guest.
>>> Patch 1 is not directly related to this patch-set because it only fixes
>>> a bug which prevented me from testing these patches. In fact it fixes
>>> the same bug Andre sent a patch for. But after the discussion about his
>>> patch he told me to just post my patch and thus here it is.
>>>
>>>        
>> Questions:
>> - the tsc multiplier really is a multiplier, right?  Not an addend that
>> is added every cycle.
>>      
> Yes, it is a real multiplier. But writes to the TSC-MSR will change the
> unscaled TSC value.
>
>    
>> So
>>
>>       wrmsr(TSC, 1e9)
>>       wrmsr(TSC_MULT, 2.0000)
>>       t = rdtsc()
>>
>> will return about 2e9, not 1e9 + 2*(time to execute the code snippet) ?
>>      
> Right. And if you exchange the two wrmsr calls it will still give you
> the same result.
>
>    
>> - what's the cost of wrmsr(TSC_MULT)?
>>      
> Hard to tell by now because I only have numbers for pre-production
> hardware.
>
>    
>> There are really two ways to implement this feature.  One is fully
>> generic, like you did.  The other is to implement it at the host level -
>> have a sysfs file and/or kernel parameter for the desired tsc frequency,
>> write it once, and forget about it.  Trust management to set the host
>> tsc frequency to the same value on all hosts in a migration cluster.
>>      
> The motivation here is mostly the flexibility. Scale the TSC for the
> whole migration cluster only makes sense if all hosts there support the
> feature. But the most likely scenario is that existing migration
> clusters will be extended by new machines and guests will be migrated
> there. And these guests should be able to see the same TSC frequency on
> the new host as the had on the old one. The older machines in the
> cluster may even have different TSC frequencys. With this flexible
> implementation those scenarios are possible. A host-wide setting for the
> scaling will make the feature useless in those (common) scenarios.
>    

It's also possible to scale the TSCs of the cluster to be matching 
outside of the framework of KVM.  In that case, the VCPU client (qemu) 
simply needs to be smart enough to not request the TSC rate be scaled.  
That approach is completely compatible with this implementation.

If you do indeed want to have mixed speed VMs running on a single host, 
that can also be done with the approach here.

Combining the two - supporting a standard cluster rate via host scaling, 
plus a variable rate for martian VMs (those not conforming to the 
standard cluster rate) would require some more work, as the multiplier 
written back on exit from a martian would not be 1.0, rather something 
else.  Everything else should work as long as tsc_khz still expresses 
the natural rate of the TSC, even when scaled to a standard cluster 
rate.  In that case, you can also pursue Avi's suggestion of skipping 
the MSR loads for VMs where the rate matches the host rate.

Adding an export to the kernel indicating the currently applied scaling 
rate may not be a bad idea if you want to support such an implementation 
in the future.

I did have one slight concern about scaling in general.  What happens 
when the CPU khz rate is not uniformly detected across machines or 
clusters?  In general, it does vary a bit, I see differences out to the 
5th digit of precision on the same machine.  This is close enough to be 
within the range of NTP correction (500 ppm), but also small enough to 
represent real clock differences (and of course, there is some 
measurement error).

If you are within the threshold where NTP can correct the time, you may 
not want to apply a multiplier to the TSC at all.  Again, this decision 
can be made in the userspace component, but it's an important 
consideration to bring up for the qemu patches that will be required to 
support this.

Zach
