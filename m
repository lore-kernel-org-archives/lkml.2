Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab1FWSMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:12:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:34568 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382Ab1FWRgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 118/247] genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
Date: Thu, 23 Jun 2011 13:33:06 -0400
Message-Id: <1308850515-15242-59-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6d83f94db95cfe65d2a6359cccdf61cf087c2598 upstream.

With CONFIG_SHIRQ_DEBUG=y we call a newly installed interrupt handler
in request_threaded_irq().

The original implementation (commit a304e1b8) called the handler
_BEFORE_ it was installed, but that caused problems with handlers
calling disable_irq_nosync(). See commit 377bf1e4.

It's braindead in the first place to call disable_irq_nosync in shared
handlers, but ....

Moving this call after we installed the handler looks innocent, but it
is very subtle broken on SMP.

Interrupt handlers rely on the fact, that the irq core prevents
reentrancy.

Now this debug call violates that promise because we run the handler
w/o the IRQ_INPROGRESS protection - which we cannot apply here because
that would result in a possibly forever masked interrupt line.

A concurrent real hardware interrupt on a different CPU results in
handler reentrancy and can lead to complete wreckage, which was
unfortunately observed in reality and took a fricking long time to
debug.

Leave the code here for now. We want this debug feature, but that's
not easy to fix. We really should get rid of those
disable_irq_nosync() abusers and remove that function completely.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 26b1b7b..8305828 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1101,7 +1101,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	if (retval)
 		kfree(action);
 
-#ifdef CONFIG_DEBUG_SHIRQ
+#ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (!retval && (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
-- 
1.7.4.4

