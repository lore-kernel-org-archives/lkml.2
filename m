Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2JPHeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:34:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39456 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2JPHee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:34:34 -0400
Date: Tue, 16 Oct 2012 08:34:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nishanth Menon <nm@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121016073428.GG7662@gmail.com>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
 <20121012134542.GH12567@gmail.com>
 <20121012134813.GK21164@n2100.arm.linux.org.uk>
 <201210121353.16798.arnd@arndb.de>
 <20121012140149.GJ12567@gmail.com>
 <50784729.4030302@ti.com>
 <20121012164221.GN12567@gmail.com>
 <507C3125.70702@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <507C3125.70702@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>>>root@ME:/ cat /sys/kernel/debug/boottime/bootgraph
> >>>>>>[    0.185254] calling  splash+0x0/0x0
> >>>>>>[    2.984335] initcall splash+0x0/0x0 returned 0 after 2799 msecs.
> >>>>>>[    2.984335] calling  autoboot_delay+0x0/0x0
> >>>>>>[    4.089513] initcall autoboot_delay+0x0/0x0 returned 0 after 1105 msecs.
> >>>>>>[    4.089513] calling  load_kernel+0x0/0x0
> >>>>>>[    4.239174] initcall load_kernel+0x0/0x0 returned 0 after 149 msecs.
> >>>>>>[    4.239174] calling  boot_kernel+0x0/0x0
> >>>>>>[    4.276260] initcall boot_kernel+0x0/0x0 returned 0 after 37 msecs.
> >>>>>>[    4.276260] calling  uncompress_ll_init+0x0/0x0
> >>>>>>[    4.276260] initcall uncompress_ll_init+0x0/0x0 returned 0 after 0 msecs.
> >>>>>>[    4.276260] Freeing init memory: 0K

> >commit 4c49a18bcfd2d041cbad7f41c6e6b39d90008382 (HEAD, refs/heads/dt-snowball-pre-rc1)
> >Author: Jonas Aaberg<jonas.aberg@stericsson.com>
> >Date:   Wed Sep 14 09:29:20 2011 +0200
> >
> >     drivers: clocksource: dbx500-prcmu: Add boottime support
> >
> >     Change-Id: I9b5e3d050131c08c08786ae84cb76619c0525049
> >     Signed-off-by: Jonas Aaberg<jonas.aberg@stericsson.com>
> >     Reviewed-on: http://gerrit.lud.stericsson.com/gerrit/32055
> >
> >diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
> >index c26c369..0069cd9 100644
> >--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
> >+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
> >@@ -14,6 +14,7 @@
> >   */
> >  #include<linux/clockchips.h>
> >  #include<linux/clksrc-dbx500-prcmu.h>
> >+#include<linux/boottime.h>
> >
> >  #include<asm/sched_clock.h>
> >
> >@@ -68,6 +69,23 @@ static u32 notrace dbx500_prcmu_sched_clock_read(void)
> >
> >  #endif
> >
> >+#ifdef CONFIG_BOOTTIME
> >+static unsigned long __init boottime_get_time(void)
> >+{
> >+	return div_s64(clocksource_cyc2ns(clocksource_dbx500_prcmu.read(
> >+						&clocksource_dbx500_prcmu),
> >+					  clocksource_dbx500_prcmu.mult,
> >+					  clocksource_dbx500_prcmu.shift),
> >+		       1000);
> >+}
> >+
> >+static struct boottime_timer __initdata boottime_timer = {
> >+	.init     = NULL,
> >+	.get_time = boottime_get_time,
> >+	.finalize = NULL,
> >+};
> >+#endif
> >+
> >  void __init clksrc_dbx500_prcmu_init(void __iomem *base)
> >  {
> >  	clksrc_dbx500_timer_base = base;
> >@@ -90,4 +108,6 @@ void __init clksrc_dbx500_prcmu_init(void __iomem *base)
> >  			 32, RATE_32K);
> >  #endif
> >  	clocksource_register_hz(&clocksource_dbx500_prcmu, RATE_32K);
> >+
> >+	boottime_activate(&boottime_timer);
> >  }
> >
> 
> OK So has this been validated and tested on any other IC then a ST part?
> This boottime_activate patch seems to be only for the dbx500.  If
> this is supposed to be a generic solution I would expect
> a generic patch for ARM to enable boot time activation.

No, this is essentially an STE patch. We don't have access to any other
hardware, so we'd be reliant on kindhearted soles to test on their h/w.
I guess something like Beagleboard and/or Panda would be ideal. Know
anyone? ;)

> Have you profiled how much time the boot time logging has added to
> the over all boot?
> Also the boottime commit message should explain a little more what
> it is measuring.
> i.e.  This patch enables logging the boot time from point x to point
> y for the kernel only.  This does not include init.
> 
> What about adding the boot time from the init sequence to init complete?

I don't know the answers to these questions, but I'll endeavour to find
out and get back to you posthaste.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
