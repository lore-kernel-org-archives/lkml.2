Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0G1QM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:12:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37634 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0G1QMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:12:55 -0400
Subject: Re: [RFC][PATCH 1/2] Remove stop_machine from change_clocksource
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <20100728091733.56004b06@mschwide.boeblingen.de.ibm.com>
References: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
	 <20100728091733.56004b06@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 09:12:49 -0700
Message-ID: <1280333569.1848.34.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 09:17 +0200, Martin Schwidefsky wrote:
> On Tue, 27 Jul 2010 19:06:41 -0700
> John Stultz <johnstul@us.ibm.com> wrote:
> 
> > To me, there isn't a clear reason why we're using stop_machine
> > when changing clocksources instead of just taking the xtime_lock.
> > 
> > Additionally, using stop_machine limits us from being able to
> > register clocksources from timers (as needed for a following
> > patch).
> > 
> > This patch simply removes the stop_machine usage and instead
> > directly calls change_clocksource, which now takes the xtime_lock.
> > 
> > I could be totally missing something here that necessitates
> > stop_machine, but in my testing it seems to function fine.
> > 
> > Any clarifications or corrections would be appreciated!
> 
> Installing a new clocksource updates quite a lot of internal
> variables, we need to make sure that no code ever uses these
> variables without holding the xtime_lock as writer.

Agreed.

> And then there is ktime_get which uses a read_seqbegin/
> read_seqretry loop on the xtime_lock to get the time from the
> clocksource. Consider the case where a ktime_get call already
> did read_seqbegin but did not yet call the read function of
> the clocksource. Another cpu registers a better clocksource
> which will cause the timekeeper.clock variable to get updated
> while the ktime_get call is using it. 

Although ktime_get will be forced to loop and try again, as any writes
require holding a write on the xtime_lock. While the xtime_lock
writelock is held, the function could possibly mix the
read/cycle_last/mask/cyc2ns values, but the results from those invalid
calculations will not be returned. 


> If I look at
> timekeeping_get_ns I don't see anything that prevents the
> compiler from generating code that reads timekeeper.clock
> multiple times. Which would mix the read function from one
> clocksource with the cycle_last / mask values from the new
> clock. Now if we add code that prevents the compiler from
> reading from timekeeper.clock multiple times we might get
> away with it.

Right, but this should be ok. timekeeping_get_ns is a helper that
requires the xtime_lock to be held (such a comment is probably needed,
but there is no usage of it when the xtime_lock isn't held). While the
function may actually mix values from two clocksources in a calculation,
the results of those calculations will be thrown out and re-done via the
xtime_lock seqlock.

> The reasoning for stop_machine is that the change of a
> clocksource is a major change which has subtle side effects
> so we want to make sure that nothing breaks. It is a very rare
> event, we can afford to spent a little bit of time there.
> Ergo stop_machine.

I do agree that there can be subtle side effects when dealing with
clocksources (part of why I'm being so cautious introducing this
change), and when the stop_machine code was added it seemed reasonable.
But given the limitations of stop_machine, the more I look at the
clocksource_change code, the more I suspect stop_machine is overkill and
we can safely just take the write lock on xtime_lock.

If I'm still missing something, do let me know.

thanks
-john




