Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2B0IqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:46:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55619 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2B0IqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:46:06 -0500
Message-ID: <1330332354.11248.32.camel@twins>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
From: Peter Zijlstra <peterz@infradead.org>
To: Venki Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 27 Feb 2012 09:45:54 +0100
In-Reply-To: <CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	 <1329989454.24994.57.camel@twins>
	 <CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 11:34 -0800, Venki Pallipadi wrote:

> > > +             local_bh_disable();
> > > +             local_irq_disable();
> >
> > That local_bh_disable() is completely superfluous, disabling IRQs
> > already kills bh.
> 
> The reason for local_bh_disable/enable was to check for potential
> softirqs after these interrupt.

Why is that needed? We never wrap local_irq_disable() in bh muck?


> > Why doesn't ipiless_idle_exit() call this? That would keep it isolated
> > to just those idle routines that actually use mwait instead of bothering
> > the generic idle paths with this.
> 
> ipiless_idle_exit is called in the inner most part of idle entry exit.
> In mwait case we may not even have interrupts enabled at that time and
> there is code that does idle residency timing etc which will get
> impacted if we start doing the pending ipi work there. Doing it at
> higher level along with things like enter-exit tickless felt nicer.

But but but, an actual interrupt can be handled before the instruction
after mwait, so why would this be a problem?

