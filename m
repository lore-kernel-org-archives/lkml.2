Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0FDMHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:07:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab0FDMHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:07:19 -0400
Subject: Re: suspend blockers & Android integration
From: Peter Zijlstra <peterz@infradead.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
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
In-Reply-To: <AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu>
	 <20100603232302.GA16184@elte.hu>
	 <AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
	 <20100604071354.GA14451@elte.hu>
	 <AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	 <20100604083423.GD15181@elte.hu>
	 <AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 14:06:50 +0200
Message-ID: <1275653210.27810.39762.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 01:56 -0700, Arve Hjønnevåg wrote:
> On Fri, Jun 4, 2010 at 1:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Arve Hj?nnev?g <arve@android.com> wrote:
> >
> >> > [...]
> >> >
> >> > Why do you need to track input wakeups? It's rather fragile and rather
> >> > unnecessary [...]
> >>
> >> Because we have keys that should always turn the screen on, but the problem
> >> is not specific to input events. If we enabled a wakeup event it usually
> >> means we need this event to always work, not just when the system is fully
> >> awake or fully suspended.
> >
> > Hm, i cannot follow that generic claim. Could you please point out the problem
> > to me via a specific example? Which task does what, what undesirable thing
> > happens where, etc.
> >
> 
> We have many wakeup events, and some of them are invisible to the
> user. For instance on the Nexus One wake up every 10 minutes monitor
> the battery health. 

> If the user presses a key right after this work
> has finished and we did not block suspend until userspace could
> process this key event, we risk suspending before we could turn the
> screen on, which to the user looks like the key did not work. 

> Another
> example, the user pressed the power key which turns the screen off and
> allows suspend. We initiate suspend and a phone call comes in. If we
> don't block suspend until we processed the incoming phone call
> notification, the phone may never ring (some devices will send a new
> message every few seconds for this, so on those devices it would just
> delay the ringing).

Right, so in the proposed scheme all these tasks would be executed by
trusted processes, and trusted processes will never get frozen and so
will never be delayed in processing these events.

Only untrusted code will be frozen. And trusted processes are reliable
for thawing the untrusted processes and delivering events to it.

Trusted processes are assumed to be sane and idle when there is nothing
for them to do, allowing the machine to go into deep idle states.

