Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2BDASv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 19:18:51 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65180 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2BDASt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 19:18:49 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 3 Feb 2012 16:18:28 -0800
Message-ID: <CALCETrVYSo+5mHjQp54YFrmHXXf0ugj2N4D4aFek-vMvZ5QD9Q@mail.gmail.com>
Subject: 3.0 does not survive make -j [sic] on a kernel tree
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make clean ; make -j hangs quickly, 100% reproducibly.  The system
answers pings but is otherwise completely unresponsive.  The
softlockup detector output and eventual oom is below.  The system does
not appear to recover.

The correct answer is "don't do that".  But this seems like poor behavior.

[  360.670894] INFO: task make:6625 blocked for more than 120 seconds.
[  360.769657] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.840404] make            D ffff8803fb5cad80  5424  6625   5600 0x00000000
[  360.950314]  ffff8803fd60bbe8 0000000000000082 ffff8803fd60bb78
ffff8803fee10000
[  361.015658]  ffff8803fd60bfd8 ffff8803fd60bcc0 ffff8803fd60bfd8
ffff8803fd60bfd8
[  361.077200]  ffff880179eb59c0 ffff8803fee10000 ffff8803fee10000
000000000000002f
[  361.131155] Call Trace:
[  361.131163]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131166]  [<ffffffff81548a1f>] __mutex_lock_slowpath+0xdf/0x180
[  361.131168]  [<ffffffff815485bd>] mutex_lock+0x1d/0x40
[  361.131172]  [<ffffffff81129692>] do_lookup+0x2b2/0x340
[  361.131175]  [<ffffffff8112abb4>] path_lookupat+0x124/0x6c0
[  361.131179]  [<ffffffff8119b518>] ? htree_dirblock_to_tree+0x108/0x180
[  361.131182]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131185]  [<ffffffff8112b17b>] do_path_lookup+0x2b/0x70
[  361.131187]  [<ffffffff8112ba14>] user_path_at_empty+0x54/0xa0
[  361.131191]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131194]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131196]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131199]  [<ffffffff8112ba6c>] user_path_at+0xc/0x10
[  361.131201]  [<ffffffff8112144f>] vfs_fstatat+0x3f/0x70
[  361.131204]  [<ffffffff8113a48a>] ? mntput+0x1a/0x30
[  361.131206]  [<ffffffff811214b6>] vfs_stat+0x16/0x20
[  361.131209]  [<ffffffff811215c5>] sys_newstat+0x15/0x30
[  361.131213]  [<ffffffff8111abd1>] ? filp_close+0x61/0x90
[  361.131215]  [<ffffffff8111acb1>] ? sys_close+0xb1/0x110
[  361.131218]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  361.131222] INFO: task make:6632 blocked for more than 120 seconds.
[  361.131223] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131225] make            D ffff880364450380  5680  6632   6609 0x00000000
[  361.131229]  ffff8803fd8fdd30 0000000000000082 ffff88040fffae00
ffff8803adc70000
[  361.131232]  ffff8803fd8fdfd8 00000000000280d0 ffff8803fd8fdfd8
ffff8803fd8fdfd8
[  361.131235]  ffff880379b69670 ffff8803adc70000 ffff88040fcd0e40
ffff88040fcd0e40
[  361.131238] Call Trace:
[  361.131240]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131242]  [<ffffffff81548265>] schedule_timeout+0x2d5/0x360
[  361.131245]  [<ffffffff8104415b>] ? hrtick_update+0x4b/0x50
[  361.131248]  [<ffffffff8104d8a6>] ? enqueue_task_fair+0x146/0x3f0
[  361.131252]  [<ffffffff81009036>] ? native_sched_clock+0x26/0x90
[  361.131254]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131256]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131259]  [<ffffffff81547047>] wait_for_common+0xa7/0x150
[  361.131262]  [<ffffffff8104c970>] ? try_to_wake_up+0x2b0/0x2b0
[  361.131264]  [<ffffffff81547198>] wait_for_completion+0x18/0x20
[  361.131266]  [<ffffffff81052e19>] do_fork+0x229/0x300
[  361.131269]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131271]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131273]  [<ffffffff81549db1>] ? _raw_spin_unlock_irq+0x11/0x40
[  361.131276]  [<ffffffff8100a8a0>] sys_vfork+0x20/0x30
[  361.131279]  [<ffffffff81550be3>] stub_vfork+0x13/0x20
[  361.131281]  [<ffffffff8155093b>] ? system_call_fastpath+0x16/0x1b
[  361.131287] INFO: task cc1:6682 blocked for more than 120 seconds.
[  361.131288] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131289] cc1             D ffff880392e3aa00  5408  6682   6656 0x00000000
[  361.131293]  ffff8803addc7c28 0000000000000082 ffff8803addc7bc8
ffff8803ac732ce0
[  361.131296]  ffff8803addc7fd8 0000000000000002 ffff8803addc7fd8
ffff8803addc7fd8
[  361.131299]  ffff88038d409670 ffff8803ac732ce0 ffff8803addc7d08
ffffffff810d6eed
[  361.131301] Call Trace:
[  361.131306]  [<ffffffff810d6eed>] ? __alloc_pages_nodemask+0xfd/0x830
[  361.131308]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131310]  [<ffffffff81548a1f>] __mutex_lock_slowpath+0xdf/0x180
[  361.131312]  [<ffffffff815485bd>] mutex_lock+0x1d/0x40
[  361.131315]  [<ffffffff81129692>] do_lookup+0x2b2/0x340
[  361.131318]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131320]  [<ffffffff81129a38>] do_last.isra.51+0x1d8/0x810
[  361.131323]  [<ffffffff811286c4>] ? path_init+0x174/0x3d0
[  361.131325]  [<ffffffff8112b70f>] path_openat+0xbf/0x370
[  361.131329]  [<ffffffff810f2c7f>] ? handle_mm_fault+0x1cf/0x330
[  361.131331]  [<ffffffff81043be9>] ? perf_event_task_sched_out+0x29/0x90
[  361.131334]  [<ffffffff8112baad>] do_filp_open+0x3d/0xa0
[  361.131336]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131339]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131341]  [<ffffffff81549d30>] ? _raw_spin_unlock+0x10/0x40
[  361.131344]  [<ffffffff81137ffc>] ? alloc_fd+0xec/0x140
[  361.131347]  [<ffffffff8111c2c2>] do_sys_open+0xf2/0x1d0
[  361.131349]  [<ffffffff8111c3bb>] sys_open+0x1b/0x20
[  361.131351]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  361.131356] INFO: task make:6727 blocked for more than 120 seconds.
[  361.131357] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131358] make            D ffff8803fb34c280  5680  6727   5600 0x00000000
[  361.131362]  ffff8803ad2abbe8 0000000000000082 ffff8803ad2b0000
ffff8803ad2b0000
[  361.131365]  ffff8803ad2abfd8 ffff8803ad2abcc0 ffff8803ad2abfd8
ffff8803ad2abfd8
[  361.131368]  ffff880084d7ace0 ffff8803ad2b0000 ffff8803ad2b0000
000000000000002f
[  361.131370] Call Trace:
[  361.131373]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131375]  [<ffffffff81548a1f>] __mutex_lock_slowpath+0xdf/0x180
[  361.131378]  [<ffffffff815485bd>] mutex_lock+0x1d/0x40
[  361.131380]  [<ffffffff81129692>] do_lookup+0x2b2/0x340
[  361.131383]  [<ffffffff8112abb4>] path_lookupat+0x124/0x6c0
[  361.131386]  [<ffffffff8112b17b>] do_path_lookup+0x2b/0x70
[  361.131389]  [<ffffffff8112ba14>] user_path_at_empty+0x54/0xa0
[  361.131392]  [<ffffffff8104c970>] ? try_to_wake_up+0x2b0/0x2b0
[  361.131394]  [<ffffffff8112ba6c>] user_path_at+0xc/0x10
[  361.131396]  [<ffffffff8112144f>] vfs_fstatat+0x3f/0x70
[  361.131398]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131400]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131403]  [<ffffffff811214b6>] vfs_stat+0x16/0x20
[  361.131405]  [<ffffffff811215c5>] sys_newstat+0x15/0x30
[  361.131408]  [<ffffffff81549db1>] ? _raw_spin_unlock_irq+0x11/0x40
[  361.131411]  [<ffffffff8106887d>] ? set_current_blocked+0x4d/0x60
[  361.131415]  [<ffffffff810034ac>] ? math_state_restore+0x2c/0x50
[  361.131417]  [<ffffffff8154ae09>] ? do_device_not_available+0x9/0x10
[  361.131419]  [<ffffffff81551635>] ? device_not_available+0x15/0x20
[  361.131422]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  361.131445] INFO: task cc1:7049 blocked for more than 120 seconds.
[  361.131446] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131447] cc1             D ffff8803fb5a6900  5584  7049   7008 0x00000000
[  361.131451]  ffff88038d675ca8 0000000000000082 ffff8803b015bd40
ffff88038d46ace0
[  361.131453]  ffff88038d675fd8 ffff88038d675d40 ffff88038d675fd8
ffff88038d675fd8
[  361.131456]  ffff88038d412ce0 ffff88038d46ace0 ffff88038d675ce8
ffffffff8112942b
[  361.131459] Call Trace:
[  361.131461]  [<ffffffff8112942b>] ? do_lookup+0x4b/0x340
[  361.131463]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131466]  [<ffffffff81548a1f>] __mutex_lock_slowpath+0xdf/0x180
[  361.131468]  [<ffffffff815485bd>] mutex_lock+0x1d/0x40
[  361.131471]  [<ffffffff81129b75>] do_last.isra.51+0x315/0x810
[  361.131473]  [<ffffffff811286c4>] ? path_init+0x174/0x3d0
[  361.131475]  [<ffffffff8112b70f>] path_openat+0xbf/0x370
[  361.131478]  [<ffffffff810efc14>] ? tlb_flush_mmu+0x64/0x90
[  361.131480]  [<ffffffff8112baad>] do_filp_open+0x3d/0xa0
[  361.131483]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131485]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131488]  [<ffffffff81549d30>] ? _raw_spin_unlock+0x10/0x40
[  361.131490]  [<ffffffff81137ffc>] ? alloc_fd+0xec/0x140
[  361.131493]  [<ffffffff8111c2c2>] do_sys_open+0xf2/0x1d0
[  361.131496]  [<ffffffff8111c3bb>] sys_open+0x1b/0x20
[  361.131498]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  361.131502] INFO: task cc1:7067 blocked for more than 120 seconds.
[  361.131503] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131504] cc1             D ffff880364454980  4336  7067   7020 0x00000000
[  361.131508]  ffff88038d7f1ca8 0000000000000086 ffff8803b01947f0
ffff88038d74c350
[  361.131510]  ffff88038d7f1fd8 ffff88038d7f1d40 ffff88038d7f1fd8
ffff88038d7f1fd8
[  361.131513]  ffff880359a1ace0 ffff88038d74c350 ffff88038d7f1ce8
ffffffff8112942b
[  361.131516] Call Trace:
[  361.131519]  [<ffffffff8112942b>] ? do_lookup+0x4b/0x340
[  361.131521]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131523]  [<ffffffff81548a1f>] __mutex_lock_slowpath+0xdf/0x180
[  361.131526]  [<ffffffff815485bd>] mutex_lock+0x1d/0x40
[  361.131528]  [<ffffffff81129b75>] do_last.isra.51+0x315/0x810
[  361.131530]  [<ffffffff811286c4>] ? path_init+0x174/0x3d0
[  361.131532]  [<ffffffff8112b70f>] path_openat+0xbf/0x370
[  361.131535]  [<ffffffff810efc14>] ? tlb_flush_mmu+0x64/0x90
[  361.131537]  [<ffffffff8112baad>] do_filp_open+0x3d/0xa0
[  361.131539]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131542]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131544]  [<ffffffff81549d30>] ? _raw_spin_unlock+0x10/0x40
[  361.131547]  [<ffffffff81137ffc>] ? alloc_fd+0xec/0x140
[  361.131550]  [<ffffffff8111c2c2>] do_sys_open+0xf2/0x1d0
[  361.131552]  [<ffffffff8111c3bb>] sys_open+0x1b/0x20
[  361.131555]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  361.131558] INFO: task cc1:7085 blocked for more than 120 seconds.
[  361.131560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131561] cc1             D ffff880251086c80  5408  7085   7063 0x00000000
[  361.131564]  ffff880389911c28 0000000000000086 ffff880389911bc8
ffff880389908000
[  361.131567]  ffff880389911fd8 0000000000000002 ffff880389911fd8
ffff880389911fd8
[  361.131570]  ffff880244579670 ffff880389908000 ffff880389911d08
ffffffff810d6eed
[  361.131573] Call Trace:
[  361.131575]  [<ffffffff810d6eed>] ? __alloc_pages_nodemask+0xfd/0x830
[  361.131578]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131580]  [<ffffffff81548a1f>] __mutex_lock_slowpath+0xdf/0x180
[  361.131582]  [<ffffffff815485bd>] mutex_lock+0x1d/0x40
[  361.131585]  [<ffffffff81129692>] do_lookup+0x2b2/0x340
[  361.131588]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131591]  [<ffffffff81129a38>] do_last.isra.51+0x1d8/0x810
[  361.131594]  [<ffffffff811286c4>] ? path_init+0x174/0x3d0
[  361.131596]  [<ffffffff8112b70f>] path_openat+0xbf/0x370
[  361.131599]  [<ffffffff810f2c7f>] ? handle_mm_fault+0x1cf/0x330
[  361.131601]  [<ffffffff81043be9>] ? perf_event_task_sched_out+0x29/0x90
[  361.131603]  [<ffffffff8112baad>] do_filp_open+0x3d/0xa0
[  361.131605]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131608]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131610]  [<ffffffff81549d30>] ? _raw_spin_unlock+0x10/0x40
[  361.131613]  [<ffffffff81137ffc>] ? alloc_fd+0xec/0x140
[  361.131616]  [<ffffffff8111c2c2>] do_sys_open+0xf2/0x1d0
[  361.131619]  [<ffffffff8111c3bb>] sys_open+0x1b/0x20
[  361.131621]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  361.131630] INFO: task cc1:7192 blocked for more than 120 seconds.
[  361.131631] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131633] cc1             D ffff880213621180  5624  7192   7169 0x00000000
[  361.131636]  ffff880379889ca8 0000000000000082 ffff8803b01939b0
ffff880379880000
[  361.131639]  ffff880379889fd8 ffff880379889d40 ffff880379889fd8
ffff880379889fd8
[  361.131642]  ffff88020c5e9670 ffff880379880000 ffff880379889ce8
ffffffff8112942b
[  361.131645] Call Trace:
[  361.131647]  [<ffffffff8112942b>] ? do_lookup+0x4b/0x340
[  361.131650]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131652]  [<ffffffff81548a1f>] __mutex_lock_slowpath+0xdf/0x180
[  361.131654]  [<ffffffff815485bd>] mutex_lock+0x1d/0x40
[  361.131657]  [<ffffffff81129b75>] do_last.isra.51+0x315/0x810
[  361.131660]  [<ffffffff811286c4>] ? path_init+0x174/0x3d0
[  361.131662]  [<ffffffff8112b70f>] path_openat+0xbf/0x370
[  361.131665]  [<ffffffff810efc14>] ? tlb_flush_mmu+0x64/0x90
[  361.131667]  [<ffffffff8112baad>] do_filp_open+0x3d/0xa0
[  361.131669]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131672]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131674]  [<ffffffff81549d30>] ? _raw_spin_unlock+0x10/0x40
[  361.131677]  [<ffffffff81137ffc>] ? alloc_fd+0xec/0x140
[  361.131679]  [<ffffffff8111c2c2>] do_sys_open+0xf2/0x1d0
[  361.131682]  [<ffffffff8111c3bb>] sys_open+0x1b/0x20
[  361.131684]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  361.131690] INFO: task cc1:7244 blocked for more than 120 seconds.
[  361.131691] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131693] cc1             D ffff8803816e5d50  4176  7244   7213 0x00000000
[  361.131696]  ffff8803749b7918 0000000000000086 000000001a052960
ffff8803816e59c0
[  361.131699]  ffff8803749b7fd8 ffffffff8127aa6d ffff8803749b7fd8
ffff8803749b7fd8
[  361.131702]  ffff8801da1face0 ffff8803816e59c0 ffff8803749b7918
ffffffff8107ebf8
[  361.131704] Call Trace:
[  361.131708]  [<ffffffff8127aa6d>] ? generic_make_request+0x24d/0x530
[  361.131711]  [<ffffffff8107ebf8>] ? ktime_get_ts+0xa8/0xe0
[  361.131714]  [<ffffffff81148d10>] ? __wait_on_buffer+0x30/0x30
[  361.131716]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131718]  [<ffffffff81547bda>] io_schedule+0x8a/0xd0
[  361.131720]  [<ffffffff81148d19>] sleep_on_buffer+0x9/0x10
[  361.131722]  [<ffffffff815484e7>] __wait_on_bit+0x57/0x80
[  361.131724]  [<ffffffff8127adc1>] ? submit_bio+0x71/0xe0
[  361.131726]  [<ffffffff81148d10>] ? __wait_on_buffer+0x30/0x30
[  361.131729]  [<ffffffff81548587>] out_of_line_wait_on_bit+0x77/0x90
[  361.131732]  [<ffffffff81074f90>] ? autoremove_wake_function+0x40/0x40
[  361.131735]  [<ffffffff81148d06>] __wait_on_buffer+0x26/0x30
[  361.131737]  [<ffffffff81194427>] ext4_bread+0x57/0x80
[  361.131740]  [<ffffffff8119a525>] ext4_dx_find_entry+0x95/0x270
[  361.131743]  [<ffffffff810d6786>] ? get_page_from_freelist+0x356/0x800
[  361.131746]  [<ffffffff8119ac14>] ext4_find_entry+0x514/0x550
[  361.131749]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131752]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131754]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131757]  [<ffffffff8119ac9d>] ext4_lookup+0x4d/0x130
[  361.131760]  [<ffffffff81127010>] d_alloc_and_lookup+0x40/0x80
[  361.131763]  [<ffffffff81133f00>] ? d_lookup+0x30/0x50
[  361.131765]  [<ffffffff811296b8>] do_lookup+0x2d8/0x340
[  361.131768]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131771]  [<ffffffff81129a38>] do_last.isra.51+0x1d8/0x810
[  361.131774]  [<ffffffff811286c4>] ? path_init+0x174/0x3d0
[  361.131776]  [<ffffffff8112b70f>] path_openat+0xbf/0x370
[  361.131779]  [<ffffffff810f2c7f>] ? handle_mm_fault+0x1cf/0x330
[  361.131781]  [<ffffffff8112baad>] do_filp_open+0x3d/0xa0
[  361.131783]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131786]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131788]  [<ffffffff81549d30>] ? _raw_spin_unlock+0x10/0x40
[  361.131790]  [<ffffffff81137ffc>] ? alloc_fd+0xec/0x140
[  361.131793]  [<ffffffff8111c2c2>] do_sys_open+0xf2/0x1d0
[  361.131796]  [<ffffffff8111c3bb>] sys_open+0x1b/0x20
[  361.131798]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  361.131803] INFO: task cc1:7298 blocked for more than 120 seconds.
[  361.131804] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.131806] cc1             D ffff88012d282680  5440  7298   7280 0x00000000
[  361.131809]  ffff8803816e9c28 0000000000000086 ffff8803816e9bc8
ffff88036be52ce0
[  361.131812]  ffff8803816e9fd8 0000000000000002 ffff8803816e9fd8
ffff8803816e9fd8
[  361.131815]  ffff88011c2e0000 ffff88036be52ce0 ffff8803816e9d08
ffffffff810d6eed
[  361.131818] Call Trace:
[  361.131821]  [<ffffffff810d6eed>] ? __alloc_pages_nodemask+0xfd/0x830
[  361.131823]  [<ffffffff81547b3a>] schedule+0x3a/0x50
[  361.131825]  [<ffffffff81548a1f>] __mutex_lock_slowpath+0xdf/0x180
[  361.131827]  [<ffffffff815485bd>] mutex_lock+0x1d/0x40
[  361.131830]  [<ffffffff81129692>] do_lookup+0x2b2/0x340
[  361.131832]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131835]  [<ffffffff81129a38>] do_last.isra.51+0x1d8/0x810
[  361.131837]  [<ffffffff811286c4>] ? path_init+0x174/0x3d0
[  361.131839]  [<ffffffff8112b70f>] path_openat+0xbf/0x370
[  361.131842]  [<ffffffff810f2c7f>] ? handle_mm_fault+0x1cf/0x330
[  361.131845]  [<ffffffff81043be9>] ? perf_event_task_sched_out+0x29/0x90
[  361.131847]  [<ffffffff8112baad>] do_filp_open+0x3d/0xa0
[  361.131849]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  361.131851]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  361.131854]  [<ffffffff81549d30>] ? _raw_spin_unlock+0x10/0x40
[  361.131856]  [<ffffffff81137ffc>] ? alloc_fd+0xec/0x140
[  361.131859]  [<ffffffff8111c2c2>] do_sys_open+0xf2/0x1d0
[  361.131862]  [<ffffffff8111c3bb>] sys_open+0x1b/0x20
[  361.131864]  [<ffffffff8155093b>] system_call_fastpath+0x16/0x1b
[  686.344217] cc1 invoked oom-killer: gfp_mask=0x280da, order=0,
oom_adj=0, oom_score_adj=0
[  686.414835] cc1 cpuset=/ mems_allowed=0
[  686.447531] Pid: 6616, comm: cc1 Not tainted 3.0.19-ama+ #5
[  686.497424] Call Trace:
[  686.519309]  [<ffffffff810d1bf7>] dump_header.isra.8+0x77/0x1d0
[  686.570092]  [<ffffffff81549b76>] ? _raw_spin_lock+0x16/0x40
[  686.616406]  [<ffffffff81549d72>] ? _raw_spin_unlock_irqrestore+0x12/0x40
[  686.677085]  [<ffffffff81294383>] ? ___ratelimit+0x93/0x110
[  686.734385]  [<ffffffff810d25bf>] out_of_memory+0x39f/0x570
[  686.789455]  [<ffffffff810d7601>] __alloc_pages_nodemask+0x811/0x830
[  686.843396]  [<ffffffff8110cda5>] alloc_pages_vma+0x95/0x150
[  686.892093]  [<ffffffff810f2747>] handle_pte_fault+0x627/0x850
[  686.946043]  [<ffffffff810f7337>] ? vma_adjust+0x537/0x570
[  686.992879]  [<ffffffff810c8070>] ? __perf_event_task_sched_out+0x40/0x280
[  687.052696]  [<ffffffff810f2c7f>] handle_mm_fault+0x1cf/0x330
[  687.100233]  [<ffffffff81043be9>] ? perf_event_task_sched_out+0x29/0x90
[  687.157883]  [<ffffffff8154cb0c>] do_page_fault+0x12c/0x520
[  687.204080]  [<ffffffff8104ac81>] ? get_parent_ip+0x11/0x50
[  687.253905]  [<ffffffff8154cf9d>] ? sub_preempt_count+0x9d/0xd0
[  687.302261]  [<ffffffff815475d2>] ? __schedule+0x432/0x900
[  687.350780]  [<ffffffff8154a40f>] page_fault+0x1f/0x30
[  687.405700] Mem-Info:
[  687.424777] Node 0 DMA per-cpu:
[  687.453319] CPU    0: hi:    0, btch:   1 usd:   0
[  687.494623] CPU    1: hi:    0, btch:   1 usd:   0
[  687.536159] CPU    2: hi:    0, btch:   1 usd:   0
[  687.576114] CPU    3: hi:    0, btch:   1 usd:   0
[  687.616300] CPU    4: hi:    0, btch:   1 usd:   0
[  687.661121] CPU    5: hi:    0, btch:   1 usd:   0
[  687.703229] CPU    6: hi:    0, btch:   1 usd:   0
[  687.744105] CPU    7: hi:    0, btch:   1 usd:   0
[  687.783526] Node 0 DMA32 per-cpu:
[  687.813467] CPU    0: hi:  186, btch:  31 usd:   0
[  687.853440] CPU    1: hi:  186, btch:  31 usd:   0
[  687.893696] CPU    2: hi:  186, btch:  31 usd:   0
[  687.934050] CPU    3: hi:  186, btch:  31 usd:   0
[  687.981205] CPU    4: hi:  186, btch:  31 usd:   0
[  688.022472] CPU    5: hi:  186, btch:  31 usd:   0
[  688.062870] CPU    6: hi:  186, btch:  31 usd:   0
[  688.103163] CPU    7: hi:  186, btch:  31 usd:   0
[  688.145459] Node 0 Normal per-cpu:
[  688.174478] CPU    0: hi:  186, btch:  31 usd:   0
[  688.214201] CPU    1: hi:  186, btch:  31 usd:  30
[  688.255562] CPU    2: hi:  186, btch:  31 usd:   0
[  688.297012] CPU    3: hi:  186, btch:  31 usd:   0
[  688.337106] CPU    4: hi:  186, btch:  31 usd:  30
[  688.378636] CPU    5: hi:  186, btch:  31 usd:   0
[  688.427676] CPU    6: hi:  186, btch:  31 usd:   0
[  688.467827] CPU    7: hi:  186, btch:  31 usd:   0
[  688.510035] active_anon:3171485 inactive_anon:413121 isolated_anon:10893
[  688.510036]  active_file:318 inactive_file:337 isolated_file:26
[  688.510037]  unevictable:0 dirty:4 writeback:422058 unstable:0
[  688.510037]  free:33002 slab_reclaimable:4574 slab_unreclaimable:112788
[  688.510038]  mapped:7 shmem:6 pagetables:50076 bounce:0
[  688.782444] Node 0 DMA free:15860kB min:64kB low:80kB high:96kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15652kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[  689.109064] lowmem_reserve[]: 0 3734 16106 16106
[  689.148154] Node 0 DMA32 free:64736kB min:15652kB low:19564kB
high:23476kB active_anon:2943656kB inactive_anon:635156kB
active_file:0kB inactive_file:8kB unevictable:0kB
isolated(anon):5888kB isolated(file):104kB present:3824048kB
mlocked:0kB dirty:4kB writeback:640564kB mapped:0kB shmem:0kB
slab_reclaimable:1072kB slab_unreclaimable:108356kB
kernel_stack:3296kB pagetables:29180kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:2213936 all_unreclaimable? no
[  689.507198] lowmem_reserve[]: 0 0 12372 12372
[  689.545231] Node 0 Normal free:51288kB min:51864kB low:64828kB
high:77796kB active_anon:9742284kB inactive_anon:1022284kB
active_file:1272kB inactive_file:1340kB unevictable:0kB
isolated(anon):30640kB isolated(file):0kB present:12669436kB
mlocked:0kB dirty:12kB writeback:1047668kB mapped:28kB shmem:24kB
slab_reclaimable:17224kB slab_unreclaimable:342784kB
kernel_stack:27048kB pagetables:171124kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:23039309 all_unreclaimable? yes
[  689.913966] lowmem_reserve[]: 0 0 0 0
[  689.945676] Node 0 DMA: 1*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB
1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15860kB
[  690.048679] Node 0 DMA32: 2496*4kB 1524*8kB 746*16kB 305*32kB
152*64kB 33*128kB 3*256kB 0*512kB 0*1024kB 1*2048kB 1*4096kB = 64736kB
[  690.154801] Node 0 Normal: 6174*4kB 2720*8kB 30*16kB 8*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 51288kB
[  690.250791] 424155 total pagecache pages
[  690.285379] 423468 pages in swap cache
[  690.316786] Swap cache stats: add 477716, delete 54248, find 1433/1436
[  690.373598] Free swap  = 14866748kB
[  690.401225] Total swap = 16777212kB
[  690.454446] 4194287 pages RAM
[  690.481487] 86133 pages reserved
[  690.508778] 12599 pages shared
[  690.535285] 3799451 pages non-shared
[  690.566871] [ pid ]   uid  tgid total_vm      rss cpu oom_adj
oom_score_adj name
[  690.630830] [ 1255]     0  1255     4274        0   7       0
      0 upstart-udev-br
