Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761876Ab0HGClj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:41:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44019 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752458Ab0HGClh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:41:37 -0400
Date: Fri, 6 Aug 2010 22:41:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: david@lang.hm
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <arve@android.com>, <mjg59@srcf.ucam.org>, <pavel@ucw.cz>,
        <florian@mickler.org>, <rjw@sisk.pl>, <swetland@google.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>,
        <alan@lxorguk.ukuu.org.uk>, <menage@google.com>, <david-b@pacbell.net>,
        <James.Bottomley@suse.de>, <tytso@mit.edu>, <arjan@infradead.org>,
        <swmike@swm.pp.se>, <galibert@pobox.com>, <dipankar@in.ibm.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <alpine.DEB.2.00.1008061800580.30564@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.1008062219590.14923-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010 david@lang.hm wrote:

> From this discussion, it looks to me like Android wants two key features 
> that they don't see a way to get today

I have largely kept out of this discussion, but this was so outrageous 
I had to say something.

> 1. the ability to decide to suspend while there are still some 
> 'unimportant' apps running.

While this may be true in some literal sense, it certainly is not the
best way to view the situation.  Linux already has the ability to
suspend (or to decide to suspend) whenever you want.  What Android has
added is the ability to suspend conditionally, based on whether or not
some applications or drivers want to keep the system running.

Furthermore, this statement leaves out the primary purpose of
wakelocks: to avoid races between suspending and wakeup events.  And it
also ignores a very important distinction: the difference between
drivers and applications.  Wakelocks are used by both, but it has been
shown that only the wakelocks used by drivers need to be implemented in
the kernel -- the others can be implemented entirely in userspace.

All of these issues are addressed by Raphael's new wakeup_events code.

> 2. changes to idle/suspend so that they can get into a state of lower 
> power consumption thatn any existing idle state (by being able to disable 
> clocks), but still have some parts of the system powered (so that they are 
> more awake than suspend)

This is nonsense.  Nothing was changed.  Instead, Android implemented
system suspend on their platform in a way that would leave some devices
running while the rest of the system powered down.  There's nothing out
of the ordinary about this.  Platforms are free to implement system
suspend in whatever way they deem most appropriate.  On modern PCs, the 
most appropriate technique is to go into ACPI's S3 or S4 state.  On 
embedded systems, the technique will vary from one platform to another.

> If these two features were available, I think that the rest of what they 
> are looking for could be built up without requireing other changes.

They already _are_ available.  Admittedly, only since quite recently.  
(Rafael's new code was accepted during the 2.6.36 merge window.)

> In addition to these key features, the fact that they use suspend much 
> more frequently means that the race condition between deciding to freeze 
> and wake events happening is far more likely to cause them problems, so 
> improvements in this area are needed. I don't think that there is any 
> fundamental opposition to these improvements, just questions on how best 
> to do it without causing performance problems.

By now, I think most of these questions have been answered.

On a slightly different tack, I have noticed that email discussions
concerning Android's wakelocks tend to evolve (I almost wrote
"devolve") along one of two paths: Either they start talking about ways
to integrate Android's goals into the mainline kernel, or else they
start complaining about the fact that Android uses system suspend so
aggressively and try to find ways to use deep-idle to achieve
equivalent results.  Although the second path generally ends up being
much less productive than the first, it is the one that most
discussions seem to end up taking.  Large portions of _this_ thread 
have tended in that direction.

Alan Stern

