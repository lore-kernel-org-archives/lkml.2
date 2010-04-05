Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0DEX2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:28:47 -0400
Received: from claw.goop.org ([74.207.240.146]:43427 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab0DEX2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:28:39 -0400
Message-ID: <4BBA7226.9080508@goop.org>
Date: Mon, 05 Apr 2010 16:28:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com, Avi Kivity <avi@redhat.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>	<20100405142419.2c9bea3d.akpm@linux-foundation.org>	<4BBA5E1C.10706@goop.org> <20100405151720.8a6ac5e3.akpm@linux-foundation.org>
In-Reply-To: <20100405151720.8a6ac5e3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 03:17 PM, Andrew Morton wrote:
> On Mon, 05 Apr 2010 15:03:08 -0700
> Jeremy Fitzhardinge<jeremy@goop.org>  wrote:
>
>    
>> On 04/05/2010 02:24 PM, Andrew Morton wrote:
>>      
>>> I think I've forgotten what balloon drivers do.  Are they as nasty a
>>> hack as I remember believing them to be?
>>>
>>>        
>> (I haven't looked at Dmitry's patch yet, so this is from the Xen
>> perspective.)
>>
>> In the simplest form, they just look like a driver which allocates a
>> pile of pages, and the underlying memory gets returned to the
>> hypervisor.  When you want the memory back, it reattaches memory to the
>> pageframes and releases the memory back to the kernel.  This allows a
>> virtual machine to shrink with respect to its original size.
>>
>> Going the other way - expanding beyond the memory allocation - is a bit
>> trickier because you need to get some new page structures from
>> somewhere.   We don't do this in Xen yet, but I've done some experiments
>> with hotplug memory to implement this.  Or a simpler approach is to fake
>> up some reserved E820 ranges to grow into.
>>
>>      
> Lots of stuff for Dmitry to add to his changelog ;)
>
>    
>>> A summary of what this code sets out to do, and how it does it would be
>>> useful.
>>>
>>> Also please explain the applicability of this driver.  Will xen use it?
>>> kvm?  Out-of-tree code?
>>>
>>>        
>> The basic idea of the driver is to allow a guest system to give up
>> memory it isn't using so it can be reused by other virtual machines (or
>> the host itself).
>>      
> So...  does this differ in any fundamental way from what hibernation
> does, via shrink_all_memory()?
>    

Note that we're using shrink and grow in opposite senses.  
shrink_all_memory() is trying to free as much kernel memory as possible, 
which to the virtual machine's host looks like the guest is growing 
(since it has claimed more memory for its own use).  A balloon "shrink" 
appears to Linux as allocated memory (ie, locking down memory within 
Linux to make it available to the rest of system).

The fact that shrink_all_memory() has much deeper insight into the 
current state of the vm subsystem is interesting; it has much more to 
work with than a simple alloc/free page.  Does it actively try to 
reclaim cold, unlikely to be used stuff, first?  It appears it does to 
my mm/ naive eye.

I guess a way to use it in the short term is to have a loop of the form:

	while (guest_size>  target) {
		shrink_all_memory(guest_size - target);		/* force pages to be free */
		while (p = alloc_page(GFP_NORETRY))		/* vacuum up pages */
			release_page_to_hypervisor(p);
		/* twiddle thumbs */
	}

...assuming the allocation would tend to pick up the pages that 
shrink_all_memory just freed.

Or ideally, have a form of shrink_all_memory() which causes pages to 
become unused, but rather than freeing them returns them to the caller.

And is there some way to get the vm subsystem to provide backpressure: 
"I'm getting desperately short of memory!"?  Experience has shown that 
administrators often accidentally over-shrink their domains and 
effectively kill them.  Sometimes due to bad UI - entering the wrong 
units - but also because they just don't know what the actual memory 
demands are.  Or they change over time.

Thanks,
     J
