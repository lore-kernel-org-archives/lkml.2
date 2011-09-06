Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1IFOvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:51:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:8838 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab1IFOvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:51:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,338,1312182000"; 
   d="scan'208";a="45987197"
Subject: Re: 3.0.3 kernel BUG at kernel/timer.c:1035
From: Lin Ming <ming.m.lin@intel.com>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <CAF1ivSYui_=tHbxHiy15a9wfiphHcpoY+J1MmAJ=dMQsAfEVLw@mail.gmail.com>
References: <20110824130238.GA24543@janus>
	 <20110902011058.c5bad476.akpm@linux-foundation.org>
	 <20110905123813.GA29763@janus>
	 <CAF1ivSYui_=tHbxHiy15a9wfiphHcpoY+J1MmAJ=dMQsAfEVLw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 06 Sep 2011 22:48:38 +0800
Message-ID: <1315320518.4235.3.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 5, 2011 at 8:38 PM, Frank van Maarseveen <frankvm@frankvm.com> wrote:
> On Fri, Sep 02, 2011 at 01:10:58AM -0700, Andrew Morton wrote:
>> On Wed, 24 Aug 2011 15:02:38 +0200 Frank van Maarseveen <frankvm@frankvm.com> wrote:
>>
>> > Got several of these (logged via netconsole):
>> >
>> >  kernel BUG at kernel/timer.c:1035!
>> >  invalid opcode: 0000 [#1]
>> >  PREEMPT
>> >  SMP
>> >
>> > ...
>> >
>> >  Call Trace:
>> >   [<c107af48>] run_timer_softirq+0x148/0x1e0
>> >   [<c1069265>] ? rebalance_domains+0x135/0x160
>> >   [<c106a28b>] ? get_parent_ip+0xb/0x40
>> >   [<c106a28b>] ? get_parent_ip+0xb/0x40
>> >   [<c1075098>] __do_softirq+0x78/0x100
>> >   [<c1075020>] ? local_bh_enable+0xa0/0xa0
>> >   <IRQ>
>> >
>> >   [<c10753ad>] ? irq_exit+0x5d/0x70
>> >   [<c104df53>] ? smp_apic_timer_interrupt+0x53/0x90
>> >   [<c178fa22>] ? apic_timer_interrupt+0x2a/0x30
>> >   [<c103d3ed>] ? mwait_idle+0x4d/0x80
>> >   [<c1034b0a>] ? cpu_idle+0x3a/0x80
>> >   [<c176dc3b>] ? rest_init+0x7b/0x80
>> >   [<c1b1471b>] ? start_kernel+0x2e2/0x2e8
>> >   [<c1b141c1>] ? loglevel+0x1a/0x1a
>> >   [<c1b140b3>] ? i386_start_kernel+0xb3/0xbb
>> >
>> >
>>
>> Could be that a timer was freed while still running.
>>
>> Please ensure that all kernel debugging options are enabled.
>> Especially
>>
>> CONFIG_DEBUG_OBJECTS=y
>> CONFIG_DEBUG_OBJECTS_SELFTEST=y
>> CONFIG_DEBUG_OBJECTS_FREE=y
>> CONFIG_DEBUG_OBJECTS_TIMERS=y
>> CONFIG_DEBUG_OBJECTS_WORK=y
>> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
>> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
>> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
>> CONFIG_SLUB_DEBUG_ON=y
>>
>> CONFIG_DEBUG_OBJECTS_TIMERS might catch this one.
>
> Got something after enabling the above. Unplugging USB storage
> before umount a couple of times produced the following trace:
>
>        usb 1-7: USB disconnect, device number 10
>        Buffer I/O error on device sdb1, logical block 0
>        lost page write due to I/O error on sdb1
>        ------------[ cut here ]------------
>        WARNING: at lib/debugobjects.c:262 debug_print_object+0x85/0xa0()
>        Hardware name: OptiPlex GX620
>        ODEBUG: free active (active state 0) object type: timer_list hint: wakeup_timer_fn+0x0/0x50

Does below patch help?

>From a98b874437f871d5ecc3f6fe409b2b474b1f2731 Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Tue, 6 Sep 2011 22:45:43 +0800
Subject: [PATCH] block: delete bdi writeback wakup_timer in blk_cleanup_queue()

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 block/blk-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..22529a3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -363,6 +363,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_sync_queue(q);
 
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
+	del_timer_sync(&q->backing_dev_info.wb.wakeup_timer);
 	mutex_lock(&q->sysfs_lock);
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
-- 
1.7.2.3

Regards,
Lin Ming

>        Modules linked in: [last unloaded: scsi_wait_scan]
>        Pid: 5144, comm: umount Not tainted 3.0.4-y264 #1
>        Call Trace:
>        [<c106f59d>] warn_slowpath_common+0x6d/0xa0
>        [<c12b5d75>] ? debug_print_object+0x85/0xa0
>        [<c12b5d75>] ? debug_print_object+0x85/0xa0
>        [<c106f64e>] warn_slowpath_fmt+0x2e/0x30
>        [<c12b5d75>] debug_print_object+0x85/0xa0
>        [<c10d4bf0>] ? bdi_init+0x150/0x150
>        [<c12b5f0a>] __debug_check_no_obj_freed+0xda/0x180
>        [<c106a2fb>] ? get_parent_ip+0xb/0x40
>        [<c12b68c5>] debug_check_no_obj_freed+0x15/0x20
>        [<c10f07ba>] kmem_cache_free+0x9a/0xc0
>        [<c12a9f18>] ? prop_local_destroy_percpu+0x8/0x10
>        [<c10d4e3b>] ? bdi_destroy+0xdb/0x110
>        [<c1299d95>] ? blk_release_queue+0x45/0x50
>        [<c1299d95>] blk_release_queue+0x45/0x50
>        [<c12a756a>] kobject_release+0x3a/0x80
>        [<c12a7530>] ? kobject_del+0x60/0x60
>        [<c12a891d>] kref_put+0x2d/0x60
>        [<c12a747d>] kobject_put+0x1d/0x50
>        [<c1084568>] ? __cancel_work_timer+0x68/0x70
>        [<c129707d>] blk_put_queue+0xd/0x10
>        [<c1465953>] scsi_device_dev_release_usercontext+0xe3/0x120
>        [<c1465870>] ? scsi_device_cls_release+0x10/0x10
>        [<c108432c>] execute_in_process_context+0x5c/0x70
>        [<c1465853>] scsi_device_dev_release+0x13/0x20
>        [<c1440559>] device_release+0x19/0x80
>        [<c10f06f9>] ? kfree+0xc9/0xd0
>        [<c12a7575>] ? kobject_release+0x45/0x80
>        [<c12a756a>] kobject_release+0x3a/0x80
>        [<c12a7530>] ? kobject_del+0x60/0x60
>        [<c12a891d>] kref_put+0x2d/0x60
>        [<c12a747d>] kobject_put+0x1d/0x50
>        [<c12a747d>] ? kobject_put+0x1d/0x50
>        [<c14402ff>] put_device+0xf/0x20
>        [<c145b2f3>] scsi_device_put+0x33/0x50
>        [<c148375b>] scsi_disk_put+0x2b/0x40
>        [<c1483daf>] sd_release+0x2f/0x60
>        [<c11200f0>] __blkdev_put+0x120/0x160
>        [<c11200cd>] __blkdev_put+0xfd/0x160
>        [<c1120153>] blkdev_put+0x23/0x110
>        [<c10f67a0>] kill_block_super+0x40/0x70
>        [<c10f6c0d>] deactivate_locked_super+0x3d/0x60
>        [<c10f72a9>] deactivate_super+0x49/0x70
>        [<c110e1c6>] mntput_no_expire+0x86/0xc0
>        [<c110f10d>] sys_umount+0x5d/0xb0
>        [<c179141c>] sysenter_do_call+0x12/0x2c
>        ---[ end trace ad6863f336beb434 ]---
>
>
> --
> Frank




