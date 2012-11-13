Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2KMI0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:26:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58219 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab2KMI0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:26:23 -0500
Message-ID: <50A20429.3020109@suse.cz>
Date: Tue, 13 Nov 2012 09:26:17 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
CC: alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Sound+USB: deadlock problem
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just plugged+unplugged+plugged my USB audio card and the audio
subsystem got stuck:

INFO: task khubd:440 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd           D ffff8801cbc92400     0   440      2 0x00000000
 ffff8801c4ae3a38 0000000000000046 ffff8801c49be270 ffff8801c4ae3fd8
 ffff8801c4ae3fd8 ffff8801c4ae3fd8 ffff8801c4284830 ffff8801c49be270
 ffff8801c4ae3a28 ffff8801a7198758 ffff8801a719875c ffff8801c49be270
Call Trace:
 [<ffffffff816ae109>] schedule+0x29/0x70
 [<ffffffff816ae38e>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff816ad02a>] __mutex_lock_slowpath+0xca/0x140
 [<ffffffff816acb5a>] mutex_lock+0x2a/0x50
 [<ffffffff8157c8e6>] snd_pcm_dev_disconnect+0x46/0x1f0
 [<ffffffff81576512>] snd_device_disconnect+0x62/0xa0
 [<ffffffff815765f4>] snd_device_disconnect_all+0x44/0x70
 [<ffffffff81570d83>] snd_card_disconnect+0x153/0x1d0
 [<ffffffff816ad3a8>] ? down_write+0x38/0x40
 [<ffffffff815bf038>] usb_audio_disconnect+0x88/0x1c0
 [<ffffffff814df460>] usb_unbind_interface+0x60/0x1a0
 [<ffffffff81436e4c>] __device_release_driver+0x7c/0xe0
 [<ffffffff814370bc>] device_release_driver+0x2c/0x40
 [<ffffffff8143681e>] bus_remove_device+0xee/0x160
 [<ffffffff81433c2a>] device_del+0x11a/0x1b0
 [<ffffffff814dce40>] usb_disable_device+0xb0/0x270
 [<ffffffff814d38ed>] usb_disconnect+0xad/0x160
 [<ffffffff814d613e>] hub_thread+0x6fe/0x1700
 [<ffffffff810b643e>] ? dequeue_task_fair+0xee/0x100
 [<ffffffff810a2c70>] ? finish_wait+0x80/0x80
 [<ffffffff814d5a40>] ? usb_remote_wakeup+0x70/0x70
 [<ffffffff810a2620>] kthread+0xc0/0xd0
 [<ffffffff810a2560>] ? kthread_create_on_node+0x130/0x130
 [<ffffffff816afb5c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810a2560>] ? kthread_create_on_node+0x130/0x130
INFO: task pulseaudio:4642 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pulseaudio      D ffff8801cbc12400     0  4642      1 0x00000000
 ffff8801c1c39cf0 0000000000000082 ffff8801c0d7d550 ffff8801c1c39fd8
 ffff8801c1c39fd8 ffff8801c1c39fd8 ffff8801a7203480 ffff8801c0d7d550
 ffff8801aa37b530 ffff8801c0d7d550 ffff8800ab118a48 fffffffeffffffff
Call Trace:
 [<ffffffff816ae109>] schedule+0x29/0x70
 [<ffffffff816aeafd>] rwsem_down_failed_common+0xbd/0x150
 [<ffffffff816aebc5>] rwsem_down_read_failed+0x15/0x17
 [<ffffffff81302c04>] call_rwsem_down_read_failed+0x14/0x30
 [<ffffffff816ad3d4>] ? down_read+0x24/0x2b
 [<ffffffff815c84b2>] snd_usb_hw_free+0x42/0x90
 [<ffffffff815809ab>] snd_pcm_release_substream+0x5b/0xc0
 [<ffffffff81580a58>] snd_pcm_release+0x48/0xb0
 [<ffffffff815707d7>] snd_disconnect_release+0x97/0xe0
 [<ffffffff8116ed8c>] __fput+0xec/0x230
 [<ffffffff8116eede>] ____fput+0xe/0x10
 [<ffffffff8109ef37>] task_work_run+0xa7/0xe0
 [<ffffffff81045959>] do_notify_resume+0x59/0x80
 [<ffffffff816afe08>] int_signal+0x12/0x17
