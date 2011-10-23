Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1JWPun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 11:50:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42800 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751538Ab1JWPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 11:50:41 -0400
Date: Sun, 23 Oct 2011 11:50:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <201110230007.33683.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1110231122430.4497-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Oct 2011, Rafael J. Wysocki wrote:

> Moreover, the race is real, because if you have two processes trying to use
> /sys/power/wakeup_count at the same time, you can get:
> 
> Process A		Process B
> read from wakeup_count
> talk to apps
> write to wakeup_count
> --------- wakeup event ----------
> 			read from wakeup_count
> 			talk to apps
> 			write to wakeup_count
> try to suspend -> success (should be failure, because the wakeup event
> may still be processed by applications at this point and Process A hasn't
> checked that).
> 
> Now, there are systems running two (or more) desktop environments each of
> which has a power manager that may want to suspend on it's own.  They both
> will probably use pm-utils, but then I somehow doubt that pm-utils is well
> prepared to handle such concurrency.

I have no objection to adding a kernel-based mechanism for restricting
the suspend interface to one process at a time.  However, that's just
part of your most recent proposal.  The other part involves
coordinating the requirements of all the processes that may want to
prevent the system from suspending, which is a harder job.


> I have one more rule.  If my would-be user space solution has the following
> properties:
> 
> * It is supposed to be used by all of the existing variants of user space
>   (i.e. all existing variants of user space are expected to use the very same
>   thing).
> 
> * It requires all of those user space variants to be modified to work with it
>   correctly.
> 
> * It includes a daemon process having to be started on boot and run permanently.
> 
> then it likely is better to handle the problem in the kernel.

This reasoning doesn't apply to the second problem of allowing
processes to block suspend.  Whether the solution is implemented in the
kernel or as a daemon, other programs will have to be modified to
accomodate it.

In fact, if it's done properly then these other programs should each
need only a single set of modifications; the differences involved in 
communicating with the kernel vs. a daemon could be encapsulated in a 
shared library.


Overall, I think the discussion is getting a little muddled because of
a significant problem that has not yet been addressed sufficiently.

There is a big difference between Android's kernel wakelocks and the
currently proposed use of wakeup_sources.  In Android, a kernel
wakelock associated with an input device isn't released until the
device's queue becomes empty, whereas we have been talking about
releasing the corresponding wakeup_source as soon as data added to
the queue becomes visible to userspace.

This is quite a significant difference.  It means there's a window of
time (from when the data is added to the queue to when it is removed)  
during which userspace is forced to cope with suspend races, instead of
letting the kernel handle things.  This is what leads to our problems
about sending fd's to the daemon process and sending a request to each
client before the daemon starts a suspend.

(Other aspects of this problem that haven't been mentioned before: What
happens when a client program using the notify-fd API wants to close
one of the wakeup-capable fd's?  It would have to tell the daemon to
close its copy of the fd as well.  And likewise, a client would have to 
inform the daemon whenever it opened a new wakeup-capable device file.)

Now, in the end, I think our approach makes more sense in a general 
setting.  The Android approach is okay for a restricted environment 
where you know beforehand exactly which devices will be wakeup-capable 
and which wakeup events will be monitored by userspace programs.  But 
for the whole range of Linux-based systems, the kernel can't rely on 
such information.

(If you think back to the original wakelock patches, for example,
you'll remember that the patch descriptions were expressed in terms of
what happens as the screen is turned on and off.  Obviously this is
meaningless for systems that, unlike an Android phone, don't have a
built-in screen.  I complained about this at the time, and the Android
people seemed to have a hard time understanding what I was objecting
to.)

So this is really our biggest problem.  If we can figure out a really
good way to solve it, I predict we'll find that the kernel-based and
daemon-based suspend solutions are extremely similar.

Alan Stern

