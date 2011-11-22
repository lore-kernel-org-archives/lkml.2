Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab1KVUi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:38:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab1KVUiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:38:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 5] PM: Update comments describing device power management callbacks
Date: Tue, 22 Nov 2011 21:41:41 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
References: <201111200153.40224.rjw@sisk.pl> <201111210038.41490.rjw@sisk.pl> <CACVXFVNiCuQdXmjM9meO+Rcf6g8WnV10-wmxsOCwYuwuMfXUAA@mail.gmail.com>
In-Reply-To: <CACVXFVNiCuQdXmjM9meO+Rcf6g8WnV10-wmxsOCwYuwuMfXUAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111222141.41841.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 22, 2011, Ming Lei wrote:
> Hi,
> 
> On Mon, Nov 21, 2011 at 7:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> >  * @prepare: Prepare the device for the upcoming transition, but do NOT change
> >  *     its hardware state.  Prevent new children of the device from being
> > @@ -71,101 +78,118 @@ typedef struct pm_message {
> >  *     probe method from being made too once @prepare() has succeeded).  If
> >  *     @prepare() detects a situation it cannot handle (e.g. registration of a
> >  *     child already in progress), it may return -EAGAIN, so that the PM core
> > - *     can execute it once again (e.g. after the new child has been registered)
> > + *     can execute it once again (e.g. after a new child has been registered)
> >  *     to recover from the race condition.  This method is executed for all
> >  *     kinds of suspend transitions and is followed by one of the suspend
> >  *     callbacks: @suspend(), @freeze(), or @poweroff().
> > - *     The PM core executes @prepare() for all devices before starting to
> > - *     execute suspend callbacks for any of them, so drivers may assume all of
> > - *     the other devices to be present and functional while @prepare() is being
> > - *     executed.  In particular, it is safe to make GFP_KERNEL memory
> > - *     allocations from within @prepare().  However, drivers may NOT assume
> > - *     anything about the availability of the user space at that time and it
> > - *     is not correct to request firmware from within @prepare() (it's too
> > - *     late to do that).  [To work around this limitation, drivers may
> > - *     register suspend and hibernation notifiers that are executed before the
> > + *     The PM core executes subsystem-level @prepare() for all devices before
> > + *     starting to execute suspend callbacks for any of them, so all devices
> > + *     may be assumed to be present and functional while @prepare() is being
> 
> Devices aren't functional in runtime suspend state, so maybe the word of
> 'functional' should be removed.

That's kind of complicated, see below.

> > + *     executed.  However, device drivers may NOT assume anything about the
> > + *     availability of user space at that time and it is NOT valid to request
> > + *     firmware from within @prepare() (it's too late to do that).  It also is
> > + *     NOT valid to allocate substantial amounts of memory from @prepare() in
> > + *     the GFP_KERNEL mode.  [To work around these limitations, drivers may
> > + *     register suspend and hibernation notifiers to be executed before the
> >  *     freezing of tasks.]
> 
> 
> >  * @resume: Executed after waking the system up from a sleep state in which the
> > - *     contents of main memory were preserved.  Put the device into the
> > - *     appropriate state, according to the information saved in memory by the
> > - *     preceding @suspend().  The driver starts working again, responding to
> > - *     hardware events and software requests.  The hardware may have gone
> > - *     through a power-off reset, or it may have maintained state from the
> > - *     previous suspend() which the driver may rely on while resuming.  On most
> > - *     platforms, there are no restrictions on availability of resources like
> > - *     clocks during @resume().
> > + *     contents of main memory were preserved.  Undo the changes made by
> > + *     the preceding @suspend() and cause the device to become operational
> 
> The device may still not be operational if it was runtime suspended
> before running @suspend().

That's correct, but at the same time it's not 100% clear what @resume should
do with devices that have been runtime-suspended before system suspend.

For example, it may depend on what power configuration the device is in
(it may be a member of a power domain that was off before the system suspend or
something like this).

I'm starting to think that it might be better to simply remove those comments
altogether. :-)

Thanks,
Rafael
