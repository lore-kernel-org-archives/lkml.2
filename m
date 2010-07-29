Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0G2Utb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:49:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47638 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0G2Uta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:49:30 -0400
Subject: Re: [RFC][PATCH 1/2] Remove stop_machine from change_clocksource
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <20100729091125.6e25368e@mschwide.boeblingen.de.ibm.com>
References: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
	 <20100728091733.56004b06@mschwide.boeblingen.de.ibm.com>
	 <1280333569.1848.34.camel@work-vm>
	 <20100729091125.6e25368e@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 13:49:07 -0700
Message-ID: <1280436547.2829.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 09:11 +0200, Martin Schwidefsky wrote:
> On Wed, 28 Jul 2010 09:12:49 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> > 
> > I do agree that there can be subtle side effects when dealing with
> > clocksources (part of why I'm being so cautious introducing this
> > change), and when the stop_machine code was added it seemed reasonable.
> > But given the limitations of stop_machine, the more I look at the
> > clocksource_change code, the more I suspect stop_machine is overkill and
> > we can safely just take the write lock on xtime_lock.
> > 
> > If I'm still missing something, do let me know.
> 
> What about a clocksource_unregister while a cpu is in the middle of a
> read_seqbegin/timekeeping_get_ns/read_seqretry? The clocksource structure
> is "free" after the successful call to the unregister. At least in theory
> this could be a use after free. The race window is tiny but on virtual
> systems there can be an arbitrary delay in the ktime_get sequence.

Huh. At first I thought "but we don't yet implement
clocksource_unregister!" but of course do now (I guess that TODO in the
clocksource.c header can be yanked :).

So yes, unregister has been contentious in the past for this very
reason. Once registered, its really hard to find a safe point when it
can be un-registered. Stop machine mostly solves this (although one
should note: vsyscall enabled clocksources really can't be freed, as
their vread() page needs to be statically mapped into userspace).

So while stop_machine is a solution here, it would make more sense to me
to use stop_machine (or maybe even a different method, as it sort of
screams RCU to me) to make sure all the cpus are out of the xtime_lock
critical section prior to returning from unregister_clocksource, rather
then stopping everything for the clocksource change.

> I agree that stop_machine is the big gun and restricts the code in the way
> how the clocksource functions may be call. But it is safe, no?

Actually, my reading of stop_machine makes me hesitate a bit, as I'm not
sure if with kernel preemption, we're sure to avoid stopping a thread
mid-syscall to gettimeofday. Anyone have a clue if that's avoided?

Regardless, we need some other method then stop_machine to register
clocksources, as stop_machine is just too limiting.

thanks
-john




