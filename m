Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab0FFNy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 09:54:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561Ab0FFNyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 09:54:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: suspend blockers & Android integration
Date: Sun, 6 Jun 2010 15:55:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
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
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20100603193045.GA7188@elte.hu> <201006060044.16950.rjw@sisk.pl> <AANLkTikrPTvkXZM2yybiDfkHraRkw4oCH9nC8R4d3KS5@mail.gmail.com>
In-Reply-To: <AANLkTikrPTvkXZM2yybiDfkHraRkw4oCH9nC8R4d3KS5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006061555.38526.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 June 2010, Arve Hjønnevåg wrote:
> 2010/6/5 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Saturday 05 June 2010, Arve Hjønnevåg wrote:
> >> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> >> > B1;2005;0cOn Fri, 4 Jun 2010, Arve Hjønnevåg wrote:
...
> >
> > Arve, we're still learning you have some more requirements we had no idea
> 
> What new requirement are you talking about. Did you assume all our
> user-space ipc calls went though a single process?

No, but I didn't assume that your wakelock-holding processes depend on the
other processes in a way that might prevent them from acquiring or dropping
a wakelock.

...
> >> >> Trusted code that calls into untrusted code has to deal with the
> >> >> untrusted code not responding, but we only want to pop up a message
> >> >> that the application is not responding if it is misbehaving, not just
> >> >> because it was frozen though no fault of its own.
> >
> > When Android starts opportunistic suspend, all applications are frozen,
> > "trusted" as well as "untrusted", right?  So, after they are all frozen, none
> > of them can do anything to prevent suspend from happening, right?
> 
> Not if you mean when we write to /sys/power/state. Processes are not
> frozen until the last suspend blocker is released.

That doesn't matter.  In the opportunistic mode you don't need to write into
/sys/power/state to start suspend, this is done by the kernel automatically as
soon as the last wakelock has been released (at least this is my assumption
about how this works).  Now, at this point the processes that don't use
wakelocks can't really prevent themselves from being frozen and only the
wakelocks users can do that.  So, if a wakelock user depends on a process
that doesn't use wakelocks in such a way that (because of that dependence) it
can't acquire its wakelock while processes are being frozen, things don't work
as they are supposed to.

> > Now, in my proposed approach the "untrusted" apps are frozen exactly at the
> > point Android would start opportunistic suspend and they wouldn't be able
> > to do anything about that anyway.  So if one of your "trusted" apps depends
> > on the "untrusted" ones in a way that you describe, you alread have a bug
> > (the "trusted" app cannot prevent automatic suspend from happening even if it
> > wants, because it depends on an "untrusted" app that has just been frozen).
> >
> 
> I don't think what you said here is correct. If a wakeup event happens
> all processed are unfrozen since the driver blocks suspend.

This only means that the theoretical failure you gave as an example doesn't
happen in practice.  No problem, then. :-)

> The app that reads this event blocks suspend before reading it. If it was
> busy talking to a less trusted app when the event happened it still works
> since all apps are running at this point.

And how is this different from an approach with cgroup freezing?  Apps that
use wakelock within the current framework would use "freeze locks" to prevent
the "untrusted" part of user space from being frozen or to thaw it.  Where's
the problem, then?

Rafael
