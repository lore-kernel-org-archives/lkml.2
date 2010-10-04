Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0JDD3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 23:29:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42476 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0JDD3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 23:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ni0HVk9PDLCmVAAuD+JiTR0NAbyr6z+/WSkDLqs+5C4oTSB7RIjjO2Fq5ASO98QNai
         FUC+Bcla0HQBqBD+ofNg/a7OUjqTsQSDPHO9VxfB0PGFbsQZmXg25R6Cff72iHUQxm+o
         YFTBcNfu0u0wY6SPawCcL0lKvpFNN4yms+ZT4=
Date: Sun, 3 Oct 2010 20:29:03 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH 0/2] PM: Wakeup sources and async suspend
 error path bug fix
Message-ID: <20101004032903.GC4439@gvim.org>
Reply-To: markgross@thegnar.org
References: <201009201957.40995.rjw@sisk.pl>
 <20101003220420.GA3707@gvim.org>
 <201010040104.09789.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010040104.09789.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 01:04:09AM +0200, Rafael J. Wysocki wrote:
> On Monday, October 04, 2010, mark gross wrote:
> > On Mon, Sep 20, 2010 at 07:57:40PM +0200, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > The following two patches are ready to go into linux-next from my point of
> > > view, so please let me know if there are any objections:
> > > 
> > > [1/2] - PM / Wakeup: Introduce wakeup source objects and event statistics (v3)
> > > 
> > > [2/2] - PM: Fix potential issue with failing asynchronous suspend
> > > 
> > > Thanks,
> > > Rafael
> > 
> > Sorry for the late response but, what user feed back will this provide
> > to the OS stack looking to put the system in a low power state?
> > 
> > There are 2 cases I can think of:
> > 1) system wakes from an event that user mode needs to handle (i.e. key
> > press or phone ring or alarm events)
> > 2) system wakes (or more likely, is blocked from suspending) by a
> > kernel critical section, say if USB-OTG is connected.
> > 
> > When wake's are of the type 1, then the power manager service could
> > simply wait for a user mode wake lock be taken and released from the
> > usermode before re-attempting to suspend.
> > 
> > When the wakes are of type 2, a power manager service thread would need
> > to do a select on a system file and be woken up to re-try the suspend
> > after the suspend-blocking is no longer needed.
> 
> IMO it is more convenient to implement that in a different way, but
> generally I think you're right.
> 
> > Do you think I should cobble together an android PM driver that plugs
> > into your code to expose an ABI for the 2 cases listed above?
> 
> Well, I'm not sure if I understand correctly, can you elaborate a bit, please?

Well, before I saw your patch I was thinking about implementing an
Android PM driver that would request a pm_qos active request that would
be notified and interface with your wake event code.  It would also
expose a misc /dev/susped_blocked node that would be signaled when the
pm_qos active request went to zero.

Now I'm sort of making things up as I go but, some sort of non-poling
mechanism to re-attempt the suspend, for type 2, is needed but I'm not
sure where to put it now.

Also, we may want to think about registering events that user mode will
handle, and all others are treated as type 2 events.


> > Also, with this do we want to revisit a pm_qos class for "active"
> > systems?  Or do you think thats redundant now?
> 
> I don't really think the pm_qos for "active" systems is really necessary at
> this point.
>

I'm still studying the patch but, you are likely right.  I need to look
at how much overhead changing the suspend blocking/unblocking is
handled.  I expect that some drivers will be hitting it on hot code
paths.

--mark

> Thanks,
> Rafael
