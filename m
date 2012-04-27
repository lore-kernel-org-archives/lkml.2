Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758Ab2D0Dtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:49:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42875 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759702Ab2D0Dtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:49:53 -0400
MIME-Version: 1.0
In-Reply-To: <201204262240.54135.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201204222322.44278.rjw@sisk.pl>
	<20120426140324.0357b1a3@notabene.brown>
	<201204262240.54135.rjw@sisk.pl>
Date: Thu, 26 Apr 2012 20:49:51 -0700
Message-ID: <CAMP5XgcmsDzB3eY53tF=+k07WNSnG11M90gPTKfSs4-f78CEtQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/8] epoll: Add a flag, EPOLLWAKEUP, to prevent
 suspend while epoll events are ready
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/26 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, April 26, 2012, NeilBrown wrote:
>> On Sun, 22 Apr 2012 23:22:43 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>
>> > From: Arve Hjønnevåg <arve@android.com>
>> >
>> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
>> > wakeup_source will be active to prevent suspend. This can be used to
>> > handle wakeup events from a driver that support poll, e.g. input, if
>> > that driver wakes up the waitqueue passed to epoll before allowing
>> > suspend.
>> >
>> > The current implementation uses an extra wakeup_source when
>> > ep_scan_ready_list runs. This can cause problems if a single thread
>> > is polling on wakeup events and frequent non-wakeup events (events
>> > usually arrive during thread freezing) using the same epoll file.
>>
>> This is quite neat.
>>
>> If I understand it correctly, you register file descriptors with epoll_ctl()
>> on an fd created with epoll_create(), and set the new EPOLLWAKEUP flag.
>> Then when a regular 'poll' or 'select' on the epoll fd reports that it is
>> readable you:

I think it makes more sense to use epoll_wait than mixing this with
select or poll.

>>   - get a wakelock
This may not be needed, since epoll does not reevaluate its state
until you call into it again (at least using epoll_wait).

>>   - use epoll_wait to collect the events
>>   - process the events
>>   - release your wakelock
>>   - go back to poll() or select() on the epoll fd.
>> Correct?  As long as there are ready events with EPOLLWAKEUP set a
>> wakeup_source is held active and the system won't go to sleep.
>>
>> My concern with this is about permissions.  It appears that any process could
>> wait of some fd (maybe a pipe they created themselves) with EPOLLWAKEUP, and
>> then simply never epoll_wait() for the event.  Then they would be keeping
>> the system awake.  I don't think that is acceptable.
>
> I wonder what Arve has to say to that, but let me say that on systems without
> autosleep every process can go into an infinite busy loop which is going to
> drain battery relatively quickly just as well and I don't see why that's so
> much different.
>

I still think is useful to limit access to this feature. On a phone, a
process stuck in an infinite loop will increase battery drain, but if
this process does not have permission to prevent suspend, then this is
only catastrophic if another process that have that permission is
preventing suspend. I think we should add a capability for this.
Assuming you agree, do want me to create a separate patch for that
adds a capability, or roll it into this one.

>> So there needs to be some way to limit who can effectively block suspend by
>> using EPOLLWAKEUP.
>> (This is one of the reasons I like an all-user-space solution.  Policy issues
>> like this can easily be decided in user-space but are clumsy to put into the
>> kernel).
>>
>> Also, I'm having trouble understanding the ep->ws wakeup_source.
>> The epi->ws makes lots of sense and I think I understand it all.
>> However I don't see why you need a wakeup_source for the 'struct eventpoll'.
>>
>> Every time that 'poll' decides to call the ->poll fop for the eventpoll, this
>> wakeup_source will be activated and deactivated which will abort any current
>> suspend cycle even if there are no events to report.
>>
>> I suspect it can just go away.
>
> I'll leave this one entirely to Arve, if you don't mind. :-)
>

I keep the wakeup-source active whenever the epitem is on a list
(ep->rdllist or the local txlist). The temporary txlist is modified
without holding the lock that protects ep->rdllist. It is easier to
use a separate wakeup source to prevent suspend while this list is
manipulated than trying to maintain the wakeup-source state in a
different way than the existing eventpoll state. I think this only
causes real problems if the same epoll file is used for frequent
non-wakeup events (e.g. a gyro) and wakeup events. You should be able
to work around this by using two epoll files.

>> One last item that doesn't really belong here - but it is in context.
>>
>> This mechanism is elegant because it provides a single implementation that
>> provides wakeup_source for almost any sort of device.  I would like to do the
>> same thing for interrupts.
>> Most (maybe all) of the wakeup device on my phone have an interrupt where the
>> body is run in a thread.  When the thread has done it's work the event is
>> visible to userspace so the EPOLLWAKEUP mechanism is all that is needed to
>> complete the path to user-space (or for my user-space solution, nothing else
>> is needed once it is visible to user-space).
>> So we just need to ensure a clear path from the "top half" interrupt handler
>> to the threaded handler.
>> So I imagine attaching a wakeup source to every interrupt for which 'wakeup'
>> is enabled, activating it when the top-half starts and relaxing it when the
>> bottom-half completes.  With this in place, almost all drivers would get
>> wakeup_source handling for free.
>> Does this seem reasonable to you.
>
> Yes, it does.
>

How useful is that? Suspend already synchronizes with interrupt
handlers and will not proceed until they have returned. Are threaded
interrupts handlers not always run at that stage? For drivers that use
work-queues instead of a threaded interrupt handler, I think the
suspend-blocking work-queue patch I wrote a while back is convenient.

-- 
Arve Hjønnevåg
