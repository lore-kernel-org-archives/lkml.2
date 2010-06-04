Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0FDJoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:44:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:35113 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0FDJoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:44:22 -0400
Subject: Re: suspend blockers & Android integration
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Arve Hj?nnev?g <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
In-Reply-To: <20100603232302.GA16184@elte.hu>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu>
	 <20100603232302.GA16184@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 11:43:39 +0200
Message-ID: <1275644619.27810.39462.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 01:23 +0200, Ingo Molnar wrote:
> Btw., i'd like to summarize the scheduler based suspend scheme proposed by
> Thomas Gleixner, Peter Zijlstra and myself. I found no good summary of it in
> the big thread, and there are also new elements of the proposal:

Just to clarify, my proposition doesn't go much further than treating
'suspend' as a genuine idle state (on suitable hardware, which x86 isn't).

> - Create a 'deep idle' mode that suspends. This, if all constraints
>    are met, is triggered by the scheduler automatically: just like the other
>    idle modes are triggered currently. This approach fixes the wakeup
>    races because an incoming wakeup event will set need_resched() and
>    abort the suspend.
>

Right, so 'suspend' as idle seems (at least on UP/arm) a very sensible
idea.  On SMP current suspend hot-unplugs all but the boot cpu, I'm not
sure we need to do that, since if the system is genuinely idle, what races
are there?

And if its not idle...

>   ( This mode can even use the existing suspend code to bring stuff down,
>      therefore it also solves the pending timer problem and works even on
>      PC style x86. )

You cannot solve the pending timer issue from idle, unless you allow idle
to stop clock_monotonic, which would change idle semantics, and that is not
something I can say is a good idea.

You want all idle states to have the same semantics, otherwise things just
get way too confusing.

> - Solve crappy app confinement via the scheduler:
>
>    A first proposal was to use the existing cgroup mechanism,

I still believe containment is a cgroup problem. The freeze/snapshot/resume
container folks seem to face many of the same problems. Including the
pending timer one I suspect. Lets solve it there.

>  - Controlled auto-suspend: drivers (such as input) could on wakeup
>    automatically set the 'minimum wakeup latency' value of wakee tasks to a
>    lower value. This automatically prevents another auto-suspend in the near
>    future: up to the point the wakee task increases its latency (via the
>    scheduler syscall) again and allows suspend again.

I think treating wakeups special like that is a mistake. I also think the
kernel should never adjust a task's QoS attributes, the user set them in
the expectation of them being respected.

I'm not really sure about the interaction between wakeups and untrusted
apps. It seems to me that an untrusted app needs a trusted intermediate
anyway, that intermediate can be responsible for freezing/unfreezing of the
untrusted app.

So either the app asks for suspend blockers through the intermediate, or it's
cgroup is managed by the intermediate -- should work out to the same end
result, right?

