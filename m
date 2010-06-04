Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0FDJ7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:59:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab0FDJ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:59:44 -0400
Date: Fri, 4 Jun 2010 11:59:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Swetland <swetland@google.com>
Cc: tytso@mit.edu, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604095917.GA3324@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com>
 <20100604075722.GA15181@elte.hu>
 <AANLkTiksGnpL8tkcc5eScWHrGoijyZNUwZik5lXmU_TS@mail.gmail.com>
 <20100604085513.GE15181@elte.hu>
 <AANLkTinphtxn-8pGTYv_mBxKFMa7jU8i1yNbHrs50Vzl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinphtxn-8pGTYv_mBxKFMa7jU8i1yNbHrs50Vzl@mail.gmail.com>
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


* Brian Swetland <swetland@google.com> wrote:

> On Fri, Jun 4, 2010 at 1:55 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > * Brian Swetland <swetland@google.com> wrote:
> >> > After basically two years of growing your fork (and some attempts to get
> >> > your drivers into drivers/staging/ - from where they have meanwhile
> >> > dropped out again) you re-started with the worst possible thing to merge:
> >> > a big and difficult kernel feature affecting many subsystems. Why?
> >>
> >> Because a large number of our drivers depend on it.
> >
> > So why not put in some stub or so? Auto-suspend/suspend-blockers is a 
> > feature, and drivers ought to be able to work without a feature as well. 
> > Keep the suspend-blocker changes in the android tree initially, and get 
> > the main body of changes out first, and establish a flow of timely 
> > changes. That reduces your maintenance burden and increases trust for 
> > future changes - a win-win situation.
> 
> The impression I got from previous discussions was that upstream did not 
> want things that were built conditionally around APIs that did not exist in 
> mainline nor stub implementations for things that were not agreed upon.

Well, if it's some ugly #ifdef solution i could imagine light objections on 
pure aesthetic micro-grounds.

> We could easily either #if defined(CONFIG_SUSPEND_BLOCKERS) or submit a 
> suspend_blockers.h that just makes everything a no-op, if that's an 
> acceptable transition vehicle.  I didn't think either were an option open to 
> us.

You can certainly put in a suspend_blockers.h thing into some Android 
directory, and populate it with empty wrappers - as long as you only use it 
within Android drivers and not core kernel code or other subsystems you dont 
maintain.

It's being done all the time and helpful cleanup patches eliminating the stubs 
are frowned upon (unless the subs are there like for years with no progress 
and no maintenance in sight).

Putting empty stubs into include/linux/ would be pushing things i think.

In fact sometimes architectures even jump the gun with major kernel features: 
we had a dynticks implementation in ARM for years, we had RTLinux stubs in x86 
code for quite some time, and we still have perfmon in IA64 - despite the core 
kernel having gone for a different design.

It's certainly not ideal, but it's certainly a solution that is used every now 
and then. The less difference there is between trees the easier it becomes to 
merge - for both sides, both technically and socially.

> > In any case, this is not to suggest that the suspend-blocker bits are 
> > 'impossible' to merge. I just say that if you start with your most 
> > difficult feature you should not be surprised to be on the receiving end 
> > of a 1000+ mails flamewar on lkml ;-)
> 
> Yeah, I do understand that we're not making it easy for ourselves here.  I 
> think we hit the point where Rafael and Matthew signed off on things and 
> thought "aha, linux-pm maintainers are happy, now we're getting somewhere" 
> only to realize the light at the end of the tunnel was a bit further out 
> than we anticipated ^^

That's a well-known problem on lkml: the light at the end of the tunnel was 
the other train ;-)

Anyway, i'm not pessimistic at all: _some_ sort of scheme appears to be 
crystalising out today. Everyone seems to agree now that the main usecases are 
indeed useful and need handling one way or another - the rest is really just 
technological discussions how to achieve the mostly-agreed-upon end goal.

The worst situation are features where one side says 'we dont need this kind 
of functionality at all' - IMO auto/opportunistic-suspend isnt in that 
situation, fortunately.

Thanks,

	Ingo
