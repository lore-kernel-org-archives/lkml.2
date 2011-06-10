Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab1FJMnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:43:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:35633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab1FJMnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:43:03 -0400
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>,
        PaulMundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
In-Reply-To: <1307709714.3941.140.camel@twins>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.493181962@chello.nl>
	 <20110609130617.f8aca966.akpm@linux-foundation.org>
	 <20110609202707.GA28951@elte.hu> <1307652883.2497.1028.camel@laptop>
	 <20110609140714.fc9ea187.akpm@linux-foundation.org>
	 <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
	 <1307705311.3941.118.camel@twins> <1307709030.3941.134.camel@twins>
	 <20110610123416.GA12451@elte.hu>  <1307709714.3941.140.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 14:42:44 +0200
Message-ID: <1307709764.3941.141.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 14:41 +0200, Peter Zijlstra wrote:
> On Fri, 2011-06-10 at 14:34 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > thinking that that would have my printk stmts appear on both the 
> > > fbcon as well as the serial line. But they fail to appear on the 
> > > latency tracer (current max was 165us waking an idle cpu).
> > 
> > Have you removed this bit:
> > 
> >                 spin_unlock(&logbuf_lock);
> >                 stop_critical_timings();        /* don't trace print latency */
> >                 call_console_drivers(_con_start, _log_end);
> >                 start_critical_timings();
> >                 local_irq_restore(flags);
> > 
> > which hides the latencies from the latency tracer?
> 
> it shouldn't those flags come from spin_lock_irqsave(), which already
> has IRQs disabled, so the restore shouldn't re-enable them.
> 
> Hmm,. that might actually already be true for mainline too, yeah, looks
> like we call vprintk()->console_unlock() with IRQs-disabled.
> 
> Hohumm..

Also, I used the preemptirqoff tracer, so even if it did re-enable
interrupts we should still have preemption disabled and still catch the
latency.