[  690.704679] [ 1259]     0  1259     5316        1   7     -17
  -1000 udevd
[  690.770091] [ 1483]     0  1483     3762        0   7       0
      0 upstart-socket-
[  690.858070] [ 1492]     0  1492     4766        0   7       0
      0 rpcbind
[  690.924113] [ 1701]   101  1701    29568        0   7       0
      0 rsyslogd
[  690.991959] [ 1790]   102  1790     6038        0   7       0
      0 dbus-daemon
[  691.066023] [ 1794]     0  1794     6349        0   6       0
      0 rpc.idmapd
[  691.131915] [ 1798]     0  1798    11784       61   7       0
      0 munin-node
[  691.199205] [ 3049]     0  3049     1066        5   7       0
      0 ntpdate
[  691.266383] [ 3058]     0  3058    12421        0   7     -17
  -1000 sshd
[  691.326175] [ 3127]     0  3127     1045        0   0       0
      0 getty
[  691.391736] [ 3133]     0  3133     1045        0   4       0
      0 getty
[  691.462029] [ 3168]     0  3168     1045        0   0       0
      0 getty
[  691.529478] [ 3170]     0  3170     1045        0   3       0
      0 getty
[  691.595524] [ 3176]     0  3176     1045        0   2       0
      0 getty
