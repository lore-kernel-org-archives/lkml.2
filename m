Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab0D0T4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:56:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36569 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab0D0T4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:56:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 27 Apr 2010 21:56:04 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: sound/core/timer.c: inconsistent lock state reported for tu->qlock
To: alsa-devel@alsa-project.org
cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Message-ID: <tkrat.3cb3230c2c45e983@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following log from a rarely used PC that I just updated from
2.6.34-rc4 to 2.6.34-rc5.  I don't know though under which kernel I last
used the soundcard of it; could have been 2.6.33, could have been a
.34-rc.  It is an x86 Mac mini with

    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)

Kernel is vanilla except for various firewire patches, which should not
matter to this issue.

=================================
[ INFO: inconsistent lock state ]
2.6.34-rc5 #5
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
dolphin/4003 [HC1[1]:SC0[0]:HE0:SE1] takes:
(&(&tu->qlock)->rlock){?.+...}, at: [<f84ec472>] snd_timer_user_tinterrupt+0x28/0x132 [snd_timer]
{HARDIRQ-ON-W} state was registered at:
  [<c1048de9>] __lock_acquire+0x654/0x1482
  [<c1049c73>] lock_acquire+0x5c/0x73
  [<c125ac3e>] _raw_spin_lock+0x25/0x34
  [<f84ec370>] snd_timer_user_ccallback+0x55/0x95 [snd_timer]
  [<f84ecc4b>] snd_timer_notify1+0x53/0xca [snd_timer]
  [<f84ecdbe>] _snd_timer_stop+0xfc/0x106 [snd_timer]
  [<f84eceab>] snd_timer_stop+0x13/0x42 [snd_timer]
  [<f84ee2dc>] snd_timer_user_ioctl+0xa27/0xaf5 [snd_timer]
  [<c1092c2f>] vfs_ioctl+0x22/0x87
  [<c10931aa>] do_vfs_ioctl+0x472/0x4ac
  [<c1093210>] sys_ioctl+0x2c/0x45
  [<c1002850>] sysenter_do_call+0x12/0x36
irq event stamp: 2042234
hardirqs last  enabled at (2042233): [<c1002883>] sysenter_exit+0xf/0x18
hardirqs last disabled at (2042234): [<c1002d67>] common_interrupt+0x27/0x34
softirqs last  enabled at (2042226): [<c102cfc3>] __do_softirq+0x102/0x10a
softirqs last disabled at (2042221): [<c102cff6>] do_softirq+0x2b/0x43

other info that might help us debug this:
2 locks held by dolphin/4003:
 #0:  (snd_pcm_link_rwlock){.-....}, at: [<f8eb0a35>] snd_pcm_period_elapsed+0x2a/0xaf [snd_pcm]
 #1:  (&(&substream->self_group.lock)->rlock){-.....}, at: [<f8eb0a3f>] snd_pcm_period_elapsed+0x34/0xaf [snd_pcm]

stack backtrace:
Pid: 4003, comm: dolphin Tainted: G	   W  2.6.34-rc5 #5
Call Trace:
 [<c125882d>] ? printk+0xf/0x12
 [<c104761b>] print_usage_bug+0x14e/0x15a
 [<c10478c8>] mark_lock+0x2a1/0x4a7
 [<c1048066>] ? check_usage_forwards+0x0/0xb0
 [<c1048d69>] __lock_acquire+0x5d4/0x1482
 [<c1049c08>] ? __lock_acquire+0x1473/0x1482
 [<c1049c73>] lock_acquire+0x5c/0x73
 [<f84ec472>] ? snd_timer_user_tinterrupt+0x28/0x132 [snd_timer]
 [<c125ac3e>] _raw_spin_lock+0x25/0x34
 [<f84ec472>] ? snd_timer_user_tinterrupt+0x28/0x132 [snd_timer]
 [<f84ec472>] snd_timer_user_tinterrupt+0x28/0x132 [snd_timer]
 [<f84ec44a>] ? snd_timer_user_tinterrupt+0x0/0x132 [snd_timer]
 [<f84ed2e1>] snd_timer_interrupt+0x213/0x264 [snd_timer]
 [<c125ac45>] ? _raw_spin_lock+0x2c/0x34
 [<f8eb0a7d>] snd_pcm_period_elapsed+0x72/0xaf [snd_pcm]
 [<f8f733bb>] azx_interrupt+0x8d/0x109 [snd_hda_intel]
 [<c1057fb0>] handle_IRQ_event+0x1d/0xa2
 [<c105980b>] handle_fasteoi_irq+0x79/0xb2
 [<c10046ff>] handle_irq+0x3b/0x48
 [<c1003f3d>] do_IRQ+0x45/0x9f
 [<c1002d6e>] common_interrupt+0x2e/0x34
 [<c1250000>] ? piix_init_one+0x1d2/0x628

-- 
Stefan Richter
-=====-==-=- -=-- ==-==
http://arcgraph.de/sr/

