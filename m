Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab0LUAUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:20:12 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:56489 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab0LUAUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:20:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U1BFJ0BPtjrY20/WSJCwhoOi2zWIBfPfIRiYC9yuWF8orM7cRsFO/Q7rD1O6xWYAgf
         Lh9mkFoDIFkNBlM0KcDOaRrwqL7Di6o9B9zlJTjcU+hZErZYfRfLbpgoTBhsStSV4KbQ
         /BBzR2+a/FxwHfkGOgJx6pgptBzU73XtykUEk=
Date: Tue, 21 Dec 2010 01:20:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 02/15] nohz_task: Avoid nohz task cpu as non-idle
 timer target
Message-ID: <20101221002005.GH1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-3-git-send-email-fweisbec@gmail.com>
 <1292860078.5021.6.camel@laptop>
 <1292861202.22905.23.camel@gandalf.stny.rr.com>
 <1292861524.5021.22.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292861524.5021.22.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:12:04PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 11:06 -0500, Steven Rostedt wrote:
> > On Mon, 2010-12-20 at 16:47 +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > > Unbound timers are preferably targeted for non idle cpu. If
> > > > possible though, prioritize idle cpus over nohz task cpus,
> > > > because the main point of nohz task is to avoid unnecessary
> > > > timer interrupts.
> > > 
> > > Oh is it?
> > > 
> > > I'd very much expect the cpu that arms the timer to get the interrupt. I
> > > mean, if the task doesn't want to get interrupted by timers,
> > > _DON'T_USE_TIMERS_ to begin with.
> > > 
> > > So no, don't much like this at all.
> > 
> > I think this comes from other tasks on other CPUs that are using timers.
> 
> Tasks on other CPUs should not cause timers on this CPU, _if_ that does
> happen, fix that.
> 
> > Although, I'm not sure what causes an "unbound" timer to happen. I
> > thought timers usually go off on the CPU that asked for it to go off.
> 
> They do, except if you enable some weird power management feature that
> migrates timers around so as to let CPUs sleep longer. But I doubt
> that's the reason for this here, and if it is, just disable that.

That seems to me the reason for that: avoid to wake up idle cpus.

I can certainly deactivate TIMER_NOT_PINNED and make it a no-op
if CONFIG_NO_HZ_TASK.
But I'm not sure why we would want to do this.
