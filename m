Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192Ab1C3VUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:20:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49585 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964850Ab1C3VT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:19:58 -0400
Date: Wed, 30 Mar 2011 17:19:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@suse.com>
cc: Jiri Slaby <jirislaby@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
In-Reply-To: <201103302202.04025.rjw@suse.com>
Message-ID: <Pine.LNX.4.44L0.1103301707210.2085-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Rafael J. Wysocki wrote:

> > Rafael, this does seem to be a general problem.  Suppose a new device
> > gets connected while the system is suspended.  How is the driver's
> > probe method supposed to cope if it gets called while userspace is
> > still frozen but it needs to load some firmware?
> > 
> > Is the answer that probing should always be delayed until after tasks
> > are thawed?  There must be lots of subsystems which would have trouble 
> > doing that, although we ought to be able to implement delayed probing 
> > from within the driver core easily enough.
> 
> I don't know how to solve that.
> 
> First off, the prepare routines of drivers that need to load firmware during
> resume probably should preload the firmware for the devices present during the
> suspend.

That's okay for drivers that are bound to a device before the suspend 
starts.  But we also need to handle new devices added while the system 
was asleep.

> Second, I don't generally think drivers should probe for devices during resume.
> I guess the delayed probing would be the cleanest appoach here.

Here's the difficulty.  Normally the USB subsystem does use delayed
probing -- in fact, probing is done in a freezable thread.  However
this is a special case.  Not all USB drivers support suspend/resume;
those that don't get unbound during suspend and then rebound during
resume.  The rebinding occurs in the "complete" phase of the resume,
before tasks are thawed.

I suppose the rebinding could be delayed.  It would be better to fix
the USB DVB drivers, though, by adding PM support.  But there's a bunch
of them in drivers/media/dvb/dvb-usb, and AFAICS they would all need to
be fixed.  And I have no idea of what changes they would need.

Do you have any better suggestions?

Alan Stern

