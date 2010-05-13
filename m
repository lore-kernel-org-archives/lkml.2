Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab0EMOQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:16:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34574 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757268Ab0EMOQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:16:11 -0400
Date: Thu, 13 May 2010 10:16:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Walmsley <paul@pwsan.com>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, <magnus.damm@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>,
       =?ISO-8859-15?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       <linux-omap@vger.kernel.org>, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
Message-ID: <Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, Paul Walmsley wrote:

> Hello,
> 
> Some general comments on the suspend blockers/wakelock/opportunistic
> suspend v6 patch series, posted here:
> 
>     https://lists.linux-foundation.org/pipermail/linux-pm/2010-April/025146.html
> 
> The comments below are somewhat telegraphic in the interests of 
> readability - more specific comments to follow in later E-mails. I am 
> indebted to those of us who discussed these issues at LPC last year and 
> ELC this year for several stimulating discussions.
> 
> There are several general problems with the design of opportunistic
> suspend and suspend-blocks.
> 
> 1. The opportunistic suspend code bypasses existing Linux kernel code,
>    such as timers and the scheduler, that indicates when code
>    needs to run, and when the system is idle.

Whoa!  That's not my understanding at all.

As I see it, opportunistic suspend doesn't bypass any code that isn't 
already bypassed by the existing suspend code.  Users can do

	echo mem >/sys/power/state

whenever they want, without regard to kernel timers and the scheduler 
(other than the fact that the user's thread must be running in order to 
carry out the write, of course).

>  This causes two problems:
> 
>    a. When opportunistic suspend is enabled, the default mode is to
>       break all timers and scheduling on the system.  This isn't
>       right: the default mode should be to preserve standard Linux
>       behavior.  Exceptions can then be added for process groups that
>       should run with the non-standard timer and scheduler behavior.

I don't understand this at all.  What gets broken, and how?  In 
particular, what gets broken that isn't also broken by "echo mem 
>/sys/power/state"?

>    b. The series introduces a de novo kernel API and userspace API
>       that are unrelated to timers and the scheduler, but if the point
>       is to modify the behavior of timers or the scheduler, the
>       existing timer or scheduler APIs should be extended.  Any new
>       APIs will need to be widely spread throughout the kernel and
>       userspace.

But the point _isn't_ to modify the behavior of timers and the
scheduler.  The point is to provide a way for the system to enter a
very low-power state as soon as possible while safely handling races.

> 2. The suspend-block kernel API tells the kernel _how_ to accomplish a
>    goal, rather than telling the kernel _what_ the goal is.  This
>    results in layering violations, unstated assumptions, and is too
>    coarse-grained.  These problems in turn will cause fragile kernel
>    code, kernel code with userspace dependencies, and power management
>    problems on modern hardware.  Code should ask for what it wants.
>    For example, if a driver needs to place an upper bound on its
>    device wakeup latency, or if it needs to place an upper bound on
>    interrupt response latency, that is what it should request.  Driver
>    and subsystem code should not care how the kernel implements those
>    requests, since the implementation can differ on different hardware
>    and even on different use-cases with the same hardware.

Although the first sentence is true, I don't find it useful.  The goal 
of suspend blockers is to prevent the system from entering a low-power 
state until some important task is finished.  It has little to do with 
interrupt response latency or device wakeup latency.

As far as I can tell, suspend blockers are more or less a direct
implementation of the desired goal.

> 3. Similarly, the suspend-block userspace API tells the kernel how to
>    accomplish a goal, rather than telling the kernel what the goal is.
>    Userspace processes should ask the kernel for what they really
>    want.  If a process' timers should be disabled upon entering
>    suspend, or the timer durations should have a lower bound, that's
>    what the API should request.

The userspace API has essentially the same goal as the kernel API.

> Merging this series as currently designed and implemented will cause 
> problems.  Suspend-blocks introduce a second, separate idle management 
> approach in the Linux kernel.  The existing approach is the familiar timer 
> and scheduler based approach.  The new approach is one where timers and 
> runqueues no longer matter: the system is always at risk of entering 
> suspend at any moment, with only suspend-blocks to stop it. Driver authors 
> will effectively have to implement both approaches in their code.

That's true.  Where's the problem?  The system is _already_ at risk of
entering suspend at any moment, as I described above.  If the "timer
and scheduler based" approach can be adapted to do what the Android 
people want, then all the better -- but I rather suspect it can't.

Alan Stern