INFO: task khubd:440 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd           D ffff8801cbc92400     0   440      2 0x00000000
 ffff8801c4ae3a38 0000000000000046 ffff8801c49be270 ffff8801c4ae3fd8
 ffff8801c4ae3fd8 ffff8801c4ae3fd8 ffff8801c4284830 ffff8801c49be270
 ffff8801c4ae3a28 ffff8801a7198758 ffff8801a719875c ffff8801c49be270
Call Trace:
 [<ffffffff816ae109>] schedule+0x29/0x70
 [<ffffffff816ae38e>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff816ad02a>] __mutex_lock_slowpath+0xca/0x140
 [<ffffffff816acb5a>] mutex_lock+0x2a/0x50
 [<ffffffff8157c8e6>] snd_pcm_dev_disconnect+0x46/0x1f0
 [<ffffffff81576512>] snd_device_disconnect+0x62/0xa0
 [<ffffffff815765f4>] snd_device_disconnect_all+0x44/0x70
 [<ffffffff81570d83>] snd_card_disconnect+0x153/0x1d0
 [<ffffffff816ad3a8>] ? down_write+0x38/0x40
 [<ffffffff815bf038>] usb_audio_disconnect+0x88/0x1c0
 [<ffffffff814df460>] usb_unbind_interface+0x60/0x1a0
 [<ffffffff81436e4c>] __device_release_driver+0x7c/0xe0
 [<ffffffff814370bc>] device_release_driver+0x2c/0x40
 [<ffffffff8143681e>] bus_remove_device+0xee/0x160
 [<ffffffff81433c2a>] device_del+0x11a/0x1b0
 [<ffffffff814dce40>] usb_disable_device+0xb0/0x270
 [<ffffffff814d38ed>] usb_disconnect+0xad/0x160
 [<ffffffff814d613e>] hub_thread+0x6fe/0x1700
 [<ffffffff810b643e>] ? dequeue_task_fair+0xee/0x100
 [<ffffffff810a2c70>] ? finish_wait+0x80/0x80
 [<ffffffff814d5a40>] ? usb_remote_wakeup+0x70/0x70
 [<ffffffff810a2620>] kthread+0xc0/0xd0
 [<ffffffff810a2560>] ? kthread_create_on_node+0x130/0x130
 [<ffffffff816afb5c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810a2560>] ? kthread_create_on_node+0x130/0x130
sadc            D ffff8801cbc92400     0  7883   7870 0x00000004
 ffff8801b9ab5d98 0000000000000082 ffff8801087b0d20 ffff8801b9ab5fd8
 ffff8801b9ab5fd8 ffff8801b9ab5fd8 ffff8801c487c830 ffff8801087b0d20
 ffff8801c0ca5380 ffff8801b99b08e8 ffff8801b99b08ec ffff8801087b0d20
Call Trace:
 [<ffffffff816ae109>] schedule+0x29/0x70
 [<ffffffff816ae38e>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff816ad02a>] __mutex_lock_slowpath+0xca/0x140
 [<ffffffff816acb5a>] mutex_lock+0x2a/0x50
 [<ffffffff814e312b>] show_manufacturer+0x2b/0x60
 [<ffffffff81433910>] dev_attr_show+0x20/0x60
 [<ffffffff81129707>] ? __get_free_pages+0x17/0x50
 [<ffffffff811d6fc5>] sysfs_read_file+0xa5/0x1c0
 [<ffffffff8116dcb9>] vfs_read+0xa9/0x180
 [<ffffffff8116dde2>] sys_read+0x52/0xa0
 [<ffffffff816afc02>] system_call_fastpath+0x16/0x1b


thanks,
-- 
js
suse labs
