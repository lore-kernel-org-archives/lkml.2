Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0E1PAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:00:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55173 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0E1PAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:00:00 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <1275052817.1645.64.camel@laptop>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	 <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	 <20100527220949.GB10602@srcf.ucam.org>
	 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
	 <20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
	 <AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
	 <20100528132138.2d802d77@lxorguk.ukuu.org.uk>
	 <1275049836.1645.1.camel@laptop>
	 <20100528140236.3214929e@lxorguk.ukuu.org.uk>
	 <1275052817.1645.64.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 May 2010 16:59:54 +0200
Message-ID: <1275058794.27810.9571.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 15:20 +0200, Peter Zijlstra wrote:
> On Fri, 2010-05-28 at 14:02 +0100, Alan Cox wrote:
> > On Fri, 28 May 2010 14:30:36 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, 2010-05-28 at 13:21 +0100, Alan Cox wrote:
> > > > [Total kernel changes
> > > > 
> > > >         Ability to mark/unmark a scheduler control group as outside of
> > > >         some parts of idle consideration. Generically useful and
> > > >         localised. Group latency will do most jobs fine (Zygo is correct
> > > >         it can't solve his backup case elegantly I think)
> > > > 
> > > >         Test in the idling logic to distinguish the case and only needed
> > > >         for a single Android specific power module. Generically useful
> > > >         and localised] 
> > > 
> > > I really don't like this..
> > > 
> > > Why can't we go with the previously suggested: make bad apps block on
> > > QoS resources or send SIGXCPU, SIGSTOP, SIGTERM and eventually SIGKILL
> > 
> > Ok. Are you happy with the QoS being attached to a scheduler control
> > group and the use of them to figure out what is what ?
> 
> Up to a point, but explicitly not running runnable tasks complicates the
> task model significantly, and interacts with fun stuff like bandwidth
> inheritance and priority/deadline inheritance like things -- a subject
> you really don't want to complicate further.
> 
> We really want to do our utmost best to make applications block on
> something without altering our task model.
> 
> If applications keep running despite being told repeatedly to cease, I
> think the SIGKILL option is a sane one (they got SIGXCPU, SIGSTOP and
> SIGTERM before that) and got ample opportunity to block on something.
> 
> Traditional cpu resource management treats the CPU as an ever
> replenished resource, breaking that assumption (not running runnable
> tasks) puts us on very shaky ground indeed.

Also, I'm not quite sure why we would need cgroups to pull this off.

It seems most of the problems the suspend-blockers are trying to solve
are due to the fact of not running runnable tasks. Not running runnable
tasks can be seen as assigning tasks 0 bandwidth. Which is a situation
extremely prone to all things inversion. Such a situation would require
bandwidth inheritance to function at all, so possibly we can see
suspend-blockers as a misguided implementation of that.

So lets look at the problem, we want to be frugal with power, this means
that the system as a whole should strive to do nothing. And we want to
enforce this as strict as possible.

If we look at the windowing thing, lets call it X, X will inform its
clients about the visibility of their window, any client trying to draw
to its window when it has been informed about it not being visible is
wasting energy and should be punished.

(I really wish the actual X on my desktop would do more of that -- its
utterly rediculous that firefox keeps animating banners and the like
when nobody can possibly see them)

Clearly when we turn the screen off, nothing is visible and all clients
should cease to draw.

How do we want to punish dis-obedient clients? Is blocking them
sufficient? Do we want to maintain a shitlist of iffy clients?

Note that the 'buggy' client doesn't function properly, if we block its
main event loop doing this, it won't respond to other events -- but as
argued, its a buggy app, hence its per definition unreliable and we
don't care.

Next comes the interesting problem of who gets to keep the screen lit, I
think in the above case that is a pure userspace problem and doesn't
need kernel intervention.

Can we apply the same reasoning to other resources, filesystems,
network? For both of them it seems the main governing body isn't this
windowing system, but the kernel (although arguably you could fully do
it in middle-ware, just like X is that).

But in both cases I think we can work with a QoS system where we assign
some service-level to each task, and a server-level (with inverse
priority scales to the task level), and only provide service when
task-level >= server-level. [server-level 0 would serve everybody,
task-level 0 would only get service when everybody does]

If we allow userspace to set server-levels, we need to ensure that
whoever is allowed that is a well functioning program.

We can do a similar thing for wakeups, aside from setting wakeup slack,
we can also set a wakeup limit per task, but I'm not quite sure how that
would work out. That needs more thought. But an application exceeding
its wakeup limit would still need to be woken (not doing so leads to fun
problems) but the event is clearly attributable and loggable.

