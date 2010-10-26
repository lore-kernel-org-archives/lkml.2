Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0JZT1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:27:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40856 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0JZT1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:27:40 -0400
From: Felipe Contreras <felipe.contreras@nokia.com>
Subject: RE: [PATCH 8/8] staging: tidspbridge - make sync_wait_on_event interruptible
To: fernando.lugo@ti.com, felipe.contreras@gmail.com
Cc: gregkh@suse.de, hiroshi.doyu@nokia.com, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <496565EC904933469F292DDA3F1663E602F49E28AB@dlee06.ent.ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com> <1288054306-4361-2-git-send-email-x0095840@ti.com> <1288054306-4361-3-git-send-email-x0095840@ti.com> <1288054306-4361-4-git-send-email-x0095840@ti.com> <1288054306-4361-5-git-send-email-x0095840@ti.com> <1288054306-4361-6-git-send-email-x0095840@ti.com> <1288054306-4361-7-git-send-email-x0095840@ti.com> <1288054306-4361-8-git-send-email-x0095840@ti.com> <1288054306-4361-9-git-send-email-x0095840@ti.com> <AANLkTinnLb9DLMKfxEs_KqMvOmegSDYRuLWh5y=hhBCe@mail.gmail.com> <496565EC904933469F292DDA3F1663E602F49E2802@dlee06.ent.ti.com> <1288112260-notmuch-felipe.contreras@nokia.com> <496565EC904933469F292DDA3F1663E602F49E28AB@dlee06.ent.ti.com>
User-Agent: notmuch 0.3.1-85-ge35d5aa
Message-ID: <1288121052-notmuch-felipe.contreras@nokia.com>
Date: Tue, 26 Oct 2010 22:27:23 +0300
X-OriginalArrivalTime: 26 Oct 2010 19:27:29.0755 (UTC) FILETIME=[D46FDAB0:01CB7543]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fernando.lugo@ti.com wrote:
> > fernando.lugo@ti.com wrote:
> > > > On Tue, Oct 26, 2010 at 3:51 AM, Fernando Guzman Lugo 
> > > > <x0095840@ti.com> wrote:
> > > > > So that avoid non-killable process.
> > > > 
> > > > It would be useful to interrupt these tasks from user-space. 
> > > > A separate ioctl to do that would be needed.
> > > 
> > > I don't see use case where that could be needed. It is only 
> > To avoid a 
> > > nonkillable task in the case the user pass an infinite Timeout.
> > > 
> > > If you have some test case where that ioctl would be needed Please 
> > > share it in order to find the best solution.
> > 
> > Well, imagine the application is using a library to access 
> > the DSP, and the library has a dedicated thread listening for 
> > DSP events in a loop.
> > This happens to be how libomxil-ti and gst-dsp work.
> > 
> > Now, the thread received the last message, but has set a 
> > timeout of 10s, or even worst, no timeout at all.
> > 
> > After realizing that was the last message, the main thread 
> > decides to shut down, but it has to wait for the DSP thread 
> > to join. Unfortunately the DSP thread is stuck waiting for 
> > events, and there's nothing that can be done.
> > 
> > However, if we have a separate ioctl to interrupt that task, 
> > then the main thread can issue that ioctl, and unlock the DSP 
> > thread without having to wait 10s, or forever.
> > 
> > Does that make sense?
> 
> Maybe sending a signal to yourselft and having a dummy signal
> Handle should work, it that would not like good.

Signals on libraries is a no-no.

> I am thinking On having a ioctl to create and set an event the you
> could Something like this:
> 
> struct dsp_notification events[3];
> 
> proc_register_notify(proc, event_type, &events[0]);
> ...
> proc_register_notify(proc, event_type, &events[1]);
> ...
> Sync_open_event(&events[2]);
> 
> 
> second thread:
> 
> 	mgr_wait_for_bridge_events(proc, events, 3, index);
> 
> 	if (index == 2) 
> 		/* main thread force exit */
> 
> 
> Main thread:
> 
> 	/* if some execption happened then finish the second thread */
> 	sync_set_event(events[2]);
> 
> 	pthread_join(...);
> 
> 
> However it is in progess a task for change replacing dspbridge sync.c
> Module with event_fd to signal events to userspace. Where now simple
> File descriptor will be used as event elements. So the mgr_wait_for_bridge_events
> Will be implemented using "select" system call inside to wait for multiple events.
> So you will be able to do something like this:
> 
> int events[3];
> 
> proc_register_notify(proc, event_type, &events[0]);
> ...
> proc_register_notify(proc, event_type, &events[1]);
> ...
> events[2] = eventfd(0, 0);
> 
> 
> second thread:
> 
> 	mgr_wait_for_bridge_events(proc, events, 3, index);
> 
> 	if (index == 2) 
> 		/* main thread force exit */
> 
> Main thread:
> 
> 	/* if some execption happened then finish the second thread */
> 	write(events[2], "s", 1);
> 
> 	pthread_join(...);
> 
> You won't need any aditional ioctl in order to do what you want to do.
> 
> So, I think it is not worth to make much changes to some module that will
> Dissapear (my patch is just a fix it is not implementing something new),
> It is just a matter of time to that task is finished and tested properly
> And then send to LO.

All right, that makes sense. I just wanted to make suere you are aware
of that need.

-- 
Felipe Contreras
