Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab1DECQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 22:16:24 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46123 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552Ab1DECQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 22:16:22 -0400
Message-ID: <4D9A7B9D.7060604@metafoo.de>
Date: Tue, 05 Apr 2011 04:17:01 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Ok to call disable_irq before request_irq?
References: <BANLkTikQk0OAS+41g=pk9BaqAWaVhQB9rg@mail.gmail.com>
In-Reply-To: <BANLkTikQk0OAS+41g=pk9BaqAWaVhQB9rg@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------050003040805000501050900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050003040805000501050900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/05/2011 02:53 AM, Timur Tabi wrote:
> Is it okay to call disable_irq() before calling request_irq()?  My
> device creates lots of spurious interrupts, and so I want the
> interrupt enable only when I expect a real interrupt to occur.  It
> seems to work, but I just want to make sure it's a proper technique.
> 

It might work in your case, but in general that would certainly be really bad
practice.
If the irq was not requested before request_irq should enable the IRQ
regardless of whether irq_disable was called or not.

I have a patch which adds the IRQF_NOAUTOEN flag, which allows you to request a
IRQ without automatically enabling it. Unfortunately the current version of the
patch will fail if your irq_chip implements the irq_startup callback. I've
attached the patch.

- Lars

--------------050003040805000501050900
Content-Type: text/x-diff;
 name="irqf_noautoen.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="irqf_noautoen.patch"

commit 0fefae8354e9045e720def1233bfe51592e2dc90
Author: Lars-Peter Clausen <lars@metafoo.de>
Date:   Thu Mar 31 19:47:41 2011 +0200

    IRQF_NOAUTOEN

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 943c9b5..d596640 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -59,6 +59,7 @@
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  * IRQF_NO_THREAD - Interrupt cannot be threaded
+ * IRQF_NOAUTOEN - Do not enable the interrupt on request
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -72,6 +73,7 @@
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
+#define IRQF_NOAUTOEN		0x00020000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 12a80fd..e5c538f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -863,6 +863,10 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	int ret, nested, shared = 0;
 	cpumask_var_t mask;
 
+	if (new->flags & (IRQF_NOAUTOEN | IRQF_SHARED) ==
+		(IRQF_NOAUTOEN | IRQF_SHARED))
+		return -EINVAL;
+
 	if (!desc)
 		return -EINVAL;
 
@@ -998,7 +1002,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (new->flags & IRQF_ONESHOT)
 			desc->istate |= IRQS_ONESHOT;
 
-		if (irq_settings_can_autoenable(desc))
+		if (irq_settings_can_autoenable(desc) &&
+			!(new->flags & IRQF_NOAUTOEN))
 			irq_startup(desc);
 		else
 			/* Undo nested disables: */

--------------050003040805000501050900--
