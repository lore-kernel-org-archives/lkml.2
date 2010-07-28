Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0G1HRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:17:37 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:41807 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0G1HRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:17:36 -0400
Date: Wed, 28 Jul 2010 09:17:33 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH 1/2] Remove stop_machine from change_clocksource
Message-ID: <20100728091733.56004b06@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
References: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 19:06:41 -0700
John Stultz <johnstul@us.ibm.com> wrote:

> To me, there isn't a clear reason why we're using stop_machine
> when changing clocksources instead of just taking the xtime_lock.
> 
> Additionally, using stop_machine limits us from being able to
> register clocksources from timers (as needed for a following
> patch).
> 
> This patch simply removes the stop_machine usage and instead
> directly calls change_clocksource, which now takes the xtime_lock.
> 
> I could be totally missing something here that necessitates
> stop_machine, but in my testing it seems to function fine.
> 
> Any clarifications or corrections would be appreciated!

Installing a new clocksource updates quite a lot of internal
variables, we need to make sure that no code ever uses these
variables without holding the xtime_lock as writer.

And then there is ktime_get which uses a read_seqbegin/
read_seqretry loop on the xtime_lock to get the time from the
clocksource. Consider the case where a ktime_get call already
did read_seqbegin but did not yet call the read function of
the clocksource. Another cpu registers a better clocksource
which will cause the timekeeper.clock variable to get updated
while the ktime_get call is using it. If I look at
timekeeping_get_ns I don't see anything that prevents the
compiler from generating code that reads timekeeper.clock
multiple times. Which would mix the read function from one
clocksource with the cycle_last / mask values from the new
clock. Now if we add code that prevents the compiler from
reading from timekeeper.clock multiple times we might get
away with it.

The reasoning for stop_machine is that the change of a
clocksource is a major change which has subtle side effects
so we want to make sure that nothing breaks. It is a very rare
event, we can afford to spent a little bit of time there.
Ergo stop_machine.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

