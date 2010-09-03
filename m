Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab0ICRcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:32:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45605 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753821Ab0ICRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:31:59 -0400
Date: Fri, 3 Sep 2010 13:31:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Colin Cross <ccross@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after
 abort
In-Reply-To: <AANLkTi=gANgv=_PFTqNKy1vDddhYKZJ9nOKhvhOBJwqE@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1009031311190.1548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Colin Cross wrote:

> >> I think there's another race condition during suspend.  If an
> >> asynchronous device calls device_pm_wait_for_dev on a device that
> >> hasn't had device_suspend called on it yet, power.completion will
> >> still be set from initialization or the last time it completed resume,
> >> and it won't wait.
> >
> > That can't happen in a properly-designed system.  It would mean the
> > async device didn't suspend because it was waiting for a device which
> > was registered before it -- and that would deadlock even if you used
> > synchronous suspend.
> I see - from the earlier thread, if devices need to break the tree
> model for suspend, they still have to follow the list ordering.

Right.  After all, the user can force the system into doing a 
synchronous suspend whenever he wants.

> >> Assuming that problem is fixed somehow, there's also a deadlock
> >> possibility.  Consider 3 devices.  A, B, and C, registered in that
> >> order.  A is async, and the suspend handler calls
> >> device_pm_wait_for_dev(C).  B's suspend handler returns an error.  A's
> >> suspend handler is now stuck waiting on C->power.completion, but
> >> device_suspend(C) will never be called.
> >
> > Why not?  The normal suspend order is last-to-first, so C will be
> > suspended before B.
> Reverse A and C, but then the earlier comment applies.

Exactly.

> >> There are also an unhandled edge condition - what is the expected
> >> behavior for a call to device_pm_wait_for_dev on a device if the
> >> suspend handler for that device returns an error?  Currently, the
> >> calling device will continue as if the target device had suspended.
> >
> > It looks like __device_suspend needs to set async_error.  Which means
> > async_suspend doesn't need to set it.  This is indeed a bug.
> Is this sufficient?  The waiting device will complete its suspend
> handler, and then be resumed, but the waited-on device never
> suspended.  Are drivers expected to handle that case?

Sorry, my reply wasn't very good.  There are _two_ related problems:
drivers calling device_pm_wait_for_dev and also the internal call where
__device_suspend calls dpm_wait_for_children.  They're both subject to
this bug, and my comment referred to the second problem rather than the
one you raised.

The entire "if (error) {"  block can be moved from async_suspend to the
end of __device_suspend, with suitable adjustment to the string
constant in the error message.  At the same time,
device_pm_wait_for_dev should return async_error instead of returning
void.  Which means its callers will have to check the return value (I
don't think there are very many callers at the moment).  Together those 
changes should fix everything.

> >> What about splitting power.completion into two flags,
> >> power.suspend_complete and power.resume_complete?
> >> power.resume_complete is initialized to 1, because the devices start
> >> resumed.  Clear power.suspend_complete for all devices at the
> >> beginning of dpm_suspend, and clear power.resume_complete for any
> >> device that is suspended at the beginning of dpm_resume.  The
> >> semantics of each flag is then always clear.  Any time between the
> >> beginning and end of dpm_suspend, waiting on any device's
> >> power.suspend_complete will block until that device is in suspend.
> >> Any time between the beginning and end of dpm_resume, waiting on
> >> power.resume_complete will block IFF the device is suspended.
> >
> > How are you going to wait for these things?  With wait_event?  Didn't
> > you say above that it would be worse than using completions?
> I'd have to complete them on errors to abort any waiters, which would
> complicate the meaning of the completion flags, but keep the rules
> above about the same.

I don't exactly follow what you're proposing here, but on the whole it
seems more complex than the current code.  There doesn't seem to be any
advantage in changing.

Now, if you want to add some comments to the existing code explaining 
what the completions are waiting for and how they need to be 
initialized, I'm sure nobody would object.

Oh yes, and please fix that bug.

Alan Stern

