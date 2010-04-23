Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0DWN54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:57:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0DWN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:57:53 -0400
Message-ID: <4BD1A74A.2050003@redhat.com>
Date: Fri, 23 Apr 2010 16:57:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default 4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
In-Reply-To: <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 04:47 PM, Dan Magenheimer wrote:
>>>> Much easier to simulate an asynchronous API with a synchronous
>>>>          
>> backend.
>>      
>>>>          
>>> Indeed.  But an asynchronous API is not appropriate for frontswap
>>> (or cleancache).  The reason the hooks are so simple is because they
>>> are assumed to be synchronous so that the page can be immediately
>>> freed/reused.
>>>
>>>        
>> Swapping is inherently asynchronous, so we'll have to wait for that to
>> complete anyway (as frontswap does not guarantee swap-in will succeed).
>> I don't doubt it makes things simpler, but also less flexible and
>> useful.
>>
>> Something else that bothers me is the double swapping.  Sure we're
>> making swapin faster, but we we're still loading the io subsystem with
>> writes.  Much better to make swap-to-ram authoritative (and have the
>> hypervisor swap it to disk if it needs the memory).
>>      
> Hmmm.... I now realize you are thinking of applying frontswap to
> a hosted hypervisor (e.g. KVM). Using frontswap with a bare-metal
> hypervisor (e.g. Xen) works fully synchronously, guarantees swap-in
> will succeed, never double-swaps, and doesn't load the io subsystem
> with writes.  This all works very nicely today with a fully
> synchronous "backend" (e.g. with tmem in Xen 4.0).
>    

Perhaps I misunderstood.  Isn't frontswap in front of the normal swap 
device?  So we do have double swapping, first to frontswap (which is in 
memory, yes, but still a nonzero cost), then the normal swap device.  
The io subsystem is loaded with writes; you only save the reads.

Better to swap to the hypervisor, and make it responsible for committing 
to disk on overcommit or keeping in RAM when memory is available.  This 
way we avoid the write to disk if memory is in fact available (or at 
least defer it until later).  This way you avoid both reads and writes 
if memory is available.

>>>> Well, copying memory so you can use a zero-copy dma engine is
>>>> counterproductive.
>>>>
>>>>          
>>> Yes, but for something like an SSD where copying can be used to
>>> build up a full 64K write, the cost of copying memory may not be
>>> counterproductive.
>>>        
>> I don't understand.  Please clarify.
>>      
> If I understand correctly, SSDs work much more efficiently when
> writing 64KB blocks.  So much more efficiently in fact that waiting
> to collect 16 4KB pages (by first copying them to fill a 64KB buffer)
> will be faster than page-at-a-time DMA'ing them.  If so, the
> frontswap interface, backed by an asynchronous "buffering layer"
> which collects 16 pages before writing to the SSD, may work
> very nicely.  Again this is still just speculation... I was
> only pointing out that zero-copy DMA may not always be the best
> solution.
>    

The guest can easily (and should) issue 64k dmas using scatter/gather.  
No need for copying.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

