Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab0E0TEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:04:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58796 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756693Ab0E0TEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:04:53 -0400
Date: Thu, 27 May 2010 15:04:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527175719.GD3543@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1005271449160.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:

> On Thu, May 27, 2010 at 07:52:59PM +0200, Peter Zijlstra wrote:
> 
> > Shall we henceforth stop confusing forced suspend for laptops and
> > powersaving a running system?
> 
> If you want to support forced suspend for laptops and you want to avoid 
> the risk of losing wakeups then you need in-kernel suspend blockers. 
> That's entirely orthogonal to Android's runtime power management.

Rather than continue going around in circles, let's agree that what the 
Android people want is a new version of forced suspend -- not a 
power-saving idle mode.  As such, latency is simply not relevant.

Here's an idea for a new approach that avoids the need for in-kernel 
suspend blockers.  I don't know exactly how or if it can be made to 
work, but at least it's a different way of looking at the problem.

A normal forced suspend is unconditional: It stops the system no matter 
what is happening.  The Android people want to make it conditional: 
Don't stop the system until nothing "important" is happening.

So what is "important"?  A possible definition could go like this.  
Let's add a per-process (or per-thread) flag to mark "important" 
processes.  And let's say that a process with this flag set is doing 
"important" work unless it is blocked inside a poll() system call.

Given that definition, an opportunistic suspend is a forced suspend 
that waits until no important processes are doing important work (i.e., 
all important processes are stuck inside poll).

Is this adequate to meet Android's needs?  I don't know.  It can handle 
the case of a program waiting for a keystroke or network packet to 
arrive.

Does it allow for sufficient accounting statistics and debugging 
capability?  I don't know -- no doubt this depends on how it is 
implemented.

Can it be made to work?  I don't know -- in fact, I don't even know how
the poll() system call works internally.  Certainly there is one
complication that needs to be handled: While a suspend is underway, the
important processes will be frozen and hence not sitting inside the
poll() call.  If an event occurs that normally would cause the poll to
complete, we would need to make it abort the suspend.  But it's
difficult to detect when this happens.  It may be necessary to _avoid_
freezing the important processes in order for this to work.

The advantages:

	No more suspend blockers cluttering up random drivers all over
	the kernel.  All the work is centralized in the poll()  
	routines and the PM core.

	It is driven by userspace policy (which processes to mark as
	"important") rather than kernel choice.

Is this doable?  Is it worth doing?  Is it better than using suspend 
blockers?

Alan Stern

