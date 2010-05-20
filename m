Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0ETHBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab0ETHBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:01:42 -0400
Message-ID: <4BF4DE28.2080103@redhat.com>
Date: Thu, 20 May 2010 10:00:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
 ring itself
References: <20100505205814.GA7090@redhat.com> <201005191709.16401.rusty@rustcorp.com.au> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au>
In-Reply-To: <201005201431.51142.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 08:01 AM, Rusty Russell wrote:
>
>> A device with out of order
>> completion (like virtio-blk) will quickly randomize the unused
>> descriptor indexes, so every descriptor fetch will require a bounce.
>>
>> In contrast, if the rings hold the descriptors themselves instead of
>> pointers, we bounce (sizeof(descriptor)/cache_line_size) cache lines for
>> every descriptor, amortized.
>>      
> We already have indirect, this would be a logical next step.  So let's
> think about it. The avail ring would contain 64 bit values, the used ring
> would contain indexes into the avail ring.
>    

Have just one ring, no indexes.  The producer places descriptors into 
the ring and updates the head,  The consumer copies out descriptors to 
be processed and copies back in completed descriptors.  Chaining is 
always linear.  The descriptors contain a tag that allow the producer to 
identify the completion.

Indirect only pays when there are enough descriptors in it to fill a 
couple of cache lines.  Otherwise it's an extra bounce.

We will always bounce here, that what happens when transferring data.  
The question is whether how many cache lines per descriptor.  A pointer 
adds 1 bounce, linear descriptors cost 1/4 bounce, chained descriptors 
cost a bounce.  So best is one ring of linearly chained descriptors.  
Indirect works when you have large requests (like block).

> So client writes descriptor page and adds to avail ring, then writes to
> index.
> Server reads index, avail ring, descriptor page (3).  Writes used
> entry (1).  Updates last_used (1).  Client reads used (1), derefs avail (1),
> updates last_used (1), cleans descriptor page (1).
>
> That's 9 cacheline transfers, worst case.  Best case of a half-full ring
> in steady state, assuming 128-byte cache lines, the avail ring costs are
> 1/16, the used entry is 1/64.  This drops it to 6 and 9/64 transfers.
>    

Cache lines are 64 bytes these days.

With a single ring, client writes descriptors (ceil(N/4)), updates head 
(1).  Server reads head (1) copies out descriptors (ceil(N/4)), issues 
requests, copies back completions ((ceil(N/4)), updates tail (1).  
Client reads back tail and descriptors (1 + ceil(N/4))

Worst case: 4 + 4 * ceil(N/4).  Best case I think this drops by half.



> (Note, the current scheme adds 2 more cacheline transfers, for the descriptor
> table, worst case.

2 bounces per descriptor due to random access.

>    Assuming indirect, we get 2/8 xfer best case.  Either way,
> it's not the main source of cacheline xfers).
>    

Indirect adds a double bounce to get to the descriptor table, but any 
descriptors there are accessed linearly.  It's only good when you have 
large chains.

> Can we do better?  The obvious idea is to try to get rid of last_used and
> used, and use the ring itself.  We would use an invalid entry to mark the
> head of the ring.
>    

Interesting!  So a peer will read until it hits a wall.  But how to 
update the wall atomically?

Maybe we can have a flag in the descriptor indicate headness or 
tailness.  Update looks ugly though: write descriptor with head flag, 
write next descriptor with head flag, remove flag from previous descriptor.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

