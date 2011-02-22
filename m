Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1BVWWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:40 -0500
Received: from kroah.org ([198.145.64.141]:33007 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1BVWWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:43 2011
Message-Id: <20110222221843.307057273@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: [63/70] genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1098,7 +1098,7 @@ int request_threaded_irq(unsigned int ir
 	if (retval)
 		kfree(action);
 
-#ifdef CONFIG_DEBUG_SHIRQ
+#ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (!retval && (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it


