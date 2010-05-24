Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab0EXP3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:29:22 -0400
Received: from king.tilera.com ([72.1.168.226]:29371 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab0EXP3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:29:20 -0400
Message-ID: <4BFA9B4E.9010200@tilera.com>
Date: Mon, 24 May 2010 11:29:18 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <4BF757FF.6060100@tilera.com> <201005240008.16497.arnd@arndb.de>
In-Reply-To: <201005240008.16497.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2010 15:29:19.0415 (UTC) FILETIME=[E0B3C470:01CAFB55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2010 6:08 PM, Arnd Bergmann wrote:
> On Saturday 22 May 2010 06:05:19 Chris Metcalf wrote:
>   
>> As an experiment, I've created a "git format-patch" output file for all
>> the remaining Tilera-specific changes [...]

> Thanks for this. I took an initial look at the code and it looks pretty
> good as far as I got though not mergeable for 2.6.35 IMHO.
>   

First of all, thank YOU for your review!

Perhaps what we can do is shoot for including a "first round" set of
Tilera support in 2.6.35, which is sufficient to boot the chip up and
work with it, but defer some of the drivers and other features
(oprofile, etc.) for a later merge window.

> It would help if you can set up an actual git tree to pull from, but
> it also works the way you did it.

Hopefully we'll have one by next month sometime.  We have to reprovision
our existing web server, so that has to be coordinated with Marketing,
etc.  I think for this round we'll have to stick to downloading git
patches, unfortunately.

> Most of these device drivers should be reviewed separately
> using the appropriate mailing lists. In general we prefer
> the drivers to live in drivers/{net,ata,serial,...} than
> in arch/.../drivers.
>
> The notable exception is pci, which should go to arch/tile/pci
> but still be reviewed in the pci mailing list.
>   

So this is an interesting question.  Currently the "device driver"
support in the arch/tile/drivers directory is for devices which exist
literally only as part of the Tilera silicon, i.e. they are not
separable from the tile architecture itself.  For example, the network
driver is tied to the Tilera networking shim DMA engine on the chip. 
Does it really make sense to move this to a directory where it is more
visible to other architectures?  I can see that it might from the point
of view of code bombings done to network drivers, for example. 
Similarly for our other drivers, which are tied to details of the
hypervisor API, etc.

For this first round of Tilera code, I will plan to push only the PCI
driver support (which makes sense to move to its own arch/tile/pci/
directory anyway, since there are half a dozen files there).  I'll put
the PCI stuff in its own commit and then cc it to the linux-pci list at
vger.

There is a very minimal hypervisor-API console driver in
arch/tile/kernel/ which I will plan to just leave there for now.

>> arch/tile/oprofile/Makefile                  |    9 +
>> arch/tile/oprofile/backtrace.c               |   73 +
>> arch/tile/oprofile/op_common.c               |  352 +
>> arch/tile/oprofile/op_impl.h                 |   37 +
>>     
> These should probably go through the oprofile list.
>   

OK.  I'll put these in a separate commit as well.  These in any case are
not critical for inclusion in the initial batch of Tilera support.

> You will want to implement PERF_EVENTS, which replaces OPROFILE

Yes, we're planning this, and in fact some friendly folks at {large
company I may not be supposed to name} are working on this with us at
the moment.  I don't think it will be part of this initial code push,
though.

> (you can have both though). You should not need HAVE_IDE, which
> is deprecated by libata, but you will need to reimplement the
> driver.

I'll file a bug internally on this for us to review.  If we make ATA
support a second-round thing anyway, we can do this in a more leisurely
manner.

> HAVE_REGS_AND_STACK_ACCESS_API is a good one, you should implmenent that.

OK.  I think this may be straightforward enough to just do as part of
the first round of code.

> HAVE_HW_BREAKPOINT is good, but requires hardware support.
>   

We do have some of this support (though with some skid), but in any case
its use needs to be coordinated with the oprofile/perf_event counters,
so we haven't gotten around to it yet.  We have a bug open on this
internally already, though.

> +config HOMECACHE
>> +	bool "Support for dynamic home cache management"
>> [...]
>> +config DATAPLANE
>> +	bool "Support for Zero-Overhead Linux mode"
>>
>>     
> These sound like very interesting features that may also be
> useful for other architectures. I would recommend splitting them
> out into separate patches, by removing the support from the
> base architecture patch, and submitting the two patches for these
> features for discussion on the linux-kernel and linux-arch
> mailing lists.
>   

Yes, the intent was to submit them later, since they are more
controversial in that they touch platform-independent code.  One thing
you'll notice in our Kconfig is a TILERA_MDE config option.  This is
effectively a toggle to allow the same Kconfig to be used for both the
code we're returning to the community now, and for the "full featured"
version that we are hacking freely in our MDE ("multicore development
environment", which is what we call the software we ship with the chip).

My initial model was that we would submit all the arch/tile/ code up to
the community, including the code that couldn't yet be enabled due to
missing architecture-independent support.  Adding the
architecture-independent code would then be done in a separate patch
thread.  But this leaves the Tilera architecture-dependent code present
in the initial submission.  How confusing do you think this situation
would be?  I could just run our code through an unifdef to remove things
tagged with CONFIG options that can't be enabled due to missing
architecture-independent support.

>> +choice
>> +	depends on EXPERIMENTAL
>> +	prompt "Memory split" if EMBEDDED
>> +	default VMSPLIT_3G
>>     
> I would recommend leaving out this option on your architecture
> because of the craziness. If I understand you correctly, the
> CPUs are all 64 bit capable, so there is little point in
> micro-optimizing the highmem case.
>   

No, our current shipping hardware is 32-bit only.  The next generation
is 64-bit capable so does not use HIGHMEM and doesn't need to allow the
craziness.  I added a "depends on !TILEGX" to disable it in that case.

>> +config XGBE_MAIN
>> +	tristate "Tilera GBE/XGBE character device support"
>> +	default y
>> +	depends on HUGETLBFS
>> +	---help---
>> +	  This is the low-level driver for access to xgbe/gbe/pcie.
>>     
> This should go to drivers/net/Kconfig.
>   

Maybe not.  This driver is just a character device that allows a user
process to talk to the networking hardware directly.  For example, you
might have an eth0 that is just a normal PCI device using the
platform-independent networking code, and then have user-space code
driving the 10 Gb on-chip NICs without involving the kernel networking
stack.  The Linux networking support (tagged with XGBE_NET) is layered
on top of this driver.

>> diff --git a/arch/tile/feedback/cachepack.c b/arch/tile/feedback/cachepack.c
>> [...]
>>     
> This file looks like mixed kernel/user code, which is something
> we don't normally do. It also does not follow kernel coding style.
> I'd suggest splitting the implementation and having the kernel
> version only include the necessary code without all the #ifdef
> and in normal style.
>
> You could also leave this out for now.
>   

Yes, for now I'll just leave this feedback-compilation support out.  In
another place we have stack backtracing support that is also shared, but
we can actually just unifdef the file when we install it in the kernel
tree, so there will be some blank lines (to make it easier to use
line-number information on the original source) but no __KERNEL__ ifdefs
in the kernel source.

>> diff --git a/arch/tile/include/arch/abi.h b/arch/tile/include/arch/abi.h
>> [...]
>>     
> This file uses nonstandard formatting of the comments. Is it
> a generated file, or something that needs to be shared with
> other projects?
>
> If it is not shared with anything that strictly mandates the
> style, I'd recommend moving to regular kernel style.
>   

I'll discuss changing the style with the rest of the Tilera software
team.  However, we have generally preferred C99 comments for our own
non-Linux code, and this "arch/tile/include/arch/" directory represents
part of the set of headers that provide access to all the grotty details
of the underlying hardware architecture, so can be used within Linux
code, or hypervisor code, booter, user space, etc etc, with no libc or
kernel header inclusion dependencies.

For what it's worth, there do seem to be plenty of files in the
architecture-dependent parts of the kernel, and drivers, that use C99
comments, so there is some precedent for leaving this files in that
style.  (grep "^//" hits 866 files, for example.)

>> +//! Get the current cycle count.
>> +//!
>> +static __inline unsigned long long
>> +get_cycle_count(void)
>> [...]
>>     
> I would not use these functions directly in driver code.
> You could move all of cycle.h to timex.h and rename
> get_cycle_count to get_cycles. The other functions
> are not used anywhere, so they don't need to be
> part of the header.
>   

This is another artifact of how we are sharing code between our <arch>
headers and Linux.  Other parts of our code base use these headers too,
so we export the correct clock-capture algorithm here, then instantiate
it once for Linux, in arch/tile/kernel/time.c.  On our 64-bit chip, the
CHIP_HAS_SPLIT_CYCLE() #define is false, so we just directly use the
trivial implementation in <arch/cycle.h>.

> You should also implement read_current_timer using
> this so you can avoid the expensive delay loop
> calibration at boot time.
>   

We have the following in <asm/timex.h>, which I think should already do
what you are saying:

#define ARCH_HAS_READ_CURRENT_TIMER
static inline int read_current_timer(unsigned long *timer_value)
{
        *timer_value = get_cycle_count_low();
        return 0;
}


We actually have a one-line change to init/calibrate.c to use an
arch_calibrate_delay_direct() macro if defined, which avoids even having
to use read_current_timer(), but since that's platform-independent code,
I didn't want to get into it yet.

>> +static __USUALLY_INLINE void
>> +cycle_relax(void)
>>     
> Another abstraction you can kill by moving this directly
> to cpu_relax and calling that from your relax().
>   

Again, shared code with non-Linux sources.

>> +/* Use __ALWAYS_INLINE to force inlining, even at "-O0". */
>> +#ifndef __ALWAYS_INLINE
>> +#define __ALWAYS_INLINE __inline __attribute__((always_inline))
>> +#endif
>> +
>> +/* Use __USUALLY_INLINE to force inlining even at "-Os", but not at "-O0". */
>> +#ifndef __USUALLY_INLINE
>> +#ifdef __OPTIMIZE__
>> +#define __USUALLY_INLINE __ALWAYS_INLINE
>> +#else
>> +#define __USUALLY_INLINE
>> +#endif
>> +#endif
>>     
> Please get rid of these abstraction, inlining is already hard
> enough with the macros we have in the common code.

Yes, I've seen some of the inlining wars go by over the years on Linux
forums.  But again, these headers are meant to be used in places that
don't have access to internal Linux headers, while at the same time
being easy to #include within code that does use the Linux headers.  We
could do some crazy transformation of our <arch> headers and install
them as "asm" headers for Linux, or something like that, but then it
gets harder to write code that can be used both inside Linux and outside
(say, in a user-mode driver, or in the hypervisor).

> Do you really need to export user.h and page.h?

We definitely don't need user.h any more; for a while we were building
strace to include it, but we haven't been for a while.  We do use
<asm/page.h> to get the page size in some places, but we could also
provide that directly via libc in <sys/page.h> and not involve the
kernel.  Our build allows tuning the page size but only by recompiling
the hypervisor and Linux both, so we just provide page size as a
constant.  (Though getpagesize() still uses the auxv value passed to
user space, just in case we make page size dynamic at some point in the
future.)

>
>> --- /dev/null
>> +++ b/arch/tile/include/asm/addrspace.h
>>     
> This file is not referenced anywhere. I'd suggest removing it
> until you send code that actually uses it.
>   

OK, I've removed it.  I assumed that it was required by architectures,
since it is used in various places in the kernel.  I see four drivers
that just include it unconditionally at the moment, though curiously,
they don't seem to use any of the symbols it defines.  And there are
four architectures (avr32, m32r, mips, sh) that all provide this header
at the moment, though there doesn't seem to be agreement as to what
symbols it should define.

>> diff --git a/arch/tile/include/asm/asm.h b/arch/tile/include/asm/asm.h
>> new file mode 100644
>> index 0000000..f064bc4
>> --- /dev/null
>> +++ b/arch/tile/include/asm/asm.h
>>     
> Can be removed. syscall_table.S is the only user (of just one
> of its macros), so just change that file to not rely on
> the header.
>   

Well, true, but it's a good abstraction.  I actually was planning to use
_ASM_EXTABLE in some of our assembly code, though I hadn't gotten around
to doing so yet.

>> diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
>>     
> This file looks mostly generic, and is to a large extent the
> same as the existing asm-generic/atomic.h. Could you add an
> #ifdef atomic_add_return to the definition of that in
> the generic file and use that, overriding the functions
> that need to be architecture specific on SMP systems?
>   

Seems like a good idea.  I'll look into it.  Should I submit the
<asm-generic/atomic.h> change first as an independent change from the
Tilera architecture stuff, or just include it with the Tilera stuff? 
Same question for the bitops stuff that you mention later on.

> It's unclear why part of atomic.h is split out into atomic_32.h,
> especially when the file actually contains the definitions for
> atomic64_t ;-).
>   

Yeah, that nomenclature does end up a little confusing.  We adopted the
x86 confusion of using "_32" for our 32-bit architecture (i386 <=>
tilepro) and "_64" for our 64-bit architecture (x86_64 <=> tilegx).  So
here, <asm/atomic_32.h> is the atomic support for our 32-bit
architecture, and <asm/atomic_64.h> is the support for our 64-bit
architecture.  However, I unifdef'ed out the things tagged with
"__tilegx__" in our sources, and removed the "*_64.[chS]" files, since
the TILE-Gx support is not 100% until we actually start shipping the
silicon.

>> +static inline void set_bit(unsigned nr, volatile unsigned long *addr)
>> +{
>> +	_atomic_or(addr + BIT_WORD(nr), BIT_MASK(nr));
>> +}
>>     
> +#include <linux/compiler.h>
> Why not just declare set_bit (and other functions from here)
> to be extern?
>   

Two reasons.  The first is that by exposing the "nr" value here, the
compiler can often optimize it away completely, or just convert it to an
appropriate constant.  If we left it in an extern set_bit() the cpu
would always have to do the shifts and adds.  Or, if not a constant, the
compiler can often use an empty slot in one of our "instruction bundles"
leading up to the call to _atomic_or() to hide the construction of the
necessary pointer and constant.

>> +++ b/arch/tile/include/asm/bitsperlong.h
>> +
>> +# define __BITS_PER_LONG 32
>>     
> This seems wrong, unless you support _only_ 32 bit user space.
>   

For the current silicon, we do.  For the 64-bit silicon, we support
either flavor, and we use #ifdef __LP64__ to guard this here.  But I'm
also unifdef'ing with -U__LP64__ for the sources you're seeing.  Perhaps
this just ends up being more, rather than less, confusing!

> with CONFIG_COMPAT support yet, so tile would be the first
> one. I think you should just move this file to
> include/asm-generic/compat.h and use that, so future architectures
> don't need to define their own.
>   

Most of it is pretty generic, for sure.  Are you comfortable with the
part about registers?  We use 64-bit registers in our 32-bit mode, since
for us "compat" mode is just a 32-bit pointer mode, like DEC Alpha's. 
So "long long" and "double" are still held in a single 64-bit register
regardless.  Here's the relevant part:

/* We use the same register dump format in 32-bit images. */
typedef unsigned long compat_elf_greg_t;
#define COMPAT_ELF_NGREG (sizeof(struct pt_regs) / sizeof(compat_elf_greg_t))
typedef compat_elf_greg_t compat_elf_gregset_t[COMPAT_ELF_NGREG];



>> + * Idle the core for 8 * iterations cycles.
>> + * Also make this a compiler barrier, as it's sometimes used in
>> + * lieue of cpu_relax(), which has barrier semantics.
>> + */
>> +static inline void
>> +relax(int iterations)
>> [...]
>>     
> I'd rather not make this part of the interface. Just move this
> definition to your spinlock_32.c file and use an open-coded
> version in delay.c
>   

We also use this in spinlock_64.c, which of course you didn't see :-) 
We could just move it to asm/spinlock.h and call it __relax() or some
such to suggest that it's not meant to be used by other code.  How does
that sound?

> +++ b/arch/tile/include/asm/kmap_types.h
>   
> Any reason for having your own copy of this instead of the
> generic file?
>   

Yes, it's because we are concerned about chewing up address space.  Each
additional km type here requires another page worth of address space per
cpu, and since we are using 64KB pages for TLB efficiency in our
embedded apps, this means 64KB times 64 processors = 4 MB of address
space per km type. (Yes, I've followed the discussions about why large
page sizes are bad for general-purpose computing.)

> This looks like you can use the asm-generic/mman.h file.

No, the bit values for the constants are wrong.  We use bits 0x8000 and
up to describe our "homecache" overrides to mmap().

> Since the file is exported to user space, the map_cache stuff probably
> should not be here, but get moved to a different header that
> is private to the kernel.
>   

It's part of the optional extended API for mmap() used by Tilera Linux,
so it is actually needed by userspace.

> +++ b/arch/tile/include/asm/posix_types.h
> Anything wrong with the asm-generic version of this file?
>   

I somehow missed being aware of the generic version of this (and of
sembuf.h and shmparam.h).  It seems likely we can use the generic
posix_types.h, and we can certainly use the generic forms of the others.

>
>> --- /dev/null
>> +++ b/arch/tile/include/asm/sigcontext.h
>> +
>> +#ifndef _ASM_TILE_SIGCONTEXT_H
>> +#define _ASM_TILE_SIGCONTEXT_H
>> +
>> +/* NOTE: we can't include <linux/ptrace.h> due to #include dependencies. */
>> +#include <asm/ptrace.h>
>> +
>> +/* Must track <sys/ucontext.h> */
>> +
>> +struct sigcontext {
>> +	struct pt_regs regs;
>> +};
>>     
> The comments both do not match the code apparently.
>   

Sorry - can you clarify this comment?  I don't see the mismatch.

>
> +++ b/arch/tile/include/asm/spinlock_32.h
>   
> This file could just be renamed to spinlock.h, afaict.
>   

Yes, well, there's the spinlock_64.h version hiding behind the unifdef
here.  :-)

