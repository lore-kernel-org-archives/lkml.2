Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab0EVCro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 22:47:44 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35164 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753003Ab0EVCrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 22:47:42 -0400
Date: Fri, 21 May 2010 22:47:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
In-Reply-To: <1274482015-30899-2-git-send-email-arve@android.com>
Message-ID: <Pine.LNX.4.44L0.1005212226180.20028-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010, [UTF-8] Arve Hjønnevåg wrote:

> The first goal can be achieved either by using device runtime PM and
> cpuidle to put all hardware into low-power states, transparently from
> the user space point of view, or by suspending the whole system.
> However, system suspend, in its current form, does not guarantee that
> the events of interest will always be responded to, since wakeup
> events (events that wake the CPU from idle and the system from
> suspend) that occur right after initiating suspend will not be
> processed until another possibly unrelated event wakes the system up
> again.

Minor point of clarification here.  I'm not requesting that the patch 
description be rewritten.  But this issue of lost wakeup events is more 
subtle than it appears.

Wakeup events can be lost in at least three different ways:

     1. A hardware signal (such as an IRQ) gets ignored.

     2. The hardware event occurs, but without effect since the
	kernel thread that would handle the event has been frozen.
	The event just ends up sitting in a queue somewhere until
	something else wakes up the system.

     3. The hardware event occurs and the kernel handles it fully,
	but the event propagates to userspace for further handling
	and the user program is already frozen.

1 is a hardware configuration failure (for example, it might happen as
a result of using edge-triggered IRQs instead of level-triggered) and
is outside the scope of this discussion.

2 generally represents a failure of the core PM subsystem, or a failure
of some other part of the kernel to use the PM core correctly.  In
theory we should be able to fix such mistakes.  Right now I'm aware of
at least one possible failure scenario that could be fixed fairly
easily.

3 is the type of failure that suspend blockers were really meant to
handle, particularly the userspace suspend-blocker API.

IMO, we should strive to fix the existing type-2 failure modes.  
However it is worth pointing out that they are basically separate from 
the suspend-blocker mechanism.

And it might be a good idea to point out somewhere in the patch
descriptions that suspend blockers are really meant to handle type-3
wakeup losses.

Alan Stern

