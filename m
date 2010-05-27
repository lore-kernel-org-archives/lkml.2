Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0E0A7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:59:06 -0400
Received: from king.tilera.com ([72.1.168.226]:26142 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab0E0A7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:59:00 -0400
Message-ID: <4BFDC3D1.40708@tilera.com>
Date: Wed, 26 May 2010 20:58:57 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <4BF757FF.6060100@tilera.com> <201005240008.16497.arnd@arndb.de> <201005252345.15685.arnd@arndb.de>
In-Reply-To: <201005252345.15685.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2010 00:58:59.0540 (UTC) FILETIME=[CA787140:01CAFD37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2010 5:45 PM, Arnd Bergmann wrote:
> Here comes the rest of my review, covering the arch/tile/kernel/ directory.
> There isn't much to comment on in arch/tile/mm and arch/tile/lib from my
> side, and I still ignored the drivers and oprofile directories.
>   

Thanks, that's great.  The drivers and oprofile stuff will not be part
of the submission we will make this week anyway, so I think that's OK.

>> diff --git a/arch/tile/kernel/backtrace.c b/arch/tile/kernel/backtrace.c
>> [...]
> this
> file looks rather complicated compared to what the other architectures
> do. 
>
> Is this really necessary because of some property of the architecture
> or do you implement other functionality that is not present on existing
> archs?
>   

The functionality we implement is to support backtrace of arbitrary
code, as long as it follows a pretty minimalist ABI.  This includes
pretty much arbitrarily-optimized code, as well as, of course, code with
no dwarf debug info available.  As a result the backtracer is slightly
more complicated, but only for the initial leaf function; after that
it's easy to chain through the call frames.

> Yes, that makes sense. You definitely want binary compatibility between
> 32 bit binaries from a native 32 bit system on TILE-Gx in the syscall
> interface.
>   

The thing is, the COMPAT layer on TILE-Gx is actually not providing
TILEPro compatibility, since the architectures are too different --
conceptually similar but with different opcode numbering, etc.  Instead
what it's doing is providing a 32-bit pointer ABI, to help porting
crufty old code (this is in fact the primary customer driver), or to
allow more compact representations of pointer-heavy data.

> compat_sys_sendfile will not be needed with the asm-generic/unistd.h definitions,
> but I think you will still need a compat_sys_sendfile64, to which the same
> applies as to compat_sys_sched_rr_get_interval.
>   

I think it's the other way around: compat_sys_sendfile64() is just
sys_sendfile64(), but compat_sys_sendfile() needs to exist since it has
to write a 32-bit pointer back to userspace.

>> +static int hardwall_ioctl(struct inode *inode, struct file *file,
>> +			  unsigned int a, unsigned long b)
>> +{
>> [...]
>>     
> The hardwall stuff looks like it is quite central to your architecture.
> Could you elaborate on what it does?
>   

It's not "central" but it is an important enabler for access to our
"user network".  This is a wormhole-routed mesh network (the UDN, or
user dynamic network) that connects all the cpus.  If a task affinitizes
itself to a single cpu (to avoid migration) and opens /dev/hardwall and
does an ioctl on it, it can associate the particular /dev/hardwall file
object with some non-overlapping subrectangle of the whole 8x8 chip (our
cpus are laid out as "tiles" in an 8x8 configuration).  It can then do
an "activate" ioctl to get access to that subrectangle of the UDN, from
that cpu.  Other threads in that process (or anyone who can share that
file object one way or another, e.g. fork or sendmsg) can then also do
an "activate" ioctl on that file object and also get access, and they
can then exchange messages with very low latency (register file to
register file in a handful of cycles) and high bandwidth (32 bits/cycle
or about 3GB/sec).

The actual "hardwall" refers to the fact that cpus on the periphery of
the allocated subrectangle of cpus set up the router so that they will
get an interrupt if some cpu tries to send a message that would
terminate outside the set of allocated cpus.  Doing it this way means
several unrelated tasks could have separate message-passing arenas
(spatially dividing the chip) and whenever the last task holding a
reference to a hardwall file object exits, the OS can drain any messages
from the UDN and deallocate the subrectangle in question.

> If it is as essential as it looks, I'd vote for promoting the interface
> from an ioctl based one to four real system calls (more if necessary).
>   

The notion of using a file descriptor as the "rights" object is pretty
central, so I think a character device will work out well.

> Note that the procfs file format is part of your ABI, and this looks
> relatively hard to parse, which may introduce bugs.
> For per-process information, it would be better to have a simpler
> file in each /proc/<pid>/directory. Would that work for you?
>   

Well, the hardwalls aren't exactly per-process anyway, and we don't in
practice use the ASCII output for anything much, so it may not matter
that they're not too parseable.  I may just look into making them more
parsable when I convert it to a /dev interface and leave it at that.

I'm planning to defer this in any case, since the UDN interface, though
a nice-to-have, obviously isn't needed to run any standard C code.  I'll
make that part of a follow-up patch.

> Note that we're about to remove the .ioctl file operation and
> replace it with .unlocked_ioctl everywhere.
>   

OK, for now I'll ensure that we are locking everything internally
correctly. I believe we are already anyway.

> [hugevmap] Not used anywhere apparently. Can you explain what this is good for?
> Maybe leave it out for now, until you merge the code that needs it.
> I don't see anything obviously wrong with the implementation though.
>   

I'll omit it; we haven't used it yet.  The intent was to provide
guaranteed huge pages for TLB purposes to kernel drivers.  Currently we
just start with huge pages where possible, and fragment them if necessary.

>> +++ b/arch/tile/kernel/hv_drivers.c
>>     
> Please have a look at drivers/char/hvc_{rtas,beat,vio,iseries}.c
> to see how we do the same for other hypervisors, in a much simpler
> way.
>   

Great, thanks for the pointer.

>> diff --git a/arch/tile/kernel/memprof.c b/arch/tile/kernel/memprof.c
>> new file mode 100644
>> index 0000000..9424cc5
>> --- /dev/null
>> +++ b/arch/tile/kernel/memprof.c
>>     
> I suppose this could get dropped in favor of perf events?
>   

I don't know enough about perf events to be sure, but I don't think so;
the memprof device is intended to provide a stream of information on
things like memory latency and bandwidth.  But perhaps it could be wired
into perf events.  I'll probably move this to "drivers", and in any case
omit it entirely from the first patch.

> +EXPORT_SYMBOL(inb);
>   
> If you just remove these definitions, you get a link error for any
> driver that tries to use these, which is probably more helpful than
> the panic.
>
> OTOH, are you sure that you can't just map the PIO calls to mmio functions
> like readb plus some fixed offset? On most non-x86 architectures, the PIO
> area of the PCI bus is just mapped to a memory range somewhere.
>   

I'll try to remove them and see if anything falls over.  We don't have
any memory-mapped addresses in the 32-bit architecture, though that
changes with the 64-bit architecture, which introduces IO mappings.  For
PCI we actually have to do a hypervisor transaction for reads or writes.

>> +/*
>> + * Support /proc/PID/pgtable
>> + */
>>     
> Do you have applications relying on this? While I can see
> how this may be useful, I don't think we should have a
> generic interface like this in architecture specific
> code.
>
> It also may be used as an attack vector for malicious applications
> that have a way of accessing parts of physical memory.
>
> I think it would be better to drop this interface for now.
>   

We do find it useful internally, mostly because it shows you what
homecaching is actually in effect for pages in an application.  But we
don't rely on it, and it is (to be generous) only semi-tastefully hooked
into the generic code, and the hooks are not present in the code we're
currently trying to return to the community.  So I'll remove it for now.

>> +/* Simple /proc/tile files. */
>> +SIMPLE_PROC_ENTRY(grid, "%u\t%u\n", smp_width, smp_height)
>> +
>> +/* More complex /proc/tile files. */
>> +static void proc_tile_seq_strconf(struct seq_file *sf, char* what,
>> +	uint32_t query)
>>     
> All of these look like they should be files in various places in
> sysfs, e.g. in /sys/devices/system/cpu or /sys/firmware/.
> Procfs is not necessarily evil, but most of your uses are for
> stuff that actually first very well into what we have in sysfs.
>   

Interesting possibility.  I'll look into it.

>> +SEQ_PROC_ENTRY(interrupts)
>> +static int proc_tile_interrupts_show(struct seq_file *sf, void *v)
>> +{
>> [...]
>>     
> Can you merge this with /proc/interrupts?
>   

It turns out /proc/interrupts is formatted the wrong way round if you
have 64 processors :-)  You want one row per cpu, not one column per cpu!

Also, there are things listed that are not strictly IRQs in the normal
sense (things like TLB flushes and syscalls) which are still good for
assessing where latency glitches might be coming from on a particular cpu.

In any case, this will likely be removed for the first round of
submission, along with all the other /proc stuff.

>> +#ifdef CONFIG_FEEDBACK_COLLECT
>> +[...]
> This probably belongs into debugfs, similar to what we do
> for gcov.
>
> How much of the feedbackl stuff is generic? It might be good
> to put those bits in a common place like kernel/feedback.c
> so that other architectures can implement this as well.
>   

Hmm, interesting.  The feedback stuff is somewhat generic, at least the
link-ordering piece; it relies on some separate userspace code that
computes cache-conflict information and then lays out all the functions
in a good order based on who calls whom.  But I'll be removing it for
now and then re-introducing it later as a separate patch anyway.

>> +		.procname	= "crashinfo",
>> +		.data		= &show_crashinfo,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= &proc_dointvec
>> +	},
>> +	{}
>> +};
>>     
> How is this different from the existing
> exception-trace/userprocess_debug sysctl?
> If it is very similar, let's not introduce yet another
> name for it but just use the common userprocess_debug.
>   

I had made a note of doing this earlier when I was porting our code up
to 2.6.34.  For now I'm going to remove the tile-specific thing, and
then later look at using the exception-trace hook.  I think they're
pretty similar.

> This seems to be read-only and coming from a kernel command
> line option, so I guess looking at /proc/cmdline would
> be a reasonable alternative.
>   

I always find that kind of painful, since you have to parse it exactly
as the kernel would to be sure you're getting it right; strstr() is only
a 99% solution.

> I believe the new way to do this is to implement
> CONFIG_HAVE_ARCH_TRACEHOOK and get all these for free.
>   

I'll check that out.

>> +SYSCALL_DEFINE3(raise_fpe, int, code, unsigned long, addr,
>> +		struct pt_regs *, regs)
>>     
> Does this need to be a system call? I thought we already had
> other architectures without floating point exceptions in hardware
> that don't need this.
>   

Hmm, I didn't know about that.  Any information would be appreciated.  I
guess you could synthesize something that looked like a signal purely in
user-space?  But how would debuggers trap it?  I'm not sure how it would
work without a system call.

>> diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
>> [...]
>> +ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count)
>> +{
>> +	return sys_readahead(fd, ((loff_t)offset_hi << 32) | offset_lo, count);
>> +}
>> +
>>
>>     
> These seem to belong with the other similar functions in compat.c
>   

Except they're also used by the 32-bit platform where there is no compat
mode (the compat code DOES use them too, it's true).

> Just use the sys_mmap_pgoff system call directly, rather than
> defining your own wrappers. Since that syscall is newer than
> asm-generic/unistd.h, that file might need some changes,
> together with fixes to arch/score to make sure we don't break
> its ABI.
>   

It should be OK.  Their sys_mmap2() just tail-calls sys_mmap_pgoff()
anyway, so it should be possible to switch mmap2 in asm-generic/unistd.h
to be mmap_pgoff instead.  We'll need some user-space changes (our mmap2
is defined in 4KB units) but that's not hard.

> It seems that this file fits in the same category as the
> backtrace code. Maybe move both away from arch/tile/kernel into a
> different directory?
>   

I'll think about it.  These are both basically disassembly-related, so
maybe an arch/tile/disasm directory with the tile_desc stuff and the
backtracer?  I'm not sure it's really worth moving out of
arch/tile/kernel though.

> Have you tried to use the generic lib/checksum.c implementation?

That sounds good.  We only touched do_csum(), which already has an
"#ifndef do_csum" in the generic code.

Thanks for all this!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