> +++ b/arch/tile/include/asm/stat.h
> part of the ABI, please don't define your own.
>   

Unfortunately, changing this would require us to make an incompatible
change to current user-space.  It may be possible anyway, since we are
planning a number of transitions for our next major release (jump from
kernel 2.6.26, switch from our current SGI-derived compiler to using
gcc, etc.).  I'll discuss this internally.

>> +/* Use this random value, just like most archs.  Mysterious. */
>> +#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
>>     
> long story. It should however actually be something related to the
> your frequency, not the time base of the i8253 chip that I hope
> you are not using.
>   

No, no i8253.  But our clock tick rate is controllable dynamically at
boot, so there's certainly no trivial constant that makes sense here. 
Should I use the slowest possible frequency here?  The fastest?  It's
used in some irrelevant drivers, but also in <linux/jiffies.h>, which is
the place that worries me.

> Your unistd.h file contains syscall numbers for many calls that
> you should not need in a new architecture. Please move to the
> asm-generic/unistd.h file instead. There may be a few things you
> need to do in libc to get there, but this version is no good.
> If you have problems with asm-generic/unistd.h (or any of the other
> asm-generic files), feel free to ask me for help.
>   

Sounds like we should take this one off-list until I know more precisely
what you're worried about.  As far as I know, I did not import any
pointless syscalls.  I have a stanza (which of course is unifdef'ed out
of your version) that removes all the foo64() syscalls when used with
64-bit userspace.  But I think all the rest are useful.

As for <asm-generic/unistd.h>, I'll look more carefully at it, though of
course using it is also dependent on whether it is reasonable for us to
completely break compatibility with current user-space programs.

Arnd - MANY thanks for your careful review so far.  I will implement
what you suggested and await the remainder of your review before
resubmitting patches.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


