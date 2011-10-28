Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1J1IZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:25:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37247 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1J1IY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:24:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Fri, 28 Oct 2011 10:27:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Greg KH <greg@kroah.com>
References: <201110230007.33683.rjw@sisk.pl> <Pine.LNX.4.44L0.1110231122430.4497-100000@netrider.rowland.org> <20111028110215.0cc5175f@notabene.brown>
In-Reply-To: <20111028110215.0cc5175f@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110281027.31071.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 28, 2011, NeilBrown wrote:
> On Sun, 23 Oct 2011 11:50:40 -0400 (EDT) Alan Stern
> <stern@rowland.harvard.edu> wrote:
> 
> > On Sun, 23 Oct 2011, Rafael J. Wysocki wrote:
> > 
> > > Moreover, the race is real, because if you have two processes trying to use
> > > /sys/power/wakeup_count at the same time, you can get:
> > > 
> > > Process A		Process B
> > > read from wakeup_count
> > > talk to apps
> > > write to wakeup_count
> > > --------- wakeup event ----------
> > > 			read from wakeup_count
> > > 			talk to apps
> > > 			write to wakeup_count
> > > try to suspend -> success (should be failure, because the wakeup event
> > > may still be processed by applications at this point and Process A hasn't
> > > checked that).
> > > 
> > > Now, there are systems running two (or more) desktop environments each of
> > > which has a power manager that may want to suspend on it's own.  They both
> > > will probably use pm-utils, but then I somehow doubt that pm-utils is well
> > > prepared to handle such concurrency.
> > 
> > I have no objection to adding a kernel-based mechanism for restricting
> > the suspend interface to one process at a time.  However, that's just
> > part of your most recent proposal.  The other part involves
> > coordinating the requirements of all the processes that may want to
> > prevent the system from suspending, which is a harder job.
> > 
> > 
> > > I have one more rule.  If my would-be user space solution has the following
> > > properties:
> > > 
> > > * It is supposed to be used by all of the existing variants of user space
> > >   (i.e. all existing variants of user space are expected to use the very same
> > >   thing).
> > > 
> > > * It requires all of those user space variants to be modified to work with it
> > >   correctly.
> > > 
> > > * It includes a daemon process having to be started on boot and run permanently.
> > > 
> > > then it likely is better to handle the problem in the kernel.
> > 
> > This reasoning doesn't apply to the second problem of allowing
> > processes to block suspend.  Whether the solution is implemented in the
> > kernel or as a daemon, other programs will have to be modified to
> > accomodate it.
> > 
> > In fact, if it's done properly then these other programs should each
> > need only a single set of modifications; the differences involved in 
> > communicating with the kernel vs. a daemon could be encapsulated in a 
> > shared library.
> > 
> > 
> > Overall, I think the discussion is getting a little muddled because of
> > a significant problem that has not yet been addressed sufficiently.
> > 
> > There is a big difference between Android's kernel wakelocks and the
> > currently proposed use of wakeup_sources.  In Android, a kernel
> > wakelock associated with an input device isn't released until the
> > device's queue becomes empty, whereas we have been talking about
> > releasing the corresponding wakeup_source as soon as data added to
> > the queue becomes visible to userspace.
> > 
> > This is quite a significant difference.  It means there's a window of
> > time (from when the data is added to the queue to when it is removed)  
> > during which userspace is forced to cope with suspend races, instead of
> > letting the kernel handle things.  This is what leads to our problems
> > about sending fd's to the daemon process and sending a request to each
> > client before the daemon starts a suspend.
> > 
> > (Other aspects of this problem that haven't been mentioned before: What
> > happens when a client program using the notify-fd API wants to close
> > one of the wakeup-capable fd's?  It would have to tell the daemon to
> > close its copy of the fd as well.  And likewise, a client would have to 
> > inform the daemon whenever it opened a new wakeup-capable device file.)
> 
> In my current code the client only associates a single event fd with each
> socket to the server, and when the client closes that socket, the fd gets
> closed (though there are rough edges I think).
> Teaching the client to use multiple fds per socket would not be difficult.
> The biggest challenge would be choosing labels to use to identify the fds so
> it can ask the server to close them - and that isn't hard.
> But I certainly agree that this needs to be properly thought through and
> resolved.
> 
> > 
> > Now, in the end, I think our approach makes more sense in a general 
> > setting.  The Android approach is okay for a restricted environment 
> > where you know beforehand exactly which devices will be wakeup-capable 
> > and which wakeup events will be monitored by userspace programs.  But 
> > for the whole range of Linux-based systems, the kernel can't rely on 
> > such information.
> 
> I think that is exactly right.  The Android code is understandable written
> to particularly suit the Android context and may not be generally applicable.

