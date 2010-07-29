Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab0G2HL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 03:11:29 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:43363 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab0G2HL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 03:11:28 -0400
Date: Thu, 29 Jul 2010 09:11:25 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH 1/2] Remove stop_machine from change_clocksource
Message-ID: <20100729091125.6e25368e@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1280333569.1848.34.camel@work-vm>
References: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
	<20100728091733.56004b06@mschwide.boeblingen.de.ibm.com>
	<1280333569.1848.34.camel@work-vm>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 09:12:49 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2010-07-28 at 09:17 +0200, Martin Schwidefsky wrote:
> > On Tue, 27 Jul 2010 19:06:41 -0700
> > John Stultz <johnstul@us.ibm.com> wrote:
> > 
> > If I look at
> > timekeeping_get_ns I don't see anything that prevents the
> > compiler from generating code that reads timekeeper.clock
> > multiple times. Which would mix the read function from one
> > clocksource with the cycle_last / mask values from the new
> > clock. Now if we add code that prevents the compiler from
> > reading from timekeeper.clock multiple times we might get
> > away with it.
> 
> Right, but this should be ok. timekeeping_get_ns is a helper that
> requires the xtime_lock to be held (such a comment is probably needed,
> but there is no usage of it when the xtime_lock isn't held). While the
> function may actually mix values from two clocksources in a calculation,
> the results of those calculations will be thrown out and re-done via the
> xtime_lock seqlock.

Ok, all callers to timekeeping_get_ns use an xtime_lock loop to
make sure that no inconsistent result gets returned.
 
> > The reasoning for stop_machine is that the change of a
> > clocksource is a major change which has subtle side effects
> > so we want to make sure that nothing breaks. It is a very rare
> > event, we can afford to spent a little bit of time there.
> > Ergo stop_machine.
> 
> I do agree that there can be subtle side effects when dealing with
> clocksources (part of why I'm being so cautious introducing this
> change), and when the stop_machine code was added it seemed reasonable.
> But given the limitations of stop_machine, the more I look at the
> clocksource_change code, the more I suspect stop_machine is overkill and
> we can safely just take the write lock on xtime_lock.
> 
> If I'm still missing something, do let me know.

What about a clocksource_unregister while a cpu is in the middle of a
read_seqbegin/timekeeping_get_ns/read_seqretry? The clocksource structure
is "free" after the successful call to the unregister. At least in theory
this could be a use after free. The race window is tiny but on virtual
systems there can be an arbitrary delay in the ktime_get sequence.

I agree that stop_machine is the big gun and restricts the code in the way
how the clocksource functions may be call. But it is safe, no?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

