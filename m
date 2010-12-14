Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab0LNUCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:02:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55701 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759573Ab0LNUCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:02:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 4/4] PM: Permit registrarion of parentless devices during system suspend
Date: Tue, 14 Dec 2010 21:02:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.1012132205000.28712-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012132205000.28712-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012142102.07804.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 14, 2010, Alan Stern wrote:
> On Tue, 14 Dec 2010, Rafael J. Wysocki wrote:
> 
> > On Monday, December 13, 2010, Alan Stern wrote:
> > > On Mon, 13 Dec 2010, Rafael J. Wysocki wrote:
> > > 
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > The registration of a new parentless device during system suspend
> > > > will not lead to any complications affecting the PM core (the device
> > > > will be effectively seen after the subsequent resume has completed),
> > > > so remove the code used for detection of such events.
> > > 
> > > Actually the tests you're changing were never as strong as they should
> > > have been.  Drivers are supposed to avoid registering new children
> > > beneath a device as soon as the device has gone through the "prepare"
> > > stage, not just after the device is suspended.  Should there be a 
> > > "prepared" bitflag to help implement this stronger test?
> > 
> > The in_suspend flag introduced by [3/4] works like this, actually.
> 
> Not entirely, because it doesn't get set until the device has gone 
> through the "suspend" stage.
> 
> > > In principle the same idea applies to parentless devices, since they
> > > can be considered children of the "system device" (a fictitious node at
> > > the root of the device tree).  The "system" goes into the prepared
> > > state before all the real devices; that's what the transition_started
> > > variable was all about.  It's nothing more than the "prepared" bitflag
> > > for the "system device".
> > 
> > It has never worked like this, because it was cleared as early as at the
> > _noirq() stage.
> 
> That was part of our lenient approach, allowing devices to be 
> registered during system resume earlier than the documentation says 
> they should be.
> 
> > Hmm.  It looks like I should modify [3/4] to clear the in_suspend flag earlier
> > to follow the current behavior (if a device is DPM_RESUMING, registration of
> > new children doesn't trigger the warning).
> 
> You could clear in_suspend at the start of device_resume.
> 
> In the end, it's a question of what are we trying to accomplish.  The
> warnings catch the most egregious violations of the documented
> requirements.  Is the purpose to let people know about the violations,
> or is it to warn about actions that appear genuinely dangerous?

I'd say the latter, like trying to register a device (child) under a suspended
controller (parent).  However, I think the new code shouldn't trigger the
warning when the old code didin't or people will report that as an apparent
issue.

Thanks,
Rafael
