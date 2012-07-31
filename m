Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2GaCHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 22:07:14 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60529 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2GaCHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 22:07:11 -0400
Date: Mon, 30 Jul 2012 19:06:21 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Sasha Levin <levinsasha928@gmail.com>, gregkh@linuxfoundation.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: /dev/kmem BUG on mmap
In-Reply-To: <20120730094308.GA7913@cmpxchg.org>
Message-ID: <alpine.LSU.2.00.1207301830590.3883@eggly.anvils>
References: <5015B913.5050309@gmail.com> <20120730094308.GA7913@cmpxchg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2012, Johannes Weiner wrote:
> On Mon, Jul 30, 2012 at 12:28:35AM +0200, Sasha Levin wrote:
> > Hi all,
> > 
> > I was poking around /dev/kmem related code, and noticed the following in mmap_kmem():
> > 
> >         /* Turn a kernel-virtual address into a physical page frame */
> >         pfn = __pa((u64)vma->vm_pgoff << PAGE_SHIFT) >> PAGE_SHIFT;
> > 
> > Which looked odd since vm_pgoff is the offset into the mapping, so
> > I'd assume that PAGE_OFFSET should be added to it as well, otherwise
> > we get an invalid address.
> 
> It's supposed to be used with kernel offsets in the first place,
> i.e. vma->vm_pgoff << PAGE_SHIFT should actually be a kernel virtual
> address.  See 6d3154c Revert "[PATCH] Fix up mmap_kmem".

Yes.  Some would say we should add a comment; but already it has one.

> 
> > I tested it by writing something like this:
> > 
> > 	int main(void)
> > 	{
> > 	        int fd;
> > 	        void *addr;
> > 	
> > 	        fd = open("/dev/kmem", O_RDONLY);
> > 	        addr = mmap(NULL, 4096, PROT_READ, MAP_PRIVATE, fd, 4096);
> > 	
> > 	        return 0;
> > 	}
> > 
> > Which indeed triggered a VM_BUG:
> > 
> > [   32.285431] kernel BUG at arch/x86/mm/physaddr.c:18!
> 
> x86's debug-version of __pa() triggers that bug.  I'm reluctant to add
> a whole lot of error checking to this interface, given that you should
> already know what you are doing.  OTOH, crashing like this is not very
> nice, either.
> 
> Is there a portable way to check if an address is a kernel virtual
> one?  It looks like comparing to PAGE_OFFSET would work on most archs,
> but not necessarily on powerpc for example.

I didn't look into powerpc; even on x86, comparing with PAGE_OFFSET
first would filter out the most likely crashes, but leave it crashing
on >= KERNEL_IMAGE_SIZE and !phys_addr_valid().

I think that's why it's so long said just __pa(), because different
architectures would not agree on the appropriate prior validation.
Debug crashes added at as low level as __pa() come as a surprise.

Thank you to Sasha for bringing this to our attention, and if there
were an obvious right answer, I'd definitely prefer to fail than crash
an out-of-range mmap arg here, even if only CAP_SYS_RAWIO gets this far.

You could say that the right answer is to add the __pa_nodebug()
to every architecture (or in asm-generic), and then use that here;
but is it worth bothering?

Once I read the DEBUG_VIRTUAL Kconfig entry:
	Enable some costly sanity checks in virtual to page code.
	This can catch mistakes with virt_to_page() and friends.
	If unsure, say N.
I'm inclined to think that few would turn DEBUG_VIRTUAL on, and
those who do so might as well welcome this crash as the costly
way in which it catches their mistakes - with apology to Sasha.

Not an answer I'm especially proud of, but doubt it's worth more.

Hugh
