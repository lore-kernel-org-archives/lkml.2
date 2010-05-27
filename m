Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab0E0Nag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:30:36 -0400
Received: from king.tilera.com ([72.1.168.226]:36084 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab0E0Nae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:30:34 -0400
Message-ID: <4BFE73DF.5090107@tilera.com>
Date: Thu, 27 May 2010 09:30:07 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005252345.15685.arnd@arndb.de> <4BFDC3D1.40708@tilera.com> <201005271041.30519.arnd@arndb.de>
In-Reply-To: <201005271041.30519.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2010 13:30:31.0947 (UTC) FILETIME=[C7A3B5B0:01CAFDA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/2010 4:41 AM, Arnd Bergmann wrote:
> On Thursday 27 May 2010, Chris Metcalf wrote:
>   
>> The thing is, the COMPAT layer on TILE-Gx is actually not providing
>> TILEPro compatibility, since the architectures are too different --
>> conceptually similar but with different opcode numbering, etc.  Instead
>> what it's doing is providing a 32-bit pointer ABI, to help porting
>> crufty old code (this is in fact the primary customer driver), or to
>> allow more compact representations of pointer-heavy data.
>>     
> [...]
> Are you able to build 32 bit kernels for TILE-Gx as well? It's
> probably something you never really want to do for performance
> reasons, but I guess you could use that to verify that the
> ABI is really compatible.
>   

No, we haven't tried to do this.  I suppose it would be possible to port
the TILE-Gx kernel to use -m32 mode and HIGHMEM, but I think it would
just uglify the code.  :-)


> What I meant about compat_sys_sendfile is that you only define it if
> the 32 bit ABI contains a reference to sys_sendfile in the first
> place. With asm-generic/unistd.h, 32 bit uses always uses the sys_sendfile64
> kernel interface, while for 64 bit the two are identical, so we take
> the regular sys_sendfile.
>   

Right, true enough.  I'm still building internally with
__ARCH_WANT_SYSCALL_OFF_T, so some extra compat functions are still
needed for linking the kernel.  I'll try to remember to unifdef them out
of the code I submit back to the community.

  

>> The notion of using a file descriptor as the "rights" object is pretty
>> central, so I think a character device will work out well.
>>     
> ok, I see. Now you could easily do this with system calls as well:
> Instead of the initial ioctl that associates the file descriptor
> with a rectangle, you can have a syscall that creates a rectangle
> and a file descriptor (using anon_inode_getfd) associated with it,
> and returns the fd to user space. This is similar to what we
> do for other system call interfaces that operate on their own fds.
>   

Yes, good point.  I'll be holding back this code from the initial patch,
so I can think about it some more.  I'm still predisposed to avoid
adding system calls in general, though.

> On a chardev, a binary interface seems more appropriate than
> an text based one anyway, so you could add another ioctl for this.ok. Then please just use .unlocked_ioctl in new drivers.
>   

OK, I bombed all our existing drivers to use .unlocked_ioctl.  It's
convenient that unlocked_ioctl now has the same signature as compat_ioctl.

> Ok. Do you use huge pages for backing the linear kernel mapping?
> Normally device drivers get huge pages for free in kmalloc and
> get_free_pages because all the memory is mapped using the largest
> page size anyway.
>   

We do now.  At the time we (semi-speculatively) wrote the hugevmap code,
we didn't.  I won't return this code to the community until we actually
use it, in any case.

>>> +EXPORT_SYMBOL(inb);
>>>   
>>> If you just remove these definitions, you get a link error for any
>>> driver that tries to use these, which is probably more helpful than
>>> the panic.
>>>
>>> OTOH, are you sure that you can't just map the PIO calls to mmio functions
>>> like readb plus some fixed offset? On most non-x86 architectures, the PIO
>>> area of the PCI bus is just mapped to a memory range somewhere.
>>>   
>>>       
>> I'll try to remove them and see if anything falls over.  We don't have
>> any memory-mapped addresses in the 32-bit architecture, though that
>> changes with the 64-bit architecture, which introduces IO mappings.  For
>> PCI we actually have to do a hypervisor transaction for reads or writes.
>>     
> Ok, then I assume that PIO would also be a hypervisor call, right?
> If you don't have MMIO on 32 bit, you might want to not define either
> PIO (inb, ...) no MMIO (readb, ...) calls there and disable
> CONFIG_HAVE_MMIO in Kconfig.
>   

We don't define CONFIG_HAVE_MMIO, but drivers certainly seem to use
ioread/iowrite methods as well as inb/outb without guarding them with
any particular tests, so we have to provide definitions of some kind for
all of them.  I'll confer with our PCI developer to see if we can clean
up the set of definitions in io.h.

>>> Does this need to be a system call? I thought we already had
>>> other architectures without floating point exceptions in hardware
>>> that don't need this.
>>>   
>>>       
>> Hmm, I didn't know about that.  Any information would be appreciated.  I
>> guess you could synthesize something that looked like a signal purely in
>> user-space?  But how would debuggers trap it?  I'm not sure how it would
>> work without a system call.
>>     
> I think the C99 standard allows you to not implement SIGFPE at all but
> instead rely on applications doing fetestexcept() etc.
>   

We use this not for the floating-point operations, but for integer
divide-by-zero.  In principle we could use it for floating-point too,
but we currently don't, since generally folks don't expect it there.

>>>> diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
>>>> [...]
>>>> +ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count)
>>>> +{
>>>> +    return sys_readahead(fd, ((loff_t)offset_hi << 32) | offset_lo, count);
>>>> +}
>>>> +
>>>>     
>>>>         
>>> These seem to belong with the other similar functions in compat.c
>>>   
>>>       
>> Except they're also used by the 32-bit platform where there is no compat
>> mode (the compat code DOES use them too, it's true).
>>     
> I see. AFAICT, all other architectures don't need the wrapper in
> the 32 bit native case because they define the syscall calling
> conventions in libc such that they match what the kernel
> expects for a 64 bit argument (typically split in two subsequent
> argument slots). Would that work for you as well?
>   

Yes, we could override this in libc.  My assumption was that it was
cleaner to do it in the kernel, since we support uclibc and glibc, and
doing it in the kernel meant only doing it in one place.

>>> Just use the sys_mmap_pgoff system call directly, rather than
>>> defining your own wrappers. Since that syscall is newer than
>>> asm-generic/unistd.h, that file might need some changes,
>>> together with fixes to arch/score to make sure we don't break
>>> its ABI.
>>>   
>>>       
>> It should be OK.  Their sys_mmap2() just tail-calls sys_mmap_pgoff()
>> anyway, so it should be possible to switch mmap2 in asm-generic/unistd.h
>> to be mmap_pgoff instead.  We'll need some user-space changes (our mmap2
>> is defined in 4KB units) but that's not hard.
>>     
> Hmm, I forgot about the page size. Actually the definition of sys_mmap2
> is to use 4KB units on all architectures except ia64, independent
> of the real page size. Maybe it's better to keep using sys_mmap/sys_mmap2
> after all but then use only one of the two (sys_mmap on 64 bit, sys_mmap2
> on 32 bit and compat).
>   

I'll keep it as-is, then.  Like the sendfile discussion above, we'll
need both for now, but I'll see if I can unifdef the unwanted ones out
for the community.

>> I'll think about it.  These are both basically disassembly-related, so
>> maybe an arch/tile/disasm directory with the tile_desc stuff and the
>> backtracer?  I'm not sure it's really worth moving out of
>> arch/tile/kernel though.
>>     
> Ok. If you leave them in the directory, just split them out into a separate
> patch on your next submission then.
>   

Does this imply separate git commits to our repository, if we want to do
things the Right Way?  I always tend to try to commit things in such a
way that everything is always buildable between each commit, and I can't
easily pull out the disassembly-related files from the kernel.  On the
other hand I can easily split up a single bit GIT commit-patch into
multiple emails, but then of course it wouldn't apply easily to a "git
am".  Guidance??  :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


