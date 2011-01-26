Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1AZUhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:37:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1AZUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:37:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] PM / Wakeup: Add missing memory barriers
Date: Wed, 26 Jan 2011 21:36:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1101261514280.1879-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101261514280.1879-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101262136.46577.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 26, 2011, Alan Stern wrote:
> On Tue, 25 Jan 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The memory barrier in wakeup_source_deactivate() is supposed to
> > prevent the callers of pm_wakeup_pending() and pm_get_wakeup_count()
> > from seeing the new value of events_in_progress (0, in particular)
> > and the old value of event_count at the same time.  However, if
> > wakeup_source_deactivate() is executed by CPU0 and, for instance,
> > pm_wakeup_pending() is executed by CPU1, where both processors can
> > reorder operations, the memory barrier in wakeup_source_deactivate()
> > doesn't affect CPU1 which can reorder reads.  In that case CPU1 may
> > very well decide to fetch event_count before it's modified and
> > events_in_progress after it's been updated, so pm_wakeup_pending()
> > may fail to detect a wakeup event.  This issue can be addressed by
> > adding a read memory barrier in pm_wakeup_pending() that will enforce
> > events_in_progress to be read before event_count.
> > 
> > For similar reason, a read memory barrier should be added to
> > pm_get_wakeup_count().
> 
> How come this is implemented using memory barriers rather than a lock?  
> Is it because this is potentially a fairly hot path?

Yes, that's the reason.

> New memory barriers are supposed to have comments present in the code, 
> explaining why they are needed.

Of course I can add them.

> Ideally you could do away with the need for synchronization entirely.  
> For example, events_in_progress and event_count could be stored as two 
> 16-bit values stuffed into a single atomic variable.  Then they could 
> both be read or updated simultaneously.

I thought about that too, but didn't actually implement it.

Well, I guess it would be better.

Thanks,
Rafael
