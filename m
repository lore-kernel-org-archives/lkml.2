Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0EWP43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 11:56:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0EWP41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 11:56:27 -0400
Date: Sun, 23 May 2010 18:51:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
	ring itself
Message-ID: <20100523155132.GA14733@redhat.com>
References: <20100505205814.GA7090@redhat.com> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au> <201005201438.17010.rusty@rustcorp.com.au> <20100523153134.GA14646@redhat.com> <4BF94CAD.5010504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF94CAD.5010504@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 06:41:33PM +0300, Avi Kivity wrote:
> On 05/23/2010 06:31 PM, Michael S. Tsirkin wrote:
>> On Thu, May 20, 2010 at 02:38:16PM +0930, Rusty Russell wrote:
>>    
>>> On Thu, 20 May 2010 02:31:50 pm Rusty Russell wrote:
>>>      
>>>> On Wed, 19 May 2010 05:36:42 pm Avi Kivity wrote:
>>>>        
>>>>>> Note that this is a exclusive->shared->exclusive bounce only, too.
>>>>>>
>>>>>>            
>>>>> A bounce is a bounce.
>>>>>          
>>>> I tried to measure this to show that you were wrong, but I was only able
>>>> to show that you're right.  How annoying.  Test code below.
>>>>        
>>> This time for sure!
>>>      
>>
>> What do you see?
>> On my laptop:
>> 	[mst@tuck testring]$ ./rusty1 share 0 1
>> 	CPU 1: share cacheline: 2820410 usec
>> 	CPU 0: share cacheline: 2823441 usec
>> 	[mst@tuck testring]$ ./rusty1 unshare 0 1
>> 	CPU 0: unshare cacheline: 2783014 usec
>> 	CPU 1: unshare cacheline: 2782951 usec
>> 	[mst@tuck testring]$ ./rusty1 lockshare 0 1
>> 	CPU 1: lockshare cacheline: 1888495 usec
>> 	CPU 0: lockshare cacheline: 1888544 usec
>> 	[mst@tuck testring]$ ./rusty1 lockunshare 0 1
>> 	CPU 0: lockunshare cacheline: 1889854 usec
>> 	CPU 1: lockunshare cacheline: 1889804 usec
>>    
>
> Ugh, can the timing be normalized per operation?  This is unreadable.
>
>> So locked version seems to be faster than unlocked,
>> and share/unshare not to matter?
>>    
>
> May be due to the processor using the LOCK operation as a hint to  
> reserve the cacheline for a bit.

Maybe we should use atomics on index then?

>> same on a workstation:
>> [root@qus19 ~]# ./rusty1 unshare 0 1
>> CPU 0: unshare cacheline: 6037002 usec
>> CPU 1: unshare cacheline: 6036977 usec
>> [root@qus19 ~]# ./rusty1 lockunshare 0 1
>> CPU 1: lockunshare cacheline: 5734362 usec
>> CPU 0: lockunshare cacheline: 5734389 usec
>> [root@qus19 ~]# ./rusty1 lockshare 0 1
>> CPU 1: lockshare cacheline: 5733537 usec
>> CPU 0: lockshare cacheline: 5733564 usec
>>
>> using another pair of CPUs gives a more drastic
>> results:
>>
>> [root@qus19 ~]# ./rusty1 lockshare 0 2
>> CPU 2: lockshare cacheline: 4226990 usec
>> CPU 0: lockshare cacheline: 4227038 usec
>> [root@qus19 ~]# ./rusty1 lockunshare 0 2
>> CPU 0: lockunshare cacheline: 4226707 usec
>> CPU 2: lockunshare cacheline: 4226662 usec
>> [root@qus19 ~]# ./rusty1 unshare 0 2
>> CPU 0: unshare cacheline: 14815048 usec
>> CPU 2: unshare cacheline: 14815006 usec
>>
>>    
>
> That's expected.  Hyperthread will be fastest (shared L1), shared L2/L3  
> will be slower, cross-socket will suck.

OK, after adding mb in code patch will be sent separately,
the test works for my workstation. locked is still fastest,
unshared sometimes shows wins and sometimes loses over shared.

[root@qus19 ~]# ./cachebounce share 0 1
CPU 0: share cacheline: 6638521 usec
CPU 1: share cacheline: 6638478 usec
[root@qus19 ~]# ./cachebounce unshare 0 1
CPU 0: unshare cacheline: 6037415 usec
CPU 1: unshare cacheline: 6037374 usec
[root@qus19 ~]# ./cachebounce lockshare 0 1
CPU 0: lockshare cacheline: 5734017 usec
CPU 1: lockshare cacheline: 5733978 usec
[root@qus19 ~]# ./cachebounce lockunshare 0 1
CPU 1: lockunshare cacheline: 5733260 usec
CPU 0: lockunshare cacheline: 5733307 usec
[root@qus19 ~]# ./cachebounce share 0 2
CPU 0: share cacheline: 14529198 usec
CPU 2: share cacheline: 14529156 usec
[root@qus19 ~]# ./cachebounce unshare 0 2
CPU 2: unshare cacheline: 14815328 usec
CPU 0: unshare cacheline: 14815374 usec
[root@qus19 ~]# ./cachebounce lockshare 0 2
CPU 0: lockshare cacheline: 4226878 usec
CPU 2: lockshare cacheline: 4226842 usec
[root@qus19 ~]# ./cachebounce locknushare 0 2
cachebounce: Usage: cachebounce share|unshare|lockshare|lockunshare <cpu0> <cpu1>
[root@qus19 ~]# ./cachebounce lockunshare 0 2
CPU 0: lockunshare cacheline: 4227432 usec
CPU 2: lockunshare cacheline: 4227375 usec

