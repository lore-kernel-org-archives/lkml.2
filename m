Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab2GPNOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:14:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59843 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753358Ab2GPNOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:14:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Rqz0HOdLR34dZCxL2LgZFsDAwilehh2J8LCWtXp
	4en6ucOvjeH4ZP
Message-ID: <1342436144.7659.58.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 16 Jul 2012 12:55:44 +0200
In-Reply-To: <1342260883.7368.30.camel@marge.simpson.net>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-14 at 12:14 +0200, Mike Galbraith wrote: 
> On Fri, 2012-07-13 at 08:50 -0400, Chris Mason wrote: 
> > On Wed, Jul 11, 2012 at 11:47:40PM -0600, Mike Galbraith wrote:
> > > Greetings,
> > 
> > [ deadlocks with btrfs and the recent RT kernels ]
> > 
> > I talked with Thomas about this and I think the problem is the
> > single-reader nature of the RW rwlocks.  The lockdep report below
> > mentions that btrfs is calling:
> > 
> > > [  692.963099]  [<ffffffff811fabd2>] btrfs_clear_path_blocking+0x32/0x70
> > 
> > In this case, the task has a number of blocking read locks on the btrfs buffers,
> > and we're trying to turn them back into spinning read locks.  Even
> > though btrfs is taking the read rwlock, it doesn't think of this as a new
> > lock operation because we were blocking out new writers.
> > 
> > If the second task has taken the spinning read lock, it is going to
> > prevent that clear_path_blocking operation from progressing, even though
> > it would have worked on a non-RT kernel.
> > 
> > The solution should be to make the blocking read locks in btrfs honor the
> > single-reader semantics.  This means not allowing more than one blocking
> > reader and not allowing a spinning reader when there is a blocking
> > reader.  Strictly speaking btrfs shouldn't need recursive readers on a
> > single lock, so I wouldn't worry about that part.
> > 
> > There is also a chunk of code in btrfs_clear_path_blocking that makes
> > sure to strictly honor top down locking order during the conversion.  It
> > only does this when lockdep is enabled because in non-RT kernels we
> > don't need to worry about it.  For RT we'll want to enable that as well.
> > 
> > I'll give this a shot later today.
> 
> I took a poke at it.  Did I do something similar to what you had in
> mind, or just hide behind performance stealing paranoid trylock loops?
> Box survived 1000 x xfstests 006 and dbench [-s] massive right off the
> bat, so it gets posted despite skepticism.

Seems btrfs isn't entirely convinced either.

