Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0FEAH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 20:07:27 -0400
Received: from www.tglx.de ([62.245.132.106]:33215 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464Ab0FEAHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 20:07:25 -0400
Date: Sat, 5 Jun 2010 02:05:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <201006050138.30859.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1006050148080.2933@localhost.localdomain>
References: <20100603193045.GA7188@elte.hu> <20100603232302.GA16184@elte.hu> <1275644619.27810.39462.camel@twins> <201006050138.30859.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010, Rafael J. Wysocki wrote:
> I kind of agree here, so I'd like to focus a bit on that.
> 
> Here's my idea in the very general terms:
> 
> (1) Use the cgroup freezer to "suspend" the "untrusted" apps (ie. the ones
>     that don't use suspend blockers aka wakelocks in the Android world) at the
>     point Android would normally start opportunistic suspend.

There is an additional benefit to this approach:

     In the current android world a background task (e.g. download
     initiated before the screensaver kicked in) prevents the suspend,
     but that also means that the crapplications can still suck power
     completely unconfined.

     With the cgroup freezer you can "suspend" them right away and
     just keep the trusted background task(s) alive which allows us to
     go into deeper idle states instead of letting the crapplications
     run unconfined until the download finished and the suspend
     blocker goes away.
 
> (2) Allow the cpuidle framework to put CPUs into low-power states after the
>     "trusted" apps (ie. the ones that use suspend blockers in the Android
>     world) have gone idle.
> 
> (3) Teach the cpuidle framework to schedule runtime suspend of I/O devices
>     before idling the last CPU (*).
> 
> (4) Design a mechanism to resume the I/O devices suspended in (3) so that
>     they are not powered up unnecessarily (that's going to be difficult as far
>     as I can see).
> 
> This way, in principle, we should be able to save (at least almost) as much
> energy as the opportunistic suspend currently used by Android, provided that
> things will be capable of staying idle for extended periods of time.
> 
> (*) That may require per-device PM QoS requirements to be used, in which case
>     devices may even be suspended earlier if the PM QoS requirements of all
>     of their users are met.
> 
> I wonder what people think.  Is this realistic and if so, would it be difficult
> to implement?

I think it's realistic and not overly complicated to implement.

Thanks,

	tglx
