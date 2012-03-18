Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2CRTbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 15:31:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36184 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab2CRTbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 15:31:47 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Dave Jones <davej@redhat.com>
Subject: Re: snd_pcm lockdep report from 3.3-rc6
Date: Sun, 18 Mar 2012 20:31:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tiwai@suse.de
References: <20120312143514.GA1881@redhat.com>
In-Reply-To: <20120312143514.GA1881@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203182031.42497.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 12 marca 2012 o 15:35:15 Dave Jones wrote:
> I just hit this..
> 
> 
> [ INFO: possible recursive locking detected ]
> 3.3.0-rc6+ #5 Not tainted
> ---------------------------------------------
> pulseaudio/1306 is trying to acquire lock:
>  (&(&substream->self_group.lock)->rlock/1){......}, at:
> [<ffffffffa0468c0b>] snd_pcm_action_group+0x9b/0x260 [snd_pcm]
> 
> but task is already holding lock:
>  (&(&substream->self_group.lock)->rlock/1){......}, at:
> [<ffffffffa0468c0b>] snd_pcm_action_group+0x9b/0x260 [snd_pcm]
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&(&substream->self_group.lock)->rlock/1);
>   lock(&(&substream->self_group.lock)->rlock/1);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 4 locks held by pulseaudio/1306:
>  #0:  (snd_pcm_link_rwlock){......}, at: [<ffffffffa046ab90>]
> snd_pcm_drop+0x60/0x100 [snd_pcm] #1: 
> (&(&substream->self_group.lock)->rlock){......}, at: [<ffffffffa046ab98>]
> snd_pcm_drop+0x68/0x100 [snd_pcm] #2: 
> (&(&substream->group->lock)->rlock){......}, at: [<ffffffffa0469ffe>]
> snd_pcm_action+0x3e/0xb0 [snd_pcm] #3: 
> (&(&substream->self_group.lock)->rlock/1){......}, at:
> [<ffffffffa0468c0b>] snd_pcm_action_group+0x9b/0x260 [snd_pcm]
> 
> stack backtrace:
> Pid: 1306, comm: pulseaudio Not tainted 3.3.0-rc6+ #5
> Call Trace:
>  [<ffffffff810cee87>] __lock_acquire+0xe47/0x1bb0
>  [<ffffffff810a62b8>] ? sched_clock_cpu+0xb8/0x130
>  [<ffffffff810d030d>] lock_acquire+0x9d/0x220
>  [<ffffffffa0468c0b>] ? snd_pcm_action_group+0x9b/0x260 [snd_pcm]
>  [<ffffffff810ca91e>] ? put_lock_stats+0xe/0x40
>  [<ffffffff8169d3cd>] _raw_spin_lock_nested+0x4d/0x90
>  [<ffffffffa0468c0b>] ? snd_pcm_action_group+0x9b/0x260 [snd_pcm]
>  [<ffffffffa0468c0b>] snd_pcm_action_group+0x9b/0x260 [snd_pcm]
>  [<ffffffffa046a031>] snd_pcm_action+0x71/0xb0 [snd_pcm]
>  [<ffffffffa046a08a>] snd_pcm_stop+0x1a/0x20 [snd_pcm]
>  [<ffffffffa046abb1>] snd_pcm_drop+0x81/0x100 [snd_pcm]
>  [<ffffffffa046cdf8>] snd_pcm_common_ioctl1+0x678/0xc00 [snd_pcm]
>  [<ffffffffa046d7d7>] snd_pcm_playback_ioctl1+0x147/0x2e0 [snd_pcm]
>  [<ffffffff812c1cbc>] ? file_has_perm+0xdc/0xf0
>  [<ffffffffa046d9a4>] snd_pcm_playback_ioctl+0x34/0x40 [snd_pcm]
>  [<ffffffff811d2398>] do_vfs_ioctl+0x98/0x570
>  [<ffffffff811d2901>] sys_ioctl+0x91/0xa0
>  [<ffffffff816a5de9>] system_call_fastpath+0x16/0x1b
> 
> 
> I suspect this ..
> 
> static int snd_pcm_action(struct action_ops *ops,
>                           struct snd_pcm_substream *substream,
>                           int state)
> {
>         int res;
> 
>         if (snd_pcm_stream_linked(substream)) {
> -->             if (!spin_trylock(&substream->group->lock)) {
>                         spin_unlock(&substream->self_group.lock);
>                         spin_lock(&substream->group->lock);
>                         spin_lock(&substream->self_group.lock);
>                 }
>                 res = snd_pcm_action_group(ops, substream, state, 1);
>                 spin_unlock(&substream->group->lock);
>         } else {
>                 res = snd_pcm_action_single(ops, substream, state);
>         }
>         return res;
> }
> 
> Should that trylock be on self_group.lock ?
> 
> 	Dave

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42958
for your bug/regression report, please add your address to the CC list in 
there, thanks!
-- 
Maciej Rutecki
http://www.mrutecki.pl
