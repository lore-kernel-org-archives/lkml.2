Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab0ETPrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:47:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0ETPrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:47:23 -0400
Message-ID: <4BF55963.30503@redhat.com>
Date: Thu, 20 May 2010 18:46:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
 ring itself
References: <20100505205814.GA7090@redhat.com> <201005201431.51142.rusty@rustcorp.com.au> <4BF4DE28.2080103@redhat.com> <201005210004.29670.rusty@rustcorp.com.au>
In-Reply-To: <201005210004.29670.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 05:34 PM, Rusty Russell wrote:
>
>> Have just one ring, no indexes.  The producer places descriptors into
>> the ring and updates the head,  The consumer copies out descriptors to
>> be processed and copies back in completed descriptors.  Chaining is
>> always linear.  The descriptors contain a tag that allow the producer to
>> identify the completion.
>>      
> This could definitely work.  The original reason for the page boundaries
> was for untrusted inter-guest communication: with appropriate page protections
> they could see each other's rings and a simply inter-guest copy hypercall
> could verify that the other guest really exposed that data via virtio ring.
>
> But, cute as that is, we never did that.  And it's not clear that it wins
> much over simply having the hypervisor read both rings directly.
>    

AFAICS having separate avail_ring/used_ring/desc_pool is orthogonal to 
this cuteness.

>>> Can we do better?  The obvious idea is to try to get rid of last_used and
>>> used, and use the ring itself.  We would use an invalid entry to mark the
>>> head of the ring.
>>>        
>> Interesting!  So a peer will read until it hits a wall.  But how to
>> update the wall atomically?
>>
>> Maybe we can have a flag in the descriptor indicate headness or
>> tailness.  Update looks ugly though: write descriptor with head flag,
>> write next descriptor with head flag, remove flag from previous descriptor.
>>      
> I was thinking a separate magic "invalid" entry.  To publish an 3 descriptor
> chain, you would write descriptors 2 and 3, write an invalid entry at 4,
> barrier, write entry 1.  It is a bit ugly, yes, but not terrible.
>    

Worth exploring. This amortizes the indexes into the ring, a good thing.

Another thing we can do is place the tail a half ring away from the head 
(and limit ring utilization to 50%), reducing bounces on short kicks.  
Or equivalently have an avail ring and used ring, but both containing 
tagged descriptors instead of pointers to descriptors.

> I think that a simple simulator for this is worth writing, which tracks
> cacheline moves under various fullness scenarios...
>    

Yup.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

