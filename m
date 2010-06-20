Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0FTPwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 11:52:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34354 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750884Ab0FTPwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 11:52:43 -0400
Date: Sun, 20 Jun 2010 11:52:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
cc: linux-omap@vger.kernel.org, <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] wait_for_completion_interruptible does not wait !!
In-Reply-To: <AANLkTikPOcNZk5ISX2WDHSmsPDw_a5_3Ic3owAbO4o0y@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1006201120210.22272-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010, Suresh Rajashekara wrote:

> I have an application which calls the ioctl of the codec driver to
> know the status of the headset.
> 
> The ioctl waits on a completion variable (using
> wait_for_completion_interruptible).
> 
> The variable is completed in the interrupt handler, which happens on
> headset insertion/removal. Once the variable is completed, the ioctl
> returns (with appropriate value in the argument) and the application
> decides what to do with the event.

What happens if the variable is completed while nobody is waiting for
it?  The next time somebody tries to wait, won't the wait terminate
immediately?

> Once done handling the event, the application then calls the ioctl
> once again (bascially it polls the audio driver) to know the status of
> the headset. The call is blocked until the headset status changes.
> 
> I am running the system on linux-2.6.29 on a OMAP1 based board. All
> this works well when the OMAP is awake.
> 
> The problem starts when we suspend the OMAP. The moment we suspend,
> the wait_for_completion_interruptible is interrupted and the ioctl
> returns.

Of course.  That's how processes that are blocked in the kernel are
given a chance to enter the freezer.

> Application ends up thinking that the headset was either
> removed/inserted.

It should not think that.  There are other reasons why an ioctl might
return early, such as a genuine signal or two status changes occurring
before the ioctl starts (the next two ioctls will both return
immediately, but the first one will contain the final status and the
second won't contain any status change).

For this to work correctly, the kernel should accumulate a bitmap of
status changes as they occur.  When an ioctl returns, it should provide
the bitmap of all the status changes that have occurred since the last
ioctl (and it should clear the status-change bitmap) along with the
current status.  Otherwise the application has no way to know about
changes that occur between ioctl calls.

> Our system does an aggressive sleep (wakes up every
> 500 ms and sleeps again) and hence the application gets the event of
> headset every 500 ms.

What's wrong with that?  It should be smart enough to realize that most
of these events aren't actual status changes.

> I tried wait_for_completion instead, but now the kernel refuses to suspend.
> 
> I have tried wait queues and mutexs with no success.
> 
> Could anyone please point me how I can resolve this issue? Is there
> any construct which can block inside the kernel during suspend/resume?

Yes: The freezer.

> Can there be a blocking call active while we suspend?

Yes, in theory.  In practice it's not a good idea, since the call 
wouldn't be able to distinguish between an actual signal and the onset 
of a suspend.  You might end up with a call that ignores all signals 
and hence cannot be interrupted.

> Ideally I would resort to a method in which I would signal the process
> when there is a headset event, but I am not free to change the
> application. Its a legacy application and I have to make the kernel
> work for it.

It's not clear that anything needs to be fixed, except possibly the
application.  Hint: See the SA_RESTART flag for sigaction(2).

It also sounds like the application's design may be fundamentally
broken.  Certain kinds of defects cannot be worked around in the
kernel.

Alan Stern

