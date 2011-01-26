Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1AZUVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:21:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52041 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752647Ab1AZUVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:21:40 -0500
Date: Wed, 26 Jan 2011 15:21:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / Wakeup: Add missing memory barriers
In-Reply-To: <201101250114.17758.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1101261514280.1879-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The memory barrier in wakeup_source_deactivate() is supposed to
> prevent the callers of pm_wakeup_pending() and pm_get_wakeup_count()
> from seeing the new value of events_in_progress (0, in particular)
> and the old value of event_count at the same time.  However, if
> wakeup_source_deactivate() is executed by CPU0 and, for instance,
> pm_wakeup_pending() is executed by CPU1, where both processors can
> reorder operations, the memory barrier in wakeup_source_deactivate()
> doesn't affect CPU1 which can reorder reads.  In that case CPU1 may
> very well decide to fetch event_count before it's modified and
> events_in_progress after it's been updated, so pm_wakeup_pending()
> may fail to detect a wakeup event.  This issue can be addressed by
> adding a read memory barrier in pm_wakeup_pending() that will enforce
> events_in_progress to be read before event_count.
> 
> For similar reason, a read memory barrier should be added to
> pm_get_wakeup_count().

How come this is implemented using memory barriers rather than a lock?  
Is it because this is potentially a fairly hot path?

New memory barriers are supposed to have comments present in the code, 
explaining why they are needed.

Ideally you could do away with the need for synchronization entirely.  
For example, events_in_progress and event_count could be stored as two 
16-bit values stuffed into a single atomic variable.  Then they could 
both be read or updated simultaneously.

Alan Stern

