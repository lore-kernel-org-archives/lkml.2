Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1IEMiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:38:21 -0400
Received: from frankvm.xs4all.nl ([83.163.148.79]:38966 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751912Ab1IEMiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:38:16 -0400
Date: Mon, 5 Sep 2011 14:38:14 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.0.3 kernel BUG at kernel/timer.c:1035
Message-ID: <20110905123813.GA29763@janus>
References: <20110824130238.GA24543@janus>
 <20110902011058.c5bad476.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902011058.c5bad476.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 01:10:58AM -0700, Andrew Morton wrote:
> On Wed, 24 Aug 2011 15:02:38 +0200 Frank van Maarseveen <frankvm@frankvm.com> wrote:
> 
> > Got several of these (logged via netconsole):
> > 
> >  kernel BUG at kernel/timer.c:1035!
> >  invalid opcode: 0000 [#1]
> >  PREEMPT
> >  SMP
> > 
> > ...
> >
> >  Call Trace:
> >   [<c107af48>] run_timer_softirq+0x148/0x1e0
> >   [<c1069265>] ? rebalance_domains+0x135/0x160
> >   [<c106a28b>] ? get_parent_ip+0xb/0x40
> >   [<c106a28b>] ? get_parent_ip+0xb/0x40
> >   [<c1075098>] __do_softirq+0x78/0x100
> >   [<c1075020>] ? local_bh_enable+0xa0/0xa0
> >   <IRQ>
> > 
> >   [<c10753ad>] ? irq_exit+0x5d/0x70
> >   [<c104df53>] ? smp_apic_timer_interrupt+0x53/0x90
> >   [<c178fa22>] ? apic_timer_interrupt+0x2a/0x30
> >   [<c103d3ed>] ? mwait_idle+0x4d/0x80
> >   [<c1034b0a>] ? cpu_idle+0x3a/0x80
> >   [<c176dc3b>] ? rest_init+0x7b/0x80
> >   [<c1b1471b>] ? start_kernel+0x2e2/0x2e8
> >   [<c1b141c1>] ? loglevel+0x1a/0x1a
> >   [<c1b140b3>] ? i386_start_kernel+0xb3/0xbb
> > 
> > 
> 
> Could be that a timer was freed while still running.
> 
> Please ensure that all kernel debugging options are enabled. 
> Especially 
> 
> CONFIG_DEBUG_OBJECTS=y
> CONFIG_DEBUG_OBJECTS_SELFTEST=y
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> CONFIG_DEBUG_OBJECTS_WORK=y
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> CONFIG_SLUB_DEBUG_ON=y
> 
> CONFIG_DEBUG_OBJECTS_TIMERS might catch this one.

Got something after enabling the above. Unplugging USB storage
before umount a couple of times produced the following trace:

	usb 1-7: USB disconnect, device number 10
	Buffer I/O error on device sdb1, logical block 0
	lost page write due to I/O error on sdb1
	------------[ cut here ]------------
	WARNING: at lib/debugobjects.c:262 debug_print_object+0x85/0xa0()
	Hardware name: OptiPlex GX620               
	ODEBUG: free active (active state 0) object type: timer_list hint: wakeup_timer_fn+0x0/0x50
	Modules linked in: [last unloaded: scsi_wait_scan]
	Pid: 5144, comm: umount Not tainted 3.0.4-y264 #1
	Call Trace:
	[<c106f59d>] warn_slowpath_common+0x6d/0xa0
	[<c12b5d75>] ? debug_print_object+0x85/0xa0
	[<c12b5d75>] ? debug_print_object+0x85/0xa0
	[<c106f64e>] warn_slowpath_fmt+0x2e/0x30
	[<c12b5d75>] debug_print_object+0x85/0xa0
	[<c10d4bf0>] ? bdi_init+0x150/0x150
	[<c12b5f0a>] __debug_check_no_obj_freed+0xda/0x180
	[<c106a2fb>] ? get_parent_ip+0xb/0x40
	[<c12b68c5>] debug_check_no_obj_freed+0x15/0x20
	[<c10f07ba>] kmem_cache_free+0x9a/0xc0
	[<c12a9f18>] ? prop_local_destroy_percpu+0x8/0x10
	[<c10d4e3b>] ? bdi_destroy+0xdb/0x110
	[<c1299d95>] ? blk_release_queue+0x45/0x50
	[<c1299d95>] blk_release_queue+0x45/0x50
	[<c12a756a>] kobject_release+0x3a/0x80
	[<c12a7530>] ? kobject_del+0x60/0x60
	[<c12a891d>] kref_put+0x2d/0x60
	[<c12a747d>] kobject_put+0x1d/0x50
	[<c1084568>] ? __cancel_work_timer+0x68/0x70
	[<c129707d>] blk_put_queue+0xd/0x10
	[<c1465953>] scsi_device_dev_release_usercontext+0xe3/0x120
	[<c1465870>] ? scsi_device_cls_release+0x10/0x10
	[<c108432c>] execute_in_process_context+0x5c/0x70
	[<c1465853>] scsi_device_dev_release+0x13/0x20
	[<c1440559>] device_release+0x19/0x80
	[<c10f06f9>] ? kfree+0xc9/0xd0
	[<c12a7575>] ? kobject_release+0x45/0x80
	[<c12a756a>] kobject_release+0x3a/0x80
	[<c12a7530>] ? kobject_del+0x60/0x60
	[<c12a891d>] kref_put+0x2d/0x60
	[<c12a747d>] kobject_put+0x1d/0x50
	[<c12a747d>] ? kobject_put+0x1d/0x50
	[<c14402ff>] put_device+0xf/0x20
	[<c145b2f3>] scsi_device_put+0x33/0x50
	[<c148375b>] scsi_disk_put+0x2b/0x40
	[<c1483daf>] sd_release+0x2f/0x60
	[<c11200f0>] __blkdev_put+0x120/0x160
	[<c11200cd>] __blkdev_put+0xfd/0x160
	[<c1120153>] blkdev_put+0x23/0x110
	[<c10f67a0>] kill_block_super+0x40/0x70
	[<c10f6c0d>] deactivate_locked_super+0x3d/0x60
	[<c10f72a9>] deactivate_super+0x49/0x70
	[<c110e1c6>] mntput_no_expire+0x86/0xc0
	[<c110f10d>] sys_umount+0x5d/0xb0
	[<c179141c>] sysenter_do_call+0x12/0x2c
	---[ end trace ad6863f336beb434 ]---


-- 
Frank
