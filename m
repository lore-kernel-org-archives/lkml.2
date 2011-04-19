Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1DSSH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab1DSSHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:07:55 -0400
Date: Tue, 19 Apr 2011 14:07:45 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: lockdep trace when unplugging usb audio (.39rc4)
Message-ID: <20110419180745.GA438@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this trace when I unplug my NuForce uDAC.

	Dave

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.39-rc4+ #9
-------------------------------------------------------
khubd/21 is trying to acquire lock:
 (register_mutex#4){+.+.+.}, at: [<ffffffffa02f87e4>] snd_pcm_dev_disconnect+0x1e/0xdd [snd_pcm]

but task is already holding lock:
 (&chip->shutdown_mutex){+.+.+.}, at: [<ffffffffa03541fc>] usb_audio_disconnect+0x4a/0x172 [snd_usb_audio]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (&chip->shutdown_mutex){+.+.+.}:
       [<ffffffff81086cdd>] lock_acquire+0xd0/0xfb
       [<ffffffff814ba195>] __mutex_lock_common+0x4c/0x35b
       [<ffffffff814ba568>] mutex_lock_nested+0x3e/0x43
       [<ffffffffa035bea4>] snd_usb_hw_free+0x44/0x6a [snd_usb_audio]
       [<ffffffffa02fce40>] snd_pcm_release_substream+0x44/0x99 [snd_pcm]
       [<ffffffffa02fceff>] snd_pcm_release+0x6a/0xba [snd_pcm]
       [<ffffffff81134171>] fput+0x127/0x1f5
       [<ffffffff8110690e>] remove_vma+0x56/0x87
       [<ffffffff81107c45>] do_munmap+0x2f2/0x30b
       [<ffffffff81107d2b>] sys_munmap+0x49/0x60
       [<ffffffff814c2782>] system_call_fastpath+0x16/0x1b

-> #5 (&pcm->open_mutex){+.+.+.}:
       [<ffffffff81086cdd>] lock_acquire+0xd0/0xfb
       [<ffffffff814ba195>] __mutex_lock_common+0x4c/0x35b
       [<ffffffff814ba568>] mutex_lock_nested+0x3e/0x43
       [<ffffffffa02fcef7>] snd_pcm_release+0x62/0xba [snd_pcm]
       [<ffffffff81134171>] fput+0x127/0x1f5
       [<ffffffff8110690e>] remove_vma+0x56/0x87
       [<ffffffff81107c45>] do_munmap+0x2f2/0x30b
       [<ffffffff81107d2b>] sys_munmap+0x49/0x60
       [<ffffffff814c2782>] system_call_fastpath+0x16/0x1b

-> #4 (&mm->mmap_sem){++++++}:
       [<ffffffff81086cdd>] lock_acquire+0xd0/0xfb
       [<ffffffff81100b94>] might_fault+0x89/0xac
       [<ffffffff811414cb>] filldir+0x6f/0xc7
       [<ffffffff8114ff71>] dcache_readdir+0x67/0x204
       [<ffffffff8114171d>] vfs_readdir+0x78/0xb1
       [<ffffffff8114183c>] sys_getdents+0x7e/0xd1
       [<ffffffff814c2782>] system_call_fastpath+0x16/0x1b

-> #3 (&sb->s_type->i_mutex_key#3){+.+.+.}:
       [<ffffffff81086cdd>] lock_acquire+0xd0/0xfb
       [<ffffffff814ba195>] __mutex_lock_common+0x4c/0x35b
       [<ffffffff814ba568>] mutex_lock_nested+0x3e/0x43
       [<ffffffff8131bed2>] devtmpfs_create_node+0x1c6/0x23f
       [<ffffffff81315da9>] device_add+0x1bb/0x5b3
       [<ffffffff813161bc>] device_register+0x1b/0x1f
       [<ffffffff81316251>] device_create_vargs+0x91/0xc9
       [<ffffffff813162ba>] device_create+0x31/0x33
       [<ffffffff81304a80>] misc_register+0xc1/0x111
       [<ffffffff81d77b0f>] vga_arb_device_init+0x15/0x8e
       [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
       [<ffffffff81d3fcce>] kernel_init+0xf7/0x171
       [<ffffffff814c3924>] kernel_thread_helper+0x4/0x10

-> #2 (&sb->s_type->i_mutex_key#2/1){+.+.+.}:
       [<ffffffff81086cdd>] lock_acquire+0xd0/0xfb
       [<ffffffff814ba195>] __mutex_lock_common+0x4c/0x35b
       [<ffffffff814ba568>] mutex_lock_nested+0x3e/0x43
       [<ffffffff8113cb3d>] lookup_create+0x28/0x99
       [<ffffffff8131be7c>] devtmpfs_create_node+0x170/0x23f
       [<ffffffff81315da9>] device_add+0x1bb/0x5b3
       [<ffffffff813161bc>] device_register+0x1b/0x1f
       [<ffffffff81316251>] device_create_vargs+0x91/0xc9
       [<ffffffff813162ba>] device_create+0x31/0x33
       [<ffffffffa021a445>] snd_register_device_for_dev+0x145/0x1b4 [snd]
       [<ffffffffa025210f>] dell_rfkill_set+0x68/0x9c [dell_laptop]
       [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
       [<ffffffff81091de5>] sys_init_module+0x132/0x283
       [<ffffffff814c2782>] system_call_fastpath+0x16/0x1b

-> #1 (sound_mutex){+.+.+.}:
       [<ffffffff81086cdd>] lock_acquire+0xd0/0xfb
       [<ffffffff814ba195>] __mutex_lock_common+0x4c/0x35b
       [<ffffffff814ba568>] mutex_lock_nested+0x3e/0x43
       [<ffffffffa021a3c7>] snd_register_device_for_dev+0xc7/0x1b4 [snd]
       [<ffffffffa02f8a25>] snd_pcm_dev_register+0x182/0x24a [snd_pcm]
       [<ffffffffa0220273>] snd_device_register_all+0x61/0x81 [snd]
       [<ffffffffa021ae67>] snd_card_register+0x88/0x1bb [snd]
       [<ffffffffa0354b53>] usb_audio_probe+0x67f/0x72c [snd_usb_audio]
       [<ffffffff81377d5c>] usb_probe_interface+0x150/0x1bd
       [<ffffffff813185ca>] driver_probe_device+0x132/0x214
       [<ffffffff8131870a>] __driver_attach+0x5e/0x82
       [<ffffffff8131760a>] bus_for_each_dev+0x59/0x8f
       [<ffffffff813181b3>] driver_attach+0x1e/0x20
       [<ffffffff81317db5>] bus_add_driver+0xd4/0x22a
       [<ffffffff81318bb2>] driver_register+0x98/0x105
       [<ffffffff81376ea3>] usb_register_driver+0xb8/0x17c
       [<ffffffffa0371040>] ipv6_defrag+0x35/0xe1 [nf_defrag_ipv6]
       [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
       [<ffffffff81091de5>] sys_init_module+0x132/0x283
       [<ffffffff814c2782>] system_call_fastpath+0x16/0x1b

-> #0 (register_mutex#4){+.+.+.}:
       [<ffffffff8108656a>] __lock_acquire+0x99e/0xc81
       [<ffffffff81086cdd>] lock_acquire+0xd0/0xfb
       [<ffffffff814ba195>] __mutex_lock_common+0x4c/0x35b
       [<ffffffff814ba568>] mutex_lock_nested+0x3e/0x43
       [<ffffffffa02f87e4>] snd_pcm_dev_disconnect+0x1e/0xdd [snd_pcm]
       [<ffffffffa02201ac>] snd_device_disconnect+0x79/0xdf [snd]
       [<ffffffffa02202fc>] snd_device_disconnect_all+0x69/0x8d [snd]
       [<ffffffffa021b81c>] snd_card_disconnect+0x1a8/0x218 [snd]
       [<ffffffffa0354228>] usb_audio_disconnect+0x76/0x172 [snd_usb_audio]
       [<ffffffff81377854>] usb_unbind_interface+0x5c/0x124
       [<ffffffff8131810a>] __device_release_driver+0x7c/0xd5
       [<ffffffff81318188>] device_release_driver+0x25/0x32
       [<ffffffff81317cd1>] bus_remove_device+0xc4/0xd4
       [<ffffffff813151bd>] device_del+0x13d/0x18b
       [<ffffffff81375aaa>] usb_disable_device+0x8c/0x178
       [<ffffffff8136e406>] usb_disconnect+0xd0/0x135
       [<ffffffff813703e4>] hub_thread+0x741/0x119d
       [<ffffffff81072d21>] kthread+0xa8/0xb0
       [<ffffffff814c3924>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

5 locks held by khubd/21:
 #0:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8136fde6>] hub_thread+0x143/0x119d
 #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8136e3ba>] usb_disconnect+0x84/0x135
 #2:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81318180>] device_release_driver+0x1d/0x32
 #3:  (register_mutex#3){+.+.+.}, at: [<ffffffffa03541f2>] usb_audio_disconnect+0x40/0x172 [snd_usb_audio]
 #4:  (&chip->shutdown_mutex){+.+.+.}, at: [<ffffffffa03541fc>] usb_audio_disconnect+0x4a/0x172 [snd_usb_audio]

stack backtrace:
Pid: 21, comm: khubd Not tainted 2.6.39-rc4+ #9
Call Trace:
 [<ffffffff814b1573>] print_circular_bug+0xa6/0xb5
 [<ffffffff8108656a>] __lock_acquire+0x99e/0xc81
 [<ffffffff81013f1b>] ? save_stack_trace+0x2c/0x49
 [<ffffffffa02f87e4>] ? snd_pcm_dev_disconnect+0x1e/0xdd [snd_pcm]
 [<ffffffff81086cdd>] lock_acquire+0xd0/0xfb
 [<ffffffffa02f87e4>] ? snd_pcm_dev_disconnect+0x1e/0xdd [snd_pcm]
 [<ffffffff8100ec13>] ? native_sched_clock+0x34/0x36
 [<ffffffffa02f87e4>] ? snd_pcm_dev_disconnect+0x1e/0xdd [snd_pcm]
 [<ffffffff814ba195>] __mutex_lock_common+0x4c/0x35b
 [<ffffffffa02f87e4>] ? snd_pcm_dev_disconnect+0x1e/0xdd [snd_pcm]
 [<ffffffff81086f9a>] ? mark_held_locks+0x4b/0x6d
 [<ffffffff814ba67f>] ? __mutex_unlock_slowpath+0x112/0x122
 [<ffffffff810870c7>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff814ba568>] mutex_lock_nested+0x3e/0x43
 [<ffffffffa02f87e4>] snd_pcm_dev_disconnect+0x1e/0xdd [snd_pcm]
 [<ffffffffa02201ac>] snd_device_disconnect+0x79/0xdf [snd]
 [<ffffffffa02202fc>] snd_device_disconnect_all+0x69/0x8d [snd]
 [<ffffffffa021b81c>] snd_card_disconnect+0x1a8/0x218 [snd]
 [<ffffffffa0354228>] usb_audio_disconnect+0x76/0x172 [snd_usb_audio]
 [<ffffffff81377854>] usb_unbind_interface+0x5c/0x124
 [<ffffffff8131810a>] __device_release_driver+0x7c/0xd5
 [<ffffffff81318188>] device_release_driver+0x25/0x32
 [<ffffffff81317cd1>] bus_remove_device+0xc4/0xd4
 [<ffffffff813151bd>] device_del+0x13d/0x18b
 [<ffffffff81375aaa>] usb_disable_device+0x8c/0x178
 [<ffffffff8136e406>] usb_disconnect+0xd0/0x135
 [<ffffffff813703e4>] hub_thread+0x741/0x119d
 [<ffffffff810870f8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81073490>] ? __init_waitqueue_head+0x4b/0x4b
 [<ffffffff8136fca3>] ? usb_remote_wakeup+0x64/0x64
 [<ffffffff81072d21>] kthread+0xa8/0xb0
 [<ffffffff814c3924>] kernel_thread_helper+0x4/0x10
 [<ffffffff814bbfd4>] ? retint_restore_args+0x13/0x13
 [<ffffffff81072c79>] ? __init_kthread_worker+0x5a/0x5a
 [<ffffffff814c3920>] ? gs_change+0x13/0x13

