Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab1BKSVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:21:11 -0500
Received: from mx3.gwdg.de ([134.76.10.16]:25701 "EHLO mx3.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757676Ab1BKSVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:21:10 -0500
X-IronPort-Reputation-Score: None
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="23606162"
X-IronPort-AV: E=Sophos;i="4.60,456,1291590000"; 
   d="scan'208";a="23606162"
In-Reply-To: <alpine.LSU.2.00.1102081132160.1591@sister.anvils>
References: <849307$bc24ct@azsmga001.ch.intel.com> <1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LSU.2.00.1102010909270.1586@sister.anvils> <20110201094643.366bc073@jbarnes-desktop> <20110201100833.3219687e@jbarnes-desktop> <AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com> <20110201113238.60b33ff9@jbarnes-desktop> <AANLkTikwfHd6t95-jhbXCy1ciW3OV+HVYVikZNs5LHfz@mail.gmail.com> <20110202091838.5efaa660@jbarnes-desktop> <alpine.LSU.2.00.1102081132160.1591@sister.anvils>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <87E55E65-72FF-462C-8BD3-84C367021DB7@tuebingen.mpg.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Content-Transfer-Encoding: 7bit
From: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
Date: Fri, 11 Feb 2011 19:21:07 +0100
To: Hugh Dickins <hughd@google.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2011, at 8:52 PM, Hugh Dickins wrote:
>>
>> But presumably the FLIP_PENDING_INTERRUPT bits are stuck on in your
>> case, otherwise we wouldn't be getting to flip prepare/finish at all.
>>
>> Some updated docs indicate those bits may not be reliable on 965
>> (though earlier ones did), so we may need to disable the flip code
>> entirely on 965 if we can't figure out what's going wrong on your
>> config...
>
> Sometime arrived, I did a bisection between v2.6.36 and v2.6.37,
> and my "pipe a underrun"s on 965 begin with 29e1316ab129 drm/i915/tv:
> Sleep before checking for state changes (appended below).
>
> But that's a necessary patch for me: without it both VESA framebuffer
> and X mistake the size and shape of the laptop screen, and my windows
> don't fit in properly.
>
> I experimented a little with intel_tv.c on 2.6.38-rc3 and rc4.
> Indeed, just deleting that intel_wait_for_vblank() stops the  
> underruns,
> but leaves the display missized.  Replacing it by msleep(20), as  
> used to
> be done, behaves the same as with intel_wait_for_vblank() there:  
> underruns
> with correctly sized display.  "#if 0"ing all of  
> intel_tv_detect_type(),
> just returning -1 from it, gives no underruns and correctly sized  
> display.
> I was going to work with the latter, when my original unflushed text
> problem resurfaced again (just as it had later done when trying  
> Chris's
> "Suppress spurious vblank interrupts" patch).  It appears that the
> underruns, while mysterious and worrisome, have litte or nothing to do
> with the unflushed text problem which is making 2.6.38-rc unusable.
>
> For the moment I've gone back to my patch moving intel_display.c's
> do_gettimeofday() call into the block where it's needed; though that
> too disappointed eventually before.  It all rather stinks of something
> uninitialized somewhere.

Just a remark, the do_gettimeofday() call is placed where it is  
(Before the spin_lock_irqsave() call for the event_lock), so that  
taking that timestamp (which is only needed later for some  
comparisons) isn't delayed by a possible blocking on that lock.  
Getting the timestamp as early as possible after entering that  
function is needed to make pageflip timestamping more robust.

I'm puzzled why calling do_gettimeofday() could cause any harm, even  
if that code gets executed by accident. I stared at the code for a  
while and couldn't see missing initializations or similar. Maybe it  
would still make sense to try to get some ftrace's on how the code  
there executes, e.g., which path does it actually take or if some  
piece of code takes an unusual and excessive amount of time to execute?

-mario

