Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2FDPNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:13:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:41914 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2FDPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:13:22 -0400
Date: Mon, 4 Jun 2012 17:13:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT Pull] timer updates for 3.5
Message-ID: <alpine.LFD.2.02.1206041711410.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

sorry for sending this late. I ran off in a hurry last thursday to
help organizing my sisters wedding and totally forgot about the few bits
pending in my trees.

The clocksource driver is pure hardware enablement and the skew option
is default off, well tested and non dangerous.

Thanks,

	tglx

------------------>
Magnus Damm (3):
      clockevents: Make clockevents_config() a global symbol
      clocksource: em_sti: Emma Mobile STI driver
      clocksource: em_sti: Add DT support

Mike Galbraith (1):
      tick: Add tick skew boot option

Thomas Gleixner (1):
      tick: Move skew_tick option into the HIGH_RES_TIMER section


 Documentation/kernel-parameters.txt |    9 +
 arch/arm/mach-shmobile/Kconfig      |    6 +
 drivers/clocksource/Makefile        |    1 +
 drivers/clocksource/em_sti.c        |  406 +++++++++++++++++++++++++++++++++++
 include/linux/clockchips.h          |    1 +
 kernel/time/clockevents.c           |    3 +-
 kernel/time/tick-sched.c            |   18 ++
 7 files changed, 442 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clocksource/em_sti.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b69cfdc12..ea38cd1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2532,6 +2532,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	sched_debug	[KNL] Enables verbose scheduler debug messages.
 
