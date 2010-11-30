Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0K3WYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:24:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43081 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0K3WYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:24:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors unnecessarily
Date: Tue, 30 Nov 2010 23:23:50 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201011281312.49949.rjw@sisk.pl> <AANLkTi=tgEug5EUpqV1-GLFh9rsD5obAyExe+V=CjsbO@mail.gmail.com>
In-Reply-To: <AANLkTi=tgEug5EUpqV1-GLFh9rsD5obAyExe+V=CjsbO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011302323.50475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 30, 2010, Ming Lei wrote:
> 2010/11/28 Rafael J. Wysocki <rjw@sisk.pl>:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Currently dpm_prepare() returns error code if it finds that a device
> > being suspended has a pending runtime resume request.  However, it
> > should not do that if the checking for wakeup events is not enabled.
> > On the other hand, if the checking for wakeup events is enabled, it
> > can return error when a wakeup event is detected, regardless of its
> > source.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/base/power/main.c |   11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > Index: linux-2.6/drivers/base/power/main.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/main.c
> > +++ linux-2.6/drivers/base/power/main.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/sched.h>
> >  #include <linux/async.h>
> > +#include <linux/suspend.h>
> >
> >  #include "../base.h"
> >  #include "power.h"
> > @@ -1052,8 +1053,10 @@ static int dpm_prepare(pm_message_t stat
> >                mutex_unlock(&dpm_list_mtx);
> >
> >                pm_runtime_get_noresume(dev);
> > -               if (pm_runtime_barrier(dev) && device_may_wakeup(dev)) {
> > -                       /* Wake-up requested during system sleep transition. */
> > +               if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
> > +                       pm_wakeup_event(dev, 0);
> > +
> > +               if (pm_check_wakeup_events()) {
> 
> If pm_check_wakeup_events returns true, it means there is no wakeup event
> coming, so seems should handle normal suspend prepare, but why
> abort the suspend here?

That's a bug, it should be !pm_check_wakeup_events() instead.

Thanks,
Rafael
