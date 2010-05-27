Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab0E0Ilu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:41:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62801 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab0E0Ilq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:41:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Thu, 27 May 2010 10:41:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005252345.15685.arnd@arndb.de> <4BFDC3D1.40708@tilera.com>
In-Reply-To: <4BFDC3D1.40708@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005271041.30519.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18zH2YHdRPGdE6EFJm6IGAQyftvw08LaJJfaRx
 BTGipZNkVwvl+UaAcd6nYBkDIaS5aCHjLmTvIoWR6vs9a8MX3/
 tFJupdPmjdDypyv6XoBHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Chris Metcalf wrote:
> > Yes, that makes sense. You definitely want binary compatibility between
> > 32 bit binaries from a native 32 bit system on TILE-Gx in the syscall
> > interface.
> >   
> 
> The thing is, the COMPAT layer on TILE-Gx is actually not providing
> TILEPro compatibility, since the architectures are too different --
> conceptually similar but with different opcode numbering, etc.  Instead
> what it's doing is providing a 32-bit pointer ABI, to help porting
> crufty old code (this is in fact the primary customer driver), or to
> allow more compact representations of pointer-heavy data.

Ah, interesting. I don't think any architecture does it this way
so far. IIRC, while alpha had some applications built in 32 bit
mode in the early days, those were just using the 64 bit system
calls directly.

Then again, that probably required some rather ugly hacks to get
the libc working, so since we have the compat code in kernel now,
your approach is probably much better.

Are you able to build 32 bit kernels for TILE-Gx as well? It's
probably something you never really want to do for performance
reasons, but I guess you could use that to verify that the
ABI is really compatible.

> > compat_sys_sendfile will not be needed with the asm-generic/unistd.h definitions,
> > but I think you will still need a compat_sys_sendfile64, to which the same
> > applies as to compat_sys_sched_rr_get_interval.
> >   
> 
> I think it's the other way around: compat_sys_sendfile64() is just
> sys_sendfile64(), but compat_sys_sendfile() needs to exist since it has
> to write a 32-bit pointer back to userspace.

Ah. I guess you're right about compat_sys_sendfile64 not being needed.
Funny enough, parisc, powerpc, s390 and sparc all define it anyway, so
it didn't occur to me that they don't actually need to.

What I meant about compat_sys_sendfile is that you only define it if
the 32 bit ABI contains a reference to sys_sendfile in the first
place. With asm-generic/unistd.h, 32 bit uses always uses the sys_sendfile64
kernel interface, while for 64 bit the two are identical, so we take
the regular sys_sendfile.

