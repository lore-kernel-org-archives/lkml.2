Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2D0VOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:14:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42101 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab2D0VOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:14:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 5/8] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready
Date: Fri, 27 Apr 2012 23:18:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201204262240.54135.rjw@sisk.pl> <CAMP5XgcmsDzB3eY53tF=+k07WNSnG11M90gPTKfSs4-f78CEtQ@mail.gmail.com>
In-Reply-To: <CAMP5XgcmsDzB3eY53tF=+k07WNSnG11M90gPTKfSs4-f78CEtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204272318.41513.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 27, 2012, Arve Hjønnevåg wrote:
> 2012/4/26 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday, April 26, 2012, NeilBrown wrote:
> >> On Sun, 22 Apr 2012 23:22:43 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >>
> >> > From: Arve Hjønnevåg <arve@android.com>
> >> >
> >> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
> >> > wakeup_source will be active to prevent suspend. This can be used to
> >> > handle wakeup events from a driver that support poll, e.g. input, if
> >> > that driver wakes up the waitqueue passed to epoll before allowing
> >> > suspend.
> >> >
> >> > The current implementation uses an extra wakeup_source when
> >> > ep_scan_ready_list runs. This can cause problems if a single thread
> >> > is polling on wakeup events and frequent non-wakeup events (events
> >> > usually arrive during thread freezing) using the same epoll file.
> >>
> >> This is quite neat.
> >>
> >> If I understand it correctly, you register file descriptors with epoll_ctl()
> >> on an fd created with epoll_create(), and set the new EPOLLWAKEUP flag.
> >> Then when a regular 'poll' or 'select' on the epoll fd reports that it is
> >> readable you:
> 
> I think it makes more sense to use epoll_wait than mixing this with
> select or poll.
> 
> >>   - get a wakelock
> This may not be needed, since epoll does not reevaluate its state
> until you call into it again (at least using epoll_wait).
> 
> >>   - use epoll_wait to collect the events
> >>   - process the events
> >>   - release your wakelock
> >>   - go back to poll() or select() on the epoll fd.
> >> Correct?  As long as there are ready events with EPOLLWAKEUP set a
> >> wakeup_source is held active and the system won't go to sleep.
> >>
> >> My concern with this is about permissions.  It appears that any process could
> >> wait of some fd (maybe a pipe they created themselves) with EPOLLWAKEUP, and
> >> then simply never epoll_wait() for the event.  Then they would be keeping
> >> the system awake.  I don't think that is acceptable.
> >
> > I wonder what Arve has to say to that, but let me say that on systems without
> > autosleep every process can go into an infinite busy loop which is going to
> > drain battery relatively quickly just as well and I don't see why that's so
> > much different.
> >
> 
> I still think is useful to limit access to this feature. On a phone, a
> process stuck in an infinite loop will increase battery drain, but if
> this process does not have permission to prevent suspend, then this is
> only catastrophic if another process that have that permission is
> preventing suspend. I think we should add a capability for this.
> Assuming you agree,

I do.

> do want me to create a separate patch for that
> adds a capability, or roll it into this one.

Please roll it into this one, if that's not a problem.

Thanks,
Rafael
