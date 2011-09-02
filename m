Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1IBPAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:00:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:53738 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1IBPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:00:32 -0400
Date: Fri, 2 Sep 2011 17:00:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Colin Walters <walters@verbum.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: TFD_CANCEL_ON_SET race when making a wall clock
In-Reply-To: <1314974233.30505.9.camel@lenny>
Message-ID: <alpine.LFD.2.02.1109021655140.2723@ionos>
References: <1314974233.30505.9.camel@lenny>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011, Colin Walters wrote:

> Hi,
> 
> So I was recently making GNOME use the new timerfd TFD_CANCEL_ON_SET so
> we get woken up when the system clock changes.  It works generally well,
> except Ryan Lortie pointed out a race condition in my use of
> timerfd_settime() that I think anyone using it to make a wall clock
> display might not realize at first:
> 
> https://bugzilla.gnome.org/show_bug.cgi?id=655129#c36
> 
> For the link-averse, basically the system clock can move backwards
> between when the process gets the current time, and computes the wakeup
> (typically for the next minute).
> 
> I was able to work around it in userspace with this patch:
> http://bugzilla-attachments.gnome.org/attachment.cgi?id=195252
> But it's clearly not what I'd call beautiful.
> 
> I don't see a nice way to handle this in the kernel given the current
> API, but maybe someone else does?
> 
> TFD_CANCEL_ON_SET isn't documented in man-pages at all right now...maybe
> this is just a useful note for a future patch to
> man-pages/man2/timerfd_create.2.

Well, the kernel can only handle the time was set scenario from the
point when timerfd_create() is called.

There is no way to handle:

   clock_gettime(a);
				clock_settime();
   timerfd_create();
   timerfd_settime(a + x);

And there wont be one ever. The guarantee is that _after_
timerfd_create() any modification to CLOCK_REALTIME in either
direction is causing a cancelation of the timer.

Thanks,

	tglx
