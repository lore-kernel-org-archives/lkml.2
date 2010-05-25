Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300Ab0EYVp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:45:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63977 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab0EYVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:45:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Tue, 25 May 2010 23:45:15 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00202-gac5d593; KDE/4.4.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <4BF757FF.6060100@tilera.com> <201005240008.16497.arnd@arndb.de>
In-Reply-To: <201005240008.16497.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005252345.15685.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/5Do1CAS/EUrMWGkMCI+8VTnhGrcSRC3lBe9J
 wOJL2d6EDe4uxoOJ0gZA4vAbfSQlacYagat72WBT609G7DyXPY
 Q+CY9Z25nQTd+BcswN7mg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here comes the rest of my review, covering the arch/tile/kernel/ directory.
There isn't much to comment on in arch/tile/mm and arch/tile/lib from my
side, and I still ignored the drivers and oprofile directories.

> diff --git a/arch/tile/kernel/backtrace.c b/arch/tile/kernel/backtrace.c
> new file mode 100644
> index 0000000..3cbb21a
> --- /dev/null
> +++ b/arch/tile/kernel/backtrace.c
> +#ifndef __KERNEL__
> +#include <stdlib.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#else
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#define abort() BUG()
> +#endif

Besides being shared kernel/user code (as you already mentioned),  this
file looks rather complicated compared to what the other architectures
do. 

Is this really necessary because of some property of the architecture
or do you implement other functionality that is not present on existing
archs?

> diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
> new file mode 100644
> index 0000000..ca6421c
> --- /dev/null
> +++ b/arch/tile/kernel/compat.c
> +/*
> + * Syscalls that take 64-bit numbers traditionally take them in 32-bit
> + * "high" and "low" value parts on 32-bit architectures.
> + * In principle, one could imagine passing some register arguments as
> + * fully 64-bit on TILE-Gx in 32-bit mode, but it seems easier to
> + * adapt the usual convention.
> + */

Yes, that makes sense. You definitely want binary compatibility between
32 bit binaries from a native 32 bit system on TILE-Gx in the syscall
interface.

> +long compat_sys_truncate64(char __user *filename, u32 dummy, u32 low, u32 high)
> +{
> +	return sys_truncate(filename, ((loff_t)high << 32) | low);
> +}
> +
> +long compat_sys_ftruncate64(unsigned int fd, u32 dummy, u32 low, u32 high)
> +{
> +	return sys_ftruncate(fd, ((loff_t)high << 32) | low);
> +}
> +
> +long compat_sys_pread64(unsigned int fd, char __user *ubuf, size_t count,
> +			u32 dummy, u32 low, u32 high)
> +{
> +	return sys_pread64(fd, ubuf, count, ((loff_t)high << 32) | low);
> +}
> +
> +long compat_sys_pwrite64(unsigned int fd, char __user *ubuf, size_t count,
> +			 u32 dummy, u32 low, u32 high)
> +{
> +	return sys_pwrite64(fd, ubuf, count, ((loff_t)high << 32) | low);
> +}
> +
> +long compat_sys_lookup_dcookie(u32 low, u32 high, char __user *buf, size_t len)
> +{
> +	return sys_lookup_dcookie(((loff_t)high << 32) | low, buf, len);
> +}
> +
> +long compat_sys_sync_file_range2(int fd, unsigned int flags,
> +				 u32 offset_lo, u32 offset_hi,
> +				 u32 nbytes_lo, u32 nbytes_hi)
> +{
> +	return sys_sync_file_range(fd, ((loff_t)offset_hi << 32) | offset_lo,
> +				   ((loff_t)nbytes_hi << 32) | nbytes_lo,
> +				   flags);
> +}
> +
> +long compat_sys_fallocate(int fd, int mode,
> +			  u32 offset_lo, u32 offset_hi,
> +			  u32 len_lo, u32 len_hi)
> +{
> +	return sys_fallocate(fd, mode, ((loff_t)offset_hi << 32) | offset_lo,
> +			     ((loff_t)len_hi << 32) | len_lo);
> +}

It may be time to finally provide generic versions of these...
Any work in that direction would be appreciated, but you may also
just keep this code, it's good.