I'm not sure why the heck this makes any difference.  For now, there doesn't
seem to be no one else who needs that functionality.  If there were people
like that we'd see some concurrent approaches appearing, but for now it's only
us considering the alternatives _theoretically_.

Moreover, if somebody who needs similar functionality and for whom the Android
stuff is not sufficient appears in the future, I don't see why not to address
his needs _at_ _that_ _time_ instead of trying to anticipate them (which is
kind of useless anyway, because we have no idea what those needs may be).

> I think the Android folk understand this and don't insist on having exactly
> that code merged.  They just want the same functionality with the same
> efficiency without unnecessary change to user-space.

The whole problem is that the Android code is proven to work on lots and
lots of systems and whatever else we can come up with will not be.

> > 
> > (If you think back to the original wakelock patches, for example,
> > you'll remember that the patch descriptions were expressed in terms of
> > what happens as the screen is turned on and off.  Obviously this is
> > meaningless for systems that, unlike an Android phone, don't have a
> > built-in screen.  I complained about this at the time, and the Android
> > people seemed to have a hard time understanding what I was objecting
> > to.)
> > 
> > So this is really our biggest problem.  If we can figure out a really
> > good way to solve it, I predict we'll find that the kernel-based and
> > daemon-based suspend solutions are extremely similar.
> 
> Actually I think our biggest problem is - and has always been - communication
> and understanding :-)
> 
> There are probably a dozen or more ways to solve this problem, each of which
> has some impact on the kernel and some impact on the Android user-space.
> 
> We need an effective dialogue (we have had plenty of ineffective dialogue)
> between people who know and care about Android and people who know and care
> about the kernel.
> 
> I think we are having a useful discussion, but I think it would be much more
> useful if we had some inside perspective and engagement with Android.
> 
> So I have added a Cc to Brian Swetland, hoping - Brian - that you might be
> able to provide some insight - or maybe tell us where this discussion is
> already happening and already progressing (maybe I missed something).
> 
> I'm particularly interested in:
>  - is it fair to say that all wakeup events are - or could be - available to
>    user-space though an 'fd' which reports POLLIN when an event is pending?
>    If not - could you list some of those other wakeup events?
>  - does a process that is handling wakeup events always "know" they are (or
>    could be) wakeup events and so could take some extra action?  (assume for
>    the moment that the action is free, it just has to be done for fds
>    receiving wakeup events, and not for other fds).
>  - How performance-sensitive is the opportunistic suspend event?  i.e. I'm
>    assuming there are a collection of user-space and kernel-space things that
>    block and unblock suspend from time to time.  At some point the last block
>    is removed and the system should then enter suspend.  What sort of latency
>    is acceptable at that point (microseconds? milliseconds?) and what sort of
>    frequency would we expect that to happen (100HZ? 10HZ? 1HZ?  0.01HZ??)
> 
> I think answers to those would help a lot to parameterise the problem space.

I'm sure they would, but I also think this already has taken too much time -
and too much pain for people who have to support two different kernels, the
mainline and the Android one, at the same time.

Thanks,
Rafael
