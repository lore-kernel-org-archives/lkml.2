Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330Ab1C3VjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:39:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:26880 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933542Ab1C3VIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133411"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tglx@linutronix.de, ak@linux.intel.com, avorontsov@ru.mvista.com,
        dwmw2@infradead.org, arjan@infradead.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [139/275] genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
Message-Id: <20110330210620.1201B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/irq/manage.c
===================================================================
--- linux-2.6.35.y.orig/kernel/irq/manage.c	2011-03-29 22:51:11.695423912 -0700
+++ linux-2.6.35.y/kernel/irq/manage.c	2011-03-29 23:03:01.175270097 -0700
@@ -1093,7 +1093,7 @@
 	if (retval)
 		kfree(action);
 
-#ifdef CONFIG_DEBUG_SHIRQ
+#ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (!retval && (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
