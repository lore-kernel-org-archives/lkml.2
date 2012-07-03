Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2GCEez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:34:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:40291 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab2GCEex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:34:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172786939"
Date: Tue, 3 Jul 2012 12:34:50 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Prasad Koya <prasad.koya@gmail.com>
Cc: jack@suse.cz, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sync blocked for long time
Message-ID: <20120703043450.GA8388@localhost>
References: <CAGXD9OfLmSHzikhXxVi7f2wHBVO4det1KHReXc70YkEgYdQTLg@mail.gmail.com>
 <20120703034915.GA7872@localhost>
 <CAGXD9Oc_LD51O2ybkPi4DrO8dyMgG875xH2fUkeNAy2PHRSG0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXD9Oc_LD51O2ybkPi4DrO8dyMgG875xH2fUkeNAy2PHRSG0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 09:10:45PM -0700, Prasad Koya wrote:
> Sorry for missing that important info. Its vfat on both USBs. 2.6.32 is our
> current production kernel and we have hung_task_panic as 1 to detect any

To detect the blocked tasks, /proc/sys/kernel/hung_task_warnings
should be enough. Then you get the warning in dmesg, and can have a
dmesg monitor script to grep for 'task .* blocked for more than .* seconds'.

> such tasks. While trying to reproduce below issue I ran into bottom one.
> Both of them seem to be related to syncing dirty buffers to storage.

It seems being blocked in __bread_slow() waiting for the READ to complete.
I can imagine the READ be delayed by the lots of SYNC writes, however
120 seconds still look way too long..

Thanks,
Fengguang

