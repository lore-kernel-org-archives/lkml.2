Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0FDIMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:12:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0FDIM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:12:27 -0400
Date: Fri, 4 Jun 2010 10:11:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
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
Message-ID: <20100604081140.GB15181@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <20100603231153.GA11302@elte.hu>
 <20100603232302.GA16184@elte.hu>
 <alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org>
 <20100603234634.GA21831@elte.hu>
 <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 4 Jun 2010, Ingo Molnar wrote:
> 
> > What you say is absolutely true, hence this would be driven via 
> > sched_tick() + TIF notifiers - i.e. only ever treat user-mode tasks as 
> > 'idle-able'. This can be done with no overhead to the regular fastpaths.
> > 
> > The TIF notifier would be the one scheduling to idle - and would thus do 
> > it only to user-mode tasks.
> 
> The thing is, unless there is some _really_ deep other reason to do 
> something like this, I still think it's total overdesign to push any 
> knowledge/choices like this into the scheduler. I'd rather keep things way 
> more independent, less tied to each other and to deep kernel subsystems.

Well, the deep reason as i see it is simply the observation that what the 
Android auto-suspend code implements via the suspend-blocker patches is an 
idle driver and user-space scheduler in disguise. (if you count that as a deep 
enough reason)

I dont mind hacks if they are local and if i dont have to maintain them, but 
the objection from other folks was that suspend blockers are not that local 
and not that maintainable. And if (and that's a big if) we have a global 
effect anyway, then we might as well consider implementing it cleanly:

 - A global /sys flag is fundamentally racy and only allows a single
   user-space actor. Not a problem on mobile phones but sure violates
   taste buds.

   Proper per task latency attributes are not racy - we always know the
   maximum/minimum values, without user-space interfering with each other.

 - When done correctly we might win a couple of new features as well around
   the fringes:

    - Useful for power savings on mobile: crappy apps can be idled on an 
      intermediate level, even before the system goes totally idle. There's no 
      equivalent suspend-blockers feature.

    - Useful for real-time tasks that want to idle lower prio tasks when some
      really important thing is running - even if the real-time task might sleep.
      This is superior to the 'hog the CPU' kind of hacks that have been used
      for this purpose before.

 - The hacks needed to express a race-free suspend/wakeup cycle are unnatural
   and stem from the model being a user-space driven idle manager instead of a
   proper part of task sleep/wakeup.

 - None of this code seems to impact any scheduler hotpath (most of it is just
   a special form of idle driver) - it's all on deeper levels of idle and, at 
   most, in off-line return-to-userspace codepaths. So there's no strong
   performance reason _against_ some level of integration. There is indeed
   the coupling effect as you mention, which weighs against.

 - i also think Andoid's auto-suspend is a strategic feature to Linux: i 
   think auto/opportunistic suspend will matter more and more, and my guess 
   is that ten years most of our daily systems will be doing auto-suspend and 
   will have proper wakeups from suspend implemented in hardware. Not just 
   phones and gadgets but also portable tablets, book readers, TVs - and i 
   wouldnt mind a non-portable, table sized tablet either ;-)

   At which point i'd hate to have some hack of a solution ingrained and
   ABI-ized with little chance to move user-space to sanity.

But yes, i definitely agree with you that it all comes down to 'do we care':

 - If we care we should integrate it intelligently where it belongs
   conceptually: the idle drivers and the scheduler.

 - If we dont care then we should isolate the hacks as much as possible - and
   then the current suspend blocker patch-set is definitely a good basis to 
   start. (with perhaps the /sys hackery cleaned up a bit, as you suggested)

I dont favor either of the solutions too deeply - so i personally have not 
NAK-ed suspend blockers - i just saw a half a dozen semi-NAKs flying from 
other folks, so tried to help come up with a palatable design.

_If_ most of x86 hardware was able to suspend race-free i think deeper 
integration would be a slam-dunk - as we could make it work almost everywhere. 
Sadly only a tiny subset of x86 qualifies, so the argument isnt obvious. Maybe 
we should pick a variant of suspend blockers and re-examine things in a few 
years? It being an ABI makes it difficult tho.

What i would personally find unacceptable is to have _neither_ solutions - and 
the discussion was heading towards that stage really, with both sides digging 
the trenches of non-cooperation. IMHO we just cannot afford to let this drop 
on the floor as the feature is immensely useful to Android and thus to Linux 
at large.

Anyway, i'm glad that it's up to you ;-)

	Ingo
