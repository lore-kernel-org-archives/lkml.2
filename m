Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1FJMbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:31:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:56433 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab1FJMbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:31:18 -0400
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>,
        PaulMundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
In-Reply-To: <1307705311.3941.118.camel@twins>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.493181962@chello.nl>
	 <20110609130617.f8aca966.akpm@linux-foundation.org>
	 <20110609202707.GA28951@elte.hu> <1307652883.2497.1028.camel@laptop>
	 <20110609140714.fc9ea187.akpm@linux-foundation.org>
	 <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
	 <1307705311.3941.118.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 14:30:30 +0200
Message-ID: <1307709030.3941.134.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 13:28 +0200, Peter Zijlstra wrote:
> On Thu, 2011-06-09 at 16:57 -0700, Hugh Dickins wrote:
> > 
> > All console-related activity curently happens under spin_lock_irqsave(&console_lock). 
> > This causes interrutps to be blocked for 1-2 milliseconds with vgacon, and for
> > hundreds of milliseconds with fbdevs.  This results in network overruns, audio
> > dropouts, dropped characters on serial ports and other such nice things.
> 
> Hmm, with these proposed patches we're actually back to that. I wonder
> if fbdev is still that crappy..

So I tried adding a fbcon to my test box (not that it actually has a
display, but who cares) and disabled lockdep (otherwise that's all I can
catch on the latency tracer) to see if I could see whopping horrid
latencies there, but I'm afraid I either failed to set things up
properly or my fbcon isn't sucky enough.

What I did was enable:

CONFIG_FB=y
CONFIG_FB_SIS=y
CONFIG_FB_SIS_315=y (the board has XGI z7)

and

CONFIG_FRAMEBUFFER_CONSOLE=y

And used:

 debug ignore_loglevel sysrq_always_enabled console=tty0
console=ttyS0,115200 earlyprintk=serial,ttyS0,115200

thinking that that would have my printk stmts appear on both the fbcon
as well as the serial line. But they fail to appear on the latency
tracer (current max was 165us waking an idle cpu).

Paul (and fellow fbcon folks), was my setup above correct, and what's
the current status of suckyness wrt fbcon output?

The idea is to keep IRQs disabled over all of printk() including the
con->write() calls, Andrew seems to be responsible removing that in the
early 2.4 time-frame due to some consoles being waaay crap and taking
like hundreds of ms to write things out, can that still happen or has
stuff improved and is using background flusher threads to write to slow
devices?