+	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
+			xtime_lock contention on larger systems, and/or RCU lock
+			contention on all systems with CONFIG_MAXSMP set.
+			Format: { "0" | "1" }
+			0 -- disable. (may be 1 via CONFIG_CMDLINE="skew_tick=1"
+			1 -- enable.
+			Note: increases power consumption, thus should only be
+			enabled if running jitter sensitive (HPC/RT) workloads.
+
 	security=	[SECURITY] Choose a security module to enable at boot.
 			If this boot parameter is not specified, only the first
 			security module asking for security registration will be
diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index f31383c..df33909 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -186,6 +186,12 @@ config SH_TIMER_TMU
 	help
 	  This enables build of the TMU timer driver.
 
+config EM_TIMER_STI
+	bool "STI timer driver"
+	default y
+	help
+	  This enables build of the STI timer driver.
+
 endmenu
 
 config SH_CLK_CPG
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 8d81a1d..dd3e661 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-clockevt.o
 obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
 obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
+obj-$(CONFIG_EM_TIMER_STI)	+= em_sti.o
 obj-$(CONFIG_CLKBLD_I8253)	+= i8253.o
 obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
 obj-$(CONFIG_DW_APB_TIMER)	+= dw_apb_timer.o
diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
new file mode 100644
index 0000000..372051d
--- /dev/null
+++ b/drivers/clocksource/em_sti.c
@@ -0,0 +1,406 @@
+/*
+ * Emma Mobile Timer Support - STI
+ *
+ *  Copyright (C) 2012 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+enum { USER_CLOCKSOURCE, USER_CLOCKEVENT, USER_NR };
+
+struct em_sti_priv {
+	void __iomem *base;
+	struct clk *clk;
+	struct platform_device *pdev;
+	unsigned int active[USER_NR];
+	unsigned long rate;
+	raw_spinlock_t lock;
+	struct clock_event_device ced;
+	struct clocksource cs;
+};
+
+#define STI_CONTROL 0x00
+#define STI_COMPA_H 0x10
+#define STI_COMPA_L 0x14
+#define STI_COMPB_H 0x18
+#define STI_COMPB_L 0x1c
+#define STI_COUNT_H 0x20
+#define STI_COUNT_L 0x24
+#define STI_COUNT_RAW_H 0x28
+#define STI_COUNT_RAW_L 0x2c
+#define STI_SET_H 0x30
+#define STI_SET_L 0x34
+#define STI_INTSTATUS 0x40
+#define STI_INTRAWSTATUS 0x44
+#define STI_INTENSET 0x48
+#define STI_INTENCLR 0x4c
+#define STI_INTFFCLR 0x50
+
+static inline unsigned long em_sti_read(struct em_sti_priv *p, int offs)
+{
+	return ioread32(p->base + offs);
+}
+
+static inline void em_sti_write(struct em_sti_priv *p, int offs,
+				unsigned long value)
+{
+	iowrite32(value, p->base + offs);
+}
+
+static int em_sti_enable(struct em_sti_priv *p)
+{
+	int ret;
+
+	/* enable clock */
+	ret = clk_enable(p->clk);
+	if (ret) {
+		dev_err(&p->pdev->dev, "cannot enable clock\n");
+		return ret;
+	}
+
+	/* configure channel, periodic mode and maximum timeout */
+	p->rate = clk_get_rate(p->clk);
+
+	/* reset the counter */
+	em_sti_write(p, STI_SET_H, 0x40000000);
+	em_sti_write(p, STI_SET_L, 0x00000000);
+
+	/* mask and clear pending interrupts */
+	em_sti_write(p, STI_INTENCLR, 3);
+	em_sti_write(p, STI_INTFFCLR, 3);
+
+	/* enable updates of counter registers */
+	em_sti_write(p, STI_CONTROL, 1);
+
+	return 0;
+}
+
+static void em_sti_disable(struct em_sti_priv *p)
+{
+	/* mask interrupts */
+	em_sti_write(p, STI_INTENCLR, 3);
+
+	/* stop clock */
+	clk_disable(p->clk);
+}
+
+static cycle_t em_sti_count(struct em_sti_priv *p)
+{
+	cycle_t ticks;
+	unsigned long flags;
+
+	/* the STI hardware buffers the 48-bit count, but to
+	 * break it out into two 32-bit access the registers
+	 * must be accessed in a certain order.
+	 * Always read STI_COUNT_H before STI_COUNT_L.
+	 */
+	raw_spin_lock_irqsave(&p->lock, flags);
+	ticks = (cycle_t)(em_sti_read(p, STI_COUNT_H) & 0xffff) << 32;
+	ticks |= em_sti_read(p, STI_COUNT_L);
+	raw_spin_unlock_irqrestore(&p->lock, flags);
+
+	return ticks;
+}
+
+static cycle_t em_sti_set_next(struct em_sti_priv *p, cycle_t next)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&p->lock, flags);
+
+	/* mask compare A interrupt */
+	em_sti_write(p, STI_INTENCLR, 1);
+
+	/* update compare A value */
+	em_sti_write(p, STI_COMPA_H, next >> 32);
+	em_sti_write(p, STI_COMPA_L, next & 0xffffffff);
+
+	/* clear compare A interrupt source */
+	em_sti_write(p, STI_INTFFCLR, 1);
+
+	/* unmask compare A interrupt */
+	em_sti_write(p, STI_INTENSET, 1);
+
+	raw_spin_unlock_irqrestore(&p->lock, flags);
+
+	return next;
+}
+
+static irqreturn_t em_sti_interrupt(int irq, void *dev_id)
+{
+	struct em_sti_priv *p = dev_id;
+
+	p->ced.event_handler(&p->ced);
+	return IRQ_HANDLED;
+}
+
+static int em_sti_start(struct em_sti_priv *p, unsigned int user)
+{
+	unsigned long flags;
+	int used_before;
+	int ret = 0;
+
+	raw_spin_lock_irqsave(&p->lock, flags);
+	used_before = p->active[USER_CLOCKSOURCE] | p->active[USER_CLOCKEVENT];
+	if (!used_before)
+		ret = em_sti_enable(p);
+
+	if (!ret)
+		p->active[user] = 1;
+	raw_spin_unlock_irqrestore(&p->lock, flags);
+
+	return ret;
+}
+
+static void em_sti_stop(struct em_sti_priv *p, unsigned int user)
+{
+	unsigned long flags;
+	int used_before, used_after;
+
+	raw_spin_lock_irqsave(&p->lock, flags);
+	used_before = p->active[USER_CLOCKSOURCE] | p->active[USER_CLOCKEVENT];
+	p->active[user] = 0;
+	used_after = p->active[USER_CLOCKSOURCE] | p->active[USER_CLOCKEVENT];
+
+	if (used_before && !used_after)
+		em_sti_disable(p);
+	raw_spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static struct em_sti_priv *cs_to_em_sti(struct clocksource *cs)
+{
+	return container_of(cs, struct em_sti_priv, cs);
+}
+
+static cycle_t em_sti_clocksource_read(struct clocksource *cs)
+{
+	return em_sti_count(cs_to_em_sti(cs));
+}
+
+static int em_sti_clocksource_enable(struct clocksource *cs)
+{
+	int ret;
+	struct em_sti_priv *p = cs_to_em_sti(cs);
+
+	ret = em_sti_start(p, USER_CLOCKSOURCE);
+	if (!ret)
+		__clocksource_updatefreq_hz(cs, p->rate);
+	return ret;
+}
+
+static void em_sti_clocksource_disable(struct clocksource *cs)
+{
+	em_sti_stop(cs_to_em_sti(cs), USER_CLOCKSOURCE);
+}
+
+static void em_sti_clocksource_resume(struct clocksource *cs)
+{
+	em_sti_clocksource_enable(cs);
+}
+
+static int em_sti_register_clocksource(struct em_sti_priv *p)
+{
+	struct clocksource *cs = &p->cs;
+
+	memset(cs, 0, sizeof(*cs));
+	cs->name = dev_name(&p->pdev->dev);
+	cs->rating = 200;
+	cs->read = em_sti_clocksource_read;
+	cs->enable = em_sti_clocksource_enable;
+	cs->disable = em_sti_clocksource_disable;
+	cs->suspend = em_sti_clocksource_disable;
+	cs->resume = em_sti_clocksource_resume;
+	cs->mask = CLOCKSOURCE_MASK(48);
+	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
+
+	dev_info(&p->pdev->dev, "used as clock source\n");
+
+	/* Register with dummy 1 Hz value, gets updated in ->enable() */
+	clocksource_register_hz(cs, 1);
+	return 0;
+}
+
+static struct em_sti_priv *ced_to_em_sti(struct clock_event_device *ced)
+{
+	return container_of(ced, struct em_sti_priv, ced);
+}
+
+static void em_sti_clock_event_mode(enum clock_event_mode mode,
+				    struct clock_event_device *ced)
+{
+	struct em_sti_priv *p = ced_to_em_sti(ced);
+
+	/* deal with old setting first */
+	switch (ced->mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		em_sti_stop(p, USER_CLOCKEVENT);
+		break;
+	default:
+		break;
+	}
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		dev_info(&p->pdev->dev, "used for oneshot clock events\n");
+		em_sti_start(p, USER_CLOCKEVENT);
+		clockevents_config(&p->ced, p->rate);
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		em_sti_stop(p, USER_CLOCKEVENT);
+		break;
+	default:
+		break;
+	}
+}
+
+static int em_sti_clock_event_next(unsigned long delta,
+				   struct clock_event_device *ced)
+{
+	struct em_sti_priv *p = ced_to_em_sti(ced);
+	cycle_t next;
+	int safe;
+
+	next = em_sti_set_next(p, em_sti_count(p) + delta);
+	safe = em_sti_count(p) < (next - 1);
+
+	return !safe;
+}
+
+static void em_sti_register_clockevent(struct em_sti_priv *p)
+{
+	struct clock_event_device *ced = &p->ced;
+
+	memset(ced, 0, sizeof(*ced));
+	ced->name = dev_name(&p->pdev->dev);
+	ced->features = CLOCK_EVT_FEAT_ONESHOT;
+	ced->rating = 200;
+	ced->cpumask = cpumask_of(0);
+	ced->set_next_event = em_sti_clock_event_next;
+	ced->set_mode = em_sti_clock_event_mode;
+
+	dev_info(&p->pdev->dev, "used for clock events\n");
+
+	/* Register with dummy 1 Hz value, gets updated in ->set_mode() */
+	clockevents_config_and_register(ced, 1, 2, 0xffffffff);
+}
+
+static int __devinit em_sti_probe(struct platform_device *pdev)
+{
+	struct em_sti_priv *p;
+	struct resource *res;
+	int irq, ret;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (p == NULL) {
+		dev_err(&pdev->dev, "failed to allocate driver data\n");
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	p->pdev = pdev;
+	platform_set_drvdata(pdev, p);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get I/O memory\n");
+		ret = -EINVAL;
+		goto err0;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq\n");
+		ret = -EINVAL;
+		goto err0;
+	}
+
+	/* map memory, let base point to the STI instance */
+	p->base = ioremap_nocache(res->start, resource_size(res));
+	if (p->base == NULL) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		ret = -ENXIO;
+		goto err0;
+	}
+
+	/* get hold of clock */
+	p->clk = clk_get(&pdev->dev, "sclk");
+	if (IS_ERR(p->clk)) {
+		dev_err(&pdev->dev, "cannot get clock\n");
+		ret = PTR_ERR(p->clk);
+		goto err1;
+	}
+
+	if (request_irq(irq, em_sti_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			dev_name(&pdev->dev), p)) {
+		dev_err(&pdev->dev, "failed to request low IRQ\n");
+		ret = -ENOENT;
+		goto err2;
+	}
+
+	raw_spin_lock_init(&p->lock);
+	em_sti_register_clockevent(p);
+	em_sti_register_clocksource(p);
+	return 0;
+
+err2:
+	clk_put(p->clk);
+err1:
+	iounmap(p->base);
+err0:
+	kfree(p);
+	return ret;
+}
+
+static int __devexit em_sti_remove(struct platform_device *pdev)
+{
+	return -EBUSY; /* cannot unregister clockevent and clocksource */
+}
+
+static const struct of_device_id em_sti_dt_ids[] __devinitconst = {
+	{ .compatible = "renesas,em-sti", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, em_sti_dt_ids);
+
+static struct platform_driver em_sti_device_driver = {
+	.probe		= em_sti_probe,
+	.remove		= __devexit_p(em_sti_remove),
+	.driver		= {
+		.name	= "em_sti",
+		.of_match_table = em_sti_dt_ids,
+	}
+};
+
+module_platform_driver(em_sti_device_driver);
+
+MODULE_AUTHOR("Magnus Damm");
+MODULE_DESCRIPTION("Renesas Emma Mobile STI Timer Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 81e803e..acba8943 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -132,6 +132,7 @@ extern u64 clockevent_delta2ns(unsigned long latch,
 			       struct clock_event_device *evt);
 extern void clockevents_register_device(struct clock_event_device *dev);
 
+extern void clockevents_config(struct clock_event_device *dev, u32 freq);
 extern void clockevents_config_and_register(struct clock_event_device *dev,
 					    u32 freq, unsigned long min_delta,
 					    unsigned long max_delta);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 9cd928f..7e1ce01 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -297,8 +297,7 @@ void clockevents_register_device(struct clock_event_device *dev)
 }
 EXPORT_SYMBOL_GPL(clockevents_register_device);
 
-static void clockevents_config(struct clock_event_device *dev,
-			       u32 freq)
+void clockevents_config(struct clock_event_device *dev, u32 freq)
 {
 	u64 sec;
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6a3a5b9..efd3866 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -814,6 +814,16 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	return HRTIMER_RESTART;
 }
 
+static int sched_skew_tick;
+
+static int __init skew_tick(char *str)
+{
+	get_option(&str, &sched_skew_tick);
+
+	return 0;
+}
+early_param("skew_tick", skew_tick);
+
 /**
  * tick_setup_sched_timer - setup the tick emulation timer
  */
@@ -831,6 +841,14 @@ void tick_setup_sched_timer(void)
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
 
+	/* Offset the tick to avert xtime_lock contention. */
+	if (sched_skew_tick) {
+		u64 offset = ktime_to_ns(tick_period) >> 1;
+		do_div(offset, num_possible_cpus());
+		offset *= smp_processor_id();
+		hrtimer_add_expires_ns(&ts->sched_timer, offset);
+	}
+
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
 		hrtimer_start_expires(&ts->sched_timer,
