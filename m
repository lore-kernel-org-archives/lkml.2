Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0DYMMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 08:12:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0DYMMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 08:12:07 -0400
Message-ID: <4BD43182.1040508@redhat.com>
Date: Sun, 25 Apr 2010 15:11:46 +0300
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
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com> <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default 4BD336CF.1000103@redhat.com> <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default>
In-Reply-To: <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 03:30 AM, Dan Magenheimer wrote:
>>>> I see.  So why not implement this as an ordinary swap device, with a
>>>> higher priority than the disk device?  this way we reuse an API and
>>>> keep
>>>> things asynchronous, instead of introducing a special purpose API.
>>>>
>>>>          
>>> Because the swapping API doesn't adapt well to dynamic changes in
>>> the size and availability of the underlying "swap" device, which
>>> is very useful for swap to (bare-metal) hypervisor.
>>>        
>> Can we extend it?  Adding new APIs is easy, but harder to maintain in
>> the long term.
>>      
> Umm... I think the difference between a "new" API and extending
> an existing one here is a choice of semantics.  As designed, frontswap
> is an extremely simple, only-very-slightly-intrusive set of hooks that
> allows swap pages to, under some conditions, go to pseudo-RAM instead
> of an asynchronous disk-like device.  It works today with at least
> one "backend" (Xen tmem), is shipping today in real distros, and is
> extremely easy to enable/disable via CONFIG or module... meaning
> no impact on anyone other than those who choose to benefit from it.
>
> "Extending" the existing swap API, which has largely been untouched for
> many years, seems like a significantly more complex and error-prone
> undertaking that will affect nearly all Linux users with a likely long
> bug tail.  And, by the way, there is no existence proof that it
> will be useful.
>
> Seems like a no-brainer to me.
>    

My issue is with the API's synchronous nature.  Both RAM and more exotic 
memories can be used with DMA instead of copying.  A synchronous 
interface gives this up.

>> Ok.  For non traditional RAM uses I really think an async API is
>> needed.  If the API is backed by a cpu synchronous operation is fine,
>> but once it isn't RAM, it can be all kinds of interesting things.
>>      
> Well, we shall see.  It may also be the case that the existing
> asynchronous swap API will work fine for some non traditional RAM;
> and it may also be the case that frontswap works fine for some
> non traditional RAM.  I agree there is fertile ground for exploration
> here.  But let's not allow our speculation on what may or may
> not work in the future halt forward progress of something that works
> today.
>    

Let's not allow the urge to merge prevent us from doing the right thing.

>
>    
>> Note that even if you do give the page to the guest, you still control
>> how it can access it, through the page tables.  So for example you can
>> easily compress a guest's pages without telling it about it; whenever
>> it
>> touches them you decompress them on the fly.
>>      
> Yes, at a much larger more invasive cost to the kernel.  Frontswap
> and cleancache and tmem are all well-layered for a good reason.
>    

No need to change the kernel at all; the hypervisor controls the page 
tables.

>> Swap has no timing
>> constraints, it is asynchronous and usually to slow devices.
>>      
> What I was referring to is that the existing swap code DOES NOT
> always have the ability to collect N scattered pages before
> initiating an I/O write suitable for a device (such as an SSD)
> that is optimized for writing N pages at a time.  That is what
> I meant by a timing constraint.  See references to page_cluster
> in the swap code (and this is for contiguous pages, not scattered).
>    

I see.  Given that swap-to-flash will soon be way more common than 
frontswap, it needs to be solved (either in flash or in the swap code).

-- 
error compiling committee.c: too many arguments to function

