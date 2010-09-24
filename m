Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab0IXXov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:44:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42006 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab0IXXot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:44:49 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: RFC: mixing device idle and CPUidle or non-atomic idle notifiers
Organization: Deep Root Systems, LLC
Date: Fri, 24 Sep 2010 16:44:46 -0700
Message-ID: <87iq1uwvtd.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have runtime PM for devices, I'm exploring ways of how to
couple the runtime PM of certain devices with CPUidle transitions.
Ideally, CPUidle should only manage CPU idle states, and device idle
states would be managed separately using runtime PM.  However, there are
cases where the device idle transistions need to be coordinated with CPU
idle transistions.  This is already a proposed topic for the PM
mini-conf at Plumbers'[1], so this RFC is to get the discussion started.

In the wild west (before runtime PM), we managed these special cases on
OMAP by having some special hacks^Whooks for certain drivers that were
called during idle.  When these devices are converted to using runtime
PM, ideally we'd like initiate device runtime PM transitions for these
devices somehow coordinated with CPU idle transitions.

So, I started to explore how to coordinate device runtime PM transitions
with CPU idle transitions.

One of the fundamental problems is that by the time CPUidle is entered,
interrupts are already disabled, and runtime PM cannot be used from
interrupts disabled context (c.f. thread on linux-pm[1].)

So that led me down the path of exploring whether we really need to have
interrupts disabled during the early part of CPUidle.  It seems to me
that during the time when the governor is selecting a state, and when
the platform-specific code is checking for device/bus activity,
interrupts do not really need to be disabled yet.  At least, I didn't
come up with a good reason why they need to be disabled so early, hence
the RFC.

Here's a simplified version how it works today:

/* arch/arm/kernel/process.c, arch/x86/kernel/process_*.c */
cpu_idle()  
    local_irq_disable()    
    pm_idle()  --> cpuidle_idle_call()

cpuidle_idle_call()
    dev->prepare()
    target_state = governor->select()  /* selects next state */
    target_state->enter()
        /* the ->enter hook must enable IRQs before returning */

As a quick hack, I just (re)enabled interrupts in our CPUidle
->prepare() hook (they're later disabled again before the core idle is
run.)  This allowed the calling of device-specific idle functions which
then use runtime PM and thus allows device-specific idle to be
coordinated with the CPU idle.

So back to the main question... do we really need interrupts disabled so
early in the idle path? 

I'm sure I'm missing something obvious about why this can't work, but
it's Friday and my brain prefers to think about beer rather than
CPUidle.

Or, as another potential option...

I just discovered that x86_64 has an atomic idle_notifier called just
before idle (c.f. arch/x86/kernel/process_64.c.)  However this is also
done with interrupts disabled, so using this has the same problems with
interrupts disabled.  But, what about adding an additional notifier
chain that happens with interrupts still enabled....  hmm, will
ponder that over that beer...

Kevin

[1] http://www.linuxplumbersconf.org/2010/ocw/proposals/717
[1] https://lists.linux-foundation.org/pipermail/linux-pm/2010-August/028124.html
