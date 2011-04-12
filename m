Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1DLNDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 09:03:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1DLNDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 09:03:22 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
	<BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com>
Date: Tue, 12 Apr 2011 15:03:22 +0200
Message-ID: <BANLkTikTPEb0BwP_Z-t=TvPjdqRZLkp5cw@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 2:44 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> 2011/4/12 Robert Święcki <robert@swiecki.net>:
>> Hi, while fuzzing Linux system calls (32bit fuzzer, 64bi linux
>> kernel), it happens after some time (10-20mins) that some processes
>> enter a state which makes them un-killable. They are either in R or D
>> state.
>>
>> # strace ps wwuax
>> ...
>> ...
>> open("/proc/450/cmdline", O_RDONLY)     = 6
>> read(6,  -             hangs....
>>
>> # kill -9 450
>> # kill -9 450 (no ESRCH)
>>
>> More data in the attachment - I'll keep it in the kdb session for
>> further examination.
>
> Hmm, it must be stuck at
>
> lib/rwsem.c
>
>        /* wait to be given the lock */
>        for (;;) {
>                if (!waiter.task)
>                        break;
>                schedule();
>                set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>        }
>
> don't know why it still can't acquire the ->mmap_sem...

btw, the ps process trying to read /proc/450/cmdline is stuck in

[0]kdb> bt
Stack traceback for pid 6959
0xffff880113334590     6959    18384  0    1   D  0xffff880113334a10  ps
<c> ffff88011f8f9d00<c> 0000000000000082<c> 00000040ffffffff<c>
0000000000000000<c>
<c> ffff88012bffcc08<c> ffff88011f8f8000<c> ffff88011f8f8000<c>
ffff880113334590<c>
<c> ffff88011f8f8010<c> ffff880113334948<c> ffff88011f8f9fd8<c>
ffff88011f8f9fd8<c>
Call Trace:
 [<ffffffff8224f665>] rwsem_down_failed_common+0xc5/0x160
 [<ffffffff8224f735>] rwsem_down_read_failed+0x15/0x17
 [<ffffffff81595694>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff810b31d0>] ? get_task_mm+0x40/0x80
 [<ffffffff8224e957>] ? down_read+0x17/0x20
 [<ffffffff811788eb>] access_process_vm+0x4b/0x1f0
 [<ffffffff8224ffba>] ? _raw_spin_unlock+0x1a/0x40
 [<ffffffff8120b15d>] proc_pid_cmdline+0x6d/0x120
 [<ffffffff811925c1>] ? alloc_pages_current+0xa1/0x100
 [<ffffffff8120bc9d>] proc_info_read+0xad/0xf0
 [<ffffffff811abc55>] vfs_read+0xc5/0x190
 [<ffffffff811abe21>] sys_read+0x51/0x90
 [<ffffffff8104f082>] system_call_fastpath+0x16/0x1b


-- 
Robert Święcki
