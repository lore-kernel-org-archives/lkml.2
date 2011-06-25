Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1FYUDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 16:03:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42526 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1FYUDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 16:03:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110609130621.921710458@linutronix.de>
References: <20110609130509.346588418@linutronix.de>
	<20110609130621.921710458@linutronix.de>
Date: Sat, 25 Jun 2011 22:03:03 +0200
Message-ID: <BANLkTinwpK=TFFexbeBeqXz-s=ouBK9gEg@mail.gmail.com>
Subject: Re: [patch 1/5] i8253: Create common clockevent implementation
From: Stijn Devriendt <highguy@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Initialize the conversion factor and the min/max deltas of the clock event
> + * structure and register the clock event source with the framework.
> + */
> +void __init clockevent_i8253_init(bool oneshot)
> +{
> +       if (oneshot)
> +               i8253_clockevent.features |= CLOCK_EVT_FEAT_ONESHOT;
> +       /*
> +        * Start pit with the boot cpu mask. x86 might make it global
> +        * when it is used as broadcast device later.
> +        */
> +       i8253_clockevent.cpumask = cpumask_of(smp_processor_id());
> +
> +       clockevents_config_and_register(&i8253_clockevent, PIT_TICK_RATE,
> +                                       0xF, 0x7FFF);
> +}
> +#endif
>
Both this function and the i8253_clockevent declaration seem to be missing
from include/linux/i8253.h causing compile failures for at least x86.

I was just trying to compile tip of
git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

Should be fixed by applying the following patch.

commit 0c24072a8d580acd5b4fc57009b72b217c0f23d9
Author: Stijn Devriendt <HIGHGuY@gmail.com>
Date:   Sat Jun 25 22:04:53 2011 +0200

    Fix missing declarations of i8253.

    Signed-off-by: Stijn Devriendt <HIGHGuY@gmail.com>

diff --git a/include/linux/i8253.h b/include/linux/i8253.h
index 0770fc5..e6c032f 100644
--- a/include/linux/i8253.h
+++ b/include/linux/i8253.h
@@ -22,6 +22,10 @@

 extern raw_spinlock_t i8253_lock;

+extern struct clock_event_device i8253_clockevent;
+
 extern void setup_pit_timer(void);

+extern void clockevent_i8253_init(bool oneshot);
+
 #endif /* __LINUX_I8253_H */
