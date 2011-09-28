Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1I1Wkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab1I1Wki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:32 2011
Message-Id: <20110928220132.905742035@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [072/244] ARM: 7081/1: mach-integrator: fix the clocksource
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit bb9ea77846620ed2b37e74c852d72c7a476b248c upstream.

I was intrigued by the fact that the clock stood still on
the Integrator, but it wasn't strange at all, because the
timer was set up all wrong and probably has been for a
while. With this patch the clock starts ticking again:
make the timer periodic (reload), |= on the divisor bit
and load the timer before starting it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-integrator/integrator_ap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -337,15 +337,15 @@ static unsigned long timer_reload;
 static void integrator_clocksource_init(u32 khz)
 {
 	void __iomem *base = (void __iomem *)TIMER2_VA_BASE;
-	u32 ctrl = TIMER_CTRL_ENABLE;
+	u32 ctrl = TIMER_CTRL_ENABLE | TIMER_CTRL_PERIODIC;
 
 	if (khz >= 1500) {
 		khz /= 16;
-		ctrl = TIMER_CTRL_DIV16;
+		ctrl |= TIMER_CTRL_DIV16;
 	}
 
-	writel(ctrl, base + TIMER_CTRL);
 	writel(0xffff, base + TIMER_LOAD);
+	writel(ctrl, base + TIMER_CTRL);
 
 	clocksource_mmio_init(base + TIMER_VALUE, "timer2",
 		khz * 1000, 200, 16, clocksource_mmio_readl_down);


