Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380Ab0HLAJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:09:19 -0400
Received: from kroah.org ([198.145.64.141]:47988 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab0HLAJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:09:05 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:18 2010
Message-Id: <20100812000618.582410219@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        xen-devel@lists.xensource.com, linux-input@vger.kernel.org,
        linuxppc-dev@ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [64/67] irq: Add new IRQ flag IRQF_NO_SUSPEND
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 685fd0b4ea3f0f1d5385610b0d5b57775a8d5842 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/interrupt.h |    7 ++++++-
 kernel/irq/manage.c       |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

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
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -216,7 +216,7 @@ static inline int setup_affinity(unsigne
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_TIMER))
+		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
 			return;
 		desc->status |= IRQ_SUSPENDED;
 	}


