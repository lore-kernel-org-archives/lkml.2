Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2BFO4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:56:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab2BFO4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:56:35 -0500
Date: Mon, 6 Feb 2012 09:56:22 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: 3.3-rc2 snd_pcm lockdep backtrace
Message-ID: <20120206145621.GA4771@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a report[1] of a lockdep backtrace from the snd_pcm driver.  I
was wondering if anyone had hit this already or had some decent ideas on
what the issue might be.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=787319

backtrace:
:[ INFO: possible recursive locking detected ]
:3.3.0-0.rc2.git2.1.fc17.x86_64 #1 Not tainted
:---------------------------------------------
:pulseaudio/954 is trying to acquire lock:
: (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa00d9093>]
snd_pcm_action_group+0xa3/0x240 [snd_pcm]
:but task is already holding lock:
: (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa00d9093>]
snd_pcm_action_group+0xa3/0x240 [snd_pcm]
:other info that might help us debug this:
: Possible unsafe locking scenario:
:       CPU0
:       ----
:  lock(&(&substream->self_group.lock)->rlock/1);
:  lock(&(&substream->self_group.lock)->rlock/1);
: *** DEADLOCK ***
: May be due to missing lock nesting notation
:4 locks held by pulseaudio/954:
: #0:  (snd_pcm_link_rwlock){......}, at: [<ffffffffa00d9e62>]
snd_pcm_drop+0x62/0x110 [snd_pcm]
: #1:  (&(&substream->self_group.lock)->rlock){......}, at:
[<ffffffffa00d9e6a>] snd_pcm_drop+0x6a/0x110 [snd_pcm]
: #2:  (&(&substream->group->lock)->rlock){......}, at: [<ffffffffa00d93ce>]
snd_pcm_action+0x3e/0xb0 [snd_pcm]
: #3:  (&(&substream->self_group.lock)->rlock/1){......}, at:
[<ffffffffa00d9093>] snd_pcm_action_group+0xa3/0x240 [snd_pcm]
:stack backtrace:
:Pid: 954, comm: pulseaudio Not tainted 3.3.0-0.rc2.git2.1.fc17.x86_64 #1
:Call Trace:
: [<ffffffff810cb7ec>] __lock_acquire+0x160c/0x1ad0
: [<ffffffff810ca4f6>] ? __lock_acquire+0x316/0x1ad0
: [<ffffffff81020f99>] ? sched_clock+0x9/0x10
: [<ffffffff810a24a5>] ? sched_clock_local+0x25/0xa0
: [<ffffffff810cc381>] lock_acquire+0xa1/0x1e0
: [<ffffffffa00d9093>] ? snd_pcm_action_group+0xa3/0x240 [snd_pcm]
: [<ffffffff8169cca4>] _raw_spin_lock_nested+0x44/0x80
: [<ffffffffa00d9093>] ? snd_pcm_action_group+0xa3/0x240 [snd_pcm]
: [<ffffffffa00d9093>] snd_pcm_action_group+0xa3/0x240 [snd_pcm]
: [<ffffffffa00d9401>] snd_pcm_action+0x71/0xb0 [snd_pcm]
: [<ffffffffa00d945a>] snd_pcm_stop+0x1a/0x20 [snd_pcm]
: [<ffffffffa00d9e84>] snd_pcm_drop+0x84/0x110 [snd_pcm]
: [<ffffffffa00dbba8>] snd_pcm_common_ioctl1+0x4a8/0xbe0 [snd_pcm]
: [<ffffffffa00dc650>] snd_pcm_playback_ioctl1+0x60/0x2d0 [snd_pcm]
: [<ffffffff812c1481>] ? file_has_perm+0xe1/0xf0
: [<ffffffffa00dc8f4>] snd_pcm_playback_ioctl+0x34/0x40 [snd_pcm]
: [<ffffffff811cf8d9>] do_vfs_ioctl+0x99/0x5a0
: [<ffffffff811cfe79>] sys_ioctl+0x99/0xa0
: [<ffffffff816a63e9>] system_call_fastpath+0x16/0x1b
