Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0FTILR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 04:11:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab0FTILM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 04:11:12 -0400
Message-ID: <4C1DCD1A.4010306@redhat.com>
Date: Sun, 20 Jun 2010 11:11:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>	 <20100615135530.4565745D@kernel.beaverton.ibm.com>	 <4C189830.2070300@redhat.com>  <1276701911.6437.16973.camel@nimitz> <1276876156.6437.23323.camel@nimitz>
In-Reply-To: <1276876156.6437.23323.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 06:49 PM, Dave Hansen wrote:
> On Wed, 2010-06-16 at 08:25 -0700, Dave Hansen wrote:
>    
>> On Wed, 2010-06-16 at 12:24 +0300, Avi Kivity wrote:
>>      
>>> On 06/15/2010 04:55 PM, Dave Hansen wrote:
>>>        
>>>> In a previous patch, we removed the 'nr_to_scan' tracking.
>>>> It was not being used to track the number of objects
>>>> scanned, so we stopped using it entirely.  Here, we
>>>> strart using it again.
>>>>
>>>> The theory here is simple; if we already have the refcount
>>>> and the kvm->mmu_lock, then we should do as much work as
>>>> possible under the lock.  The downside is that we're less
>>>> fair about the KVM instances from which we reclaim.  Each
>>>> call to mmu_shrink() will tend to "pick on" one instance,
>>>> after which it gets moved to the end of the list and left
>>>> alone for a while.
>>>>
>>>>          
>>> That also increases the latency hit, as well as a potential fault storm,
>>> on that instance.  Spreading out is less efficient, but smoother.
>>>        
>> This is probably something that we need to go back and actually measure.
>> My suspicion is that, when memory fills up and this shrinker is getting
>> called a lot, it will be naturally fair.  That list gets shuffled around
>> enough, and mmu_shrink() called often enough that no VMs get picked on
>> too unfairly.
>>
>> I'll go back and see if I can quantify this a bit, though.
>>      
> The shrink _query_ (mmu_shrink() with nr_to_scan=0) code is called
> really, really often.  Like 5,000-10,000 times a second during lots of
> VM pressure.  But, it's almost never called on to actually shrink
> anything.
>
> Over the 20 minutes or so that I tested, I saw about 700k calls to
> mmu_shrink().  But, only 6 (yes, six) calls that had a non-zero
> nr_to_scan.  I'm not sure whether this is because of the .seeks argument
> to the shrinker or what, but the slab code stays far, far away from
> making mmu_shrink() do much real work.
>    

Certainly seems so from vmscan.c.

> That changes a few things.  I bet all the contention we were seeing was
> just from nr_to_scan=0 calls and not from actual shrink operations.
> Perhaps we should just stop this set after patch 4.
>    

At the very least, we should re-measure things.

Even afterwards, we might reduce .seeks in return for making the 
shrinker cleverer and eliminating the cap on mmu pages.  But I'm afraid 
the interface between vmscan and the shrinker is too simplistic; 
sometimes we can trim pages without much cost (unreferenced pages), but 
some pages are really critical for performance.  To see real 
improvement, we might need our own scanner.

-- 
error compiling committee.c: too many arguments to function

