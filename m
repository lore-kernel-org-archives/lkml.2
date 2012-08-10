Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab2HJVpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 17:45:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46698 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758605Ab2HJVpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 17:45:38 -0400
MIME-Version: 1.0
X-Originating-IP: [71.62.63.105]
In-Reply-To: <alpine.LNX.2.00.1208101948590.17673@swampdragon.chaosbits.net>
References: <0bac01cd7717$9fa6bbf0$def433d0$@lucidpixels.com>
	<alpine.LNX.2.00.1208101948590.17673@swampdragon.chaosbits.net>
Date: Fri, 10 Aug 2012 17:45:38 -0400
Message-ID: <CAO9zADxocKKFMsf5RqmP+YMjFLj58yDbdqFm1xexQ+mSLb7JHQ@mail.gmail.com>
Subject: Re: Upgraded from 3.4 to 3.5.1 kernel: machine does not boot
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, ap@solarrain.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 1:53 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Fri, 10 Aug 2012, Justin Piszcz wrote:
>
>> Hello,
>>
>> Motherboard: Supermicro X8DTH-6F
>> Distro: Debian Testing x86_64
>>
>> >From 3.4 -> 3.5.1 on x86_64 make oldconfig and a few minor changes and the
>> machine attempts to boot but hangs at the filesystem mounting part of the
>> boot process.

Hi,

Found the root cause, the 3.5.1 kernel cannot mount my ext4 filesystem (60TB).

The 3.4 kernel works fine.

This is proven by commenting out the filesystem in /etc/fstab with
3.5.1, and all is OK.

When I run mount for that filesystem, it hangs, I ran alt+sysrq+t to
get additional output and I have pasted it below with the 3.5.1
kernel:

[  160.373406] mount           R  running task        0  4361   4355 0x00000000
[  160.373407]  ffff8806266bdb68 0000000000000086 ffff8806266bdaa8
ffff8806266bdfd8
[  160.373410]  ffff8806266bdfd8 0000000000004000 ffff8806270b0600
ffff880626c73a10
[  160.373413]  0000000000011240 ffff880c260177c0 ffff880c260177c0
00000000ffffffff
[  160.373415] Call Trace:
[  160.373416]  [<ffffffff816bd009>] ? __schedule+0x299/0x770
[  160.373418]  [<ffffffff81053465>] __cond_resched+0x25/0x40
[  160.373420]  [<ffffffff816bd6ba>] _cond_resched+0x2a/0x40
[  160.373421]  [<ffffffff8115bc09>] ext4_calculate_overhead+0x239/0x3e0
[  160.373425]  [<ffffffff8115d859>] ext4_fill_super+0x1aa9/0x2930
[  160.373427]  [<ffffffff810c677f>] mount_bdev+0x19f/0x1e0
[  160.373429]  [<ffffffff8115bdb0>] ? ext4_calculate_overhead+0x3e0/0x3e0
[  160.373431]  [<ffffffff811579c0>] ext4_mount+0x10/0x20
[  160.373433]  [<ffffffff810c69eb>] mount_fs+0x1b/0xd0
[  160.373434]  [<ffffffff810df2df>] vfs_kern_mount+0x6f/0x110
[  160.373437]  [<ffffffff810df3ff>] do_kern_mount+0x4f/0x100
[  160.373439]  [<ffffffff810e091e>] do_mount+0x2fe/0x8a0
[  160.373440]  [<ffffffff81097053>] ? strndup_user+0x53/0x70
[  160.373442]  [<ffffffff810e0fd0>] sys_mount+0x90/0xe0
[  160.373443]  [<ffffffff816beba6>] system_call_fastpath+0x1a/0x1f
[  160.373446] jbd2/sda1-8     S ffff880c2675f800     0  4362      2 0x00000000
[  160.373448]  ffff880623ca9e50 0000000000000046 ffff880626c73a10
ffff880623ca9fd8
[  160.373450]  ffff880623ca9fd8 0000000000004000 ffff8806271b9850
ffff880626d08250
[  160.373453]  ffff880623ca9da0 ffff8806266bdbe0 ffff880c2675f8a0
ffff880c2675f888
[  160.373455] Call Trace:
[  160.373456]  [<ffffffff81055f9d>] ? default_wake_function+0xd/0x10
[  160.373458]  [<ffffffff8104acf1>] ? autoremove_wake_function+0x11/0x40
[  160.373460]  [<ffffffff810521f5>] ? __wake_up_common+0x55/0x90
[  160.373462]  [<ffffffff816bd504>] schedule+0x24/0x70
[  160.373463]  [<ffffffff81183f8e>] kjournald2+0x1ce/0x1e0
[  160.373465]  [<ffffffff8104ace0>] ? abort_exclusive_wait+0xb0/0xb0
[  160.373467]  [<ffffffff81183dc0>] ? commit_timeout+0x10/0x10
[  160.373469]  [<ffffffff8104a27e>] kthread+0x8e/0xa0
[  160.373471]  [<ffffffff816bfed4>] kernel_thread_helper+0x4/0x10
[  160.373472]  [<ffffffff8104a1f0>] ? kthread_flush_work_fn+0x10/0x10
[  160.373474]  [<ffffffff816bfed0>] ? gs_change+0xb/0xb

Justin.
