Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1AXPdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:33:50 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:46181 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1AXPdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:33:49 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCH] parport: make lockdep happy with waitlist_lock
Date: Mon, 24 Jan 2011 18:33:40 +0300
Message-Id: <824b6fef0971504d44a56b3b54ee0e21bf7f1519.1295883191.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110124152831.GB4416@elte.hu>
References: <20110124152831.GB4416@elte.hu>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parport_unregister_device should never be used when interrupts are
enabled in hardware and irq handler is registered so there is no need
to disable interrupts when using waitlist_lock. But there is no way to
explain this subtle semantics to lockdep analyzer. So disable interrupts
here too to simplify things. The price is negligible.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/parport/share.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index a2d9d1e..a848e02 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -678,7 +678,7 @@ void parport_unregister_device(struct pardevice *dev)
 
 	/* Make sure we haven't left any pointers around in the wait
 	 * list. */
-	spin_lock (&port->waitlist_lock);
+	spin_lock_irq(&port->waitlist_lock);
 	if (dev->waitprev || dev->waitnext || port->waithead == dev) {
 		if (dev->waitprev)
 			dev->waitprev->waitnext = dev->waitnext;
@@ -689,7 +689,7 @@ void parport_unregister_device(struct pardevice *dev)
 		else
 			port->waittail = dev->waitprev;
 	}
-	spin_unlock (&port->waitlist_lock);
+	spin_unlock_irq(&port->waitlist_lock);
 
 	kfree(dev->state);
 	kfree(dev);
-- 
1.7.2.3

