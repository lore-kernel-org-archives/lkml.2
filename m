Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab2FHKgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:36:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54073 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2FHKgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:36:42 -0400
Date: Fri, 8 Jun 2012 03:35:02 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: leonid.moiseichuk@nokia.com
Cc: kosaki.motohiro@gmail.com, penberg@kernel.org, b.zolnierkie@samsung.com,
        john.stultz@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 2/5] vmevent: Convert from deferred timer to deferred work
Message-ID: <20120608103501.GA15827@lizard>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com>
 <20120608065828.GA1515@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608075844.GA6362@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7A24@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608084105.GA9883@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7B01@008-AM1MPN1-004.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045F7B01@008-AM1MPN1-004.mgdnok.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 08:57:13AM +0000, leonid.moiseichuk@nokia.com wrote:
> > -----Original Message-----
> > From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> > Sent: 08 June, 2012 11:41
> ...
> > > Right. It but it has drawbacks as well e.g. ensure that daemon scheduled
> > properly and propagate reaction decision outside ulmkd.
> > 
> > No, ulmkd itself propagates the decision (i.e. it kills processes).
> 
> That is a decision "select & kill" :)
> Propagation of this decision required time. Not all processes could be killed. You may stuck in killing in some cases.

Yeah. But since we have plenty of free memory (i.e. we're getting
notified in advance), it's OK to be not super-fast.

And if we're losing control, OOMK will help us. (Btw, we can
introduce "thrash killer" in-kernel driver. This would also help
desktop use case, when the system is thrashing so hard that it
becomes unresponsive, we'd better do something about it. When
browser goes crazy on my laptop, I wish I had such a driver. :-)
It takes forever to get OOM condition w/ 2GB swap space, slow
hard drive and CPU all busy w/ moving pages back and forward.)

> > If we start "polling" on /proc/vmstat via userland deferred timers, that would
> > be a single timer, just like in vmevent case. So, I'm not sure what is the
> > difference?..
> 
> Context switches, parsing, activity in userspace even memory situation is not changed.

Sure, there is some additional overhead. I'm just saying that it is
not drastic. It would be like 100 sprintfs + 100 sscanfs + 2 context
switches? Well, it is unfortunate... but come on, today's phones are
running X11 and Java. :-)

> In kernel space you can use sliding timer (increasing interval) + shinker.

Well, w/ Minchan's idea, we can get shrinker notifications into the
userland, so the sliding timer thing would be still possible.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
