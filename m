Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab1DZUrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:47:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53889 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101Ab1DZUrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:47:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for device PM.
Date: Tue, 26 Apr 2011 22:47:43 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com> <201104261347.21811.rjw@sisk.pl> <20110426203543.GB27140@elf.ucw.cz>
In-Reply-To: <20110426203543.GB27140@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104262247.44113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 26, 2011, Pavel Machek wrote:
> Hi!
> 
> > If I saw it correctly, patches [2-3/3] only added the generic routine to
> > the platform and i2c bus types, right?
> > 
> > Now, this one is better than the previous one IMO, but (1) it also should
> > cover hibernation (I'd don't see a reason why suspend-to-RAM should be a
> > special case here) and (2) I don't really think that thawing user
> > space is
> 
> Suspend-to-RAM really is special here... at least for zaurus-like
> machine.
> 
> In hibernation, you are "powered down"; that means suspend to RAM with
> bootloader active (operating system is off). You do not need to do any
> kind of maintenance -- bootloader takes care of battery charging and
> protection.
> 
> > "too heavy" (in fact it's much lighter weight than resuming all devices
> > that your approach doesn't prevent from happening, so for example on my
> > desktop/notebook machines I woulnd't mind at all if user space were
> > thawed after all of the devices had been resumed).
> 
> Well, it would be behavior change for the user. I told the zaurus to
> go s2ram, I do not expect it to wake up after 5 minutes because it
> needed to check battery status.
> 
> I'd have to modify my userland to retry suspend again and again and
> again...

And that's exactly what should be done.  Have a user space process controlling
that, because avoiding to thaw user space doesn't buy us almost anything.

Now, I know that it's probably easier to modify the kernel than to write
a user space tool for that, test it and so on, but "easier" is not necessarily
"better".

> > > @@ -145,6 +145,15 @@ typedef struct pm_message {
> > >   *	actions required for resuming the device that need interrupts to be
> > >   *	disabled
> > >   *
> > > + * @suspend_again: Tell the system whether the device wants to either
> > > + *	suspend again (return > 0), wake up (return < 0), or not-care
> > > + *	(return = 0). If a device wants to poll sensors or execute some code
> > > + *	during suspended, suspend_again callback is the place assuming that
> > > + *	periodic-wakeup or alarm-wakeup is already setup. Note that if a
> > > + *	device returns "wakeup" with an under-zero value, it overrides
> > > + *	other devices' "suspend again" return values. This allows to
> > > + *	execute some codes while being kept suspended in the view of userland.
> > > + *
> > 
> > Since, as I said, I think that should cover hibernation too, I'd change the
> > name to, say, sleep_again().
> 
> I'm not sure if we need to cover hibernation. Do you know any machine
> that needs this for hibernation case?

Yes, any machine that "needs" it while suspended.  What's the difference,
after all?  The only difference is that there's an image on permanent storage
in the hibernation case.  You still can overheat a battery when charging it
while hibernated, right?

> > > @@ -291,7 +291,9 @@ int enter_state(suspend_state_t state)
> > >  		goto Finish;
> > >  
> > >  	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
> > > -	error = suspend_devices_and_enter(state);
> > > +	do {
> > > +		error = suspend_devices_and_enter(state);
> > > +	} while (!error && dpm_suspend_again());
> > >  
> > >   Finish:
> > >  	pr_debug("PM: Finishing wakeup.\n");
> > > 
> > 
> > To conclude, I'm not sure about the approach.  In particular, I'm not sure
> > if the benefit is worth the effort and the resulting complications (ie. the
> > possibility of having to deal with wakeup signals not requested by user
> > space) seem to be a bit too far reaching.
> 
> We already have platform-specific hacks to do exactly this at least on
> Zaurus. Moving it to common code means that hacks are not duplicated..

Well, good to know they are there, but I'm still not sure what to do about
that.  At the moment I feel like having too little information to really
decide, so perhaps please point me to the code you're talking about for
starters.

Thanks,
Rafael
