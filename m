Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0E0PwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:52:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36093 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0E0PwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:52:21 -0400
Date: Thu, 27 May 2010 16:52:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527155201.GA31937@srcf.ucam.org>
References: <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:32:56PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Matthew Garrett wrote:
> > Now let's try this in the Android world. The user hits a key and the 
> > system wakes up. The input layer takes a suspend block. The application 
> > now draws all the cows it wants to, takes its own suspend block and 
> > reads the input device. This empties the queue and the kernel-level 
> > suspend block is released. The application then processes the event 
> > before releasing the suspend block. The event has been delivered and 
> > handled.
> 
> Thanks for providing this example:
> 
>   1) It proves that suspend blockers are solely designed to encourage
>      people to code crap.

No. Suspend blockers are designed to ensure that suspend isn't racy with 
respect to wakeup events. The bit that mitigates badly written 
applications is the bit where the scheduler doesn't run any more.

If you're happy with a single badly written application being able to 
cripple your power management story, you don't need opportunistic 
suspend. But you still have complications when it comes to deciding to 
enter suspend at the same time as you receive a wakeup event.

>      And you need to do that, because the user applications suspend
>      blocker magic is racy as hell. To work around that you sprinkle
>      your suspend blocker magic all over the kernel instead of telling
>      people how to solve the problem correctly.

What /is/ the correct way to solve this problem when entering explicit 
suspend states? How do you guarantee that an event has been delivered to 
userspace before transitioning into suspend? Now, this is a less 
interesting problem if you're not using opportunistic suspend, but it's 
still a problem.

>      Simply because you move the cow drawing CPU time from the point
>      where the device wants to go into suspend to the point where the
>      user hits a key again. You even delay the reaction of your app to
>      the user input by the time it needs to finish drawing cows.

It's how application mainloops tend to work.

> > You can't express that with resource limits or QoS constraints. If you 
> > want to deal with this kind of situation then, as far as I can tell, you 
> > need either suspend blockers or something so close to them that it makes 
> > no difference.
> 
> Wrong. If your application is interactive then you set the QoS
> requirement once to interactive and be done.
>
> So the correct point to make a power state decision is when the app
> waits for a key press. At this point the kernel can take several
> pathes:
> 
>       1) Keep the system alive because the input device is in active
>        	 state and a key press is expected
> 
>       2) Go into supsend because the input device is deactivated after
>       	 the screen lock kicked in.

That's no good. If the input device has been deactivated, how does the 
wakeup event get delivered to the application?
 
> This behaves exactly the same way in terms of power consumption as
> your blocker example just without all the mess you are trying to
> create.

And means that wakeup events don't get delivered. That's a shortcoming.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
