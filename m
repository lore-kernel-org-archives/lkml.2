Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab0FCEYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:24:33 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44248 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0FCEYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:24:30 -0400
Date: Thu, 3 Jun 2010 13:24:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Arve Hj?nnev?g <arve@android.com>,
       Paul@smtp1.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603042403.GC20028@linux-sh.org>
References: <Pine.LNX.4.44L0.1005271141410.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005271751240.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271751240.3032@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 06:06:43PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Alan Stern wrote:
> > And to answer Thomas's question: The whole reason for having in-kernel 
> > suspend blockers is so that userspace can tell the system to suspend 
> > without losing wakeup events.
> > 
> > Suppose a key is pressed just as a user program writes "mem" to
> > /sys/power/state.  The keyboard driver handles the keystroke and queues
> > an input event.  Then the system suspends and doesn't wake up until
> > some other event occurs -- even though the keypress was an important
> > one and it should have prevented the system from suspending.
> > 
> > With in-kernel suspend blockers and opportunistic suspend, this 
> > scenario is prevented.  That is their raison-d'etre.
> 
> I tend to disagree. You are still looking at suspend as some extra
> esoteric mechanism. We should stop doing this and look at suspend (to
> RAM) as an additional deep idle state, which is well defined in terms
> of power savings and wakeup latency. That's what I think opportunistic
> suspend is all about. Now if you look at our current idle states in
> x86 the incoming keystroke is never lost. 
> 
For systems with runtime PM and deep idle states in cpuidle suspend is
already fairly opportunistic. If sleep states (including suspend to RAM
and CPU off) are factored in to cpuidle then it's very easy to get in to
situations where everything simply shuts off automatically, which can be
problematic if a platform doesn't expose any external wakeup sources.

Platforms still need to be able to establish some heuristics, whether
this is via blocking certain state transitions or simply defining a
maximum acceptable suspend depth irrespective of latency (at least we
presently don't have a clean interface for preventing entry in to
impossible to recover from idle states outside of latency hints via PM
QoS, or at least not one that I'm aware of).

On the other hand, while this isn't that difficult for the UP case it
does pose more problems for the SMP case. Presently the suspend paths
(suspend-to-RAM/hibernate/kexec jump) all deal with disabling and
enabling of non-boot CPUs via CPU hotplug explicitly, which will clear
them from the online CPU map. We would have to rework the semantics a bit
if cpuidle were also permitted to opportunistically offline CPUs.