> +/*
> + * The 32-bit runtime uses layouts for "struct stat" and "struct stat64"
> + * that match the TILEPro/TILE64 runtime.  Unfortunately the "stat64"
> + * layout on existing 32 bit architectures doesn't quite match the
> + * "normal" 64-bit bit layout, so we have to convert for that too.
> + * Worse, it has an unaligned "st_blocks", so we have to use __copy_to_user().
> + */
> +
> +int cp_compat_stat(struct kstat *kbuf, struct compat_stat __user *ubuf)
> +{
> +	compat_ino_t ino;
> +
> +	if (!old_valid_dev(kbuf->dev) || !old_valid_dev(kbuf->rdev))
> +		return -EOVERFLOW;
> +	if (kbuf->size >= 0x7fffffff)
> +		return -EOVERFLOW;
> +	ino = kbuf->ino;
> +	if (sizeof(ino) < sizeof(kbuf->ino) && ino != kbuf->ino)
> +		return -EOVERFLOW;
> +	if (!access_ok(VERIFY_WRITE, ubuf, sizeof(struct compat_stat)) ||
> +	    __put_user(old_encode_dev(kbuf->dev), &ubuf->st_dev) ||
> ...

With the asm-generic/stat.h definitions, this is no longer necessary.
Those are defined to be compatible, so you can just call the 64 bit
version of sys_stat in place of the 32 bit sys_stat64.

> +long compat_sys_sched_rr_get_interval(compat_pid_t pid,
> +				      struct compat_timespec __user *interval)
> +{
> +	struct timespec t;
> +	int ret;
> +	mm_segment_t old_fs = get_fs();
> +
> +	set_fs(KERNEL_DS);
> +	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
> +	set_fs(old_fs);
> +	if (put_compat_timespec(&t, interval))
> +		return -EFAULT;
> +	return ret;
> +}

This is relatively ugly and probably identical to the other six copies
of the same function. Someone (not necessarily you) should do this
the right way.

> +
> +ssize_t compat_sys_sendfile(int out_fd, int in_fd, compat_off_t __user *offset,
> +			    size_t count)
> +{
> +	mm_segment_t old_fs = get_fs();
> +	int ret;
> +	off_t of;
> +
> +	if (offset && get_user(of, offset))
> +		return -EFAULT;
> +
> +	set_fs(KERNEL_DS);
> +	ret = sys_sendfile(out_fd, in_fd, offset ? (off_t __user *)&of : NULL,
> +			   count);
> +	set_fs(old_fs);
> +
> +	if (offset && put_user(of, offset))
> +		return -EFAULT;
> +	return ret;
> +}

compat_sys_sendfile will not be needed with the asm-generic/unistd.h definitions,
but I think you will still need a compat_sys_sendfile64, to which the same
applies as to compat_sys_sched_rr_get_interval.

> +/*
> + * The usual compat_sys_msgsnd() and _msgrcv() seem to be assuming
> + * some different calling convention than our normal 32-bit tile code.
> + */

Fascinating, the existing functions are useless, because no architecture
is actually able to call them directly from their sys_call_table.
We should replace those with your version and change the other architectures
accordingly.

> diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
> new file mode 100644
> index 0000000..e21554e
> --- /dev/null
> +++ b/arch/tile/kernel/compat_signal.c
> +
> +struct compat_sigaction {
> +	compat_uptr_t sa_handler;
> +	compat_ulong_t sa_flags;
> +	compat_uptr_t sa_restorer;
> +	sigset_t sa_mask;		/* mask last for extensibility */
> +};
> +
> +struct compat_sigaltstack {
> +	compat_uptr_t ss_sp;
> +	int ss_flags;
> +	compat_size_t ss_size;
> +};
> +
> +struct compat_ucontext {
> +	compat_ulong_t	  uc_flags;
> +	compat_uptr_t     uc_link;
> +	struct compat_sigaltstack	  uc_stack;
> +	struct sigcontext uc_mcontext;
> +	sigset_t	  uc_sigmask;	/* mask last for extensibility */
> +};

It's been some time since I looked at this stuff, so I'd need help
from others to review it. I sense that it should be simpler though.

> +/*
> + * Interface to /proc and the VFS.
> + */
> +
> +static int hardwall_ioctl(struct inode *inode, struct file *file,
> +			  unsigned int a, unsigned long b)
> +{
> +	struct hardwall_rectangle rect;
> +	struct khardwall_rectangle *krect = file_to_rect(file);
> +	int sig;
> +
> +	switch (a) {
> +	case HARDWALL_CREATE:
> +		if (udn_disabled)
> +			return -ENOSYS;
> +		if (copy_from_user(&rect, (const void __user *) b,
> +				   sizeof(rect)) != 0)
> +			return -EFAULT;
> +		if (krect != NULL)
> +			return -EALREADY;
> +		krect = hardwall_create(&rect);
> +		if (IS_ERR(krect))
> +			return PTR_ERR(krect);
> +		_file_to_rect(file) = krect;
> +		return 0;
> +
> +	case HARDWALL_ACTIVATE:
> +		return hardwall_activate(krect);
> +
> +	case HARDWALL_DEACTIVATE:
> +		if (current->thread.hardwall != krect)
> +			return -EINVAL;
> +		return hardwall_deactivate(current);
> +
> +	case HARDWALL_SIGNAL:
> +		if (krect == NULL)
> +			return -EINVAL;
> +		sig = krect->abort_signal;
> +		if (b >= 0)
> +			krect->abort_signal = b;
> +		return sig;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}

The hardwall stuff looks like it is quite central to your architecture.
Could you elaborate on what it does?

If it is as essential as it looks, I'd vote for promoting the interface
from an ioctl based one to four real system calls (more if necessary).

> +/* Dump a line of data for the seq_file API to print the hardwalls */
> +static int hardwall_show(struct seq_file *m, void *v)
> +{
> +	struct khardwall_rectangle *kr;
> +	struct hardwall_rectangle *r;
> +	struct task_struct *p;
> +	unsigned long flags;
> +
> +	if (udn_disabled) {
> +		if (ptr_to_index(v) == 0)
> +			seq_printf(m, "%dx%d 0,0 pids: 0@0,0\n",
> +				   smp_width, smp_height);
> +		return 0;
> +	}
> +	spin_lock_irqsave(&hardwall_lock, flags);
> +	kr = _nth_rectangle(ptr_to_index(v));
> +	if (kr == NULL) {
> +		spin_unlock_irqrestore(&hardwall_lock, flags);
> +		return 0;
> +	}
> +	r = &kr->rect;
> +	seq_printf(m, "%dx%d %d,%d pids:",
> +		   r->width, r->height, r->ulhc_x, r->ulhc_y);
> +	for_each_hardwall_task(p, &kr->task_head) {
> +		unsigned int cpu = cpumask_first(&p->cpus_allowed);
> +		unsigned int x = cpu % smp_width;
> +		unsigned int y = cpu / smp_width;
> +		seq_printf(m, " %d@%d,%d", p->pid, x, y);
> +	}
> +	seq_printf(m, "\n");
> +	spin_unlock_irqrestore(&hardwall_lock, flags);
> +	return 0;
> +}

Note that the procfs file format is part of your ABI, and this looks
relatively hard to parse, which may introduce bugs.
For per-process information, it would be better to have a simpler
file in each /proc/<pid>/directory. Would that work for you?

> +static int hardwall_open(struct inode *inode, struct file *file)
> +{
> +	/*
> +	 * The standard "proc_reg_file_ops", which we get from
> +	 * create_proc_entry(), does not include a "flush" op.
> +	 * We add it here so that we can deactivate on close.
> +	 * Since proc_reg_file_ops, and all its function pointers,
> +	 * are static in fs/proc/inode.c, we just copy them blindly.
> +	 */
> +	static struct file_operations override_ops;
> +	if (override_ops.open == NULL) {
> +		override_ops = *file->f_op;
> +		BUG_ON(override_ops.open == NULL);
> +		BUG_ON(override_ops.flush != NULL);
> +		override_ops.flush = hardwall_flush;
> +	} else {
> +		BUG_ON(override_ops.open != file->f_op->open);
> +	}
> +	file->f_op = &override_ops;
> +
> +	return seq_open(file, &hardwall_op);
> +}

As you are probably aware of, this is really ugly. Hopefully it
won't be necessary if you can move to actual syscalls.

> +/* Referenced from proc_tile_init() */
> +static const struct file_operations proc_tile_hardwall_fops = {
> +	.open		= hardwall_open,
> +	.ioctl          = hardwall_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl   = hardwall_compat_ioctl,
> +#endif
> +	.flush          = hardwall_flush,
> +	.release        = hardwall_release,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +};

Note that we're about to remove the .ioctl file operation and
replace it with .unlocked_ioctl everywhere. Also, as I mentioned
in the first review round, ioctl on procfs is something you should
never do.

> diff --git a/arch/tile/kernel/hugevmap.c b/arch/tile/kernel/hugevmap.c
> new file mode 100644
> index 0000000..c408666
> --- /dev/null
> +++ b/arch/tile/kernel/hugevmap.c

Not used anywhere apparently. Can you explain what this is good for?
Maybe leave it out for now, until you merge the code that needs it.
I don't see anything obviously wrong with the implementation though.

> diff --git a/arch/tile/kernel/hv_drivers.c b/arch/tile/kernel/hv_drivers.c
> new file mode 100644
> index 0000000..5e69973
> --- /dev/null
> +++ b/arch/tile/kernel/hv_drivers.c

Please have a look at drivers/char/hvc_{rtas,beat,vio,iseries}.c
to see how we do the same for other hypervisors, in a much simpler
way.

> +/*
> + * Interrupt dispatcher, invoked upon a hypervisor device interrupt downcall
> + */
> +void tile_dev_intr(struct pt_regs *regs, int intnum)
> +{
> +	int count;
> +
> +	/*
> +	 * Get the device interrupt pending mask from where the hypervisor
> +	 * has tucked it away for us.
> +	 */
> +	unsigned long pending_dev_intr_mask = __insn_mfspr(SPR_SYSTEM_SAVE_1_3);
> +
> +
> +	/* Track time spent here in an interrupt context. */
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +	irq_enter();
> +
> +	for (count = 0; pending_dev_intr_mask; ++count) {
> +		if (pending_dev_intr_mask & 0x1) {
> +			struct tile_irq_desc *desc = &tile_irq_desc[count];
> +			if (desc->handler == NULL) {
> +				printk(KERN_ERR "Ignoring hv dev interrupt %d;"
> +				       " handler not registered!\n", count);
> +			} else {
> +				desc->handler(desc->dev_id);
> +			}
> +
> +			/* Count device irqs; IPIs are counted elsewhere. */
> +			if (count > HV_MAX_IPI_INTERRUPT)
> +				__get_cpu_var(irq_stat).irq_dev_intr_count++;
> +		}
> +		pending_dev_intr_mask >>= 1;
> +	}

Why the extra indirection for regular interrupts instead of always calling
generic_handle_irq?

> diff --git a/arch/tile/kernel/memprof.c b/arch/tile/kernel/memprof.c
> new file mode 100644
> index 0000000..9424cc5
> --- /dev/null
> +++ b/arch/tile/kernel/memprof.c

I suppose this could get dropped in favor of perf events?

> +/*
> + * These came from asm-tile/io.h, they made the compiler assert when
> + * they were inlined there, but I shouldn't be worried about the
> + * overhead of the function call if they're just calling panic.
> + */
> +
> +u32 inb(u32 addr)
> +{
> +	panic("inb not implemented");
> +}
> +EXPORT_SYMBOL(inb);

If you just remove these definitions, you get a link error for any
driver that tries to use these, which is probably more helpful than
the panic.

OTOH, are you sure that you can't just map the PIO calls to mmio functions
like readb plus some fixed offset? On most non-x86 architectures, the PIO
area of the PCI bus is just mapped to a memory range somewhere.

> +/****************************************************************
> + *
> + * Backward compatible /proc/pci interface.
> + * This is borrowed from 2.6.9, it was dropped by 2.6.18.
> + *
> + * It's good for debugging, in the absence of lspci, but is not
> + * needed for anything to work.
> + *
> + ****************************************************************/

Does this do anything that you can't do with lspci/setpci?
I'd suggest just dropping this again.

> +/*
> + * Support /proc/PID/pgtable
> + */

Do you have applications relying on this? While I can see
how this may be useful, I don't think we should have a
generic interface like this in architecture specific
code.

It also may be used as an attack vector for malicious applications
that have a way of accessing parts of physical memory.

I think it would be better to drop this interface for now.

> +/* Simple /proc/tile files. */
> +SIMPLE_PROC_ENTRY(grid, "%u\t%u\n", smp_width, smp_height)
> +
> +/* More complex /proc/tile files. */
> +static void proc_tile_seq_strconf(struct seq_file *sf, char* what,
> +	uint32_t query)

All of these look like they should be files in various places in
sysfs, e.g. in /sys/devices/system/cpu or /sys/firmware/.
Procfs is not necessarily evil, but most of your uses are for
stuff that actually first very well into what we have in sysfs.

> +SEQ_PROC_ENTRY(memory)
> +static int proc_tile_memory_show(struct seq_file *sf, void *v)
> +{
> +	int node;
> +	int ctrl;
> +	HV_Coord coord = { 0, 0 };
> +	/*
> +	 * We make two passes here; one through our memnodes to display
> +	 * which controllers they correspond with, and one through all
> +	 * controllers to get their speeds.  We may not actually have
> +	 * access to all of the controllers whose speeds we retrieve, but
> +	 * we get them because they're useful for mcstat, which provides
> +	 * stats for physical controllers whether we're using them or not.
> +	 */
> +	for (node = 0; node < MAX_NUMNODES; node++) {
> +		ctrl = node_controller[node];
> +		if (ctrl >= 0)
> +			seq_printf(sf, "controller_%d_node: %d\n", ctrl, node);
> +	}
> +	/*
> +	 * Note that we use MAX_NUMNODES as the limit for the controller
> +	 * loop because we don't have anything better.
> +	 */
> +	for (ctrl = 0; ctrl < MAX_NUMNODES; ctrl++) {
> +		HV_MemoryControllerInfo info =
> +			hv_inquire_memory_controller(coord, ctrl);
> +		if (info.speed)
> +			seq_printf(sf, "controller_%d_speed: %llu\n",
> +				   ctrl, info.speed);
> +	}
> +	return 0;
> +}

This one should probably be split up into files under /sys/devices/system/node/nodeX/

> +#ifdef CONFIG_DATAPLANE
> +SEQ_PROC_ENTRY(dataplane)
> +static int proc_tile_dataplane_show(struct seq_file *sf, void *v)
> +{
> +	int cpu;
> +	int space = 0;
> +	for_each_cpu(cpu, &dataplane_map) {
> +		if (space)
> +			seq_printf(sf, " ");
> +		else
> +			space = 1;
> +		seq_printf(sf, "%d", cpu);
> +	}
> +	if (space)
> +		seq_printf(sf, "\n");
> +	return 0;
> +}
> +#else
> +#define proc_tile_dataplane_init() do {} while (0)
> +#endif

Not sure where in sysfs this would fit best, but I think the format
should match that of the other cpu bitmaps in /sys/devices/system/node.

> +SEQ_PROC_ENTRY(interrupts)
> +static int proc_tile_interrupts_show(struct seq_file *sf, void *v)
> +{
> +	int i;
> +
> +	seq_printf(sf, "%-8s%8s%8s%8s%8s%8s%8s%8s\n", "",
> +		   "timer", "syscall", "resched", "hvflush", "SMPcall",
> +		   "hvmsg", "devintr");
> +
> +	for_each_online_cpu(i) {
> +		irq_cpustat_t *irq = &per_cpu(irq_stat, i);
> +		seq_printf(sf, "%-8d%8d%8d%8d%8d%8d%8d%8d\n", i,
> +			   irq->irq_timer_count,
> +			   irq->irq_syscall_count,
> +			   irq->irq_resched_count,
> +			   irq->irq_hv_flush_count,
> +			   irq->irq_call_count,
> +			   irq->irq_hv_msg_count,
> +			   irq->irq_dev_intr_count);
> +	}
> +	return 0;
> +}

Can you merge this with /proc/interrupts?

> +#ifdef CONFIG_FEEDBACK_COLLECT
> +
> +extern void *__feedback_edges_ptr;
> +extern long __feedback_edges_size;
> +extern void flush_my_deferred_graph(void *dummy);
> +
> +ssize_t feedback_read(struct file *file, char __user *buf, size_t size,
> +		      loff_t *ppos)

This probably belongs into debugfs, similar to what we do
for gcov.

How much of the feedbackl stuff is generic? It might be good
to put those bits in a common place like kernel/feedback.c
so that other architectures can implement this as well.

> +/*
> + * Support /proc/sys/tile directory
> + */
> +
> +
> +static ctl_table unaligned_table[] = {
> +	{
> +		.procname	= "enabled",
> +		.data		= &unaligned_fixup,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec
> +	},
> +	{
> +		.procname	= "printk",
> +		.data		= &unaligned_printk,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec
> +	},
> +	{
> +		.procname	= "count",
> +		.data		= &unaligned_fixup_count,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec
> +	},
> +	{}
> +};
> +
> +
> +static ctl_table tile_root[] = {
> +
> +	{
> +		.procname	= "unaligned_fixup",
> +		.mode		= 0555,
> +		unaligned_table
> +	},

Hmm, similar to what sh64 does, yet different.
Not much of a problem though.

> +	{
> +		.procname	= "crashinfo",
> +		.data		= &show_crashinfo,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec
> +	},
> +	{}
> +};

How is this different from the existing
exception-trace/userprocess_debug sysctl?
If it is very similar, let's not introduce yet another
name for it but just use the common userprocess_debug.

> +
> +#if CHIP_HAS_CBOX_HOME_MAP()
> +static ctl_table hash_default_table[] = {
> +	{
> +		.procname	= "hash_default",
> +		.data		= &hash_default,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0444,
> +		.proc_handler	= &proc_dointvec
> +	},
> +	{}
> +};
> +#endif

This seems to be read-only and coming from a kernel command
line option, so I guess looking at /proc/cmdline would
be a reasonable alternative.

> +long arch_ptrace(struct task_struct *child, long request, long addr, long data)
> +{
> +	unsigned long __user *datap;
> +	unsigned long tmp;
> +	int i;
> +	long ret = -EIO;
> +
> +#ifdef CONFIG_COMPAT
> +	if (task_thread_info(current)->status & TS_COMPAT)
> +		data = (u32)data;
> +	if (task_thread_info(child)->status & TS_COMPAT)
> +		addr = (u32)addr;
> +#endif
> +	datap = (unsigned long __user *)data;
> +
> +	switch (request) {
> +
> +	case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
> +	case PTRACE_POKEUSR:  /* Write register in pt_regs. */
> +	case PTRACE_GETREGS:  /* Get all registers from the child. */
> +	case PTRACE_SETREGS:  /* Set all registers in the child. */
> +	case PTRACE_GETFPREGS:  /* Get the child FPU state. */
> +	case PTRACE_SETFPREGS:  /* Set the child FPU state. */

I believe the new way to do this is to implement
CONFIG_HAVE_ARCH_TRACEHOOK and get all these for free.

> +	case PTRACE_SETOPTIONS:
> +		/* Support TILE-specific ptrace options. */
> +		child->ptrace &= ~PT_TRACE_MASK_TILE;
> +		tmp = data & PTRACE_O_MASK_TILE;
> +		data &= ~PTRACE_O_MASK_TILE;
> +		ret = ptrace_request(child, request, addr, data);
> +		if (tmp & PTRACE_O_TRACEMIGRATE)
> +			child->ptrace |= PT_TRACE_MIGRATE;
> +		break;

It may be better to add this to the common code, possibly
in an #ifdef CONFIG_ARCH_TILE, to make sure we never
get conflicting numbers for future PTRACE_O_* values.

> +SYSCALL_DEFINE3(raise_fpe, int, code, unsigned long, addr,
> +		struct pt_regs *, regs)

Does this need to be a system call? I thought we already had
other architectures without floating point exceptions in hardware
that don't need this.

> diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
> new file mode 100644
> index 0000000..3190bc1
> --- /dev/null
> +++ b/arch/tile/kernel/stack.c
> +/* Callback for backtracer; basically a glorified memcpy */
> +static bool read_memory_func(void *result, VirtualAddress address,
> +			     unsigned int size, void *vkbt)
> +{
> +	int retval;
> +	struct KBacktraceIterator *kbt = (struct KBacktraceIterator *)vkbt;
> +	if (in_kernel_text(address)) {
> +		/* OK to read kernel code. */
> +	} else if (address >= PAGE_OFFSET) {
> +		/* We only tolerate kernel-space reads of this task's stack */
> +		if (!in_kernel_stack(kbt, address))
> +			return 0;
> +	} else if (kbt->pgtable == NULL) {
> +		return 0;	/* can't read user space in other tasks */
> +	} else if (!valid_address(kbt, address)) {
> +		return 0;	/* invalid user-space address */
> +	}
> +	pagefault_disable();
> +	retval = __copy_from_user_inatomic(result, (const void *)address,
> +					   size);
> +	pagefault_enable();
> +	return (retval == 0);
> +}

more backtrace code in stack.c, same comment as above.

> diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
> new file mode 100644
> index 0000000..97fde79
> --- /dev/null
> +++ b/arch/tile/kernel/sys.c
> +/*
> + * Syscalls that pass 64-bit values on 32-bit systems normally
> + * pass them as (low,high) word packed into the immediately adjacent
> + * registers.  If the low word naturally falls on an even register,
> + * our ABI makes it work correctly; if not, we adjust it here.
> + * Handling it here means we don't have to fix uclibc AND glibc AND
> + * any other standard libcs we want to support.
> + */
> +
> +
> +
> +ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count)
> +{
> +	return sys_readahead(fd, ((loff_t)offset_hi << 32) | offset_lo, count);
> +}
> +
> +long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
> +		     u32 len, int advice)
> +{
> +	return sys_fadvise64_64(fd, ((loff_t)offset_hi << 32) | offset_lo,
> +				len, advice);
> +}
> +
> +int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
> +		       u32 len_lo, u32 len_hi, int advice)
> +{
> +	return sys_fadvise64_64(fd, ((loff_t)offset_hi << 32) | offset_lo,
> +				((loff_t)len_hi << 32) | len_lo, advice);
> +}

These seem to belong with the other similar functions in compat.c

> +
> +
> +
> +/*
> + * This API uses a 4KB-page-count offset into the file descriptor.
> + * It is likely not the right API to use on a 64-bit platform.
> + */
> +SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
> +	       unsigned long, prot, unsigned long, flags,
> +	       unsigned int, fd, unsigned long, off_4k)
> +{
> +#define PAGE_ADJUST (PAGE_SHIFT - 12)
> +	if (off_4k & ((1 << PAGE_ADJUST) - 1))
> +		return -EINVAL;
> +	return sys_mmap_pgoff(addr, len, prot, flags, fd,
> +			      off_4k >> PAGE_ADJUST);
> +}
> +
> +/*
> + * This API uses a byte offset into the file descriptor.
> + * It is likely not the right API to use on a 32-bit platform.
> + */
> +SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
> +	      unsigned long, prot, unsigned long, flags,
> +	      unsigned int, fd, unsigned long, offset)
> +{
> +	if (offset & ((1 << PAGE_SHIFT) - 1))
> +		return -EINVAL;
> +	return sys_mmap_pgoff(addr, len, prot, flags, fd,
> +			      offset >> PAGE_SHIFT);
> +}

Just use the sys_mmap_pgoff system call directly, rather than
defining your own wrappers. Since that syscall is newer than
asm-generic/unistd.h, that file might need some changes,
together with fixes to arch/score to make sure we don't break
its ABI.

> diff --git a/arch/tile/kernel/syscall_table.S b/arch/tile/kernel/syscall_table.S
> new file mode 100644
> index 0000000..7fcd160
> --- /dev/null
> +++ b/arch/tile/kernel/syscall_table.S

This file should be replaced with the C variant, as
arch/score/kernel/sys_call_table.c does.

> diff --git a/arch/tile/kernel/tile-desc_32.c b/arch/tile/kernel/tile-desc_32.c
> new file mode 100644
> index 0000000..771eab1
> --- /dev/null
> +++ b/arch/tile/kernel/tile-desc_32.c
> @@ -0,0 +1,13865 @@
> +/* Define to include "bfd.h" and get actual BFD relocations below. */
> +/* #define WANT_BFD_RELOCS */
> +
> +#ifdef WANT_BFD_RELOCS
> +#include "bfd.h"
> +#define MAYBE_BFD_RELOC(X) (X)
> +#else
> +#define MAYBE_BFD_RELOC(X) -1
> +#endif
> +
> +/* Special registers. */
> +#define TREG_LR 55
> +#define TREG_SN 56
> +#define TREG_ZERO 63
> +
> +#if defined(__KERNEL__) || defined(_LIBC)
> +// FIXME: Rename this.
> +#include <asm/opcode-tile.h>
> +#else
> +#include "tile-desc.h"
> +#endif

It seems that this file fits in the same category as the
backtrace code. Maybe move both away from arch/tile/kernel into a
different directory?

> diff --git a/arch/tile/lib/checksum.c b/arch/tile/lib/checksum.c
> new file mode 100644
> index 0000000..a909a35
> --- /dev/null
> +++ b/arch/tile/lib/checksum.c

Have you tried to use the generic lib/checksum.c implementation?

	Arnd
