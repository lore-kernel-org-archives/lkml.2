Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1HVXWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:22:12 -0400
Received: from infernal.debian.net ([87.230.26.131]:53772 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1HVXWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:22:08 -0400
Date: Tue, 23 Aug 2011 01:22:04 +0200
From: Andreas Bombe <aeb@debian.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: Lockdep splat in sound core
Message-ID: <20110822232203.GA15492@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following lockdep splat occurs when the EMU10K1 driver is loaded. It
actually did that for a long time already, it's about time I finally
report it:

=============================================
[ INFO: possible recursive locking detected ]
3.1.0-rc2-00171-gbed8cad #88
---------------------------------------------
pulseaudio/3074 is trying to acquire lock:
 (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa012b0c9>] snd_pcm_action_group+0x4f/0x1d6 [snd_pcm]

but task is already holding lock:
 (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa012b0c9>] snd_pcm_action_group+0x4f/0x1d6 [snd_pcm]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&substream->self_group.lock)->rlock);
  lock(&(&substream->self_group.lock)->rlock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by pulseaudio/3074:
 #0:  (snd_pcm_link_rwlock){.-.-..}, at: [<ffffffffa012a0b1>] snd_pcm_stream_lock_irq+0x15/0x25 [snd_pcm]
 #1:  (&(&substream->self_group.lock)->rlock){-.-...}, at: [<ffffffffa012a0bd>] snd_pcm_stream_lock_irq+0x21/0x25 [snd_pcm]
 #2:  (&(&substream->group->lock)->rlock){......}, at: [<ffffffffa012ca6d>] snd_pcm_action+0x2e/0x8b [snd_pcm]
 #3:  (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa012b0c9>] snd_pcm_action_group+0x4f/0x1d6 [snd_pcm]

stack backtrace:
Pid: 3074, comm: pulseaudio Not tainted 3.1.0-rc2-00171-gbed8cad #88
Call Trace:
 [<ffffffff8106b728>] print_deadlock_bug+0xca/0xd5
 [<ffffffff8106c567>] validate_chain.isra.34+0x31c/0x39d
 [<ffffffff8106cc7c>] __lock_acquire+0x36f/0x3e8
 [<ffffffffa012b0c9>] ? snd_pcm_action_group+0x4f/0x1d6 [snd_pcm]
 [<ffffffff8106d1a9>] lock_acquire+0xc4/0x112
 [<ffffffffa012b0c9>] ? snd_pcm_action_group+0x4f/0x1d6 [snd_pcm]
 [<ffffffff813d1494>] _raw_spin_lock_nested+0x3a/0x49
 [<ffffffffa012b0c9>] ? snd_pcm_action_group+0x4f/0x1d6 [snd_pcm]
 [<ffffffffa012b0c9>] snd_pcm_action_group+0x4f/0x1d6 [snd_pcm]
 [<ffffffffa012caa3>] snd_pcm_action+0x64/0x8b [snd_pcm]
 [<ffffffffa012a0bd>] ? snd_pcm_stream_lock_irq+0x21/0x25 [snd_pcm]
 [<ffffffffa012cadf>] snd_pcm_stop+0x15/0x17 [snd_pcm]
 [<ffffffffa012cdce>] snd_pcm_drop+0x5e/0x6d [snd_pcm]
 [<ffffffffa012dc6e>] snd_pcm_common_ioctl1+0x53e/0x580 [snd_pcm]
 [<ffffffff8106d652>] ? trace_hardirqs_on_caller.part.36+0xbd/0xf4
 [<ffffffffa012e12d>] snd_pcm_playback_ioctl1+0x21d/0x232 [snd_pcm]
 [<ffffffff810f307d>] ? slab_free_hook.isra.64+0x50/0x59
 [<ffffffffa012e16c>] snd_pcm_playback_ioctl+0x2a/0x2e [snd_pcm]
 [<ffffffff8110bb1a>] do_vfs_ioctl+0x267/0x281
 [<ffffffff810febc5>] ? fget_light+0x3b/0x9a
 [<ffffffff8110bb85>] sys_ioctl+0x51/0x74
 [<ffffffff813d2912>] system_call_fastpath+0x16/0x1b


-- 
Andreas Bombe