> >> +static int hardwall_ioctl(struct inode *inode, struct file *file,
> >> +                      unsigned int a, unsigned long b)
> >> +{
> >> [...]
> >>     
> > The hardwall stuff looks like it is quite central to your architecture.
> > Could you elaborate on what it does?
> >   
> It's not "central" but it is an important enabler for access to our
> "user network".  This is a wormhole-routed mesh network (the UDN, or
> user dynamic network) that connects all the cpus.  If a task affinitizes
> itself to a single cpu (to avoid migration) and opens /dev/hardwall and
> does an ioctl on it, it can associate the particular /dev/hardwall file
> object with some non-overlapping subrectangle of the whole 8x8 chip (our
> cpus are laid out as "tiles" in an 8x8 configuration).  It can then do
> an "activate" ioctl to get access to that subrectangle of the UDN, from
> that cpu.  Other threads in that process (or anyone who can share that
> file object one way or another, e.g. fork or sendmsg) can then also do
> an "activate" ioctl on that file object and also get access, and they
> can then exchange messages with very low latency (register file to
> register file in a handful of cycles) and high bandwidth (32 bits/cycle
> or about 3GB/sec).
>
> The actual "hardwall" refers to the fact that cpus on the periphery of
> the allocated subrectangle of cpus set up the router so that they will
> get an interrupt if some cpu tries to send a message that would
> terminate outside the set of allocated cpus.  Doing it this way means
> several unrelated tasks could have separate message-passing arenas
> (spatially dividing the chip) and whenever the last task holding a
> reference to a hardwall file object exits, the OS can drain any messages
> from the UDN and deallocate the subrectangle in question.
>
> > If it is as essential as it looks, I'd vote for promoting the interface
> > from an ioctl based one to four real system calls (more if necessary).
> >   
> 
> The notion of using a file descriptor as the "rights" object is pretty
> central, so I think a character device will work out well.

ok, I see. Now you could easily do this with system calls as well:
Instead of the initial ioctl that associates the file descriptor
with a rectangle, you can have a syscall that creates a rectangle
and a file descriptor (using anon_inode_getfd) associated with it,
and returns the fd to user space. This is similar to what we
do for other system call interfaces that operate on their own fds.

Another alternative might be to combine this with cpusets subsystem,
which has a related functionality. I guess that would be the
preferred way if you expect tile-gx to take over the world and
have lots of applications written to it.
For a niche product, the syscall or ioctl approach does seem
simple enough, and it does not require other users of cpusets
to learn about requirements of your rectangles.

> > Note that the procfs file format is part of your ABI, and this looks
> > relatively hard to parse, which may introduce bugs.
> > For per-process information, it would be better to have a simpler
> > file in each /proc/<pid>/directory. Would that work for you?
> >   
> 
> Well, the hardwalls aren't exactly per-process anyway, and we don't in
> practice use the ASCII output for anything much, so it may not matter
> that they're not too parseable.  I may just look into making them more
> parsable when I convert it to a /dev interface and leave it at that.

On a chardev, a binary interface seems more appropriate than
an text based one anyway, so you could add another ioctl for this.

> I'm planning to defer this in any case, since the UDN interface, though
> a nice-to-have, obviously isn't needed to run any standard C code.  I'll
> make that part of a follow-up patch.

ok

> > Note that we're about to remove the .ioctl file operation and
> > replace it with .unlocked_ioctl everywhere.
> >   
> 
> OK, for now I'll ensure that we are locking everything internally
> correctly. I believe we are already anyway.

ok. Then please just use .unlocked_ioctl in new drivers.

> > [hugevmap] Not used anywhere apparently. Can you explain what this is good for?
> > Maybe leave it out for now, until you merge the code that needs it.
> > I don't see anything obviously wrong with the implementation though.
> >   
> 
> I'll omit it; we haven't used it yet.  The intent was to provide
> guaranteed huge pages for TLB purposes to kernel drivers.  Currently we
> just start with huge pages where possible, and fragment them if necessary.

Ok. Do you use huge pages for backing the linear kernel mapping?
Normally device drivers get huge pages for free in kmalloc and
get_free_pages because all the memory is mapped using the largest
page size anyway.

> > +EXPORT_SYMBOL(inb);
> >   
> > If you just remove these definitions, you get a link error for any
> > driver that tries to use these, which is probably more helpful than
> > the panic.
> >
> > OTOH, are you sure that you can't just map the PIO calls to mmio functions
> > like readb plus some fixed offset? On most non-x86 architectures, the PIO
> > area of the PCI bus is just mapped to a memory range somewhere.
> >   
> 
> I'll try to remove them and see if anything falls over.  We don't have
> any memory-mapped addresses in the 32-bit architecture, though that
> changes with the 64-bit architecture, which introduces IO mappings.  For
> PCI we actually have to do a hypervisor transaction for reads or writes.

Ok, then I assume that PIO would also be a hypervisor call, right?
If you don't have MMIO on 32 bit, you might want to not define either
PIO (inb, ...) no MMIO (readb, ...) calls there and disable
CONFIG_HAVE_MMIO in Kconfig.
 
> >> +SEQ_PROC_ENTRY(interrupts)
> >> +static int proc_tile_interrupts_show(struct seq_file *sf, void *v)
> >> +{
> >> [...]
> >>     
> > Can you merge this with /proc/interrupts?
> >   
> 
> It turns out /proc/interrupts is formatted the wrong way round if you
> have 64 processors :-)  You want one row per cpu, not one column per cpu!

Yes, interesting observation. I'm sure the Altix folks are suffering from
this a lot.
 
> Also, there are things listed that are not strictly IRQs in the normal
> sense (things like TLB flushes and syscalls) which are still good for
> assessing where latency glitches might be coming from on a particular cpu.

That's fine, just look at what a current x86 kernel gives you (slightly
cut):
           CPU0       CPU1
  0:   18764948     504980   IO-APIC-edge      timer
  1:     228456       2572   IO-APIC-edge      i8042
  9:    2632595      79544   IO-APIC-fasteoi   acpi
 12:    1094468      43409   IO-APIC-edge      i8042
 16:      82761       1455   IO-APIC-fasteoi   uhci_hcd:usb6, yenta, heci
 28:     908865      85857   PCI-MSI-edge      ahci
 29:       6421      11595   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:    1987682    9057144   Local timer interrupts
