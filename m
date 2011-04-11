Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1DKO4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:56:31 -0400
Received: from mail201c2.megamailservers.com ([69.49.111.102]:43074 "EHLO
	mail201c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956Ab1DKO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:56:30 -0400
X-Authenticated-User: daniel.gaisler.com
Message-ID: <4DA31603.6070308@gaisler.com>
Date: Mon, 11 Apr 2011 16:53:55 +0200
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Kristoffer Glembo <kristoffer@gaisler.com>
Subject: Re: [PATCH 1/4] PCI: refactor io size calculation code
References: <4DA2FFB6.3040209@gaisler.com> <BANLkTikqB2tr-jNTaqVtTpBkH5O1iYQS-Q@mail.gmail.com>
In-Reply-To: <BANLkTikqB2tr-jNTaqVtTpBkH5O1iYQS-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=Ma2F9VxktdrohpwE1Ldo3j5zboDzDSax3kyf6Hawm04= c=1 sm=1
		a=pl2ZPvC6udcA:10 a=liV55vvCHxUA:10 a=U62ajLuCel8A:10 a=8nJEP1OIZ-IA:10
		a=jXKJviUpWSOlMmIvGrHOfw==:17 a=ebG-ZW-8AAAA:8 a=7NxiOfhJNlJqVJIRXEAA:9
		a=_TAhauMUqd7s4p3usnQA:7 a=wPNLvfGTeEIA:10 a=cCYF7-FHeg4A:10
		a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

>On Mon, Apr 11, 2011 at 6:18 AM, Daniel Hellstrom <daniel@gaisler.com> wrote:
>  
>
>>In commit 13583b16592a ("PCI: refactor io size calculation code"):
>>    
>>
>>>refactor  code  that  calculates  the  io  size in pbus_size_io()
>>>and pbus_mem_io() into separate functions.
>>>
>>>Signed-off-by: Ram Pai <linuxram@xxxxxxxxxx>
>>>---
>>>drivers/pci/setup-bus.c |   66
>>>++++++++++++++++++++++++++++++-----------------
>>>1 files changed, 42 insertions(+), 24 deletions(-)
>>>
>>>diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>>>index 66cb8f4..2121215 100644
>>>--- a/drivers/pci/setup-bus.c
>>>+++ b/drivers/pci/setup-bus.c
>>>@@ -404,6 +404,43 @@ static struct resource *find_free_bus_resource(struct
>>>pci_bus *bus, unsigned lon
>>>       return NULL;
>>>}
>>>
>>>      
>>>
>>...
>>
>>    
>>
>>>+
>>>+static resource_size_t calculate_memsize(resource_size_t size,
>>>+               resource_size_t min_size,
>>>+               resource_size_t size1,
>>>+               resource_size_t old_size,
>>>+               resource_size_t align)
>>>+{
>>>+       if (size < min_size)
>>>+               size = min_size;
>>>+       if (old_size == 1 )
>>>+               old_size = 0;
>>>+       if (size < old_size)
>>>+               size = old_size;
>>>+       size = ALIGN(size + size1, align);
>>>+       return size;
>>>+}
>>>+
>>>/* Sizing the IO windows of the PCI-PCI bridge is trivial,
>>>  since these windows have 4K granularity and the IO ranges
>>>  of non-bridge PCI devices are limited to 256 bytes.
>>>
>>>
>>>      
>>>
>>...
>>
>>    
>>
>>>@@ -516,14 +542,6 @@ static int pbus_size_mem(struct pci_bus *bus,
>>>unsigned long mask,
>>>                       mem64_mask &= r->flags & IORESOURCE_MEM_64;
>>>               }
>>>       }
>>>-       if (size < min_size)
>>>-               size = min_size;
>>>-       old_size = resource_size(b_res);
>>>-       if (old_size == 1)
>>>-               old_size = 0;
>>>-       if (size < old_size)
>>>-               size = old_size;
>>>-
>>>       align = 0;
>>>       min_align = 0;
>>>       for (order = 0; order <= max_order; order++) {
>>>@@ -537,7 +555,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned
>>>long mask,
>>>                       min_align = align1 >> 1;
>>>               align += aligns[order];
>>>       }
>>>-       size = ALIGN(size, min_align);
>>>+       size = calculate_memsize(size, min_size, 0, resource_size(b_res),
>>>align);
>>>
>>>      
>>>
>>On my SPARC32/LEON4 PCI system I get overlapped areas, double mapped
>>resources. Some BARs on PCIBUS0 are in the same non-prefetchable memory
>>range as the secondary bus PCIBUS1. Changing align to min_align in the above
>>call to calculate_memsize() fixes the problem, and the memory allocation is
>>the same as with 2.6.36.4 kernel.
>>
>>I belive this is just a typo.
>>    
>>
>
>It does seem that way. The original code used 'min_align' and 'align'
>itself is meaningless in that place.
>  
>
Agree.

>Can you confirm that the patch you talk about as fixing things is the attached?
>
>                  Linus
>  
>
Yes, the below patch works on the system that triggered the problem 
before. The last min_align was added in a later patch, I missed it 
initially.

Thanks,
Daniel

>------------------------------------------------------------------------
>
> drivers/pci/setup-bus.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>index 89d0a6a88df7..ebf51ad1b714 100644
>--- a/drivers/pci/setup-bus.c
>+++ b/drivers/pci/setup-bus.c
>@@ -676,10 +676,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
> 			min_align = align1 >> 1;
> 		align += aligns[order];
> 	}
>-	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), align);
>+	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), min_align);
> 	size1 = !add_size ? size :
> 		calculate_memsize(size, min_size+add_size, 0,
>-				resource_size(b_res), align);
>+				resource_size(b_res), min_align);
> 	if (!size0 && !size1) {
> 		if (b_res->start || b_res->end)
> 			dev_info(&bus->self->dev, "disabling bridge window "
>  
>

