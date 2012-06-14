Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2FOAJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:09:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab2FNX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:03 -0400
Message-Id: <20120614235624.343074533@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [ 05/42] powerpc/time: Sanity check of decrementer expiration is necessary
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit 860aed25a1f0936d4852ab936252b47cd1e630f1 upstream.

This reverts 68568add2c ("powerpc/time: Remove unnecessary sanity check
of decrementer expiration").  We do need to check whether we have reached
the expiration time of the next event, because we sometimes get an early
decrementer interrupt, most notably when we set the decrementer to 1 in
arch_irq_work_raise().  The effect of not having the sanity check is that
if timer_interrupt() gets called early, we leave the decrementer set to
its maximum value, which means we then don't get any more decrementer
interrupts for about 4 seconds (or longer, depending on timebase
frequency).  I saw these pauses as a consequence of getting a stray
hypervisor decrementer interrupt left over from exiting a KVM guest.

This isn't quite a straight revert because of changes to the surrounding
code, but it restores the same algorithm as was previously used.

Acked-by: Anton Blanchard <anton@samba.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/time.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -474,6 +474,7 @@ void timer_interrupt(struct pt_regs * re
 	struct pt_regs *old_regs;
 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
 	struct clock_event_device *evt = &__get_cpu_var(decrementers);
+	u64 now;
 
 	/* Ensure a positive value is written to the decrementer, or else
 	 * some CPUs will continue to take decrementer exceptions.
@@ -508,9 +509,16 @@ void timer_interrupt(struct pt_regs * re
 		irq_work_run();
 	}
 
-	*next_tb = ~(u64)0;
-	if (evt->event_handler)
-		evt->event_handler(evt);
+	now = get_tb_or_rtc();
+	if (now >= *next_tb) {
+		*next_tb = ~(u64)0;
+		if (evt->event_handler)
+			evt->event_handler(evt);
+	} else {
+		now = *next_tb - now;
+		if (now <= DECREMENTER_MAX)
+			set_dec((int)now);
+	}
 
 #ifdef CONFIG_PPC64
 	/* collect purr register values often, for accurate calculations */