> <3>[12099840.577044] INFO: task cli_copy:27939 blocked for more than
> 120 seconds.
> <3>[12099840.655175] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> <6>[12099840.751981] Cli           D ffff8800036101c0     0 27939  27567
> 0x00020004
> <4>[12099840.751988]  ffff8800359a3678 0000000000200082 0000000000000000
> 0000000000000000
> <4>[12099840.751995]  ffff8800359a35d8 ffffffff8130e312 ffff8800359a35d8
> ffff8800359a3fd8
> <4>[12099840.752002]  ffff88003e93c2c8 000000000000ca08 00000000000101c0
> 00000000000101c0
> <4>[12099840.752008] Call Trace:
> <4>[12099840.752019]  [<ffffffff8130e312>] ? _spin_lock_irq+0x1f/0x23
> <4>[12099840.752028]  [<ffffffff810ae0cc>] ? sync_buffer+0x0/0x42
> <4>[12099840.752033]  [<ffffffff810ae0cc>] ? sync_buffer+0x0/0x42
> <4>[12099840.752038]  [<ffffffff8130c22e>] io_schedule+0x38/0x4d
> <4>[12099840.752042]  [<ffffffff810ae10a>] sync_buffer+0x3e/0x42
> <4>[12099840.752047]  [<ffffffff8130c6c1>] __wait_on_bit+0x43/0x76
> <4>[12099840.752051]  [<ffffffff8130c75d>] out_of_line_wait_on_bit+0x69/0x74
> <4>[12099840.752056]  [<ffffffff810ae0cc>] ? sync_buffer+0x0/0x42
> <4>[12099840.752063]  [<ffffffff81047f11>] ? wake_bit_function+0x0/0x2e
> <4>[12099840.752068]  [<ffffffff810ae05b>] __wait_on_buffer+0x1f/0x21
> <4>[12099840.752073]  [<ffffffff810b0568>] __bread+0x95/0xad
> <4>[12099840.752079]  [<ffffffff81113b1f>] fat_ent_bread+0x6a/0xab
> <4>[12099840.752084]  [<ffffffff8111320b>] fat_alloc_clusters+0x1fb/0x46c
> <4>[12099840.752092]  [<ffffffff81115e57>] fat_get_block+0x103/0x1da
> <4>[12099840.752097]  [<ffffffff8130e1f8>] ? _spin_unlock+0x13/0x2e
> <4>[12099840.752102]  [<ffffffff810aeded>] __block_prepare_write+0x1b3/0x3b6
> <4>[12099840.752107]  [<ffffffff81115d54>] ? fat_get_block+0x0/0x1da
> <4>[12099840.752113]  [<ffffffff81067b18>] ?
> grab_cache_page_write_begin+0x7e/0xaa
> <4>[12099840.752119]  [<ffffffff810af17e>] block_write_begin+0x7b/0xcd
> <4>[12099840.752124]  [<ffffffff810af4e9>] cont_write_begin+0x319/0x33d
> <4>[12099840.752129]  [<ffffffff81115d54>] ? fat_get_block+0x0/0x1da
> <4>[12099840.752135]  [<ffffffff81116026>] fat_write_begin+0x31/0x33
> <4>[12099840.752139]  [<ffffffff81115d54>] ? fat_get_block+0x0/0x1da
> <4>[12099840.752144]  [<ffffffff810684d0>]
> generic_file_buffered_write+0x107/0x2a1
> <4>[12099840.752151]  [<ffffffff810394da>] ? current_fs_time+0x22/0x29
> <4>[12099840.752156]  [<ffffffff81068b25>] __generic_file_aio_write+0x350/0x385
> <4>[12099840.752161]  [<ffffffff8130cbec>] ? __mutex_lock_slowpath+0x26c/0x294
> <4>[12099840.752167]  [<ffffffff81068bb8>] generic_file_aio_write+0x5e/0xa8
> <4>[12099840.752173]  [<ffffffff8108d05a>] do_sync_write+0xe3/0x120
> <4>[12099840.752178]  [<ffffffff81047edd>] ? autoremove_wake_function+0x0/0x34
> <4>[12099840.752185]  [<ffffffff81080afd>] ? do_mmap_pgoff+0x28b/0x2ee
> <4>[12099840.752190]  [<ffffffff8108d9cb>] vfs_write+0xad/0x14e
> <4>[12099840.752195]  [<ffffffff8108e25b>] ? fget_light+0xae/0xd2
> <4>[12099840.752200]  [<ffffffff8108db25>] sys_write+0x45/0x6c
> <4>[12099840.752206]  [<ffffffff810260c5>] cstar_dispatch+0x7/0x2b
> 
> 
> On Mon, Jul 2, 2012 at 8:49 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > Hi Prasad,
> >
> > On Mon, Jul 02, 2012 at 08:37:19PM -0700, Prasad Koya wrote:
> > > Hi
> > >
> > > Sorry about writing to your personal address. I'm running into below
> > panic
> > > but I couldn't find any patch for this in 2.6.32. I do see below
> > discussion
> > > related to pretty much similar issue which doesn't appear to be
> > resolved. I
> > > looked around quite a bit but I couldn't find any patches for this. Is
> > this
> > > still unresolved? I have 2 USB sticks and I can get into this state by
> > > copying 2 large files (say 200-300M each) simultaneously (followed by
> > sync)
> > > into both drives.
> >
> > That is doing sync lots of data on slow device, with the sync time
> > being further enlarged by the active writers. I can imagine for the
> > sync to take very long time.
> >
> > What's the filesystem btw?
> >
> > > Appreciate any pointers.
> > >
> > > thank you.
> > >
> > > http://marc.info/?t=126596633700002&r=1&w=2
> > >
> > >
> > > <3>[  600.392088] INFO: task sync:2675 blocked for more than 120 seconds.
> > > <3>[  600.466884] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > disables this message.
> > ...
> > > <4>[  600.560507]  [<ffffffff810a7dab>] sync_inodes_sb+0x1d/0xf1
> > > <4>[  600.560519]  [<ffffffff810abb3e>] __sync_filesystem+0x29/0x52
> > > <4>[  600.560536]  [<ffffffff810abc0f>] sync_filesystems+0xa8/0xfe
> > > <4>[  600.560556]  [<ffffffff810abcb5>] sys_sync+0x1c/0x2e
> > > <4>[  600.560570]  [<ffffffff810260c5>] cstar_dispatch+0x7/0x2b
> > > <0>[  600.560580] Kernel panic - not syncing: hung_task: blocked tasks
> >
> > Please check /proc/sys/kernel/hung_task_panic . Normal users should
> > never set it to 1..
> >
> > Thanks,
> > Fengguang
> >
