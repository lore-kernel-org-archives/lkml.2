Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0FCXnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:43:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438Ab0FCXnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:43:16 -0400
Date: Thu, 3 Jun 2010 16:37:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Arve Hj?nnev?g <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <20100603232302.GA16184@elte.hu>
Message-ID: <alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu> <20100603232302.GA16184@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jun 2010, Ingo Molnar wrote:
> 
>    This allows a task to 'exclude' other tasks that dont have low-latency 
>    requirements. Crappy apps would have a large latency value, so they'd
>    be idled out when a privileged task sets the exclusion level low enough.

Quite frankly, this sounds fundamentally broken.

Think deadlock. The high-latency task got a lock, and now you're excluding 
it because it scheduled away.

So from my perspective, putting that kind of logic deep in the system 
sounds like the _last_ thing we want to do.

I think it's much saner to have a very targeted suspend blocker that only 
blocks the opportunistic suspends and has _zero_ interaction with the rest 
of the system (certainly none at all with core code like the scheduler).

And if somebody then suspends the traditional way (by an actual suspend 
event, not that opportunistic thing), then the suspend blocker does 
nothing at all - because it simply doesn't even _exist_ at that level. 
It's only about the opportunistic suspends.

(I'd further suggest that disk wait and running in kernel mode disable any 
opportunistic suspend anyway - but that's not about suspend blockers as 
much as it is about just the opportunistic suspend itself).

		Linus
