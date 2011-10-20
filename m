Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1JTO3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:29:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53744 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755799Ab1JTO3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:29:34 -0400
Date: Thu, 20 Oct 2011 10:29:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NeilBrown <neilb@suse.de>
cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <20111020111743.13b40558@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011, NeilBrown wrote:

> > All a client needs to know is whether or not _it_ is busy, so that it
> > can provide correct information to the daemon.  (Some clients may also
> > need to be notified each time the system resumes -- that's a separate
> > matter.)  As for the rest, a client may as well assume that the system
> > is perpetually on the verge of suspending, except when it has
> > personally told the daemon to stay awake.
> 
> I don't think it is always appropriate to assume the system is on the verge
> of suspending except when explicitly asking for stay-awake.

For some programs it may not be appropriate, but for wakeup clients I 
believe it is.

> Consider a daemon tasked with managing the "GSM" interface in a phone.
> Any message from the GSM module will wake the phone if it is suspended.
> 
> When suspended, the daemon only wants to get "incoming call" and "incoming
> SMS" events.
> When not suspended, the daemon also wants "Active cell changed" events so
> that it can make this information available to some display widget.
> 
> So when it is told that a suspend is imminent it quickly tells the GSM
> module to be quieter and then says "OK".  If it had to assume it was always
> on the verge, it could never allow active-cell-changed events.
> 
> You could argue that the GSM daemon should only be reporting CELL changes -
> and so the GSM module should only be asked to report them - when the widget
> (or some other client) is explicitly asking for them.  So when the screen
> goes blank, the widget stops getting expose events, so it rescinds is request
> for updates and the GSM daemon passes that on to the GSM module.  So when
> suspend happens, the GSM module has already stopped reporting.
> 
> But I'm not convinced that complexity is always justified.
> 
> I could make the situation a little more complex.  There might be a daemon
> which wants to monitor GSM cell locations and so is always asking.
> The GSM daemon might have a policy that if anyone wants those updates, then
>  - if system is awake for some other reason, report them as they arrive
>  - if system is otherwise suspended, wake up every 10 minutes to poll and
>    report.
> 
> In that case the suspend-client (the GSM daemon) really does care about the
> difference between an explicit stay-awake and a late reply to a
> suspend-imminent message.
> 
> So I'm still inclined to think that the two cases need to be treated
> separately.

The way I see it, your GSM daemon needs to know when the system is 
about to go into suspend.  That's a separate matter from communicating 
information about wakeup activity to/from the PM daemon.

What should happen is this: When the PM daemon is ready to start a
suspend (none of its clients need to keep the system awake), it should
broadcast the fact that a suspend is about to begin.  This broadcast
could take various forms, the simplest of which is to run a shell
script.

In fact, we may want to integrate the PM daemon into pm-utils at a 
level above where the various suspend scripts get run.

Alan Stern

