Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1JaEfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 00:35:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52859 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1JaEfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 00:35:30 -0400
MIME-Version: 1.0
In-Reply-To: <1319676161.22361.148.camel@sli10-conroe>
References: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
	<CANejiEWBpeiBKvg+_W5OC0onQQLpAFCsgADWW1mTutUWF9ZQfA@mail.gmail.com>
	<CADAg6uy7iDG1QxHd=5hX7J=9dYGLA+Ze1uE6WwF7Nfxc83T4hA@mail.gmail.com>
	<1319676161.22361.148.camel@sli10-conroe>
Date: Mon, 31 Oct 2011 10:05:29 +0530
Message-ID: <CADAg6uy2xOoAaAhVg07oYia+AZAuOGKywPGx8fvT0EF4ThuKCQ@mail.gmail.com>
Subject: Re: Multi-partition block layer behaviour
From: Tiju Jacob <jacobtiju@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 6:12 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Wed, 2011-10-26 at 18:10 +0800, Tiju Jacob wrote:
>> >> 1. When an I/O request is made to the filesystem, process 'A' acquires
>> >> a mutex FS lock and a mutex block driver lock.
>> >>
>> >> 2. Process 'B' tries to acquire the mutex FS lock, which is not
>> >> available. Hence, it goes to sleep. Due to the new plugging mechanism,
>> >> before going to sleep, shcedule() is invoked which disables preemption
>> >> and the context becomes atomic. In schedule(), the newly added
>> >> blk_flush_plug_list() is invoked which unplugs the block driver.
>> >>
>> >> 3) During unplug operation the block driver tries to acquire the mutex
>> >> lock which fails, because the lock was held by process 'A'. Previous
>> >> invocation of scheudle() in step 2 has already made the context as
>> >> atomic, hence the error "Schedule while atomic" occured.
>> > if blk_flush_plug_list() is called in schedule(), it will use
>> > blk_run_queue_async
>> > to unplug the queue. This runs in a workqueue. So how could this happen?
>> >
>>
>> The call stack goes as follows:
>>
>> From schedule() it calls blk_schedule_flush_plug()  and
>> blk_flush_plug_list() gets invoked.
>>
>> In blk_flush_plug_list() queue_unplugged() does not get invoked. Hence
>>  blk_run_queue_async is not called.
>> Instead __elv_add_request() is invoked with ELEVATOR_INSERT_SORT_MERGE
>> flag and the flag gets reassigned to ELEVATOR_INSERT_BACK.
>>
>> In ELEVATOR_INSERT_BACK, __blk_run_queue() gets invoked and calls request_fn().

> This doesn't make sense. why the flag is changed from
> ELEVATOR_INSERT_SORT_MERGE to ELEVATOR_INSERT_BACK?

In  __elv_add_request() "where" gets reassigned as follows:

	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
		    (where == ELEVATOR_INSERT_SORT ||
		     where == ELEVATOR_INSERT_SORT_MERGE))
		where = ELEVATOR_INSERT_BACK;

>	
> can you post a full log? or did your driver have something special?

Our driver doesn't have anything special. Our FTL driver works fine
with linux kernels 2.6.38 and prior 2.6 kernels. This error occurs
from 2.6.39 onwards.
However, here's the log.

.....
.....
BUG: scheduling while atomic: fsstress.fork_n/498/0x00000002
Modules linked in: fs_fat(P) fs_glue(P) ftl_driver(P) fsr(P)
[<c0042e30>] (unwind_backtrace+0x0/0xec) from [<c031e234>] (schedule+0x54/0x3ec)
[<c031e234>] (schedule+0x54/0x3ec) from [<c031f884>]
(__mutex_lock_slowpath+0x174/0x294)
[<c031f884>] (__mutex_lock_slowpath+0x174/0x294) from [<c031f9b0>]
(mutex_lock+0xc/0x20)
[<c031f9b0>] (mutex_lock+0xc/0x20) from [<bf062b50>]
(ftl_request+0x264/0x3c0 [ftl_driver])
[<bf062b50>] (ftl_request+0x264/0x3c0 [ftl_driver]) from [<c01c1d6c>]
(__blk_run_queue+0x1c/0x24)
[<c01c1d6c>] (__blk_run_queue+0x1c/0x24) from [<c01c11a8>]
(__elv_add_request+0x1ec/0x248)
[<c01c11a8>] (__elv_add_request+0x1ec/0x248) from [<c01c3bbc>]
(blk_flush_plug_list+0x1b4/0x204)
[<c01c3bbc>] (blk_flush_plug_list+0x1b4/0x204) from [<c031e3a0>]
(schedule+0x1c0/0x3ec)
[<c031e3a0>] (schedule+0x1c0/0x3ec) from [<c016acb8>]
(start_this_handle+0x318/0x50c)
[<c016acb8>] (start_this_handle+0x318/0x50c) from [<c016b0ac>]
(jbd2__journal_start+0xa8/0xd8)
[<c016b0ac>] (jbd2__journal_start+0xa8/0xd8) from [<c0148114>]
(ext4_journal_start_sb+0x110/0x128)
[<c0148114>] (ext4_journal_start_sb+0x110/0x128) from [<c013bb54>]
(_ext4_get_block+0x74/0x138)
[<c013bb54>] (_ext4_get_block+0x74/0x138) from [<c00f2d5c>]
(__blockdev_direct_IO+0x594/0xc1c)
[<c00f2d5c>] (__blockdev_direct_IO+0x594/0xc1c) from [<c013e208>]
(ext4_direct_IO+0x120/0x214)
[<c013e208>] (ext4_direct_IO+0x120/0x214) from [<c0097d48>]
(generic_file_direct_write+0x120/0x208)
[<c0097d48>] (generic_file_direct_write+0x120/0x208) from [<c00981f0>]
(__generic_file_aio_write+0x3c0/0x4f4)
[<c00981f0>] (__generic_file_aio_write+0x3c0/0x4f4) from [<c0098390>]
(generic_file_aio_write+0x6c/0xdc)
[<c0098390>] (generic_file_aio_write+0x6c/0xdc) from [<c0135d58>]
(ext4_file_write+0x268/0x2dc)
[<c0135d58>] (ext4_file_write+0x268/0x2dc) from [<c00c3ec0>]
(do_sync_write+0x9c/0xe8)
[<c00c3ec0>] (do_sync_write+0x9c/0xe8) from [<c00c4704>] (vfs_write+0xb0/0x13c)
[<c00c4704>] (vfs_write+0xb0/0x13c) from [<c00c4c98>] (sys_write+0x3c/0x68)
[<c00c4c98>] (sys_write+0x3c/0x68) from [<c003d4a0>] (ret_fast_syscall+0x0/0x30)
.....
.....
.....