[  691.658492] [ 3187]     0  3187     4744        0   7       0
      0 cron
[  691.729448] [ 3188]     0  3188     4194        0   0       0
      0 atd
[  691.792454] [ 3218]   105  3218    42948      818   0       0
      0 mysqld
[  691.854899] [ 3226]     0  3226     3962        1   7       0
      0 irqbalance
[  691.923980] [ 3353]     0  3353    38294        0   7       0
      0 hpasmlited
[  691.993249] [ 3468]     0  3468    20283       13   7       0
      0 apache2
[  692.060159] [ 3485]    33  3485    76142        1   6       0
      0 apache2
[  692.128273] [ 3486]    33  3486    76142        1   7       0
      0 apache2
[  692.194291] [ 3732]     0  3732     1547        0   7       0
      0 latencytopd
[  692.260938] [ 3734]     0  3734     1045        0   7       0
      0 getty
[  692.324327] [ 3980]     0  3980     5382        1   7     -17
  -1000 udevd
[  692.387169] [ 3981]     0  3981     5315        0   7     -17
  -1000 udevd
[  692.453235] [ 4176]     0  4176    18784        3   7       0
      0 sshd
[  692.528870] [ 4202]  1000  4202    18784       20   7       0
      0 sshd
[  692.591152] [ 4203]  1000  4203     7563        1   7       0
      0 bash
