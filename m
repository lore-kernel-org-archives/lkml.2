Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0HAWna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 18:43:30 -0400
Received: from THUNK.ORG ([69.25.196.29]:36384 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab0HAWn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 18:43:28 -0400
Date: Sun, 1 Aug 2010 16:40:26 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100801204026.GH31324@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
	florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
	swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
	alan@lxorguk.ukuu.org.uk
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801191228.GL2470@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 12:12:28PM -0700, Paul E. McKenney wrote:
> 
> I understand that you would prefer that we group applications into
> "good" and "bad" categories, but then again, I suspect that most of us
> understood that before you posted this message.  Given your significant
> and well-appreciated contributions to power efficiency over the past
> several years, I must confess to be quite disappointed that you failed
> to do more than to simply restate your preference.

Paul, I very much agree with what you stated later, with respect to
doubting whether the whack-a-mole approach to application fixups is
workable.  Given how many applications screw up using fsync()
correctly, to the extent that XFS, ext4, and btrfs all had to agree on
a common hueristics to deal with the fact that application programmers
are aggressively ignorant, and outnumber the file system developers, I
too doubt the general strategy of relying only on application
programmers to do the right thing.  That's not to say that we
shouldn't give up on trying to influence application programmers ---
but relying on that as the only strategy seems to depart from the path
of wisdom.

There is however a much bigger point, which is that it's unfortunately
black and white to talk about applications being "good" and "bad".  In
fact, it's a continuing point of concern I have with the whole qos
approach to power management.  In fact, power is often something that
needs to trade off against performance.  For example, an application
could aggressively prefetch e-mail messages or web pages that a user
_might_ view --- or it could aggressively pre-resolve DNS queries,
etc, which might make perfect sense when the device is hooked up to AC
mains, but which I might not want to do on when I only have 800mWh
worth of battery --- however, if I'm using a laptop with 94,000mWh,
maybe I'd be happy if the application was a bit more profligate.

So for Arjan to claim that all applications will be held to the same
standard, whether they are hooked up to the AC mains, or are limited
to 800mWh of battery, or 94,000 mWh worth of power, is vastly
oversimplifying the problem.  Of *course* if I'm writing an
application that will be running in a cloud data center, I'm going to
care about power.  But I may have different tradeoffs about what might
considered acceptible when considering the qualify of user experience
I'm delivering to the end-user when I'm connected to AC mains, versus
a cell phone battery, versus a 6-cell laptop battery.

This brings me back to a major problem I have with the pm_qos approach
to power management.  It assumes that applications know best, and that
they should be free to tell pm_qos subsystem whether they need 0ms
latency for wireless.  Right now, I can't even query the pm_qos
subsystem to see which application is responsible for keeping the
wireless on 100% of the time!  And even if I could find out, maybe
some power management framework should be allowed to give a override
to the application's wishes.  OK, maybe the Opera web browser is
requesting the very best wireless QOS because it wants to beat Chrome
on some silly potato benchmark --- well, it's ***stupid*** to say that
my power management should be a one-size-fits all because applications
should be always as power efficient as possible whether they are
connected to AC mains or I have a 800mWh cell phone battery.  Worse
yet, it's stupid to say that the application should have the last
word.  Darn it, *I* own the mobile device, and I (or my proxy, which
might be the Android OS, or some power manage daemon) should be able
to say, "I don't care what the application claimed it wanted for power
QOS --- it's not getting more than 100ms wireless latency, and that's
final."

And note that this is something that might even change over time, or
depending on circumstances.  Maybe normally I might be willing to let
the application be profilgate with power, so that web pages render a
bit faster than they might otherwise --- but if I'm on an American
Airlines flight which has retrofitted its power jacks to use an AC
plug, and I only have a DC adaptor, and my laptop batteries are worn
out and only have half their endurance as they used to, I might want
to use a more stringent pm_qos than I might otherwise normally allow.

          	      		       	       - Ted

