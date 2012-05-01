Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2EAAwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:52:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37118 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab2EAAwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:52:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120430115819.633c2cb6@notabene.brown>
References: <201202070200.55505.rjw@sisk.pl>
	<201204222322.44278.rjw@sisk.pl>
	<20120426140324.0357b1a3@notabene.brown>
	<201204262240.54135.rjw@sisk.pl>
	<CAMP5XgcmsDzB3eY53tF=+k07WNSnG11M90gPTKfSs4-f78CEtQ@mail.gmail.com>
	<20120430115819.633c2cb6@notabene.brown>
Date: Mon, 30 Apr 2012 17:52:08 -0700
Message-ID: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/8] epoll: Add a flag, EPOLLWAKEUP, to prevent
 suspend while epoll events are ready
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
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

On Sun, Apr 29, 2012 at 6:58 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 26 Apr 2012 20:49:51 -0700 Arve Hjønnevåg <arve@android.com> wrote:
...
>> I keep the wakeup-source active whenever the epitem is on a list
>> (ep->rdllist or the local txlist). The temporary txlist is modified
>> without holding the lock that protects ep->rdllist. It is easier to
>> use a separate wakeup source to prevent suspend while this list is
>> manipulated than trying to maintain the wakeup-source state in a
>> different way than the existing eventpoll state. I think this only
>> causes real problems if the same epoll file is used for frequent
>> non-wakeup events (e.g. a gyro) and wakeup events. You should be able
>> to work around this by using two epoll files.
>
> Thanks for the explanation.  I can now see more clearly how your patch works.
> I can also see why you might need the ep->ws wakeup_source.  However I don't
> like it.
>
> If it acted purely as a lock and prevented suspend while it was active then
> it would be fine.  However it doesn't.  It also aborts any current suspend
> attempt - so it is externally visible.
> The way your code it written, *any* call to epoll_wait will abort the current
> suspend cycle, even if it is called by a completely non-privileged user.

With the patch I posted Friday, a non-privileged user will not be able
to pass EPOLLWAKEUP and have the wakeup-source created.

> That may not obviously be harmful, but it makes the precise semantics of the
> system call something quite non-obvious, and it is much better to have a very
> clean semantic.
> As you say, it can probably be worked-around but code is much safer when you
> don't need to work-around things.
>
> I see two alternatives:
> 1/ set the 'wakeup' flag on the whole epoll-fd, not on the individual events
>   that it is asked to monitor.  i.e. add a new flag to epoll_create1()
>   instead of to epoll_ctl events.
>   Then you just need a single wakeup_source for the fd which is active
>   whenever any event is ready.
>
>   This interface might be generally nicer, I'm not sure.
>
> 2/ Find a way to get rid of ep->ws.
>   Thinking about it more, I again think it isn't needed.
>   The reason is that suspend is already exclusive with any process running in
>   kernel context.
>   One of the first things suspend does is to freeze all process and (for
>   regular non-kernel-thread processes) this happens by sending a virtual
>   signal which is acted up when the process returns from a system call or
>   returns from a context switch.  So while any given system call is running
>   (e.g. epoll_wait) suspend is blocked.  When epoll_wait sets
>   TASK_INTERRUPTIBLE the 'freeze' signal will interrupt it of course, but
>   this is the only point where suspend can interfere with epoll_wait, and you
>   aren't holding ep->ws then anyway.
>   Hopefully Rafael will correct me if I got that outline wrong.  But even if
>   I did, I think we need to get rid of ep->ws.
>

If ep_scan_ready_list is only called from freezable threads, then
ep->ws is not strictly needed, but without it another suspend attempt
will be triggered if there are not other wakeup-sources active. I'm
also not sure if it could get called from a non-freezable thread since
other subsystems can call it through the poll hook.

A third option is to only activate ep->ws when needed. This may may work:
---
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 16718f6..beb7138 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -572,7 +572,6 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * in a lockless way.
 	 */
 	spin_lock_irqsave(&ep->lock, flags);
