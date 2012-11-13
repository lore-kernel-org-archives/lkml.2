Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2KMJjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:39:22 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40538 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2KMJjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:39:18 -0500
Message-ID: <50A21542.2090102@suse.cz>
Date: Tue, 13 Nov 2012 10:39:14 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Sound+USB: deadlock problem
References: <50A20429.3020109@suse.cz> <s5ha9ulx5xe.wl%tiwai@suse.de> <50A20512.10805@suse.cz> <s5h7gppx568.wl%tiwai@suse.de>
In-Reply-To: <s5h7gppx568.wl%tiwai@suse.de>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 09:45 AM, Takashi Iwai wrote:
> At Tue, 13 Nov 2012 09:30:10 +0100,
> Jiri Slaby wrote:
>>
>> On 11/13/2012 09:28 AM, Takashi Iwai wrote:
>>> At Tue, 13 Nov 2012 09:26:17 +0100,
>>> Jiri Slaby wrote:
>>>>
>>>> Hello,
>>>>
>>>> I've just plugged+unplugged+plugged my USB audio card and the audio
>>>> subsystem got stuck:
>>>
>>> Which kernel?  If it's older than 3.7-rc5, could you try 3.7-rc5?
>>
>> Oh, forgot to mention:
>> 3.7.0-rc5-next-20121112_64+
> 
> Through a quick glance, one of mutex locks seems stuck.
> Just a blind short -- does the patch below cure the problem?

Yes, this helps.

Adding a LOCKDEP splash _before_ applying the patch:
======================================================
[ INFO: possible circular locking dependency detected ]
3.7.0-rc5-next-20121112_64-ldep+ #15 Not tainted
-------------------------------------------------------
khubd/446 is trying to acquire lock:
 (&pcm->open_mutex){+.+.+.}, at: [<ffffffff8154c555>]
snd_pcm_dev_disconnect+0x45/0x1f0

