Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0D1TOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:14:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37417 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754263Ab0D1TN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:13:58 -0400
Date: Wed, 28 Apr 2010 15:13:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <1272429119-12103-2-git-send-email-arve@android.com>
Message-ID: <Pine.LNX.4.44L0.1004281317310.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, [UTF-8] Arve Hjønnevåg wrote:

> +For example, in cell phones or other embedded systems, where powering the screen
> +is a significant drain on the battery, suspend blockers can be used to allow
> +user-space to decide whether a keystroke received while the system is suspended
> +should cause the screen to be turned back on or allow the system to go back into
> +suspend. Use set_irq_wake or a platform specific api to make sure the keypad
> +interrupt wakes up the cpu. Once the keypad driver has resumed, the sequence of
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
> +
> +                 Key pressed   Key released
> +                     |             |
> +keypad-scan          ++++++++++++++++++
> +input-event-queue        +++          +++
> +process-input-events       +++          +++

This is better than before, but it still isn't ideal.  Here's what I 
mean:

>  suspend blockers can be used to allow
> +user-space to decide whether a keystroke received while the system is suspended
> +should cause the screen to be turned back on or allow the system to go back into
> +suspend.

That's not right.  Handling the screen doesn't need suspend blockers:
The program decides what to do and then either turns on the screen or
else writes "mem" to /sys/power/state.  What suspend blockers add is
the ability to resolve races and satisfy multiple constraints when
going into suspend -- which has nothing to do with operating the
screen.

I _think_ what you're trying to get at can be expressed this way:

	Here's an example showing how a cell phone or other embedded
	system can handle keystrokes (or other input events) in the 
	presence of suspend blockers.  Use set_irq_wake...

	...

      - The user-space input-event thread returns from read.  It 
	carries out whatever activities are appropriate (for example,
	powering up the display screen, running other programs, and so 
	on).  When it is finished, it calls suspend_unblock on the
	process_input_events suspend_blocker and then calls select or
	poll.  The system will automatically suspend again when it is
	idle and no suspend blockers remain active.


> +/**
> + * suspend_block() - Block suspend
> + * @blocker:	The suspend blocker to use
> + *
> + * It is safe to call this function from interrupt context.
> + */
> +void suspend_block(struct suspend_blocker *blocker)
> +{
> +	unsigned long irqflags;
> +
> +	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
> +		return;
> +
> +	spin_lock_irqsave(&list_lock, irqflags);
> +	blocker->flags |= SB_ACTIVE;
> +	list_del(&blocker->link);
> +
> +	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
> +		pr_info("suspend_block: %s\n", blocker->name);
> +
> +	list_add(&blocker->link, &active_blockers);

Here and in suspend_unblock(), you can use list_move() in place of 
list_del() followed by list_add().

Alan Stern


