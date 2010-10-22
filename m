Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0JVSdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:33:06 -0400
Received: from kroah.org ([198.145.64.141]:37737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab0JVSYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Drake <dsd@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/49] serial8250: ratelimit "too much work" error
Date: Fri, 22 Oct 2010 11:21:28 -0700
Message-Id: <1287771688-14805-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Drake <dsd@laptop.org>

Running a serial console, if too many kernel messages are generated within
a short time causing a lot of serial I/O, the 8250 driver will generate
another kernel message reporting this, which just adds to the I/O. It has
a cascading effect and quickly results the system being brought to its knees
by a flood of "too much work" messages.

Ratelimit the error message to avoid this.

[akpm@linux-foundation.org: use the superior printk_ratelimited()]
[akpm@linux-foundation.org: printk_ratelimited() needs ratelimit.h]
Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 37f19a6..167c4a6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/tty.h>
+#include <linux/ratelimit.h>
 #include <linux/tty_flip.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_core.h>
@@ -1600,8 +1601,8 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 
 		if (l == i->head && pass_counter++ > PASS_LIMIT) {
 			/* If we hit this, we're dead. */
-			printk(KERN_ERR "serial8250: too much work for "
-				"irq%d\n", irq);
+			printk_ratelimited(KERN_ERR
+				"serial8250: too much work for irq%d\n", irq);
 			break;
 		}
 	} while (l != end);
-- 
1.7.2

