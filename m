Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0LNDTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 22:19:09 -0500
Received: from netrider.rowland.org ([192.131.102.5]:36910 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752075Ab0LNDTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:19:08 -0500
Date: Mon, 13 Dec 2010 22:19:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH 4/4] PM: Permit registrarion of parentless devices
 during system suspend
In-Reply-To: <201012140005.49193.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012132205000.28712-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010, Rafael J. Wysocki wrote:

> On Monday, December 13, 2010, Alan Stern wrote:
> > On Mon, 13 Dec 2010, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > The registration of a new parentless device during system suspend
> > > will not lead to any complications affecting the PM core (the device
> > > will be effectively seen after the subsequent resume has completed),
> > > so remove the code used for detection of such events.
> > 
> > Actually the tests you're changing were never as strong as they should
> > have been.  Drivers are supposed to avoid registering new children
> > beneath a device as soon as the device has gone through the "prepare"
> > stage, not just after the device is suspended.  Should there be a 
> > "prepared" bitflag to help implement this stronger test?
> 
> The in_suspend flag introduced by [3/4] works like this, actually.

Not entirely, because it doesn't get set until the device has gone 
through the "suspend" stage.

> > In principle the same idea applies to parentless devices, since they
> > can be considered children of the "system device" (a fictitious node at
> > the root of the device tree).  The "system" goes into the prepared
> > state before all the real devices; that's what the transition_started
> > variable was all about.  It's nothing more than the "prepared" bitflag
> > for the "system device".
> 
> It has never worked like this, because it was cleared as early as at the
> _noirq() stage.

That was part of our lenient approach, allowing devices to be 
registered during system resume earlier than the documentation says 
they should be.

> Hmm.  It looks like I should modify [3/4] to clear the in_suspend flag earlier
> to follow the current behavior (if a device is DPM_RESUMING, registration of
> new children doesn't trigger the warning).

You could clear in_suspend at the start of device_resume.

In the end, it's a question of what are we trying to accomplish.  The
warnings catch the most egregious violations of the documented
requirements.  Is the purpose to let people know about the violations,
or is it to warn about actions that appear genuinely dangerous?

Alan Stern

