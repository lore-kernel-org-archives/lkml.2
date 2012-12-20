Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2LTEso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 23:48:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40476 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2LTEsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 23:48:35 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>, Paul Walmsley <paul@pwsan.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: BUG: spinlock bad magic on CPU#0 on BeagleBone
Thread-Topic: BUG: spinlock bad magic on CPU#0 on BeagleBone
Thread-Index: Ac3d19Tuh71R9S9WSuWEzeDZcuyRFQAA2teAAAdYrQAAHJHlkA==
Date: Thu, 20 Dec 2012 04:48:26 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EC9B6FE@DBDE01.ent.ti.com>
References: <B5906170F1614E41A8A28DE3B8D121433EC9A69C@DBDE01.ent.ti.com>
 <alpine.DEB.2.00.1212191650430.16873@utopia.booyaka.com>
 <50D2224E.4060300@codeaurora.org>
In-Reply-To: <50D2224E.4060300@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 01:53:42, Stephen Boyd wrote:
> On 12/19/12 08:53, Paul Walmsley wrote:
> > On Wed, 19 Dec 2012, Bedia, Vaibhav wrote:
> >
> >> Current mainline on Beaglebone using the omap2plus_defconfig + 3 build fixes
> >> is triggering a BUG()
> > ...
> >
> >> [    0.109688] Security Framework initialized
> >> [    0.109889] Mount-cache hash table entries: 512
> >> [    0.112674] BUG: spinlock bad magic on CPU#0, swapper/0/0
> >> [    0.112724]  lock: atomic64_lock+0x240/0x400, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> >> [    0.112782] [<c001af64>] (unwind_backtrace+0x0/0xf0) from [<c02c2010>] (do_raw_spin_lock+0x158/0x198)
> >> [    0.112813] [<c02c2010>] (do_raw_spin_lock+0x158/0x198) from [<c04d89ec>] (_raw_spin_lock_irqsave+0x4c/0x58)
> >> [    0.112844] [<c04d89ec>] (_raw_spin_lock_irqsave+0x4c/0x58) from [<c02cabf0>] (atomic64_add_return+0x30/0x5c)
> >> [    0.112886] [<c02cabf0>] (atomic64_add_return+0x30/0x5c) from [<c0124564>] (alloc_mnt_ns.clone.14+0x44/0xac)
> >> [    0.112914] [<c0124564>] (alloc_mnt_ns.clone.14+0x44/0xac) from [<c0124f4c>] (create_mnt_ns+0xc/0x54)
> >> [    0.112951] [<c0124f4c>] (create_mnt_ns+0xc/0x54) from [<c06f31a4>] (mnt_init+0x120/0x1d4)
> >> [    0.112978] [<c06f31a4>] (mnt_init+0x120/0x1d4) from [<c06f2d50>] (vfs_caches_init+0xe0/0x10c)
> >> [    0.113005] [<c06f2d50>] (vfs_caches_init+0xe0/0x10c) from [<c06d4798>] (start_kernel+0x29c/0x300)
> >> [    0.113029] [<c06d4798>] (start_kernel+0x29c/0x300) from [<80008078>] (0x80008078)
> >> [    0.118290] CPU: Testing write buffer coherency: ok
> >> [    0.118968] CPU0: thread -1, cpu 0, socket -1, mpidr 0
> >> [    0.119053] Setting up static identity map for 0x804de2c8 - 0x804de338
> >> [    0.120698] Brought up 1 CPUs
> > This is probably a memory corruption bug, there's probably some code 
> > executing early that's writing outside its own data and trashing some 
> > previously-allocated memory.
> 
> I'm not so sure. It looks like atomic64s use spinlocks on processors
> that don't have 64-bit atomic instructions (see lib/atomic64.c). And
> those spinlocks are not initialized until a pure initcall runs,
> init_atomic64_lock(). Pure initcalls don't run until after
> vfs_caches_init() and so you get this BUG() warning that the spinlock is
> not initialized.
> 
> How about we initialize the locks statically? Does that fix your problem?
> 
> ---->8-----
> 
> diff --git a/lib/atomic64.c b/lib/atomic64.c
> index 9785378..08a4f06 100644
> --- a/lib/atomic64.c
> +++ b/lib/atomic64.c
> @@ -31,7 +31,11 @@
>  static union {
>         raw_spinlock_t lock;
>         char pad[L1_CACHE_BYTES];
> -} atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
> +} atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp = {
> +       [0 ... (NR_LOCKS - 1)] = {
> +               .lock =  __RAW_SPIN_LOCK_UNLOCKED(atomic64_lock.lock),
> +       },
> +};
>  
>  static inline raw_spinlock_t *lock_addr(const atomic64_t *v)
>  {
> @@ -173,14 +177,3 @@ int atomic64_add_unless(atomic64_t *v, long long a, long long u)
>         return ret;
>  }
>  EXPORT_SYMBOL(atomic64_add_unless);
> -
> -static int init_atomic64_lock(void)
> -{
> -       int i;
> -
> -       for (i = 0; i < NR_LOCKS; ++i)
> -               raw_spin_lock_init(&atomic64_lock[i].lock);
> -       return 0;
> -}
> -
> -pure_initcall(init_atomic64_lock);
> 

I tried out 3 variants of AM335x boards - 2 of these (BeagleBone and EVM) have DDR2
and 1 has DDR3 (EVM-SK). The BUG is triggered on all of these at the same point.

With Stephen's change I don't see this on any of the board variants :)
New bootlog below.

Thanks,
Vaibhav

---


[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.7.0-01415-g55bc169-dirty (a0393953@psplinux063) (gcc version 4.5.3 20110311 (prerelease) (GCC) ) #4 SMP Thu Dec 20 09:59:12 IST 2012
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: TI AM335x BeagleBone
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] AM335X ES1.0 (neon )
[    0.000000] PERCPU: Embedded 9 pages/cpu @c0f1a000 s12992 r8192 d15680 u36864
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768
[    0.000000] Kernel command line: console=ttyO0,115200n8 mem=256M root=/dev/ram rw initrd=0x82000000,16MB ramdisk_size=65536 earlyprintk=serial
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 255MB = 255MB total
[    0.000000] Memory: 229012k/229012k available, 33132k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc06d3f34   (6960 kB)
[    0.000000]       .init : 0xc06d4000 - 0xc07252c0   ( 325 kB)
[    0.000000]       .data : 0xc0726000 - 0xc07b6068   ( 577 kB)
[    0.000000]        .bss : 0xc07b608c - 0xc0d10af0   (5483 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=2 to nr_cpu_ids=1.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with 128 interrupts
[    0.000000] Total of 128 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER1 at 24000000 Hz
[    0.000000] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
[    0.000000] OMAP clocksource: GPTIMER2 at 24000000 Hz
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.001226] Calibrating delay loop... 364.48 BogoMIPS (lpj=1425408)
[    0.109077] pid_max: default: 32768 minimum: 301
[    0.109684] Security Framework initialized
[    0.109889] Mount-cache hash table entries: 512
[    0.122121] CPU: Testing write buffer coherency: ok
[    0.123909] CPU0: thread -1, cpu 0, socket -1, mpidr 0
[    0.124001] Setting up static identity map for 0x804de288 - 0x804de2f8
[    0.127162] Brought up 1 CPUs
[    0.127192] SMP: Total of 1 processors activated (364.48 BogoMIPS).
[    0.206604] pinctrl core: initialized pinctrl subsystem
[...]
