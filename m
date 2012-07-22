Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2GVCIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 22:08:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65439 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2GVCIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 22:08:24 -0400
Date: Sat, 21 Jul 2012 19:07:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Roland Dreier <roland@purestorage.com>
cc: Tomasz Chmielewski <tch@wpkg.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.5-rc7 - can no longer wake up from suspend to RAM
In-Reply-To: <CAL1RGDU8TVBkZ4yP=kjwqvGUsrnQcBGpLa_x-7c=Gu54piVwyw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1207211905010.1570@eggly.anvils>
References: <50079125.3020007@wpkg.org> <CAL1RGDU8TVBkZ4yP=kjwqvGUsrnQcBGpLa_x-7c=Gu54piVwyw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2012, Roland Dreier wrote:
> On Wed, Jul 18, 2012 at 9:46 PM, Tomasz Chmielewski <tch@wpkg.org> wrote:
> > After upgrading to 3.5-rc7, my laptop no longer wakes up reliable from suspend to RAM. 3.4.x worked fine.
> 
> FWIW, I've been having similar problems with 3.5-rc7.  With 3.5-rc6 my
> laptop resumed fine, but since updating to -rc7, it often seems to just
> sit there after opening the lid -- the moon/sleep LED stays on, and the
> power LED smoothly cycles on and off, as if it's fast asleep.  Even pressing
> the power button doesn't have any effect (until I hold down the power
> button long enough to turn off).
> 
> I guess I'll start a bisection, but it's slow going because it takes multiple
> tries to know for sure if a kernel is bad.
> 
> The only commit between rc6 and rc7 that looks like it might be related
> is dc332fdf9f373a87b1e2f423b5b004b2a3c37e1a ("ACPI / PM: Leave
> Bus Master Arbitration enabled for suspend/resume"), which apparently
> fixes some other laptops.  But perhaps I'll try reverting that and see how
> it goes.

Interrupt your bisection to try this from 3.5 final:

commit 3e997130bd2e8c6f5aaa49d6e3161d4d29b43ab0
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Jul 16 12:50:42 2012 -0400

    timekeeping: Add missing update call in timekeeping_resume()
    
    The leap second rework unearthed another issue of inconsistent data.
    
    On timekeeping_resume() the timekeeper data is updated, but nothing
    calls timekeeping_update(), so now the update code in the timer
    interrupt sees stale values.
    
    This has been the case before those changes, but then the timer
    interrupt was using stale data as well so this went unnoticed for quite
    some time.
    
    Add the missing update call, so all the data is consistent everywhere.
    
    Reported-by: Andreas Schwab <schwab@linux-m68k.org>
    Reported-and-tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
    Reported-and-tested-by: Martin Steigerwald <Martin@lichtvoll.de>
    Cc: LKML <linux-kernel@vger.kernel.org>
    Cc: Linux PM list <linux-pm@vger.kernel.org>
    Cc: John Stultz <johnstul@us.ibm.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
    Cc: Prarit Bhargava <prarit@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: John Stultz <johnstul@us.ibm.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 269b1fe..3447cfa 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -717,6 +717,7 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
+	timekeeping_update(false);
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	touch_softlockup_watchdog();
