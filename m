Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0HGGQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:16:19 -0400
Received: from THUNK.ORG ([69.25.196.29]:32998 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab0HGGQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:16:14 -0400
Date: Sat, 7 Aug 2010 02:15:59 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: david@lang.hm
Cc: Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100807061558.GA28087@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, david@lang.hm,
	Brian Swetland <swetland@google.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
	florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
	peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
	menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
	arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
	dipankar@in.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100804195704.GA23681@linux.vnet.ibm.com>
 <20100806225453.GA3947@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
 <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
 <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 08:14:09PM -0700, david@lang.hm wrote:
> 
> that description sounds far more like normal sleep power management
> that suspending. especially since they want to set timers to wake
> the system up and the defining characteristic of suspend (according
> to this thread) is that timers don't fire while suspended.
> 
> as I am seeing it, there are two reasons why this don't "just work"
> 
> 1. sleeping can't currently save as much power as suspending

No, I don't think that's the case at all.  The key thing here is that
*most* applications don't need to be modified to use suspend locks,
because even though they might be in an event loop, when the user user
turns off the display, the user generally doesn't want it doing things
on their behalf.

Again, take for example the Mac Book, since Apple has gotten this
right for most users' use cases.  When you close the lid, you even if
the application is under the misguided belief that it should be
checking every five seconds to see whether or not the web page has
reloaded --- actually, that's not what you want.  You probably want
the application to be forcibly put to sleep.  So the whole point of
the suspend blocker design is that you don't have to modify most
applications; they just simply get put to sleep when you close the
MacBook lid, or, in the case of the Android device, you push the
button that turns off the screen.

So the reason why this doesn't work is that power management for small
mobile devices *is* different from power management for laptops and
data center servers, and if you want a rich application ecosystem,
it's best if you don't require them to be specially tuned to use the
absolute minimum power.  (And that means waking up every 30 seconds
might be too much; as Brian and Arve have pointed out, with the G1 in
airplane mode, the CPU might be waking up once every half hour or more
--- and at that rate, powertop will be waking up the CPU more than
Android system would be doing so.)

So the real key here is to take most applications, which may be
written using techniques that might be considered well written from a
laptop point of view, but not for a cell phone, and not require
modifications.  Even though the application writer might think it's
doing well by waking up every 15 seconds, if the laptop lid is down,
or if the screen is off, for **most** applications, it should be
forcibly put to sleep.

It's only the rare applications that should really be allowed to run
while screen is off.  And it's only those applications that need
modifications to use suspend blocker.  From your earlier comments, it
seems that this is the key point which you are missing.  (No doubt,
some of these applications that do need to know about suspend blockers
are important ones; ones that make sure the battery isn't about to
blow up, or ones which silently wake up every 10-15 minutes to pull
down fresh mail for you from your mail server.  But those applications
are the exception, not the rule.)

Best regards,

	    	   	   		    	- Ted
