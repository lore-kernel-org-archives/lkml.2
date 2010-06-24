Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab0FXXIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 19:08:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab0FXXII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 19:08:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Fri, 25 Jun 2010 01:06:41 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006241257410.1654-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006241257410.1654-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006250106.41855.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 24, 2010, Alan Stern wrote:
> On Thu, 24 Jun 2010, Rafael J. Wysocki wrote:
> 
> > > This is slightly different from the wakelock design.  Each call to
> > > pm_stay_awake() must be paired with a call to pm_relax(), allowing one
> > > device to have multiple concurrent critical sections, whereas calls to
> > > pm_wakeup_event() must not be paired with anything.  With wakelocks,
> > > you couldn't have multiple pending events for the same device.
> > 
> > You could, but you needed to define multiple wakelocks for the same device for
> > this purpose.
> 
> Yeah, okay, but who's going to do that?
> 
> > > I'm not sure which model is better in practice.  No doubt the Android people 
> > > will prefer their way.
> > 
> > I suppose so.
> 
> It may not make a significant difference in the end.  You can always
> emulate the wakelock approach by not calling pm_stay_awake() when you
> know there is an earlier call still pending.
> 
> > > This requires you to define an explicit PCI_WAKEUP_COOLDOWN delay.  I 
> > > think that's okay; I had to do something similar with USB and SCSI.  
> > > (And I still think it would be a good idea to prevent workqueue threads 
> > > from freezing until their queues are empty.)
> > 
> > I guess you mean the freezable ones?
> 
> Yes.  The unfreezable workqueue threads don't have to worry about 
> getting frozen while their queues are non-empty.  :-)
> 
> >  I'm not sure if that helps a lot, because
> > new work items may still be added after the workqueue thread has been frozen.
> 
> That's not the point.  If a wakeup handler queues a work item (for
> example, by calling pm_request_resume) then it wouldn't need to guess a
> timeout.  The work item would be guaranteed to run before the system
> could suspend again.

You seem to be referring to the PM workqueue specifically.  Perhaps it would be
better to special-case it and stop it by adding a barrier work during suspend
instead of just freezing?  Then, it wouldn't need to be singlethread any more.

Still, I think the timeout is necessary anyway in case the driver simply
doesn't handle the event and user space needs time to catch up.  Unfortunately,
the PCI wakeup code doesn't know what happens next in advance.

Rafael
