Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2GQIVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:21:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59321 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2GQIVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:21:10 -0400
Message-ID: <5005206E.9040804@openvz.org>
Date: Tue, 17 Jul 2012 12:21:02 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120608 Firefox/10.0.5 Iceape/2.7.5
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] timekeeping: Add missing update call in timekeeping_resume()
References: <1342457442-7255-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1342457442-7255-1-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I run into the same regression in s2ram between v3.5-rc6 and v3.5-rc7.
This patch helps. Thanks.

Tested-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

John Stultz wrote:
> From: Thomas Gleixner<tglx@linutronix.de>
>
> Linus,
> 	Since Thomas is on vacation I wanted to send you his fix to resolve
> the suspend regression from the leapsecond fixes.
>
> thanks
> -john
>
> The leap second rework unearthed another issue of inconsistent data.
>
> On timekeeping_resume() the timekeeper data is updated, but nothing
> calls timekeeping_update(), so now the update code in the timer
> interrupt sees stale values.
>
> This has been the case before those changes, but then the timer
> interrupt was using stale data as well so this went unnoticed for
> quite some time.
>
> Add the missing update call, so all the data is consistent everywhere.
>
> Reported-by: Andreas Schwab<schwab@linux-m68k.org>
> Reported-by-and-tested-by: "Rafael J. Wysocki"<rjw@sisk.pl>
> CC: LKML<linux-kernel@vger.kernel.org>
> Cc: Linux PM list<linux-pm@vger.kernel.org>
> Cc: John Stultz<johnstul@us.ibm.com>
> Cc: Ingo Molnar<mingo@kernel.org>
> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>,
> Cc: Prarit Bhargava<prarit@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> Signed-off-by: John Stultz<johnstul@us.ibm.com>
> ---
>   kernel/time/timekeeping.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 269b1fe..3447cfa 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -717,6 +717,7 @@ static void timekeeping_resume(void)
>   	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
>   	timekeeper.ntp_error = 0;
>   	timekeeping_suspended = 0;
> +	timekeeping_update(false);
>   	write_sequnlock_irqrestore(&timekeeper.lock, flags);
>
>   	touch_softlockup_watchdog();

