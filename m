Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0G2LbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:31:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:44745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab0G2LbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:31:10 -0400
Date: Thu, 29 Jul 2010 11:30:47 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, ian.campbell@citrix.com,
        jeremy@goop.org, dmitry.torokhov@gmail.com, benh@kernel.crashing.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        ian.campbell@citrix.com, jeremy@goop.org, dmitry.torokhov@gmail.com,
        benh@kernel.crashing.org, tglx@linutronix.de
In-Reply-To: <1280398595-29708-1-git-send-email-ian.campbell@citrix.com>
References: <1280398595-29708-1-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irq: Add new IRQ flag IRQF_NO_SUSPEND
Message-ID: <tip-685fd0b4ea3f0f1d5385610b0d5b57775a8d5842@git.kernel.org>
Git-Commit-ID: 685fd0b4ea3f0f1d5385610b0d5b57775a8d5842
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Jul 2010 11:30:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  685fd0b4ea3f0f1d5385610b0d5b57775a8d5842
Gitweb:     http://git.kernel.org/tip/685fd0b4ea3f0f1d5385610b0d5b57775a8d5842
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Thu, 29 Jul 2010 11:16:32 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Jul 2010 13:24:57 +0200

irq: Add new IRQ flag IRQF_NO_SUSPEND

A small number of users of IRQF_TIMER are using it for the implied no
suspend behaviour on interrupts which are not timer interrupts.

Therefore add a new IRQF_NO_SUSPEND flag, rename IRQF_TIMER to
__IRQF_TIMER and redefine IRQF_TIMER in terms of these new flags.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: xen-devel@lists.xensource.com
Cc: linux-input@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Cc: devicetree-discuss@lists.ozlabs.org
LKML-Reference: <1280398595-29708-1-git-send-email-ian.campbell@citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    7 ++++++-
 kernel/irq/manage.c       |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c233113..a0384a4 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -53,16 +53,21 @@
  * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
+ * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
+ *
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
-#define IRQF_TIMER		0x00000200
+#define __IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
+#define IRQF_NO_SUSPEND		0x00004000
+
+#define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
 /*
  * Bits used by threaded handlers:
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e149748..c3003e9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -216,7 +216,7 @@ static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_TIMER))
+		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
 			return;
 		desc->status |= IRQ_SUSPENDED;
 	}
