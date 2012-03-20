Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634Ab2CTRNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:13:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564Ab2CTRNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:13:31 -0400
Date: Tue, 20 Mar 2012 13:13:25 -0400
From: Dave Jones <davej@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: snd_pcm lockdep report from 3.3-rc6
Message-ID: <20120320171325.GA10110@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Takashi Iwai <tiwai@suse.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120312143514.GA1881@redhat.com>
 <s5hfwdd3ecn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfwdd3ecn.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 06:42:48PM +0100, Takashi Iwai wrote:
 > However, that code is known to be too tricky and messy for long time.
 > It'd be really better to get rid of this complexity.  I tried some
 > times but failed to reach to the final goal due to lack of time.
 > 
 > OK, let me respin my old patch.  The refreshed one is attached below.
 > (Note that it's totally untested.  I have to leave my office now,
 >  sorry for that.  Let me know if the wonder happens and it works :)

I thought I was going crazy when I still saw the same trace,
and made sure the patch was actually applied, and rebuilt the kernel.
Seems this patch doesn't fix this.

The trace is slightly different (one fewer lock taken)..

	Dave

=============================================
[ INFO: possible recursive locking detected ]
3.3.0+ #15 Not tainted
---------------------------------------------
pulseaudio/1269 is trying to acquire lock:
 (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa0476c00>] snd_pcm_action_group+0x90/0x250 [snd_pcm]

but task is already holding lock:
 (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa0476c00>] snd_pcm_action_group+0x90/0x250 [snd_pcm]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&substream->self_group.lock)->rlock/1);
  lock(&(&substream->self_group.lock)->rlock/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by pulseaudio/1269:
 #0:  (snd_pcm_link_rwlock){......}, at: [<ffffffffa0478ac9>] snd_pcm_drop+0x49/0xe0 [snd_pcm]
 #1:  (&(&substream->group->lock)->rlock){......}, at: [<ffffffffa0478ad5>] snd_pcm_drop+0x55/0xe0 [snd_pcm]
 #2:  (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa0476c00>] snd_pcm_action_group+0x90/0x250 [snd_pcm]

stack backtrace:
Pid: 1269, comm: pulseaudio Not tainted 3.3.0+ #15
Call Trace:
 [<ffffffff810cee37>] __lock_acquire+0xe47/0x1bb0
 [<ffffffff81023322>] ? native_sched_clock+0x22/0x80
 [<ffffffff810d02bd>] lock_acquire+0x9d/0x220
 [<ffffffffa0476c00>] ? snd_pcm_action_group+0x90/0x250 [snd_pcm]
 [<ffffffff810ca8be>] ? put_lock_stats+0xe/0x40
 [<ffffffff816a1a1d>] _raw_spin_lock_nested+0x4d/0x90
 [<ffffffffa0476c00>] ? snd_pcm_action_group+0x90/0x250 [snd_pcm]
 [<ffffffffa0476c00>] snd_pcm_action_group+0x90/0x250 [snd_pcm]
 [<ffffffff812c5a46>] ? avc_has_perm_noaudit+0x46/0x500
 [<ffffffffa0477f03>] snd_pcm_action+0x23/0x40 [snd_pcm]
 [<ffffffffa0477f3a>] snd_pcm_stop+0x1a/0x20 [snd_pcm]
 [<ffffffffa0478aef>] snd_pcm_drop+0x6f/0xe0 [snd_pcm]
 [<ffffffffa047ad08>] snd_pcm_common_ioctl1+0x668/0xc30 [snd_pcm]
 [<ffffffffa047b727>] snd_pcm_playback_ioctl1+0x147/0x2e0 [snd_pcm]
 [<ffffffff812c839c>] ? file_has_perm+0xdc/0xf0
 [<ffffffffa047b8f4>] snd_pcm_playback_ioctl+0x34/0x40 [snd_pcm]
 [<ffffffff811d4858>] do_vfs_ioctl+0x98/0x570
 [<ffffffff811d4dc1>] sys_ioctl+0x91/0xa0
 [<ffffffff816aa3e9>] system_call_fastpath+0x16/0x1b

