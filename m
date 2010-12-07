Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab0LGNv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 08:51:27 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59464 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab0LGNv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:51:26 -0500
Subject: Re: [BUG] "perf top" results in "NOHZ: local_softirq_pending 100"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20101207132951.GB10927@osiris.boeblingen.de.ibm.com>
References: <20101207124448.GA10927@osiris.boeblingen.de.ibm.com>
	 <20101207132951.GB10927@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Dec 2010 14:51:07 +0100
Message-ID: <1291729867.2032.534.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 14:29 +0100, Heiko Carstens wrote:
> > As far as I could see this function gets called from process context with
> > a spinlock held and hence we don't have any guarantee that this pending
> > softirq get executed before the idle task gets scheduled and tries to
> > disable the tick.
> > 
> > The easiest fix would be to set wakeup to one (see patch below), but I guess
> > there is a reason why its zero. Anybody?

We can start that hrtimer from within the scheduler function while
holding the rq->lock, doing a wakeup from there is not sane.

The best solution would be to fix the hrtimer_start*() interface,
something Thomas and I have wanted to do for ages but because we've
procrastinated is now a much larger job than it was :/

The whole HRTIMER_SOFTIRQ thing should die.. but for that to happen its
only use-case today must first go.

The problem is trying to start a timer with already elapsed time.
Preferably hrtimer_start*() would simply return -ETIME and let the
caller sort it, sadly the current behaviour is to 'fix' it for the
caller by enqueueing the timer onto the softirq list and raising the
softirq.

I guess we could make hrtimer_start*(.wakeup=false) return the -ENOTIME
thing and audit those few use-cases.
 
