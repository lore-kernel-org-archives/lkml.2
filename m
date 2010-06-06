Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab0FFLJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:09:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57328 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755881Ab0FFLJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:09:56 -0400
Date: Sun, 6 Jun 2010 07:09:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Felipe Balbi <felipe.balbi@nokia.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <Pine.LNX.4.44L0.1006052233100.22666-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1006060650270.28143-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010, Alan Stern wrote:

> > If you are referring to the approach that we don't use suspend but
> > freeze a cgroup instead, this only solves the problem of bad apps. It
> > does not help pause timers in trusted user space code and in the
> > kernel, so it does not lower our average power consumption.
> 
> You can solve this problem if you restructure your "trusted" apps in
> the right way.  Require a trusted app to guarantee that whenever it
> doesn't hold any suspend blockers, it will do nothing but wait (in a
> poll() system call for example) for a wakeup event.  When the event
> occurs, it must then activate a suspend blocker.
> 
> Better yet, make it more fine-grained.  Instead of trusted apps, have
> trusted threads.  Freeze the untrusted threads along with everything
> else, and require the trusted threads to satisfy this guarantee.
> 
> In this way, while the system is idle no user timers will get renewed.
> Kernel timers are another matter, but we should be able to handle them.  
> There's nothing Android-specific about wanting to reduce kernel timer 
> wakeups while in a low-power mode.

In fact it's possible to do this with only minimal changes to the
userspace, providing you can specify all your possible hardware wakeup
sources.  (On the Android this list probably isn't very large -- I
imagine it includes the keypad, the radio link(s), the RTC, and maybe
a few switches, buttons, or other things.)

Here's how you can do it.  Extend the userspace suspend-blocker API, so 
that each suspend blocker can optionally have an associated wakeup 
source.

The power-manager process should keep a list of "active" wakeup
sources.  A source gets removed from the list when an associated
suspend blocker is activated.

When the "active" list is empty and no suspend blockers are activated,
the power manager freezes ALL other processes, trusted and untrusted
alike.  It then does a big poll() on all the wakeup sources.  When the
poll() returns, its output is used to repopulate the "active" list and
processes are unfrozen.

(You can also include some error detection: If a source remains on the
"active" list for too long then something has gone wrong.)

To do all this you don't even need to use cgroups.  The existing PM
implementation allows a user process to freeze everything but itself;  
that's how swsusp and related programs work.

This is still a big-hammer sort of approach, but it doesn't require any 
kernel changes.

Alan Stern

