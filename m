Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab0DWQdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:33:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44850 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758110Ab0DWQdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:33:04 -0400
Date: Fri, 23 Apr 2010 12:33:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
cc: linux-pm@lists.linux-foundation.org, <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/9] PM: Add suspend block api.
In-Reply-To: <1271984938-13920-2-git-send-email-arve@android.com>
Message-ID: <Pine.LNX.4.44L0.1004231204450.1777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010, [UTF-8] Arve Hjønnevåg wrote:

> Adds /sys/power/policy that selects the behaviour of /sys/power/state.
> After setting the policy to opportunistic, writes to /sys/power/state
> become non-blocking requests that specify which suspend state to enter
> when no suspend blockers are active. A special state, "on", stops the
> process by activating the "main" suspend blocker.

> --- /dev/null
> +++ b/Documentation/power/suspend-blockers.txt
> @@ -0,0 +1,97 @@
> +Suspend blockers
> +================
> +
> +Suspend blockers provide a mechanism for device drivers and user-space processes
> +to prevent the system from entering suspend. By default writing to
> +/sys/power/state will ignore suspend blockers. Writing "opportunistic" to
> +/sys/power/policy will change the behaviour of /sys/power/state to repeatedly
> +enter the requested state when no suspend blockers are active. Writing "on" to
> +/sys/power/state will cancel the automatic sleep request. Suspend blockers do
> +not affect sleep states entered from idle.

You should document that writing "forced" to /sys/power/policy causes
the /sys/power/state to return to normal operation (i.e., ignoring
suspend blockers).


> +In cell phones or other embedded systems where powering the screen is a
> +significant drain on the battery, suspend blockers can be used to allow
> +user-space to decide whether a keystroke received while the system is suspended
> +should cause the screen to be turned back on or allow the system to go back into
> +suspend.

The description below is incomplete and consequently doesn't make 
sense.

>  Use set_irq_wake or a platform specific api to make sure the keypad
> +interrupt wakes up the cpu.

And as part of waking up the CPU, the screen driver's resume method is
called.  Presumably this will turn the screen back on.  If it doesn't,
you need to explain why not.

> Once the keypad driver has resumed, the sequence of
> +events can look like this:
> +
> +- The Keypad driver gets an interrupt. It then calls suspend_block on the
> +  keypad-scan suspend_blocker and starts scanning the keypad matrix.
> +- The keypad-scan code detects a key change and reports it to the input-event
> +  driver.
> +- The input-event driver sees the key change, enqueues an event, and calls
> +  suspend_block on the input-event-queue suspend_blocker.
> +- The keypad-scan code detects that no keys are held and calls suspend_unblock
> +  on the keypad-scan suspend_blocker.
> +- The user-space input-event thread returns from select/poll, calls
> +  suspend_block on the process-input-events suspend_blocker and then calls read
> +  on the input-event device.
> +- The input-event driver dequeues the key-event and, since the queue is now
> +  empty, it calls suspend_unblock on the input-event-queue suspend_blocker.
> +- The user-space input-event thread returns from read. If it determines that
> +  the key should leave the screen off, it calls suspend_unblock on the
> +  process_input_events suspend_blocker and then calls select or poll. The
> +  system will automatically suspend again, since now no suspend blockers are
> +  active.

This is highly misleading.  Although you _say_ this decision is about
whether or not to leave the screen off, it _really_ is about whether or
not to let the system automatically suspend again.  In other words, the
exposition confuses suspending the system with turning off the screen.  
Unless you can keep the two notions separate and explain more clearly
what's going on, this whole section should be removed from the
documentation.


> +Driver API
> +==========
> +
> +A driver can use the suspend block api by adding a suspend_blocker variable to
> +its state and calling suspend_blocker_init. For instance:
> +struct state {
> +	struct suspend_blocker suspend_blocker;
> +}
> +
> +init() {
> +	suspend_blocker_init(&state->suspend_blocker, "suspend-blocker-name");
> +}
> +
> +Before freeing the memory, suspend_blocker_destroy must be called:
> +
> +uninit() {
> +	suspend_blocker_destroy(&state->suspend_blocker);
> +}
> +
> +When the driver determines that it needs to run (usually in an interrupt
> +handler) it calls suspend_block:
> +	suspend_block(&state->suspend_blocker);
> +
> +When it no longer needs to run it calls suspend_unblock:
> +	suspend_unblock(&state->suspend_blocker);
> +
> +Calling suspend_block when the suspend blocker is active or suspend_unblock when
> +it is not active has no effect. This allows drivers to update their state and
> +call suspend suspend_block or suspend_unblock based on the result.

But suspend_block() and suspend_unblock() don't nest.  You should 
mention this.


> --- /dev/null
> +++ b/include/linux/suspend_blocker.h
> @@ -0,0 +1,60 @@
...
> +/**
> + * struct suspend_blocker - the basic suspend_blocker structure
> + * @flags:	Tracks initialized and active state.
> + * @name:	Name used for debugging.
> + *
> + * When a suspend_blocker is active it prevents the system from entering
> + * suspend.
> + *
> + * The suspend_blocker structure must be initialized by suspend_blocker_init()
> + */
> +
> +struct suspend_blocker {
> +#ifdef CONFIG_SUSPEND_BLOCKERS
> +	atomic_t            flags;
> +	const char         *name;
> +#endif

Why is flags an atomic_t?  Are you worried that drivers might try to 
activate a suspend_blocker at the same time that it is being destroyed?
If this happens, does the code do the right thing?  I don't think it 
does -- if a race occurs, suspend_block() will leave flags set to the 
wrong value.  The same goes for suspend_unblock().

Since these routines don't nest, there is also the possibility of a
race between suspend_block() and suspend_unblock().  If the race goes
one way the blocker is active; the other way it isn't.  Given that such
problems already exist, why worry about what happens when the suspend
blocker is destroyed?

Alan Stern

