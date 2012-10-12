Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab2JLQma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:42:30 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47499 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810Ab2JLQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:42:26 -0400
Date: Fri, 12 Oct 2012 17:42:21 +0100
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
Message-ID: <20121012164221.GN12567@gmail.com>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
 <20121012134542.GH12567@gmail.com>
 <20121012134813.GK21164@n2100.arm.linux.org.uk>
 <201210121353.16798.arnd@arndb.de>
 <20121012140149.GJ12567@gmail.com>
 <50784729.4030302@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50784729.4030302@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Dan Murphy wrote:

> 
> On 10/12/2012 09:01 AM, Lee Jones wrote:
> >On Fri, 12 Oct 2012, Arnd Bergmann wrote:
> >
> >>On Friday 12 October 2012, Russell King - ARM Linux wrote:
> >>>>root@ME:/ cat /sys/kernel/debug/boottime/bootgraph
> >>>>[    0.185254] calling  splash+0x0/0x0
> >>>>[    2.984335] initcall splash+0x0/0x0 returned 0 after 2799 msecs.
> >>>>[    2.984335] calling  autoboot_delay+0x0/0x0
> >>>>[    4.089513] initcall autoboot_delay+0x0/0x0 returned 0 after 1105 msecs.
> >>>>[    4.089513] calling  load_kernel+0x0/0x0
> >>>>[    4.239174] initcall load_kernel+0x0/0x0 returned 0 after 149 msecs.
> >>>>[    4.239174] calling  boot_kernel+0x0/0x0
> >>>>[    4.276260] initcall boot_kernel+0x0/0x0 returned 0 after 37 msecs.
> >>>>[    4.276260] calling  uncompress_ll_init+0x0/0x0
> >>>>[    4.276260] initcall uncompress_ll_init+0x0/0x0 returned 0 after 0 msecs.
> >>>>[    4.276260] Freeing init memory: 0K
> >>>Umm, what happened to sysfs not becoming procfs v2?  I thought we had
> >>>a fairly strict requirement for "one value per file and not nicely
> >>>formatted" for sysfs?
> >>>
> >>I was thinking the same thing at first, but then I noticed it's actually
> >>debugfs, which has no such rules.
> >Right. :)
> >
> OK I don't see when boottime_activate is called.
> 
> Where would this call actually be made from?
> 
> I see the call to deactivate but no call to activate.

Here perhaps (Jonas, alerted me to the missing patch):

commit 4c49a18bcfd2d041cbad7f41c6e6b39d90008382 (HEAD, refs/heads/dt-snowball-pre-rc1)
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Wed Sep 14 09:29:20 2011 +0200

    drivers: clocksource: dbx500-prcmu: Add boottime support
    
    Change-Id: I9b5e3d050131c08c08786ae84cb76619c0525049
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Reviewed-on: http://gerrit.lud.stericsson.com/gerrit/32055

diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index c26c369..0069cd9 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -14,6 +14,7 @@
  */
 #include <linux/clockchips.h>
 #include <linux/clksrc-dbx500-prcmu.h>
+#include <linux/boottime.h>
 
 #include <asm/sched_clock.h>
 
@@ -68,6 +69,23 @@ static u32 notrace dbx500_prcmu_sched_clock_read(void)
 
 #endif
 
+#ifdef CONFIG_BOOTTIME
+static unsigned long __init boottime_get_time(void)
+{
+	return div_s64(clocksource_cyc2ns(clocksource_dbx500_prcmu.read(
+						  &clocksource_dbx500_prcmu),
+					  clocksource_dbx500_prcmu.mult,
+					  clocksource_dbx500_prcmu.shift),
+		       1000);
+}
+
+static struct boottime_timer __initdata boottime_timer = {
+	.init     = NULL,
+	.get_time = boottime_get_time,
+	.finalize = NULL,
+};
+#endif
+
 void __init clksrc_dbx500_prcmu_init(void __iomem *base)
 {
 	clksrc_dbx500_timer_base = base;
@@ -90,4 +108,6 @@ void __init clksrc_dbx500_prcmu_init(void __iomem *base)
 			 32, RATE_32K);
 #endif
 	clocksource_register_hz(&clocksource_dbx500_prcmu, RATE_32K);
+
+	boottime_activate(&boottime_timer);
 }

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
