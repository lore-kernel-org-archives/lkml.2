Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab1CCR1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:27:25 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37613 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758234Ab1CCR1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:27:21 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+ITLNtAjuIUCmeoqShjDqQkslSEM9sEZwNrnra9Z
	b/m1GmtP2+sA4T
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: richard.cochran@omicron.at, johnstul@us.ibm.com, tglx@linutronix.de,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 2/3] ptp: add a software clock based on clock_monotonic_raw
Date: Thu,  3 Mar 2011 18:26:13 +0100
Message-Id: <1299173174-348-3-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299173174-348-1-git-send-email-torbenh@gmx.de>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First version of a software clock. Not very useful yet,
as it doesnt generate events, but at least it allows
for testing the ptp framework without special hardware.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/ptp/Kconfig        |    6 +
 drivers/ptp/Makefile       |    1 +
 drivers/ptp/ptp_software.c |  221 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 228 insertions(+), 0 deletions(-)
 create mode 100644 drivers/ptp/ptp_software.c

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index d99e6f9..0427361 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -40,4 +40,10 @@ config PTP_1588_CLOCK_IXP46X
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp_ixp46x.
 
+config PTP_1588_CLOCK_SOFTWARE
+	tristate "software PTP clock"
+	depends on PTP_1588_CLOCK
+	help
+	  This driver adds a software PTP clock. 
+
 endmenu
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index f6933e8..8f18a55 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -5,3 +5,4 @@
 ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
+obj-$(CONFIG_PTP_1588_CLOCK_SOFTWARE)	+= ptp_software.o
diff --git a/drivers/ptp/ptp_software.c b/drivers/ptp/ptp_software.c
new file mode 100644
index 0000000..1182426
--- /dev/null
+++ b/drivers/ptp/ptp_software.c
@@ -0,0 +1,221 @@
+/*
+ * Software PTP Clock
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/ptp_clock_kernel.h>
+
+#define DRIVER		"ptp_sofware"
+#define N_EXT_TS	2
+
+struct ixp_clock {
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info caps;
+	s64 offset_ns;
+	struct timespec last_timestamp;
+	s32 freq;
+};
+
+DEFINE_SEQLOCK(clock_lock);
+
+
+/*
+ * Register access functions
+ */
+
+static struct timespec timespec_mul_freq(struct timespec val, u32 ppb)
+{
+	struct timespec retval;
+	u32 remain_sec;
+	u64 muled_sec  = (u64) val.tv_sec * ppb;
+	u64 muled_nsec = (u64) val.tv_nsec * ppb;
+
+	muled_sec  = div_u64_rem(muled_sec, NSEC_PER_SEC, &remain_sec);
+	muled_nsec = div_u64(muled_nsec, NSEC_PER_SEC);
+
+	set_normalized_timespec(&retval, muled_sec, muled_nsec+remain_sec); 
+	return retval;
+}
+
+static struct timespec __transformed_time(struct timespec val, struct ixp_clock *clock)
+{
+	struct timespec diff, muled, retval;
+	int neg_adj = 0;
+	s32 ppb;
+
+	if (clock->freq < 0) {
+		neg_adj = 1;
+		ppb = -clock->freq;
+	} else {
+		ppb = clock->freq;
+	}
+
+	diff = timespec_sub(val, clock->last_timestamp);
+	muled = timespec_mul_freq(diff, (u32) ppb);
+
+	if (neg_adj) {
+		retval = timespec_sub(val, muled);
+	} else {
+		retval = timespec_add(val, muled);
+	}
+
+	if (clock->offset_ns < 0)
+		retval = timespec_sub(retval, ns_to_timespec(-clock->offset_ns));
+	else
+		retval = timespec_add(retval, ns_to_timespec(clock->offset_ns));
+
+	return retval;
+}
+
+/*
+ * PTP clock operations
+ */
+
+static int ptp_ixp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+{
+	struct timespec now_kernel, now_this;
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+
+	getrawmonotonic(&now_kernel);
+
+	write_seqlock(&clock_lock);
+
+	now_this = __transformed_time(now_kernel, ixp_clock);
+
+	ixp_clock->offset_ns = timespec_to_ns(&now_this) - timespec_to_ns(&now_kernel);
+	ixp_clock->last_timestamp = now_kernel;
+	ixp_clock->freq = ppb;
+
+	write_sequnlock(&clock_lock);
+
+	return 0;
+}
+
+static int ptp_ixp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+
+	write_seqlock(&clock_lock);
+	ixp_clock->offset_ns += delta;
+	write_sequnlock(&clock_lock);
+
+	return 0;
+}
+
+static int ptp_ixp_gettime(struct ptp_clock_info *ptp, struct timespec *ts)
+{
+	unsigned long seq;
+	struct timespec now_kernel;
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+
+	getrawmonotonic(&now_kernel);
+	
+	do {
+		seq = read_seqbegin(&clock_lock);
+
+		*ts = __transformed_time(now_kernel, ixp_clock);
+	} while (read_seqretry(&clock_lock, seq));
+
+	return 0;
+}
+
+static int ptp_ixp_settime(struct ptp_clock_info *ptp,
+			   const struct timespec *ts)
+{
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+
+	struct timespec now_kernel;
+
+	getrawmonotonic(&now_kernel);
+
+	write_seqlock(&clock_lock);
+	ixp_clock->last_timestamp = now_kernel;
+	ixp_clock->offset_ns = timespec_to_ns(ts) - timespec_to_ns(&now_kernel);
+	write_sequnlock(&clock_lock);
+
+	return 0;
+}
+
+static int ptp_ixp_enable(struct ptp_clock_info *ptp,
+			  struct ptp_clock_request *rq, int on)
+{
+	//struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		switch (rq->extts.index) {
+		default:
+			return -EINVAL;
+		}
+		return 0;
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static struct ptp_clock_info ptp_ixp_caps = {
+	.owner		= THIS_MODULE,
+	.name		= "software timer",
+	.max_adj	= 66666655,
+	.n_ext_ts	= 0,
+	.pps		= 0,
+	.adjfreq	= ptp_ixp_adjfreq,
+	.adjtime	= ptp_ixp_adjtime,
+	.gettime	= ptp_ixp_gettime,
+	.settime	= ptp_ixp_settime,
+	.enable		= ptp_ixp_enable,
+};
+
+/* module operations */
+
+static struct ixp_clock ixp_clock;
+
+static void __exit ptp_ixp_exit(void)
+{
+	ptp_clock_unregister(ixp_clock.ptp_clock);
+}
+
+static int __init ptp_ixp_init(void)
+{
+	ixp_clock.caps = ptp_ixp_caps;
+
+	ixp_clock.ptp_clock = ptp_clock_register(&ixp_clock.caps);
+
+	if (IS_ERR(ixp_clock.ptp_clock))
+		return PTR_ERR(ixp_clock.ptp_clock);
+
+	return 0;
+}
+
+module_init(ptp_ixp_init);
+module_exit(ptp_ixp_exit);
+
+MODULE_AUTHOR("Richard Cochran <richard.cochran@omicron.at>");
+MODULE_DESCRIPTION("PTP clock using the IXP46X timer");
+MODULE_LICENSE("GPL");
-- 
1.7.2.3

