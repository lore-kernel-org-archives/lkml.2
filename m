Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075Ab2FHDXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:23:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab2FHDXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:23:18 -0400
Date: Thu, 7 Jun 2012 23:23:12 -0400
From: Dave Jones <davej@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: snd_pcm lockdep report from 3.3-rc6
Message-ID: <20120608032312.GA4594@redhat.com>
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

Hi Takashi,

 > > [ INFO: possible recursive locking detected ]
 > > 3.3.0-rc6+ #5 Not tainted
 > > ---------------------------------------------
 > > pulseaudio/1306 is trying to acquire lock:
 > >  (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa0468c0b>] snd_pcm_action_group+0x9b/0x260 [snd_pcm]
 > > 
 > > but task is already holding lock:
 > >  (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa0468c0b>] snd_pcm_action_group+0x9b/0x260 [snd_pcm]
 > > 
 > > other info that might help us debug this:
 > >  Possible unsafe locking scenario:
 > > 
 > >        CPU0
 > >        ----
 > >   lock(&(&substream->self_group.lock)->rlock/1);
 > >   lock(&(&substream->self_group.lock)->rlock/1);
 > > 
 > >  *** DEADLOCK ***
 > > 
 > >  May be due to missing lock nesting notation
 > > 
 > > 4 locks held by pulseaudio/1306:
 > >  #0:  (snd_pcm_link_rwlock){......}, at: [<ffffffffa046ab90>] snd_pcm_drop+0x60/0x100 [snd_pcm]
 > >  #1:  (&(&substream->self_group.lock)->rlock){......}, at: [<ffffffffa046ab98>] snd_pcm_drop+0x68/0x100 [snd_pcm]
 > >  #2:  (&(&substream->group->lock)->rlock){......}, at: [<ffffffffa0469ffe>] snd_pcm_action+0x3e/0xb0 [snd_pcm]
 > >  #3:  (&(&substream->self_group.lock)->rlock/1){......}, at: [<ffffffffa0468c0b>] snd_pcm_action_group+0x9b/0x260 [snd_pcm]
 > > 
 > > stack backtrace:
 > > Pid: 1306, comm: pulseaudio Not tainted 3.3.0-rc6+ #5
 > > Call Trace:
 > >  [<ffffffff810cee87>] __lock_acquire+0xe47/0x1bb0
 > >  [<ffffffff810a62b8>] ? sched_clock_cpu+0xb8/0x130
 > >  [<ffffffff810d030d>] lock_acquire+0x9d/0x220
 > >  [<ffffffffa0468c0b>] ? snd_pcm_action_group+0x9b/0x260 [snd_pcm]
 > >  [<ffffffff810ca91e>] ? put_lock_stats+0xe/0x40
 > >  [<ffffffff8169d3cd>] _raw_spin_lock_nested+0x4d/0x90
 > >  [<ffffffffa0468c0b>] ? snd_pcm_action_group+0x9b/0x260 [snd_pcm]
 > >  [<ffffffffa0468c0b>] snd_pcm_action_group+0x9b/0x260 [snd_pcm]
 > >  [<ffffffffa046a031>] snd_pcm_action+0x71/0xb0 [snd_pcm]
 > >  [<ffffffffa046a08a>] snd_pcm_stop+0x1a/0x20 [snd_pcm]
 > >  [<ffffffffa046abb1>] snd_pcm_drop+0x81/0x100 [snd_pcm]
 > >  [<ffffffffa046cdf8>] snd_pcm_common_ioctl1+0x678/0xc00 [snd_pcm]
 > >  [<ffffffffa046d7d7>] snd_pcm_playback_ioctl1+0x147/0x2e0 [snd_pcm]
 > >  [<ffffffff812c1cbc>] ? file_has_perm+0xdc/0xf0
 > >  [<ffffffffa046d9a4>] snd_pcm_playback_ioctl+0x34/0x40 [snd_pcm]
 > >  [<ffffffff811d2398>] do_vfs_ioctl+0x98/0x570
 > >  [<ffffffff811d2901>] sys_ioctl+0x91/0xa0
 > >  [<ffffffff816a5de9>] system_call_fastpath+0x16/0x1b
 > > 
 > > 
 > > I suspect this ..
 > > 
 > > static int snd_pcm_action(struct action_ops *ops,
 > >                           struct snd_pcm_substream *substream,
 > >                           int state)
 > > {
 > >         int res;
 > > 
 > >         if (snd_pcm_stream_linked(substream)) {
 > > -->             if (!spin_trylock(&substream->group->lock)) {
 > >                         spin_unlock(&substream->self_group.lock);
 > >                         spin_lock(&substream->group->lock);
 > >                         spin_lock(&substream->self_group.lock);
 > >                 }
 > >                 res = snd_pcm_action_group(ops, substream, state, 1);
 > >                 spin_unlock(&substream->group->lock);
 > >         } else {
 > >                 res = snd_pcm_action_single(ops, substream, state);
 > >         }
 > >         return res;
 > > }
 > > 
 > > Should that trylock be on self_group.lock ?
 > 
 > No, the check above should be correct.  The code tries to re-lock when
 > the stream is linked like group-lock -> stream-lock.
 > 
 > However, that code is known to be too tricky and messy for long time.
 > It'd be really better to get rid of this complexity.  I tried some
 > times but failed to reach to the final goal due to lack of time.
 > 
 > OK, let me respin my old patch.  The refreshed one is attached below.
 > (Note that it's totally untested.  I have to leave my office now,
 >  sorry for that.  Let me know if the wonder happens and it works :)


I'm not sure if I got back to you on this, but that patch did nothing
to change this for me, and I still see this on 3.5-rc1

	Dave

