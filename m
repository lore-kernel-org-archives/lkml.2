Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0DWOyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab0DWOyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:54:14 -0400
Message-ID: <4BD1B427.9010905@redhat.com>
Date: Fri, 23 Apr 2010 17:52:23 +0300
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
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default 4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
In-Reply-To: <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 05:43 PM, Dan Magenheimer wrote:
>>
>> Perhaps I misunderstood.  Isn't frontswap in front of the normal swap
>> device?  So we do have double swapping, first to frontswap (which is in
>> memory, yes, but still a nonzero cost), then the normal swap device.
>> The io subsystem is loaded with writes; you only save the reads.
>> Better to swap to the hypervisor, and make it responsible for
>> committing
>> to disk on overcommit or keeping in RAM when memory is available.  This
>> way we avoid the write to disk if memory is in fact available (or at
>> least defer it until later).  This way you avoid both reads and writes
>> if memory is available.
>>      
> Each page is either in frontswap OR on the normal swap device,
> never both.  So, yes, both reads and writes are avoided if memory
> is available and there is no write issued to the io subsystem if
> memory is available.  The is_memory_available decision is determined
> by the hypervisor dynamically for each page when the guest attempts
> a "frontswap_put".  So, yes, you are indeed "swapping to the
> hypervisor" but, at least in the case of Xen, the hypervisor
> never swaps any memory to disk so there is never double swapping.
>    

I see.  So why not implement this as an ordinary swap device, with a 
higher priority than the disk device?  this way we reuse an API and keep 
things asynchronous, instead of introducing a special purpose API.

Doesn't this commit the hypervisor to retain this memory?  If so, isn't 
it simpler to give the page to the guest (so now it doesn't need to swap 
at all)?

What about live migration?  do you live migrate frontswap pages?

>>> If I understand correctly, SSDs work much more efficiently when
>>> writing 64KB blocks.  So much more efficiently in fact that waiting
>>> to collect 16 4KB pages (by first copying them to fill a 64KB buffer)
>>> will be faster than page-at-a-time DMA'ing them.  If so, the
>>> frontswap interface, backed by an asynchronous "buffering layer"
>>> which collects 16 pages before writing to the SSD, may work
>>> very nicely.  Again this is still just speculation... I was
>>> only pointing out that zero-copy DMA may not always be the best
>>> solution.
>>>        
>> The guest can easily (and should) issue 64k dmas using scatter/gather.
>> No need for copying.
>>      
> In many cases, this is true.  For the swap subsystem, it may not always
> be true, though I see recent signs that it may be headed in that
> direction.

I think it will be true in an overwhelming number of cases.  Flash is 
new enough that most devices support scatter/gather.

> In any case, unless you see this SSD discussion as
> critical to the proposed acceptance of the frontswap patchset,
> let's table it until there's some prototyping done.
>    

It isn't particularly related.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

