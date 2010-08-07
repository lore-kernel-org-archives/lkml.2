Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0HGG2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:28:46 -0400
Received: from THUNK.ORG ([69.25.196.29]:44231 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab0HGG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:28:43 -0400
Date: Sat, 7 Aug 2010 02:28:28 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: david@lang.hm
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100807062828.GB28087@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, david@lang.hm,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Brian Swetland <swetland@google.com>,
	kevin granade <kevin.granade@gmail.com>,
	Arve Hj?nnev?g <arve@android.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
	peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm>
 <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
 <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
 <20100806123047.GE31326@sirena.org.uk>
 <20100806172226.GH2432@linux.vnet.ibm.com>
 <20100806173325.GA25367@rakim.wolfsonmicro.main>
 <20100806181832.GJ2432@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008061517130.30564@asgard.lang.hm>
 <20100807001431.GA3252@opensource.wolfsonmicro.com>
 <alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 06:00:34PM -0700, david@lang.hm wrote:
> 
> today there are two ways of this happening, via the idle approach
> (on everything except Android), or via suspend (on Android)
> 

Most other devices use a lot more power at idle; in some cases it's
because the hardware just isn't as power optimized (why bother, when
you have 94,000 mWh of power at your disposal with a 6 cell laptop
battery, as opposed to the 800-1000 mWh that you might have on a cell
phone battery).  In other cases, it's because the kernel and the
low-level software stack (never mind the applications) are waking up
the CPU too darned often --- in other words, idle simply isn't idle
enough.

So you may want to consider whether part of the problem is that
general purpose Linux systems need a radical redesign to get power
utilization down to those sorts of levels --- where the CPU might only
be waking up once every half-hour or so, and then only do actual
useful work.

Can you get there by assuming that every single application is
competently written?  In an idle approach, you have to.  That way lies
Maemo, where installing just one bad application will cut your battery
life time by a factor of 2-3.  You could try stopping processes by
using kill -STOP, but this at that point, you've moved into Android
strategy of "suspend".  And the only question is what is the most
efficient way to allow the system to run when there is true work that
needs to be done, and how to avoid deadlocks by stopping processes
that might be holding user space locks --- and to administer when and
how to suspend the processes.

Sure, you could do someting amazing complicated using cgroups, and
user space processes that have to wake up the CPU every 30 seconds to
see if it's safe to suspend the system --- but why not just use the
system which is being used by 200,000 new phones every day?  It's
simple and it works.  And unlike Maemo, untrustworthy applications
don't end up chewing up your battery lifetime.

						- Ted
