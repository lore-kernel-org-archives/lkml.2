Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0EWPlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 11:41:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0EWPlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 11:41:44 -0400
Message-ID: <4BF94CAD.5010504@redhat.com>
Date: Sun, 23 May 2010 18:41:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
 ring itself
References: <20100505205814.GA7090@redhat.com> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au> <201005201438.17010.rusty@rustcorp.com.au> <20100523153134.GA14646@redhat.com>
In-Reply-To: <20100523153134.GA14646@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2010 06:31 PM, Michael S. Tsirkin wrote:
> On Thu, May 20, 2010 at 02:38:16PM +0930, Rusty Russell wrote:
>    
>> On Thu, 20 May 2010 02:31:50 pm Rusty Russell wrote:
>>      
>>> On Wed, 19 May 2010 05:36:42 pm Avi Kivity wrote:
>>>        
>>>>> Note that this is a exclusive->shared->exclusive bounce only, too.
>>>>>
>>>>>            
>>>> A bounce is a bounce.
>>>>          
>>> I tried to measure this to show that you were wrong, but I was only able
>>> to show that you're right.  How annoying.  Test code below.
>>>        
>> This time for sure!
>>      
>
> What do you see?
> On my laptop:
> 	[mst@tuck testring]$ ./rusty1 share 0 1
> 	CPU 1: share cacheline: 2820410 usec
> 	CPU 0: share cacheline: 2823441 usec
> 	[mst@tuck testring]$ ./rusty1 unshare 0 1
> 	CPU 0: unshare cacheline: 2783014 usec
> 	CPU 1: unshare cacheline: 2782951 usec
> 	[mst@tuck testring]$ ./rusty1 lockshare 0 1
> 	CPU 1: lockshare cacheline: 1888495 usec
> 	CPU 0: lockshare cacheline: 1888544 usec
> 	[mst@tuck testring]$ ./rusty1 lockunshare 0 1
> 	CPU 0: lockunshare cacheline: 1889854 usec
> 	CPU 1: lockunshare cacheline: 1889804 usec
>    

Ugh, can the timing be normalized per operation?  This is unreadable.

> So locked version seems to be faster than unlocked,
> and share/unshare not to matter?
>    

May be due to the processor using the LOCK operation as a hint to 
reserve the cacheline for a bit.

> same on a workstation:
> [root@qus19 ~]# ./rusty1 unshare 0 1
> CPU 0: unshare cacheline: 6037002 usec
> CPU 1: unshare cacheline: 6036977 usec
> [root@qus19 ~]# ./rusty1 lockunshare 0 1
> CPU 1: lockunshare cacheline: 5734362 usec
> CPU 0: lockunshare cacheline: 5734389 usec
> [root@qus19 ~]# ./rusty1 lockshare 0 1
> CPU 1: lockshare cacheline: 5733537 usec
> CPU 0: lockshare cacheline: 5733564 usec
>
> using another pair of CPUs gives a more drastic
> results:
>
> [root@qus19 ~]# ./rusty1 lockshare 0 2
> CPU 2: lockshare cacheline: 4226990 usec
> CPU 0: lockshare cacheline: 4227038 usec
> [root@qus19 ~]# ./rusty1 lockunshare 0 2
> CPU 0: lockunshare cacheline: 4226707 usec
> CPU 2: lockunshare cacheline: 4226662 usec
> [root@qus19 ~]# ./rusty1 unshare 0 2
> CPU 0: unshare cacheline: 14815048 usec
> CPU 2: unshare cacheline: 14815006 usec
>
>    

That's expected.  Hyperthread will be fastest (shared L1), shared L2/L3 
will be slower, cross-socket will suck.


-- 
error compiling committee.c: too many arguments to function

