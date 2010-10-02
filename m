Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab0JBLEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 07:04:43 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:27574 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713Ab0JBLEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 07:04:42 -0400
From: Daniel Drake <dsd@laptop.org>
To: akpm@linux-foundation.org
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] serial8250: ratelimit "too much work" error
Message-Id: <20101002110438.801F49D401B@zog.reactivated.net>
Date: Sat,  2 Oct 2010 12:04:38 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=QKEh0UfrkogA:10 a=Op-mwl0xAAAA:8 a=UZJmvzrOllWCSOIfOWsA:9 a=aJJoMPhx_OijXoMRbx4A:7 a=ahST-61qzjo16HQR4xjoU8paZFMA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a serial console, if too many kernel messages are generated within
a short time causing a lot of serial I/O, the 8250 driver will generate
another kernel message reporting this, which just adds to the I/O. It has
a cascading effect and quickly results the system being brought to its knees
by a flood of "too much work" messages.

Ratelimit the error message to avoid this.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/serial/8250.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 24110f6..d3c5855 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1606,8 +1606,9 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 
 		if (l == i->head && pass_counter++ > PASS_LIMIT) {
 			/* If we hit this, we're dead. */
-			printk(KERN_ERR "serial8250: too much work for "
-				"irq%d\n", irq);
+			if (printk_ratelimit())
+				printk(KERN_ERR "serial8250: too much work for "
+					"irq%d\n", irq);
 			break;
 		}
 	} while (l != end);
-- 
1.7.2.3

