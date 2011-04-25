Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab1DYUZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:11 -0400
Received: from 1wt.eu ([62.212.114.60]:34487 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359Ab1DYUZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:09 -0400
Message-Id: <20110425200235.472060344@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 057/173] genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1079,7 +1079,7 @@ int request_threaded_irq(unsigned int ir
 	if (retval)
 		kfree(action);
 
-#ifdef CONFIG_DEBUG_SHIRQ
+#ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (irqflags & IRQF_SHARED) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it


