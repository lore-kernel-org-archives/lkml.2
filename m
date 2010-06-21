Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab0FUV7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:59:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab0FUV7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:59:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Mon, 21 Jun 2010 23:58:05 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006212358.05755.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 21, 2010, Alan Stern wrote:
> On Sun, 20 Jun 2010, Rafael J. Wysocki wrote:
> 
> > > > Generally, there are two problems in that area.  First, if a wakeup event
> > > > occurs exactly at the same time when /sys/power/state is being written to,
> > > > the even may be delivered to user space right before the freezing of it,
> > > > in which case the user space consumer of the event may not be able to process
> > > > it before the system is suspended.
> > > 
> > > Indeed, the same problem arises if the event isn't delivered to
> > > userspace until after userspace is frozen.
> > 
> > In that case the kernel should abort the suspend so that the event can be
> > delivered to the user space.
> 
> Yes.
> 
> > > Of course, the underlying issue here is that the kernel has no direct way
> > > to know when userspace has finished processing an event.  Userspace would
> > > have to tell it, which generally would mean rewriting some large number of user
> > > programs.
> > 
> > I'm not sure of that.  If the kernel doesn't initiate suspend, it doesn't
> > really need to know whether or not user space has already consumed the event.
> 
> That's true.  But it only shifts the onus: When a userspace program has 
> finished processing an event, it has to tell the power-manager process.  
> Clearly this sort of thing is unavoidable, one way or another.

That's correct, but there already are multiple ways to communicate things
between user space processes, while we would need new interfaces to
pass that information between user space and the kernel.  That makes quite
some difference.

> > > > The following patch illustrates my idea of how these two problems may be
> > > > addressed.  It introduces a new global sysfs attribute,
> > > > /sys/power/wakeup_count, associated with a running counter of wakeup events
> > > > and a helper function, pm_wakeup_event(), that may be used by kernel subsystems
> > > > to increment the wakeup events counter.
> > > 
> > > In what way is this better than suspend blockers?
> > 
> > It doesn't add any new framework and it doesn't require the users of
> > pm_wakeup_event() to "unblock" suspend, so it is simpler.  It also doesn't add
> > the user space interface that caused so much opposition to appear.
> 
> Okay.  A quick comparison shows that in your proposal:
> 
> 	There's no need to register and unregister suspend blockers.
> 	But instead you create the equivalent of a suspend blocker
> 	inside every struct device.

Not really.  That thing is for statistics purposes only and it's not essential
from the functionality POV.  But you know that. :-)

> 	Drivers (or subsystems) don't have to activate suspend 
> 	blockers.  But instead they have to call pm_wakeup_event().
>
> 	Drivers don't have to deactivate suspend blockers.  You don't
> 	have anything equivalent, and as a result your scheme is 
> 	subject to the race described below.

The original one without user space variant of suspend blockers is subject to
it as well, because the kernel doesn't know when the user space consumer is
going to finish processing the event.

Rafael