-	__pm_stay_awake(ep->ws);
 	list_splice_init(&ep->rdllist, &txlist);
 	ep->ovflist = NULL;
 	spin_unlock_irqrestore(&ep->lock, flags);
@@ -753,6 +752,8 @@ static int ep_read_events_proc(struct eventpoll
*ep, struct list_head *head,
 			 * callback, but it's not actually ready, as far as
 			 * caller requested events goes. We can remove it here.
 			 */
+			if (epi->ws && epi->ws->active)
+				__pm_stay_awake(ep->ws);
 			__pm_relax(epi->ws);
 			list_del_init(&epi->rdllink);
 		}
@@ -1344,6 +1345,8 @@ static int ep_send_events_proc(struct eventpoll
*ep, struct list_head *head,
 	     !list_empty(head) && eventcnt < esed->maxevents;) {
 		epi = list_first_entry(head, struct epitem, rdllink);

+		if (epi->ws && epi->ws->active)
+			__pm_stay_awake(ep->ws);
 		__pm_relax(epi->ws);
 		list_del_init(&epi->rdllink);

---


> Also, I think it is important to clearly document how to use this safely.
> You suggested that if any EPOLLWAKEUP event is ready, then suspend will
> remain disabled not only until the event is handled, but also until the next
> call to epoll_wait.  That sounds like very useful semantics, but it isn't at
> all explicit in the patch.  I think it should be made very clear in
> eventpoll.h how the flag can be used. (and then eventually get this into a
> man page of course).
>

OK

>>
>> >> One last item that doesn't really belong here - but it is in context.
>> >>
>> >> This mechanism is elegant because it provides a single implementation that
>> >> provides wakeup_source for almost any sort of device.  I would like to do the
>> >> same thing for interrupts.
>> >> Most (maybe all) of the wakeup device on my phone have an interrupt where the
>> >> body is run in a thread.  When the thread has done it's work the event is
>> >> visible to userspace so the EPOLLWAKEUP mechanism is all that is needed to
>> >> complete the path to user-space (or for my user-space solution, nothing else
>> >> is needed once it is visible to user-space).
>> >> So we just need to ensure a clear path from the "top half" interrupt handler
>> >> to the threaded handler.
>> >> So I imagine attaching a wakeup source to every interrupt for which 'wakeup'
>> >> is enabled, activating it when the top-half starts and relaxing it when the
>> >> bottom-half completes.  With this in place, almost all drivers would get
>> >> wakeup_source handling for free.
>> >> Does this seem reasonable to you.
>> >
>> > Yes, it does.
>> >
>>
>> How useful is that? Suspend already synchronizes with interrupt
>> handlers and will not proceed until they have returned. Are threaded
>> interrupts handlers not always run at that stage? For drivers that use
>> work-queues instead of a threaded interrupt handler, I think the
>> suspend-blocking work-queue patch I wrote a while back is convenient.
>>
>
> Maybe it isn't useful at all - I'm still working this stuff out.
>
> Yes, threaded interrupts are run "straight away", but what exactly does that
> mean?  And in particular, is there any interlocking to ensure they run
> before suspend gets stop the CPU?  Maybe the scheduling priority of the
> different threads is enough to make sure this works, as irq_threads are
> SCHED_FIFO and  the suspending thread almost certainly isn't.  But is that
> still a guarantee on an SMP machine?  irq_threads aren't freezable so suspend
> won't block on them for that reason..
>
> I really just want to be sure that some interlock is in place to ensure that
> the threaded interrupt handler runs before suspend absolutely commits to
> suspending.  If that is already the case, when what I suggest isn't needed as
> you suggest.  Do you know of such an interlock?
>

Normal interrupts are disabled during suspend. This synchronizes with
the interrupt handler, and pending wakeup interrupts abort suspend. I
have not looked at this code since threaded interrupt handlers were
added, so there could be bugs there.

-- 
Arve Hjønnevåg
