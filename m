Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2JEWCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2JEWCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:02:30 -0400
Date: Fri, 5 Oct 2012 18:02:23 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: tiwai@suse.de
Subject: alsa lockdep trace.
Message-ID: <20121005220223.GB2406@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, tiwai@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi,
I've been seeing this on one machine since around 3.3 (perhaps earlier, I forget)
I reported it a while ago, and you had me test some patch that didn't make any
difference, then it fell off my radar..

	Dave

=============================================
[ INFO: possible recursive locking detected ]
3.6.0+ #31 Not tainted
---------------------------------------------
pulseaudio/1022 is trying to acquire lock:
blocked:  (&(&substream->self_group.lock)->rlock/1){......}, instance: ffff88009befc140, at: [<ffffffffa04ba173>] snd_pcm_action_group+0xa3/0x240 [snd_pcm]

but task is already holding lock:
held:     (&(&substream->self_group.lock)->rlock/1){......}, instance: ffff88009bee2190, at: [<ffffffffa04ba173>] snd_pcm_action_group+0xa3/0x240 [snd_pcm]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&substream->self_group.lock)->rlock/1);
  lock(&(&substream->self_group.lock)->rlock/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks on stack by pulseaudio/1022:
 #0: held:     (snd_pcm_link_rwlock){......}, instance: ffffffffa04c8138, at: [<ffffffffa04baee2>] snd_pcm_drop+0x62/0x110 [snd_pcm]
 #1: held:     (&(&substream->self_group.lock)->rlock){......}, instance: ffff88009bee60f0, at: [<ffffffffa04baeea>] snd_pcm_drop+0x6a/0x110 [snd_pcm]
 #2: blocked:  (&(&substream->group->lock)->rlock){......}, instance: ffff8800b4e0dde8, at: [<ffffffffa04ba4ae>] snd_pcm_action+0x3e/0xb0 [snd_pcm]
 #3: held:     (&(&substream->self_group.lock)->rlock/1){......}, instance: ffff88009bee2190, at: [<ffffffffa04ba173>] snd_pcm_action_group+0xa3/0x240 [snd_pcm]

stack backtrace:
Pid: 1022, comm: pulseaudio Not tainted 3.6.0+ #31
Call Trace:
 [<ffffffff810d8395>] __lock_acquire+0x6f5/0x1b80
 [<ffffffff810d7fa7>] ? __lock_acquire+0x307/0x1b80
 [<ffffffff81021dd3>] ? native_sched_clock+0x13/0x80
 [<ffffffff810d9ef1>] lock_acquire+0xa1/0x1f0
 [<ffffffffa04ba173>] ? snd_pcm_action_group+0xa3/0x240 [snd_pcm]
 [<ffffffff816c9e24>] _raw_spin_lock_nested+0x44/0x80
 [<ffffffffa04ba173>] ? snd_pcm_action_group+0xa3/0x240 [snd_pcm]
 [<ffffffffa04ba173>] snd_pcm_action_group+0xa3/0x240 [snd_pcm]
 [<ffffffffa04ba4e1>] snd_pcm_action+0x71/0xb0 [snd_pcm]
 [<ffffffffa04ba53a>] snd_pcm_stop+0x1a/0x20 [snd_pcm]
 [<ffffffffa04baf04>] snd_pcm_drop+0x84/0x110 [snd_pcm]
 [<ffffffffa04bccd8>] snd_pcm_common_ioctl1+0x4f8/0xc00 [snd_pcm]
 [<ffffffff810d4f4f>] ? lock_release_holdtime.part.26+0xf/0x180
 [<ffffffffa04bd770>] snd_pcm_playback_ioctl1+0x60/0x2e0 [snd_pcm]
 [<ffffffffa04bda24>] snd_pcm_playback_ioctl+0x34/0x40 [snd_pcm]
 [<ffffffff811d9cf9>] do_vfs_ioctl+0x99/0x5a0
 [<ffffffff812d9b07>] ? file_has_perm+0x97/0xb0
 [<ffffffff811da291>] sys_ioctl+0x91/0xb0
 [<ffffffff816d4290>] tracesys+0xdd/0xe2

