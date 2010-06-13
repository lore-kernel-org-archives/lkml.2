Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0FMPdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:33:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:37762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab0FMPcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:14 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/12] irq: add comment about overall design of lost/spurious IRQ handling
Date: Sun, 13 Jun 2010 17:31:36 +0200
Message-Id: <1276443098-20653-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give a general overview of the facility at the top of file and add
copyright notice.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/irq/spurious.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 2d92113..329555f 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -2,8 +2,66 @@
  * linux/kernel/irq/spurious.c
  *
  * Copyright (C) 1992, 1998-2004 Linus Torvalds, Ingo Molnar
+ * Copyright (C) 2010            SUSE Linux Products GmbH
+ * Copyright (C) 2010            Tejun Heo <tj@kernel.org>
  *
- * This file contains spurious interrupt handling.
+ * There are two ways interrupt handling can go wrong - too few or too
+ * many.  Due to misrouting or other issues, sometimes IRQs don't
+ * reach the driver while at other times an interrupt line gets stuck
+ * and a continuous spurious interrupts are generated.
+ *
+ * This file implements workaround for both cases.  Lost interrupts
+ * are handled by IRQ expecting and watching, and spurious interrupts
+ * by spurious polling.  All mechanisms need IRQF_SHARED to be set on
+ * the irqaction in question.
+ *
+ * Both lost interrupt workarounds require cooperation from drivers
+ * and can be chosen depending on how much information the driver can
+ * provide.
+ *
+ * - IRQ expecting
+ *
+ *   IRQ expecting is useful when the driver can tell when IRQs can be
+ *   expected; in other words, when IRQs are used to signal completion
+ *   of host initiated operations.  This is the surest way to work
+ *   around lost interrupts.
+ *
+ *   When the controller is expected to raise an IRQ, the driver
+ *   should call expect_irq() and, when the expected event happens or
+ *   times out, unexpect_irq().  IRQ subsystem polls the interrupt
+ *   inbetween.
+ *
+ *   As interrupts tend to keep working if it works at the beginning,
+ *   IRQ expecting implements "verified state".  After certain number
+ *   of successful IRQ deliveries, the irqaction becomes verified and
+ *   much longer polling interval is used.
+ *
+ * - IRQ watching
+ *
+ *   This can be used when the driver doesn't know when to exactly
+ *   expect and unexpect IRQs.  Once watch_irq() is called, the
+ *   irqaction is slowly polled for certain amount of time (1min).  If
+ *   IRQs are missed during that time, the irqaction is marked and
+ *   actively polled; otherwise, the watching is stopped.
+ *
+ *   In the most basic case, drivers can call this right after
+ *   registering an irqaction to verify IRQ delivery.  In many cases,
+ *   if IRQ works at the beginning, it keeps working, so just calling
+ *   watch_irq() once can provide decent protection against misrouted
+ *   IRQs.  It would also be a good idea to call watch_irq() when
+ *   timeouts are detected.
+ *
+ * - Spurious IRQ handling
+ *
+ *   All IRQs are continuously monitored and spurious IRQ handling
+ *   kicks in if there are too many spurious IRQs.  The IRQ is
+ *   disabled and the registered irqactions are polled.  The IRQ is
+ *   given another shot after certain number IRQs are handled or an
+ *   irqaction is added or removed.
+ *
+ * All of the above three mechanisms can be used together.  Spurious
+ * IRQ handling is enabled by default and drivers are free to expect
+ * and watch IRQs as they see fit.
  */
 
 #include <linux/jiffies.h>
@@ -17,6 +75,20 @@
 
 #include "internals.h"
 
+/*
+ * I spent quite some time thinking about each parameter but they
+ * still are just numbers pulled out of my ass.  If you think your ass
+ * is prettier than mine, please go ahead and suggest better ones.
+ *
+ * Most parameters are intentionally fixed constants and not
+ * adjustable through API.  The nature of IRQ delivery failures isn't
+ * usually dependent on specific drivers and the timing parameters are
+ * more about human perceivable latencies rather than any specific
+ * controller timing details, so figuring out constant values which
+ * can work for most cases shouldn't be too hard.  This allows tighter
+ * control over polling behaviors, eases future changes and makes the
+ * interface easy for drivers.
+ */
 enum {
 	/* irqfixup levels */
 	IRQFIXUP_SPURIOUS		= 0,		/* spurious storm detection */
-- 
1.6.4.2

