Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1IENbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:31:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:48189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab1IENbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:31:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,333,1312182000"; 
   d="scan'208";a="45695159"
Date: Mon, 5 Sep 2011 21:31:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] D state process after unplug and umount usb disk
Message-ID: <20110905133135.GA6124@localhost>
References: <CABqxG0dM27pmAiajtwAFeBVgc=U+2KaaLCYH9wxOdcW=vbku_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqxG0dM27pmAiajtwAFeBVgc=U+2KaaLCYH9wxOdcW=vbku_A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 03, 2011 at 06:31:11PM +0800, Dave Young wrote:
> Hi,
> 
> Known issue?
> 
> Reproduce by:
> mount /dev/sdb2 /mnt/sdb2 -t ext3
> cat /mnt/sdb2/* >/dev/null
> unplug usb disk
> umount -f /mnt/sdb2

When I do the above sequence on a normal disk, umount will rightfully
fail. So the error is specific to unplugging a mounted USB disk.

root@fat /home/wfg# mount /dev/sda7 /fs/sda7
root@fat /home/wfg# ls /fs/sda7
root@fat /home/wfg# cp /dev/zero /fs/sda7&
[1] 7900
root@fat /home/wfg# cat /fs/sda7/* > /dev/null&; umount -f /fs/sda7
[2] 7909
umount2: Device or resource busy
umount: /fs/sda7: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount2: Device or resource busy

> dmesg as below:
> 
> [ 1440.567271] SysRq : Show Blocked State
> [ 1440.567278]   task                        PC stack   pid father
> [ 1440.567312] cat             D ffff880037a1e378  4296  2381   2310 0x00000004
> [ 1440.567320]  ffff88003cca5838 0000000000000046 ffff88003cca57e8
> ffffffff00000000
> [ 1440.567332]  00000000000134c0 00000000000134c0 00000000000134c0
> ffff880037a1e000
> [ 1440.567339]  00000000000134c0 ffff88003cca5fd8 00000000000134c0
> 00000000000134c0
> [ 1440.567347] Call Trace:
> [ 1440.567357]  [<ffffffff810c0468>] ? lock_page+0x2a/0x2a
> [ 1440.567363]  [<ffffffff815e452d>] io_schedule+0x5e/0x79
> [ 1440.567368]  [<ffffffff810c0471>] sleep_on_page+0x9/0xd
> [ 1440.567373]  [<ffffffff815e4adf>] __wait_on_bit_lock+0x41/0x8a
> [ 1440.567378]  [<ffffffff810c0437>] __lock_page+0x61/0x68
> [ 1440.567384]  [<ffffffff81058739>] ? autoremove_wake_function+0x34/0x34
> [ 1440.567390]  [<ffffffff8102f704>] ? should_resched+0x9/0x29

> [ 1440.567395]  [<ffffffff810c9b0b>] lock_page+0x25/0x29
> [ 1440.567400]  [<ffffffff810ca1ac>] truncate_inode_pages_range+0x2a6/0x32d
> [ 1440.567406]  [<ffffffff810ca240>] truncate_inode_pages+0xd/0xf

Maybe the page is locked for read IO somewhere else, which never
managed to complete due to the unplugged USB disk?

This can be (not strictly) confirmed by running this and check if
there are locked and !uptodate pages:

        page-types -lr -b locked

If so the root cause should be, the IO requests are stuck rather than
being failed after some timeout value.

Thanks,
Fengguang

> [ 1440.567411]  [<ffffffff811642cf>] ext3_evict_inode+0xc9/0x1d7
> [ 1440.567417]  [<ffffffff8111288e>] evict+0xa3/0x15e
> [ 1440.567422]  [<ffffffff81112b34>] dispose_list+0x3d/0x49
> [ 1440.567426]  [<ffffffff81113475>] evict_inodes+0xf1/0x100
> [ 1440.567431]  [<ffffffff810ffd21>] generic_shutdown_super+0x47/0xc7
> [ 1440.567436]  [<ffffffff810ffdc3>] kill_block_super+0x22/0x65
> [ 1440.567441]  [<ffffffff811000da>] deactivate_locked_super+0x21/0x52
> [ 1440.567445]  [<ffffffff811009ab>] deactivate_super+0x35/0x39
> [ 1440.567452]  [<ffffffff81116395>] mntput_no_expire+0xcb/0xd0
> [ 1440.567457]  [<ffffffff811163bb>] mntput+0x21/0x23
> [ 1440.567461]  [<ffffffff810ff8e7>] fput+0x196/0x1a5
> [ 1440.567467]  [<ffffffff810fc7a1>] filp_close+0x6b/0x76
> [ 1440.567472]  [<ffffffff8103fa8a>] put_files_struct+0x73/0xd1
> [ 1440.567477]  [<ffffffff8103fb7b>] exit_files+0x46/0x4f
> [ 1440.567481]  [<ffffffff8103fe01>] do_exit+0x27d/0x7b3
> [ 1440.567487]  [<ffffffff8104d97f>] ? get_signal_to_deliver+0x81/0x4ac
> [ 1440.567493]  [<ffffffff812e5e27>] ? do_raw_spin_lock+0x6b/0x122
> [ 1440.567497]  [<ffffffff810405c5>] do_group_exit+0x7d/0xa8
> [ 1440.567502]  [<ffffffff8104dd8b>] get_signal_to_deliver+0x48d/0x4ac
> [ 1440.567509]  [<ffffffff81001ea2>] do_signal+0x39/0x600
> [ 1440.567514]  [<ffffffff810fdb37>] ? fsnotify_access+0x5d/0x65
> [ 1440.567519]  [<ffffffff810024a4>] do_notify_resume+0x27/0x69
> [ 1440.567524]  [<ffffffff812e158e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1440.567529]  [<ffffffff815ecd63>] int_signal+0x12/0x17
> [ 1440.710163] INFO: task cat:2381 blocked for more than 120 seconds.
> [ 1440.710170] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 1440.710175] cat             D ffff880037a1e378  4296  2381   2310 0x00000004
> [ 1440.710188]  ffff88003cca5838 0000000000000046 ffff88003cca57e8
> ffffffff00000000
> [ 1440.710201]  00000000000134c0 00000000000134c0 00000000000134c0
> ffff880037a1e000
> [ 1440.710218]  00000000000134c0 ffff88003cca5fd8 00000000000134c0
> 00000000000134c0
> [ 1440.710225] Call Trace:
> [ 1440.710233]  [<ffffffff810c0468>] ? lock_page+0x2a/0x2a
> [ 1440.710239]  [<ffffffff815e452d>] io_schedule+0x5e/0x79
> [ 1440.710244]  [<ffffffff810c0471>] sleep_on_page+0x9/0xd
> [ 1440.710249]  [<ffffffff815e4adf>] __wait_on_bit_lock+0x41/0x8a
> [ 1440.710253]  [<ffffffff810c0437>] __lock_page+0x61/0x68
> [ 1440.710259]  [<ffffffff81058739>] ? autoremove_wake_function+0x34/0x34
> [ 1440.710264]  [<ffffffff8102f704>] ? should_resched+0x9/0x29
> [ 1440.710269]  [<ffffffff810c9b0b>] lock_page+0x25/0x29
> [ 1440.710274]  [<ffffffff810ca1ac>] truncate_inode_pages_range+0x2a6/0x32d
> [ 1440.710279]  [<ffffffff810ca240>] truncate_inode_pages+0xd/0xf
> [ 1440.710284]  [<ffffffff811642cf>] ext3_evict_inode+0xc9/0x1d7
> [ 1440.710289]  [<ffffffff8111288e>] evict+0xa3/0x15e
> [ 1440.710294]  [<ffffffff81112b34>] dispose_list+0x3d/0x49
> [ 1440.710299]  [<ffffffff81113475>] evict_inodes+0xf1/0x100
> [ 1440.710303]  [<ffffffff810ffd21>] generic_shutdown_super+0x47/0xc7
> [ 1440.710308]  [<ffffffff810ffdc3>] kill_block_super+0x22/0x65
> [ 1440.710312]  [<ffffffff811000da>] deactivate_locked_super+0x21/0x52
> [ 1440.710316]  [<ffffffff811009ab>] deactivate_super+0x35/0x39
> [ 1440.710322]  [<ffffffff81116395>] mntput_no_expire+0xcb/0xd0
> [ 1440.710326]  [<ffffffff811163bb>] mntput+0x21/0x23
> [ 1440.710330]  [<ffffffff810ff8e7>] fput+0x196/0x1a5
> [ 1440.710335]  [<ffffffff810fc7a1>] filp_close+0x6b/0x76
> [ 1440.710342]  [<ffffffff8103fa8a>] put_files_struct+0x73/0xd1
> [ 1440.710346]  [<ffffffff8103fb7b>] exit_files+0x46/0x4f
> [ 1440.710350]  [<ffffffff8103fe01>] do_exit+0x27d/0x7b3
> [ 1440.710356]  [<ffffffff8104d97f>] ? get_signal_to_deliver+0x81/0x4ac
> [ 1440.710361]  [<ffffffff812e5e27>] ? do_raw_spin_lock+0x6b/0x122
> [ 1440.710366]  [<ffffffff810405c5>] do_group_exit+0x7d/0xa8
> [ 1440.710371]  [<ffffffff8104dd8b>] get_signal_to_deliver+0x48d/0x4ac
> [ 1440.710376]  [<ffffffff81001ea2>] do_signal+0x39/0x600
> [ 1440.710381]  [<ffffffff810fdb37>] ? fsnotify_access+0x5d/0x65
> [ 1440.710386]  [<ffffffff810024a4>] do_notify_resume+0x27/0x69
> [ 1440.710391]  [<ffffffff812e158e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1440.710396]  [<ffffffff815ecd63>] int_signal+0x12/0x17
> [ 1440.710399] INFO: lockdep is turned off.
> 
> -- 
> Regards
> Yang RuiRui
