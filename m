Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0FXRJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:09:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33723 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750970Ab0FXRJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:09:28 -0400
Date: Thu, 24 Jun 2010 13:09:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <201006241819.25055.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006241257410.1654-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010, Rafael J. Wysocki wrote:

> > This is slightly different from the wakelock design.  Each call to
> > pm_stay_awake() must be paired with a call to pm_relax(), allowing one
> > device to have multiple concurrent critical sections, whereas calls to
> > pm_wakeup_event() must not be paired with anything.  With wakelocks,
> > you couldn't have multiple pending events for the same device.
> 
> You could, but you needed to define multiple wakelocks for the same device for
> this purpose.

Yeah, okay, but who's going to do that?

> > I'm not sure which model is better in practice.  No doubt the Android people 
> > will prefer their way.
> 
> I suppose so.

It may not make a significant difference in the end.  You can always
emulate the wakelock approach by not calling pm_stay_awake() when you
know there is an earlier call still pending.

> > This requires you to define an explicit PCI_WAKEUP_COOLDOWN delay.  I 
> > think that's okay; I had to do something similar with USB and SCSI.  
> > (And I still think it would be a good idea to prevent workqueue threads 
> > from freezing until their queues are empty.)
> 
> I guess you mean the freezable ones?

Yes.  The unfreezable workqueue threads don't have to worry about 
getting frozen while their queues are non-empty.  :-)

>  I'm not sure if that helps a lot, because
> new work items may still be added after the workqueue thread has been frozen.

That's not the point.  If a wakeup handler queues a work item (for
example, by calling pm_request_resume) then it wouldn't need to guess a
timeout.  The work item would be guaranteed to run before the system
could suspend again.

> > Instead of allocating the work structures dynamically, would you be 
> > better off using a memory pool?
> 
> Well, it would be kind of equivalent to defining my own slab cache for that,
> wouldn't it?

I suppose so.  It would make the GFP_ATOMIC allocations a little more 
reliable.

Alan Stern

