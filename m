Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2DYDGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:06:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab2DYDGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:06:17 -0400
From: NeilBrown <neilb@suse.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 25 Apr 2012 13:05:23 +1000
Subject: [PATCH 0/3] Ensure twl4030 interrupts are lost during suspend.
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Message-ID: <20120425025637.7832.14013.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the scatter-gun list of email address, but while each of
these patches only touches one subsystem, they really needed each
other to provide proper context.

The goal is to ensure that an interrupt that arrives on a TWL4030
connected to an OMAP3, during the 'late-suspend' stage will
cause the suspend to abort (if the interrupt is properly configured).
(e.g. power button, RTC alarm, USB plug/unplug)

The interrupt as seen by the OMAP3 is a level-triggered interrupt so
if it arrives at this time, it is masked.  With the current code it
remains masked and so cannot wake the device from suspend.

To fix this:
  The twl4030 drivers must mark the interrupt for wakeup
  The OMAP interrupt handler must allow the interrupt to be
     marked for wakeup
  The core interrupt/PM code must allow masked level-triggered
     interrupts to abort a suspend.

I'm least sure about that last one.  My patch unmasks any masked
interrupt that is suppose to support wakeup.  I suspect that is
correct but I don't know enough about general IRQ handling to be sure.
Maybe there could be cases where a driver has explicitly masked the
interrupt without cleaning the 'wakeup' setting.  Is that allowed?


---

NeilBrown (3):
      twl4030: enable wakeup on twl4030 IRQ.
      IRQ: allow check_wakeup_irqs to notice level-triggered interrupts.
      ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC interrupts.


 arch/arm/mach-omap2/irq.c |    1 +
 drivers/mfd/twl4030-irq.c |    1 +
 kernel/irq/pm.c           |    6 ++++++
 3 files changed, 8 insertions(+)

-- 
Signature