but task is already holding lock:
 (register_mutex#2){+.+.+.}, at: [<ffffffff8154c533>]
snd_pcm_dev_disconnect+0x23/0x1f0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (register_mutex#2){+.+.+.}:
       [<ffffffff810c5e8a>] lock_acquire+0x5a/0x70
       [<ffffffff81697fa9>] mutex_lock_nested+0x69/0x3a0
       [<ffffffff8154c533>] snd_pcm_dev_disconnect+0x23/0x1f0
       [<ffffffff815462e2>] snd_device_disconnect+0x62/0xa0
       [<ffffffff815463bc>] snd_device_disconnect_all+0x3c/0x60
       [<ffffffff81540ec7>] snd_card_disconnect+0x147/0x1d0
       [<ffffffff8158c328>] usb_audio_disconnect+0x98/0x1d0
       [<ffffffff814aa4fe>] usb_unbind_interface+0x5e/0x1a0
       [<ffffffff81404ad7>] __device_release_driver+0x77/0xe0
       [<ffffffff81404d49>] device_release_driver+0x29/0x40
       [<ffffffff814044aa>] bus_remove_device+0xfa/0x170
       [<ffffffff81401917>] device_del+0x127/0x1c0
       [<ffffffff814a7f20>] usb_disable_device+0xb0/0x270
       [<ffffffff8149ea0d>] usb_disconnect+0xad/0x160
       [<ffffffff814a12bc>] hub_thread+0x71c/0x1730
       [<ffffffff810967e6>] kthread+0xd6/0xe0
       [<ffffffff8169c2ec>] ret_from_fork+0x7c/0xb0

-> #1 (&chip->shutdown_rwsem){++++++}:
       [<ffffffff810c5e8a>] lock_acquire+0x5a/0x70
       [<ffffffff816993b7>] down_read+0x47/0x5c
       [<ffffffff8158cf9c>] snd_usb_autoresume+0x2c/0x60
       [<ffffffff81594e2f>] snd_usb_pcm_open+0x20f/0x4a0
       [<ffffffff815950db>] snd_usb_playback_open+0xb/0x10
       [<ffffffff81553c0e>] snd_pcm_open_substream+0x4e/0x90
       [<ffffffff81553d02>] snd_pcm_open+0xb2/0x250
       [<ffffffff81553f53>] snd_pcm_playback_open+0x43/0x70
       [<ffffffff8153fb9a>] snd_open+0xba/0x200
       [<ffffffff81152766>] chrdev_open+0x96/0x1c0
       [<ffffffff8114c766>] do_dentry_open.isra.16+0x1e6/0x280
       [<ffffffff8114c836>] finish_open+0x36/0x70
       [<ffffffff8115c53e>] do_last.isra.64+0x2ce/0xcc0
       [<ffffffff8115cfe3>] path_openat.isra.65+0xb3/0x4d0
       [<ffffffff8115d66c>] do_filp_open+0x3c/0x90
       [<ffffffff8114d8af>] do_sys_open+0xef/0x1d0
       [<ffffffff8114d9ac>] sys_open+0x1c/0x20
       [<ffffffff8169c392>] system_call_fastpath+0x16/0x1b

-> #0 (&pcm->open_mutex){+.+.+.}:
       [<ffffffff810c5968>] __lock_acquire+0x1c38/0x1c40
       [<ffffffff810c5e8a>] lock_acquire+0x5a/0x70
       [<ffffffff81697fa9>] mutex_lock_nested+0x69/0x3a0
       [<ffffffff8154c555>] snd_pcm_dev_disconnect+0x45/0x1f0
       [<ffffffff815462e2>] snd_device_disconnect+0x62/0xa0
       [<ffffffff815463bc>] snd_device_disconnect_all+0x3c/0x60
       [<ffffffff81540ec7>] snd_card_disconnect+0x147/0x1d0
       [<ffffffff8158c328>] usb_audio_disconnect+0x98/0x1d0
       [<ffffffff814aa4fe>] usb_unbind_interface+0x5e/0x1a0
       [<ffffffff81404ad7>] __device_release_driver+0x77/0xe0
       [<ffffffff81404d49>] device_release_driver+0x29/0x40
       [<ffffffff814044aa>] bus_remove_device+0xfa/0x170
       [<ffffffff81401917>] device_del+0x127/0x1c0
       [<ffffffff814a7f20>] usb_disable_device+0xb0/0x270
       [<ffffffff8149ea0d>] usb_disconnect+0xad/0x160
       [<ffffffff814a12bc>] hub_thread+0x71c/0x1730
       [<ffffffff810967e6>] kthread+0xd6/0xe0
       [<ffffffff8169c2ec>] ret_from_fork+0x7c/0xb0

other info that might help us debug this:

Chain exists of:
  &pcm->open_mutex --> &chip->shutdown_rwsem --> register_mutex#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(register_mutex#2);
                               lock(&chip->shutdown_rwsem);
                               lock(register_mutex#2);
  lock(&pcm->open_mutex);

 *** DEADLOCK ***

6 locks held by khubd/446:
 #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff814a0c7e>]
hub_thread+0xde/0x1730
 #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff8149e9c1>]
usb_disconnect+0x61/0x160
 #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff81404d41>]
device_release_driver+0x21/0x40
 #3:  (register_mutex#5){+.+.+.}, at: [<ffffffff8158c2c5>]
usb_audio_disconnect+0x35/0x1d0
 #4:  (&chip->shutdown_rwsem){++++++}, at: [<ffffffff8158c2d5>]
usb_audio_disconnect+0x45/0x1d0
 #5:  (register_mutex#2){+.+.+.}, at: [<ffffffff8154c533>]
snd_pcm_dev_disconnect+0x23/0x1f0

stack backtrace:
Pid: 446, comm: khubd Not tainted 3.7.0-rc5-next-20121112_64-ldep+ #15
Call Trace:
 [<ffffffff81691220>] print_circular_bug+0x1fb/0x20c
 [<ffffffff810c5968>] __lock_acquire+0x1c38/0x1c40
 [<ffffffff81546a6e>] ? snd_unregister_oss_device+0x9e/0x120
 [<ffffffff810c5e8a>] lock_acquire+0x5a/0x70
 [<ffffffff8154c555>] ? snd_pcm_dev_disconnect+0x45/0x1f0
 [<ffffffff81697fa9>] mutex_lock_nested+0x69/0x3a0
 [<ffffffff8154c555>] ? snd_pcm_dev_disconnect+0x45/0x1f0
 [<ffffffff8154c555>] snd_pcm_dev_disconnect+0x45/0x1f0
 [<ffffffff815462e2>] snd_device_disconnect+0x62/0xa0
 [<ffffffff815463bc>] snd_device_disconnect_all+0x3c/0x60
 [<ffffffff81540ec7>] snd_card_disconnect+0x147/0x1d0
 [<ffffffff8158c328>] usb_audio_disconnect+0x98/0x1d0
 [<ffffffff814aa4fe>] usb_unbind_interface+0x5e/0x1a0
 [<ffffffff81404ad7>] __device_release_driver+0x77/0xe0
 [<ffffffff81404d49>] device_release_driver+0x29/0x40
 [<ffffffff814044aa>] bus_remove_device+0xfa/0x170
 [<ffffffff81401917>] device_del+0x127/0x1c0
 [<ffffffff8149e9c1>] ? usb_disconnect+0x61/0x160
 [<ffffffff814a7f20>] usb_disable_device+0xb0/0x270
 [<ffffffff8149ea0d>] usb_disconnect+0xad/0x160
 [<ffffffff814a12bc>] hub_thread+0x71c/0x1730
 [<ffffffff810c689d>] ? trace_hardirqs_on_caller+0x10d/0x1e0
 [<ffffffff81096d70>] ? __init_waitqueue_head+0x60/0x60
 [<ffffffff814a0ba0>] ? usb_remote_wakeup+0x70/0x70
 [<ffffffff810967e6>] kthread+0xd6/0xe0
 [<ffffffff8169b65b>] ? _raw_spin_unlock_irq+0x2b/0x50
 [<ffffffff81096710>] ? kthread_create_on_node+0x140/0x140
 [<ffffffff8169c2ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff81096710>] ? kthread_create_on_node+0x140/0x140



-- 
js
suse labs