[ 2292.336229] use_block_rsv: 1810 callbacks suppressed
[ 2292.336231] ------------[ cut here ]------------
[ 2292.336255] WARNING: at fs/btrfs/extent-tree.c:6344 use_block_rsv+0x17d/0x190 [btrfs]()
[ 2292.336257] Hardware name: System x3550 M3 -[7944K3G]-
[ 2292.336259] btrfs: block rsv returned -28
[ 2292.336260] Modules linked in: joydev st sr_mod ide_gd_mod(N) ide_cd_mod ide_core cdrom ibm_rtl nfsd lockd ipmi_devintf nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_msghandler ipv6 ipv6_lib af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf edd fuse btrfs zlib_deflate ext3 jbd loop dm_mod usbhid hid cdc_ether usbnet mii sg shpchp pci_hotplug pcspkr bnx2 ioatdma i2c_i801 i2c_core tpm_tis tpm tpm_bios serio_raw i7core_edac edac_core button dca iTCO_wdt iTCO_vendor_support ext4 mbcache jbd2 uhci_hcd ehci_hcd sd_mod usbcore rtc_cmos crc_t10dif usb_common fan processor ata_generic ata_piix libata megaraid_sas scsi_mod thermal thermal_sys hwmon
[ 2292.336296] Supported: Yes
[ 2292.336298] Pid: 12975, comm: bonnie Tainted: G        W  N  3.0.35-rt56-rt #27
[ 2292.336300] Call Trace:
[ 2292.336312]  [<ffffffff81004562>] dump_trace+0x82/0x2e0
[ 2292.336320]  [<ffffffff814542b3>] dump_stack+0x69/0x6f
[ 2292.336325]  [<ffffffff8105900b>] warn_slowpath_common+0x7b/0xc0
[ 2292.336330]  [<ffffffff81059105>] warn_slowpath_fmt+0x45/0x50
[ 2292.336342]  [<ffffffffa034db7d>] use_block_rsv+0x17d/0x190 [btrfs]
[ 2292.336389]  [<ffffffffa0350d49>] btrfs_alloc_free_block+0x49/0x240 [btrfs]
[ 2292.336432]  [<ffffffffa033d49e>] __btrfs_cow_block+0x13e/0x510 [btrfs]
[ 2292.336457]  [<ffffffffa033d96f>] btrfs_cow_block+0xff/0x230 [btrfs]
[ 2292.336482]  [<ffffffffa0341ab0>] btrfs_search_slot+0x360/0x7e0 [btrfs]
[ 2292.336513]  [<ffffffffa03567c5>] btrfs_del_csums+0x175/0x2f0 [btrfs]
[ 2292.336562]  [<ffffffffa034a0f0>] __btrfs_free_extent+0x550/0x760 [btrfs]
[ 2292.336599]  [<ffffffffa034a53d>] run_delayed_data_ref+0x9d/0x190 [btrfs]
[ 2292.336636]  [<ffffffffa034f355>] run_clustered_refs+0xd5/0x3a0 [btrfs]
[ 2292.336678]  [<ffffffffa034f768>] btrfs_run_delayed_refs+0x148/0x350 [btrfs]
[ 2292.336723]  [<ffffffffa0362047>] __btrfs_end_transaction+0xb7/0x2b0 [btrfs]
[ 2292.336796]  [<ffffffffa036d153>] btrfs_evict_inode+0x2d3/0x340 [btrfs]
[ 2292.336863]  [<ffffffff81170121>] evict+0x91/0x190
[ 2292.336868]  [<ffffffff81163c07>] do_unlinkat+0x177/0x1f0
[ 2292.336875]  [<ffffffff8145e312>] system_call_fastpath+0x16/0x1b
[ 2292.336881]  [<00007fea187f9e67>] 0x7fea187f9e66
[ 2292.336887] ---[ end trace 0000000000000004 ]---
[ 2610.370398] use_block_rsv: 1947 callbacks suppressed
[ 2610.370400] ------------[ cut here ]------------

> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 4106264..ae47cc2 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -77,7 +77,7 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
>  {
>  	int i;
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +#if (defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PREEMPT_RT_BASE))
>  	/* lockdep really cares that we take all of these spinlocks
>  	 * in the right order.  If any of the locks in the path are not
>  	 * currently blocking, it is going to complain.  So, make really
> @@ -104,7 +104,7 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
>  		}
>  	}
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +#if (defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PREEMPT_RT_BASE))
>  	if (held)
>  		btrfs_clear_lock_blocking_rw(held, held_rw);
>  #endif
> diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
> index 272f911..4db7c14 100644
> --- a/fs/btrfs/locking.c
> +++ b/fs/btrfs/locking.c
> @@ -19,6 +19,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/spinlock.h>
>  #include <linux/page-flags.h>
> +#include <linux/delay.h>
>  #include <asm/bug.h>
>  #include "ctree.h"
>  #include "extent_io.h"
> @@ -97,7 +98,18 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
>  void btrfs_tree_read_lock(struct extent_buffer *eb)
>  {
>  again:
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +	while (atomic_read(&eb->blocking_readers))
> +		cpu_chill();
> +	while(!read_trylock(&eb->lock))
> +		cpu_chill();
> +	if (atomic_read(&eb->blocking_readers)) {
> +		read_unlock(&eb->lock);
> +		goto again;
> +	}
> +#else
>  	read_lock(&eb->lock);
> +#endif
>  	if (atomic_read(&eb->blocking_writers) &&
>  	    current->pid == eb->lock_owner) {
>  		/*
> @@ -131,11 +143,26 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb)
>  	if (atomic_read(&eb->blocking_writers))
>  		return 0;
>  
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +	if (atomic_read(&eb->blocking_readers))
> +		return 0;
> +	while(!read_trylock(&eb->lock))
> +		cpu_chill();
> +#else
>  	read_lock(&eb->lock);
> +#endif
> +
>  	if (atomic_read(&eb->blocking_writers)) {
>  		read_unlock(&eb->lock);
>  		return 0;
>  	}
> +
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +	if (atomic_read(&eb->blocking_readers)) {
> +		read_unlock(&eb->lock);
> +		return 0;
> +	}
> +#endif
>  	atomic_inc(&eb->read_locks);
>  	atomic_inc(&eb->spinning_readers);
>  	return 1;
> 
> 


