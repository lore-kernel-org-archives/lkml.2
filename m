Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2ENCZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:25:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56323 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753963Ab2ENCZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:25:10 -0400
Date: Sun, 13 May 2012 22:25:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bojan Smojver <bojan@rexursive.com>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, <bp@alien8.de>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
In-Reply-To: <1336957376.4914.5.camel@shrek.rexursive.com>
Message-ID: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Bojan Smojver wrote:

> On Mon, 2012-05-14 at 05:02 +0530, Srivatsa S. Bhat wrote:
> > This is the point where your patch gets scary - Suspend is not carried
> > out in its fullest sense; instead you jump directly to
> > suspend_devices_and_enter(). Luckily, most of the things that happen
> > before this are common between suspend and hibernation. However, one
> > thing that really stands out is the notifications: if you directly
> > call suspend_devices_and_enter(), we end up missing the
> > PM_SUSPEND_PREPARE notifications.
> 
> I'm guessing because at the point of suspend to RAM here, we are not
> really doing the real, full suspend to RAM, things would be different.
> At this point, not the whole system is alive - most of it is frozen.
> Only devices required for image writing are alive. Or maybe I'm
> misunderstanding the hibernation process...

Yes, you misunderstand it.  It's documented pretty thoroughly in
Documentation/power/devices.txt and there's a fair amount of kerneldoc
in include/linux/pm.h.  After the memory image has been prepared,
_every_ device goes back to full functionality before the image gets
written out (with maybe a few platform-specific exceptions).

> > And there is no guarantee that everybody implements the same thing for
> > both PM_SUSPEND_PREPARE and PM_HIBERNATION_PREPARE notifications. That
> > is the reason I don't think it is safe.
> 
> OK.
> 
> So, you would do:
> 
> - prepare for hibernation (includes suspension of devices)

No, devices are not suspended -- they are "frozen".  There's a
difference (frozen devices are supposed to remain at full power).

> - resume devices involved in image writing

Resume all devices.  Except that it's not called "resume"; it's called 
"thaw" -- the reverse of freezing.

> - write image
> - prepare for suspend
> - suspend to RAM
> - resume from RAM
> - post suspend from RAM

It's not clear what you mean by this last step.

> - unwind unsuccessful hibernation

Not exactly.  For example, the devices are already back at full power 
so they don't need any "unwinding".  Basically you just have to 
invalidate the hibernation image stored on disk and unfreeze the tasks.

> Isn't that going to confuse devices involved in image writing even more
> by essentially executing post-resume twice (once for suspend to RAM,
> once for hibernation)?

Not if you do it as described above.

Alan Stern