[  692.655775] [ 4460]     0  4460     1045        0   7       0
      0 getty
[  692.723558] [ 5600]  1000  5600     3113        1   7       0
      0 make
[  692.788362] [ 6502]     0  6502     1556        0   7       0
      0 lockfile-touch
[  692.860618] [ 6596]  1000  6596     2949        1   7       0
      0 make
[  692.938351] [ 6601]  1000  6601     2919        0   5       0
      0 make
[  693.002503] [ 6605]  1000  6605     1068        0   7       0
      0 sh
[  693.065718] [ 6608]  1000  6608     1839        0   7       0
      0 gcc
[  693.133019] [ 6609]  1000  6609     2951        0   6       0
      0 make
[  693.194018] [ 6611]  1000  6611     1068        0   3       0
      0 sh
[  693.258054] [ 6613]  1000  6613     1067        0   6       0
      0 sh
[  693.319310] [ 6614]  1000  6614     1067        0   0       0
      0 sh
[  693.382107] [ 6615]  1000  6615     1839        0   3       0
      0 gcc
[  693.446211] [ 6616]  1000  6616    14737     4271   6       0
      0 cc1
[  693.510351] [ 6617]  1000  6617     1838        0   1       0
      0 gcc
[  693.584388] [ 6620]  1000  6620     4691        0   7       0
      0 as
