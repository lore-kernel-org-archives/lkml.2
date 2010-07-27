Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0G0S4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:56:52 -0400
Received: from claw.goop.org ([74.207.240.146]:51722 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab0G0S4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:56:51 -0400
Message-ID: <4C4F2BF2.6010903@goop.org>
Date: Tue, 27 Jul 2010 11:56:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] vmap: add flag to allow lazy unmap to be disabled at
 runtime
References: <4C4DEF13.1030403@goop.org> <20100727082439.GB6332@amd>
In-Reply-To: <20100727082439.GB6332@amd>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/27/2010 01:24 AM, Nick Piggin wrote:
> On Mon, Jul 26, 2010 at 01:24:51PM -0700, Jeremy Fitzhardinge wrote:
>>
>> [ Nick, I forget if I sent this to you before.  Could you Ack it if it looks OK? Thanks, J ]
>>
>> Add a flag to force lazy_max_pages() to zero to prevent any outstanding
>> mapped pages.  We'll need this for Xen.
> You have sent this to me before, probably several times, and I always
> forget about it right as you send it again.
>
> It's no problem merging something like this for Xen, although as you
> know I would love to see an approach where Xen would benefit from
> delayed flushing as well :)

Yes indeed, that would be nice to get.  What it comes down to is we need 
to be able to flush any lazy vunmap aliases from within interrupt 
context, but the code really isn't set up to do that, and last time I 
tried to understand that code I couldn't see a straightforward way to 
make it work.   It would also be nice to have a way to shoot down the 
aliases for a specific page, assuming that's any more efficient than 
flushing everything.

I don't think anything has changed since we last talked about this.

> You will need to disable lazy flushing from the per-cpu allocator
> (vm_map_ram/vm_unmap_ram, which are used by XFS now). That's not
> tied to the lazy_max stuff (which it should be, arguably)

Ah, OK.  I should really add xfs to our roster of regularly tested 
filesystems, since it seems to play the most games.  Do you know of any 
other filesystems which do that kind of thing?

> That code basically allocates per-cpu chunks of va from the global
> allocator, uses them, then frees them back to the global allocator
> all without doing any TLB flushing.
>
> If you have to do global TLB flushing there, then it's probably not
> much value in per-cpu locking of the address allocator anyway, so
> you could just add a test for vmap_lazy_unmap in these branches:
>
>    if (likely(count<= VMAP_MAX_ALLOC)&&  !vmap_lazy_unmap)

We don't need to do any tlb flushing in these cases, because we're 
concerned about making sure we know what ptes a given page is mapped 
by.  The hypervisor will do any tlb flushing it requires to maintain its 
own invariants (so, for example, we can't use a stale tlb entry to keep 
accessing a page we've given back to Xen).

Thanks,
     J
