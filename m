Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab2BNDQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:16:52 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:45088 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab2BNDQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:16:48 -0500
MIME-Version: 1.0
In-Reply-To: <3125411.WeeEOF8PnR@f209>
References: <3125411.WeeEOF8PnR@f209>
From: Paul Hartman <paul.hartman@gmail.com>
Date: Mon, 13 Feb 2012 21:16:26 -0600
Message-ID: <CAEH5T2O=r4j9Gm+T0GQuoSz7DQ-Xp9=mO-c6Aub3sou4J3UXYA@mail.gmail.com>
Subject: Re: Deadlock?
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 5:17 AM, Markus <M4rkusXXL@web.de> wrote:
> Hi!
>
> I noted some kind of deadlock, where I was not able to write to the raid6,
> while writing to each disk would still work.
> This caused many processes to "wait" in d-state, thus making it impossible to
> unmount, cleanly reboot, sync, ...

I'm using RAID5 and kernel 3.2.2 and encountered a hang when running
e4defrag on some large files today. When I tried to browse to that
directory in Midnight Commander, it also became D state hung. After
magic sysrq REISUB, raid is resyncing.

I don't know if it's related, or useful, but here's my dmesg output:

[1555304.508443] INFO: task e4defrag:9929 blocked for more than 120 seconds.
[1555304.508446] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555304.508449] e4defrag        D 000000015ccdc212     0  9929  21774
0x00000000
[1555304.508454]  ffff880309b93d38 0000000000000082 ffff880309b93cc8
ffffffff00000000
[1555304.508458]  ffff8801009d0000 0000000000010980 ffff880309b93fd8
ffff880309b92000
[1555304.508463]  0000000000010980 0000000000004000 ffff880309b93fd8
0000000000010980
[1555304.508467] Call Trace:
[1555304.508474]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555304.508480]  [<ffffffff81494f02>] ? _raw_spin_unlock_irqrestore+0x12/0x40
[1555304.508484]  [<ffffffff810319ee>] ? __wake_up+0x4e/0x70
[1555304.508487]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555304.508490]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555304.508493]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555304.508496]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555304.508500]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555304.508504]  [<ffffffff810a77d0>] ? __lock_page+0x70/0x70
[1555304.508507]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555304.508510]  [<ffffffff81492de7>] io_schedule+0x87/0xd0
[1555304.508513]  [<ffffffff810a77d9>] sleep_on_page+0x9/0x10
[1555304.508516]  [<ffffffff814934d7>] __wait_on_bit+0x57/0x80
[1555304.508520]  [<ffffffff810a79fe>] wait_on_page_bit+0x6e/0x80
[1555304.508524]  [<ffffffff8105fb80>] ? autoremove_wake_function+0x40/0x40
[1555304.508528]  [<ffffffff810b2310>] ? pagevec_lookup_tag+0x20/0x30
[1555304.508531]  [<ffffffff810a80ca>] filemap_fdatawait_range+0xfa/0x190
[1555304.508537]  [<ffffffff81116e76>] sys_sync_file_range+0x176/0x180
[1555304.508541]  [<ffffffff81495b7b>] system_call_fastpath+0x16/0x1b
[1555424.340835] INFO: task e4defrag:9929 blocked for more than 120 seconds.
[1555424.340838] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555424.340841] e4defrag        D 000000015ccdc212     0  9929  21774
0x00000000
[1555424.340845]  ffff880309b93d38 0000000000000082 ffff880309b93cc8
ffffffff00000000
[1555424.340850]  ffff8801009d0000 0000000000010980 ffff880309b93fd8
ffff880309b92000
[1555424.340854]  0000000000010980 0000000000004000 ffff880309b93fd8
0000000000010980
[1555424.340859] Call Trace:
[1555424.340866]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555424.340872]  [<ffffffff81494f02>] ? _raw_spin_unlock_irqrestore+0x12/0x40
[1555424.340875]  [<ffffffff810319ee>] ? __wake_up+0x4e/0x70
[1555424.340878]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555424.340881]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555424.340885]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555424.340888]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555424.340891]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555424.340895]  [<ffffffff810a77d0>] ? __lock_page+0x70/0x70
[1555424.340899]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555424.340902]  [<ffffffff81492de7>] io_schedule+0x87/0xd0
[1555424.340905]  [<ffffffff810a77d9>] sleep_on_page+0x9/0x10
[1555424.340908]  [<ffffffff814934d7>] __wait_on_bit+0x57/0x80
[1555424.340911]  [<ffffffff810a79fe>] wait_on_page_bit+0x6e/0x80
[1555424.340916]  [<ffffffff8105fb80>] ? autoremove_wake_function+0x40/0x40
[1555424.340919]  [<ffffffff810b2310>] ? pagevec_lookup_tag+0x20/0x30
[1555424.340923]  [<ffffffff810a80ca>] filemap_fdatawait_range+0xfa/0x190
[1555424.340928]  [<ffffffff81116e76>] sys_sync_file_range+0x176/0x180
[1555424.340932]  [<ffffffff81495b7b>] system_call_fastpath+0x16/0x1b
[1555544.173120] INFO: task jbd2/md2-8:2842 blocked for more than 120 seconds.
[1555544.173123] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555544.173126] jbd2/md2-8      D 000000015cd20110     0  2842      2
0x00000000
[1555544.173131]  ffff88030fba1ce0 0000000000000046 0000000000000002
0000000100000000
[1555544.173136]  ffff88030f9c1650 0000000000010980 ffff88030fba1fd8
ffff88030fba0000
[1555544.173140]  0000000000010980 0000000000004000 ffff88030fba1fd8
0000000000010980
[1555544.173144] Call Trace:
[1555544.173152]  [<ffffffff8100a1b8>] ? native_sched_clock+0x28/0x90
[1555544.173158]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555544.173163]  [<ffffffff811932ac>]
jbd2_journal_commit_transaction+0x17c/0x13a0
[1555544.173166]  [<ffffffff8149259e>] ? __schedule+0x46e/0xa90
[1555544.173171]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555544.173175]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555544.173179]  [<ffffffff8105fb40>] ? wake_up_bit+0x40/0x40
[1555544.173183]  [<ffffffff81197472>] kjournald2+0xb2/0x210
[1555544.173187]  [<ffffffff8105fb40>] ? wake_up_bit+0x40/0x40
[1555544.173190]  [<ffffffff811973c0>] ? commit_timeout+0x10/0x10
[1555544.173194]  [<ffffffff8105f666>] kthread+0x96/0xa0
[1555544.173198]  [<ffffffff81496f74>] kernel_thread_helper+0x4/0x10
[1555544.173204]  [<ffffffff8105f5d0>] ? kthread_worker_fn+0x190/0x190
[1555544.173207]  [<ffffffff81496f70>] ? gs_change+0xb/0xb
[1555544.173231] INFO: task e4defrag:9929 blocked for more than 120 seconds.
[1555544.173233] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555544.173235] e4defrag        D 000000015ccdc212     0  9929  21774
0x00000000
[1555544.173238]  ffff880309b93d38 0000000000000082 ffff880309b93cc8
ffffffff00000000
[1555544.173242]  ffff8801009d0000 0000000000010980 ffff880309b93fd8
ffff880309b92000
[1555544.173245]  0000000000010980 0000000000004000 ffff880309b93fd8
0000000000010980
[1555544.173249] Call Trace:
[1555544.173252]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555544.173256]  [<ffffffff81494f02>] ? _raw_spin_unlock_irqrestore+0x12/0x40
[1555544.173259]  [<ffffffff810319ee>] ? __wake_up+0x4e/0x70
[1555544.173261]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555544.173264]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555544.173267]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555544.173270]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555544.173272]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555544.173276]  [<ffffffff810a77d0>] ? __lock_page+0x70/0x70
[1555544.173279]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555544.173281]  [<ffffffff81492de7>] io_schedule+0x87/0xd0
[1555544.173284]  [<ffffffff810a77d9>] sleep_on_page+0x9/0x10
[1555544.173287]  [<ffffffff814934d7>] __wait_on_bit+0x57/0x80
[1555544.173290]  [<ffffffff810a79fe>] wait_on_page_bit+0x6e/0x80
[1555544.173293]  [<ffffffff8105fb80>] ? autoremove_wake_function+0x40/0x40
[1555544.173296]  [<ffffffff810b2310>] ? pagevec_lookup_tag+0x20/0x30
[1555544.173299]  [<ffffffff810a80ca>] filemap_fdatawait_range+0xfa/0x190
[1555544.173303]  [<ffffffff81116e76>] sys_sync_file_range+0x176/0x180
[1555544.173307]  [<ffffffff81495b7b>] system_call_fastpath+0x16/0x1b
[1555544.173310] INFO: task mc:22249 blocked for more than 120 seconds.
[1555544.173312] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555544.173313] mc              D 000000015cd1eecf     0 22249   9847
0x00000000
[1555544.173317]  ffff8802f7ea9b48 0000000000000082 ffff8802f7ea9a28
0000000000000000
[1555544.173321]  ffff8802fc390000 0000000000010980 ffff8802f7ea9fd8
ffff8802f7ea8000
[1555544.173324]  0000000000010980 0000000000004000 ffff8802f7ea9fd8
0000000000010980
[1555544.173327] Call Trace:
[1555544.173331]  [<ffffffff810b3242>] ? __lru_cache_add+0x72/0xd0
[1555544.173334]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555544.173337]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555544.173339]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555544.173342]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555544.173346]  [<ffffffff811194d0>] ? unmap_underlying_metadata+0x50/0x50
[1555544.173349]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555544.173351]  [<ffffffff81492de7>] io_schedule+0x87/0xd0
[1555544.173354]  [<ffffffff811194d9>] sleep_on_buffer+0x9/0x10
[1555544.173357]  [<ffffffff81493392>] __wait_on_bit_lock+0x52/0xb0
[1555544.173360]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555544.173363]  [<ffffffff811194d0>] ? unmap_underlying_metadata+0x50/0x50
[1555544.173366]  [<ffffffff81493463>] out_of_line_wait_on_bit_lock+0x73/0x90
[1555544.173369]  [<ffffffff8105fb80>] ? autoremove_wake_function+0x40/0x40
[1555544.173372]  [<ffffffff8111a6be>] __lock_buffer+0x2e/0x30
[1555544.173375]  [<ffffffff811924e9>] do_get_write_access+0x5a9/0x6c0
[1555544.173379]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555544.173382]  [<ffffffff81198dc6>] ?
jbd2_journal_add_journal_head+0xd6/0x1f0
[1555544.173385]  [<ffffffff811927dc>] jbd2_journal_get_write_access+0x2c/0x50
[1555544.173389]  [<ffffffff8117e3b9>] __ext4_journal_get_write_access+0x39/0x80
[1555544.173392]  [<ffffffff81164f08>] ext4_reserve_inode_write+0x88/0xb0
[1555544.173395]  [<ffffffff81164f69>] ext4_mark_inode_dirty+0x39/0x1e0
[1555544.173399]  [<ffffffff810ff8a0>] ? filldir64+0xd0/0xd0
[1555544.173402]  [<ffffffff81167148>] ext4_dirty_inode+0x38/0x60
[1555544.173404]  [<ffffffff8111246b>] __mark_inode_dirty+0x3b/0x220
[1555544.173407]  [<ffffffff81106445>] touch_atime+0x115/0x160
[1555544.173410]  [<ffffffff810ffae6>] vfs_readdir+0xb6/0xc0
[1555544.173413]  [<ffffffff810ffbd0>] sys_getdents+0x80/0xe0
[1555544.173416]  [<ffffffff81495b7b>] system_call_fastpath+0x16/0x1b
[1555664.005410] INFO: task jbd2/md2-8:2842 blocked for more than 120 seconds.
[1555664.005413] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555664.005416] jbd2/md2-8      D 000000015cd20110     0  2842      2
0x00000000
[1555664.005421]  ffff88030fba1ce0 0000000000000046 0000000000000002
0000000100000000
[1555664.005426]  ffff88030f9c1650 0000000000010980 ffff88030fba1fd8
ffff88030fba0000
[1555664.005430]  0000000000010980 0000000000004000 ffff88030fba1fd8
0000000000010980
[1555664.005434] Call Trace:
[1555664.005442]  [<ffffffff8100a1b8>] ? native_sched_clock+0x28/0x90
[1555664.005448]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555664.005453]  [<ffffffff811932ac>]
jbd2_journal_commit_transaction+0x17c/0x13a0
[1555664.005456]  [<ffffffff8149259e>] ? __schedule+0x46e/0xa90
[1555664.005462]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555664.005465]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555664.005469]  [<ffffffff8105fb40>] ? wake_up_bit+0x40/0x40
[1555664.005473]  [<ffffffff81197472>] kjournald2+0xb2/0x210
[1555664.005477]  [<ffffffff8105fb40>] ? wake_up_bit+0x40/0x40
[1555664.005480]  [<ffffffff811973c0>] ? commit_timeout+0x10/0x10
[1555664.005483]  [<ffffffff8105f666>] kthread+0x96/0xa0
[1555664.005488]  [<ffffffff81496f74>] kernel_thread_helper+0x4/0x10
[1555664.005492]  [<ffffffff8105f5d0>] ? kthread_worker_fn+0x190/0x190
[1555664.005495]  [<ffffffff81496f70>] ? gs_change+0xb/0xb
[1555664.005521] INFO: task e4defrag:9929 blocked for more than 120 seconds.
[1555664.005523] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555664.005525] e4defrag        D 000000015ccdc212     0  9929  21774
0x00000000
[1555664.005529]  ffff880309b93d38 0000000000000082 ffff880309b93cc8
ffffffff00000000
[1555664.005533]  ffff8801009d0000 0000000000010980 ffff880309b93fd8
ffff880309b92000
[1555664.005537]  0000000000010980 0000000000004000 ffff880309b93fd8
0000000000010980
[1555664.005542] Call Trace:
[1555664.005545]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555664.005549]  [<ffffffff81494f02>] ? _raw_spin_unlock_irqrestore+0x12/0x40
[1555664.005553]  [<ffffffff810319ee>] ? __wake_up+0x4e/0x70
[1555664.005556]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555664.005559]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555664.005562]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555664.005566]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555664.005569]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555664.005573]  [<ffffffff810a77d0>] ? __lock_page+0x70/0x70
[1555664.005576]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555664.005579]  [<ffffffff81492de7>] io_schedule+0x87/0xd0
[1555664.005582]  [<ffffffff810a77d9>] sleep_on_page+0x9/0x10
[1555664.005585]  [<ffffffff814934d7>] __wait_on_bit+0x57/0x80
[1555664.005589]  [<ffffffff810a79fe>] wait_on_page_bit+0x6e/0x80
[1555664.005592]  [<ffffffff8105fb80>] ? autoremove_wake_function+0x40/0x40
[1555664.005596]  [<ffffffff810b2310>] ? pagevec_lookup_tag+0x20/0x30
[1555664.005599]  [<ffffffff810a80ca>] filemap_fdatawait_range+0xfa/0x190
[1555664.005604]  [<ffffffff81116e76>] sys_sync_file_range+0x176/0x180
[1555664.005608]  [<ffffffff81495b7b>] system_call_fastpath+0x16/0x1b
[1555664.005612] INFO: task mc:22249 blocked for more than 120 seconds.
[1555664.005614] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555664.005616] mc              D 000000015cd1eecf     0 22249   9847
0x00000000
[1555664.005620]  ffff8802f7ea9b48 0000000000000082 ffff8802f7ea9a28
0000000000000000
[1555664.005624]  ffff8802fc390000 0000000000010980 ffff8802f7ea9fd8
ffff8802f7ea8000
[1555664.005628]  0000000000010980 0000000000004000 ffff8802f7ea9fd8
0000000000010980
[1555664.005632] Call Trace:
[1555664.005636]  [<ffffffff810b3242>] ? __lru_cache_add+0x72/0xd0
[1555664.005639]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555664.005642]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555664.005646]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555664.005649]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555664.005653]  [<ffffffff811194d0>] ? unmap_underlying_metadata+0x50/0x50
[1555664.005656]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555664.005659]  [<ffffffff81492de7>] io_schedule+0x87/0xd0
[1555664.005663]  [<ffffffff811194d9>] sleep_on_buffer+0x9/0x10
[1555664.005666]  [<ffffffff81493392>] __wait_on_bit_lock+0x52/0xb0
[1555664.005669]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555664.005673]  [<ffffffff811194d0>] ? unmap_underlying_metadata+0x50/0x50
[1555664.005676]  [<ffffffff81493463>] out_of_line_wait_on_bit_lock+0x73/0x90
[1555664.005680]  [<ffffffff8105fb80>] ? autoremove_wake_function+0x40/0x40
[1555664.005684]  [<ffffffff8111a6be>] __lock_buffer+0x2e/0x30
[1555664.005687]  [<ffffffff811924e9>] do_get_write_access+0x5a9/0x6c0
[1555664.005691]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555664.005695]  [<ffffffff81198dc6>] ?
jbd2_journal_add_journal_head+0xd6/0x1f0
[1555664.005698]  [<ffffffff811927dc>] jbd2_journal_get_write_access+0x2c/0x50
[1555664.005703]  [<ffffffff8117e3b9>] __ext4_journal_get_write_access+0x39/0x80
[1555664.005707]  [<ffffffff81164f08>] ext4_reserve_inode_write+0x88/0xb0
[1555664.005710]  [<ffffffff81164f69>] ext4_mark_inode_dirty+0x39/0x1e0
[1555664.005714]  [<ffffffff810ff8a0>] ? filldir64+0xd0/0xd0
[1555664.005717]  [<ffffffff81167148>] ext4_dirty_inode+0x38/0x60
[1555664.005721]  [<ffffffff8111246b>] __mark_inode_dirty+0x3b/0x220
[1555664.005724]  [<ffffffff81106445>] touch_atime+0x115/0x160
[1555664.005728]  [<ffffffff810ffae6>] vfs_readdir+0xb6/0xc0
[1555664.005731]  [<ffffffff810ffbd0>] sys_getdents+0x80/0xe0
[1555664.005734]  [<ffffffff81495b7b>] system_call_fastpath+0x16/0x1b
[1555783.837700] INFO: task jbd2/md2-8:2842 blocked for more than 120 seconds.
[1555783.837703] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1555783.837706] jbd2/md2-8      D 000000015cd20110     0  2842      2
0x00000000
[1555783.837711]  ffff88030fba1ce0 0000000000000046 0000000000000002
0000000100000000
[1555783.837715]  ffff88030f9c1650 0000000000010980 ffff88030fba1fd8
ffff88030fba0000
[1555783.837719]  0000000000010980 0000000000004000 ffff88030fba1fd8
0000000000010980
[1555783.837724] Call Trace:
[1555783.837731]  [<ffffffff8100a1b8>] ? native_sched_clock+0x28/0x90
[1555783.837737]  [<ffffffff81492d4a>] schedule+0x3a/0x50
[1555783.837742]  [<ffffffff811932ac>]
jbd2_journal_commit_transaction+0x17c/0x13a0
[1555783.837746]  [<ffffffff8149259e>] ? __schedule+0x46e/0xa90
[1555783.837751]  [<ffffffff8103a671>] ? get_parent_ip+0x11/0x50
[1555783.837754]  [<ffffffff8103a74d>] ? sub_preempt_count+0x9d/0xd0
[1555783.837759]  [<ffffffff8105fb40>] ? wake_up_bit+0x40/0x40
[1555783.837763]  [<ffffffff81197472>] kjournald2+0xb2/0x210
[1555783.837766]  [<ffffffff8105fb40>] ? wake_up_bit+0x40/0x40
[1555783.837770]  [<ffffffff811973c0>] ? commit_timeout+0x10/0x10
[1555783.837773]  [<ffffffff8105f666>] kthread+0x96/0xa0
[1555783.837777]  [<ffffffff81496f74>] kernel_thread_helper+0x4/0x10
[1555783.837781]  [<ffffffff8105f5d0>] ? kthread_worker_fn+0x190/0x190
[1555783.837784]  [<ffffffff81496f70>] ? gs_change+0xb/0xb
