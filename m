Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0FCXPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:15:18 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50356 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab0FCXPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:15:16 -0400
Date: Thu, 3 Jun 2010 16:15:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
Message-ID: <20100603161513.60370e98@nehalam>
In-Reply-To: <alpine.LFD.2.00.1006031515030.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam>
	<alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org>
	<20100603120313.10a73b20@nehalam>
	<alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031355140.8175@i5.linux-foundation.org>
	<20100603144913.24828629@nehalam>
	<alpine.LFD.2.00.1006031455280.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031515030.8175@i5.linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 15:33:23 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 3 Jun 2010, Linus Torvalds wrote:
> >
> > > So still a race that shows up with KVM (fast floppy?) and manifests
> > > as floppy_ready or reset_interrupt OOPS.
> > 
> > Yes, it's quite possible that the Linux floppy driver is simply broken by 
> > any floppy device that basically responds immediately to a command with an 
> > interrupt. And considering how few people use floppies, I do expect that 
> > driver to get _worse_ rather than better in the future.
> 
> Having looked at that driver some more, I can inf act pretty much 
> guarantee it. The locking is rather baroque. It has a "floppy_lock", but 
> that only protects certain small parts. In particular, it looks like the 
> irq handler and the timers do _not_ take it, and that's where most of the 
> real work is done.
> 
> And in fact, that does look broken. The interrupt handler really does a 
> "schedule_work()" to schedule the actual handler outside of irq context, 
> and I don't see any serialization between the timers that file and the 
> handler running.
> 
> That driver used to be this state machine that ran entirely from interrupt 
> context, where one interrupt handler would set the state for the next one 
> (that's what the "do_floppy" thing is for). But then it became bottom 
> halves, and now it's using schedule_work() instead - and at the same time, 
> the _timers_ haven't really changed. Those run in timer context, and can 
> thus interrupt the work thing.
> 
> It always was a disgusting driver. Now it's just even more so. And yes, 
> I'm sure it's full of races that are largely hidden by the fact that real 
> floppy hardware is so slow that you can never hit them.
> 
> Looking too much at that driver will cause PTSD.  I have to look away.
> 
> 			Linus

Maybe putting all back together in a threaded_irq would be safest.
