Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab1DZUfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:35:50 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53278 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757448Ab1DZUfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:35:48 -0400
Date: Tue, 26 Apr 2011 22:35:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for
 device PM.
Message-ID: <20110426203543.GB27140@elf.ucw.cz>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
 <1303781471-2477-1-git-send-email-myungjoo.ham@samsung.com>
 <201104261347.21811.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104261347.21811.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> If I saw it correctly, patches [2-3/3] only added the generic routine to
> the platform and i2c bus types, right?
> 
> Now, this one is better than the previous one IMO, but (1) it also should
> cover hibernation (I'd don't see a reason why suspend-to-RAM should be a
> special case here) and (2) I don't really think that thawing user
> space is

Suspend-to-RAM really is special here... at least for zaurus-like
machine.

In hibernation, you are "powered down"; that means suspend to RAM with
bootloader active (operating system is off). You do not need to do any
kind of maintenance -- bootloader takes care of battery charging and
protection.

> "too heavy" (in fact it's much lighter weight than resuming all devices
> that your approach doesn't prevent from happening, so for example on my
> desktop/notebook machines I woulnd't mind at all if user space were
> thawed after all of the devices had been resumed).

Well, it would be behavior change for the user. I told the zaurus to
go s2ram, I do not expect it to wake up after 5 minutes because it
needed to check battery status.

I'd have to modify my userland to retry suspend again and again and
again...

> > @@ -145,6 +145,15 @@ typedef struct pm_message {
> >   *	actions required for resuming the device that need interrupts to be
> >   *	disabled
> >   *
> > + * @suspend_again: Tell the system whether the device wants to either
> > + *	suspend again (return > 0), wake up (return < 0), or not-care
> > + *	(return = 0). If a device wants to poll sensors or execute some code
> > + *	during suspended, suspend_again callback is the place assuming that
> > + *	periodic-wakeup or alarm-wakeup is already setup. Note that if a
> > + *	device returns "wakeup" with an under-zero value, it overrides
> > + *	other devices' "suspend again" return values. This allows to
> > + *	execute some codes while being kept suspended in the view of userland.
> > + *
> 
> Since, as I said, I think that should cover hibernation too, I'd change the
> name to, say, sleep_again().

I'm not sure if we need to cover hibernation. Do you know any machine
that needs this for hibernation case?

> > @@ -291,7 +291,9 @@ int enter_state(suspend_state_t state)
> >  		goto Finish;
> >  
> >  	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
> > -	error = suspend_devices_and_enter(state);
> > +	do {
> > +		error = suspend_devices_and_enter(state);
> > +	} while (!error && dpm_suspend_again());
> >  
> >   Finish:
> >  	pr_debug("PM: Finishing wakeup.\n");
> > 
> 
> To conclude, I'm not sure about the approach.  In particular, I'm not sure
> if the benefit is worth the effort and the resulting complications (ie. the
> possibility of having to deal with wakeup signals not requested by user
> space) seem to be a bit too far reaching.

We already have platform-specific hacks to do exactly this at least on
Zaurus. Moving it to common code means that hacks are not duplicated..
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