[  693.644574] [ 6621]  1000  6621     3602       23   5       0
      0 bash
[  693.714070] [ 6624]  1000  6624     1068        0   3       0
      0 sh
[  693.774403] [ 6625]  1000  6625     3170      135   5       0
      0 make
[  693.835635] [ 6627]  1000  6627    14168     4183   2       0
      0 cc1
[  693.901134] [ 6628]  1000  6628     2921        0   7       0
      0 make
[  693.963465] [ 6629]  1000  6629     1839        0   3       0
      0 gcc
[  694.025949] [ 6630]  1000  6630     4691        0   3       0
      0 as
[  694.088928] [ 6631]  1000  6631     2927        0   5       0
      0 make
[  694.152988] [ 6632]  1000  6632     3105      194   6       0
      0 make
[  694.217626] [ 6633]  1000  6633     1068        0   2       0
      0 sh
[  694.277547] [ 6634]  1000  6634     9602      420   2       0
      0 cc1
[  694.340841] [ 6635]  1000  6635     3009        1   1       0
      0 make
[  694.402716] [ 6637]  1000  6637    13669     3835   4       0
      0 cc1
[  694.464632] [ 6639]  1000  6639     3003       17   4       0
      0 make
[  694.531920] [ 6640]  1000  6640     1839        0   2       0
      0 gcc
[  694.603801] [ 6641]  1000  6641     2925        0   3       0
      0 make
[  694.665076] [ 6642]  1000  6642     4691        0   6       0
      0 as
[  694.731861] [ 6643]  1000  6643     1068        0   5       0
      0 sh
[  694.793448] [ 6648]  1000  6648     3102       95   5       0
      0 make
[  694.854712] [ 6650]  1000  6650     1068        0   1       0
      0 sh
[  694.925501] [ 6652]  1000  6652     1068        0   7       0
      0 sh
[  694.996766] [ 6654]  1000  6654    12452     3839   0       0
      0 cc1
[  695.061816] [ 6656]  1000  6656     1839        0   2       0
      0 gcc
[  695.122409] [ 6657]  1000  6657     2920        0   2       0
      0 make
[  695.190468] [ 6658]  1000  6658     1839        0   5       0
      0 gcc
[  695.251513] [ 6660]  1000  6660     1068        0   5       0
      0 sh
[  695.313397] [ 6661]  1000  6661     4691        0   2       0
      0 as

[etc.]