SPU:          0          0   Spurious interrupts
CNT:          0          0   Performance counter interrupts
PND:          0          0   Performance pending work
RES:    3598785    3903513   Rescheduling interrupts
CAL:       8848       5944   Function call interrupts
TLB:      31467      18283   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:        354        346   Machine check polls
ERR:          0
MIS:          0

Lots of things in there that fit your category.

> > This seems to be read-only and coming from a kernel command
> > line option, so I guess looking at /proc/cmdline would
> > be a reasonable alternative.
> >   
> 
> I always find that kind of painful, since you have to parse it exactly
> as the kernel would to be sure you're getting it right; strstr() is only
> a 99% solution.

How about making it a module_param then? You can still see it
in /sys/modules/*/parameters then, even if the code is builtin,
but it won't be in the sysctl name space any more.
 
> >> +SYSCALL_DEFINE3(raise_fpe, int, code, unsigned long, addr,
> >> +            struct pt_regs *, regs)
> >>     
> > Does this need to be a system call? I thought we already had
> > other architectures without floating point exceptions in hardware
> > that don't need this.
> >   
> 
> Hmm, I didn't know about that.  Any information would be appreciated.  I
> guess you could synthesize something that looked like a signal purely in
> user-space?  But how would debuggers trap it?  I'm not sure how it would
> work without a system call.

I think the C99 standard allows you to not implement SIGFPE at all but
instead rely on applications doing fetestexcept() etc.

> >> diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
> >> [...]
> >> +ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count)
> >> +{
> >> +    return sys_readahead(fd, ((loff_t)offset_hi << 32) | offset_lo, count);
> >> +}
> >> +
> >>
> >>     
> > These seem to belong with the other similar functions in compat.c
> >   
> 
> Except they're also used by the 32-bit platform where there is no compat
> mode (the compat code DOES use them too, it's true).

I see. AFAICT, all other architectures don't need the wrapper in
the 32 bit native case because they define the syscall calling
conventions in libc such that they match what the kernel
expects for a 64 bit argument (typically split in two subsequent
argument slots). Would that work for you as well?

> > Just use the sys_mmap_pgoff system call directly, rather than
> > defining your own wrappers. Since that syscall is newer than
> > asm-generic/unistd.h, that file might need some changes,
> > together with fixes to arch/score to make sure we don't break
> > its ABI.
> >   
> 
> It should be OK.  Their sys_mmap2() just tail-calls sys_mmap_pgoff()
> anyway, so it should be possible to switch mmap2 in asm-generic/unistd.h
> to be mmap_pgoff instead.  We'll need some user-space changes (our mmap2
> is defined in 4KB units) but that's not hard.

Hmm, I forgot about the page size. Actually the definition of sys_mmap2
is to use 4KB units on all architectures except ia64, independent
of the real page size. Maybe it's better to keep using sys_mmap/sys_mmap2
after all but then use only one of the two (sys_mmap on 64 bit, sys_mmap2
on 32 bit and compat).

Either way should work though.

> > It seems that this file fits in the same category as the
> > backtrace code. Maybe move both away from arch/tile/kernel into a
> > different directory?
> >   
> 
> I'll think about it.  These are both basically disassembly-related, so
> maybe an arch/tile/disasm directory with the tile_desc stuff and the
> backtracer?  I'm not sure it's really worth moving out of
> arch/tile/kernel though.

Ok. If you leave them in the directory, just split them out into a separate
patch on your next submission then.

	Arnd
