Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0ICCm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:42:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33453 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753764Ab0ICCmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:42:25 -0400
Date: Thu, 2 Sep 2010 22:42:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Colin Cross <ccross@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after
 abort
In-Reply-To: <AANLkTikug=+ztLCJbxYiyx1U_whLkQ9zsYvEMbV9JyJi@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1009022233030.19022-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Colin Cross wrote:

> > Well, in fact that was used in one version of the patchset that introduced
> > asynchronous suspend-resume, but it was rejected by Linus, because it was
> > based on non-standard synchronization.  The Linus' argument, that I agreed
> > with, was that standard snychronization constructs, such as locks or
> > completions, were guaranteed to work accross different architectures and thus
> > were simply _safer_ to use than open-coded synchronization that you seem to be
> > preferring.
> If I'm reading the right thread, that was using rwlocks, not
> conditions.

No, the thread talked about rwsems, not rwlocks.  And that's not what 
Linus didn't like -- indeed, using rwsems was his idea.  He didn't like 
non-standard open-coded synchronization.

>  wait_on_condition looks just as cross-architecture as
> completions, and is almost as simple.

Do you mean wait_event?  It doesn't include the synchronization that 
completions have.

> I look at it like this:  Are you waiting for something to complete, or
> are you waiting for something to be in a specific state?  Completion
> works great if you know that you will only want to wait after it
> starts.  That's not true for an aborted suspend - you may call
> dpm_wait on a device that has never started resuming, because it never
> suspended.  You can use a completion, and make sure it's state is
> right for all the corner cases, but at the end of the day that's not
> what you mean.  What you mean is "wait on the device to be resumed",
> and that's a condition, not a simple completion event.
> 
> > Completions simply allowed us to get the desired behavior with the least
> > effort and that's why we used them.
> I'm happy with the end result, but I may submit a patch that converts
> the completions to conditions for discussion.

Be sure to add memory barriers at the appropriate places.  That's what 
Linus was complaining about in the earlier approach.

Alan Stern

