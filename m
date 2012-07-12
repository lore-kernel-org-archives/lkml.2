Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab2GLWgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:36:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759347Ab2GLWgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:36:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 009/187] powerpc: check_and_cede_processor() never cedes
Date: Thu, 12 Jul 2012 15:32:45 -0700
Message-Id: <20120712191523.108881148@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 0b17ba7258db83cd02da560884e053b85de371f2 upstream.

Commit f948501b36c6 ("Make hard_irq_disable() actually hard-disable
interrupts") caused check_and_cede_processor to stop working.
->irq_happened will never be zero right after a hard_irq_disable
so the compiler removes the call to cede_processor completely.

The bug was introduced back in the lazy interrupt handling rework
of 3.4 but was hidden until recently because hard_irq_disable did
nothing.

This issue will eventually appear in 3.4 stable since the
hard_irq_disable fix is marked stable, so mark this one for stable
too.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/hw_irq.h               |    5 +++++
 arch/powerpc/platforms/pseries/processor_idle.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -102,6 +102,11 @@ static inline void hard_irq_disable(void
 /* include/linux/interrupt.h needs hard_irq_disable to be a macro */
 #define hard_irq_disable	hard_irq_disable
 
+static inline bool lazy_irq_pending(void)
+{
+	return !!(get_paca()->irq_happened & ~PACA_IRQ_HARD_DIS);
+}
+
 /*
  * This is called by asynchronous interrupts to conditionally
  * re-enable hard interrupts when soft-disabled after having
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -106,7 +106,7 @@ static void check_and_cede_processor(voi
 	 * we first hard disable then check.
 	 */
 	hard_irq_disable();
-	if (get_paca()->irq_happened == 0)
+	if (!lazy_irq_pending())
 		cede_processor();
 }
 


