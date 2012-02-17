Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2BQA7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:59:46 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46977 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756635Ab2BQA7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:43 -0500
X-Sasl-enc: UVsrq+RAUMoFZDTF5iU0afQJ748j+1/x6pe7+9gBBhW/ 1329440382
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:11 2012
Message-Id: <20120217005511.147708184@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Jander <david@protonic.nl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Manfred Gruber <m.gruber@unverspurt.at>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [09/15] gpio/pca953x: Fix warning of enabled interrupts in handler
In-Reply-To: <20120217005650.GA17119@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jander <david@protonic.nl>

commit 6dd599f8af0166805951f4421a78ba716d78321a upstream.

When using nested threaded irqs, use handle_nested_irq(). This function
does not call the chip handler, so no handler is set.

Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Manfred Gruber <m.gruber@unverspurt.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/pca953x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -437,7 +437,7 @@ static irqreturn_t pca953x_irq_handler(i
 
 	do {
 		level = __ffs(pending);
-		generic_handle_irq(level + chip->irq_base);
+		handle_nested_irq(level + chip->irq_base);
 
 		pending &= ~(1 << level);
 	} while (pending);
@@ -481,8 +481,8 @@ static int pca953x_irq_setup(struct pca9
 			int irq = lvl + chip->irq_base;
 
 			irq_set_chip_data(irq, chip);
-			irq_set_chip_and_handler(irq, &pca953x_irq_chip,
-						 handle_simple_irq);
+			irq_set_chip(irq, &pca953x_irq_chip);
+			irq_set_nested_thread(irq, true);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else


